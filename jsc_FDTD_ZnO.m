function [Jsc, jsc_dictionary_ZnO, simulations_required, simulation_num] = jsc_FDTD_ZnO(population, jsc_dictionary_ZnO, simulations_required, simulation_num)
format longG;
%population = [29 30 31 32]; %test population

Jsc_output = zeros(1,length(population));

for (I=1:length(population))
    %checking if I = index of repeating value
    pop = population(I);
    
    %% ONLY FOR TESTING -------------- start
    if ~(isKey(simulations_required, pop))
        simulations_required(pop) = I;
        simulation_num = simulation_num + 1;
    end
    %% ONLY FOR TESTING -------------- end
    
    %%
    if (isKey(jsc_dictionary_ZnO, pop))
        Jsc_output(1,I) = jsc_dictionary_ZnO(pop);
    else
        %Open FDTD session
        FDTD_session=appopen('fdtd');
        
        %Load simulation file
        appevalscript(FDTD_session,'load("D:\_Research files\Evolutionary algorithm works\Reference study (ZnO optical spacer)\_Newest\ITO-MoOx-P3HT.ICBA-ZnO-Ag\Evo_alg__P3HT-ICBA.fsp");');
        appevalscript(FDTD_session, 'switchtolayout;');
        
        %Set global variable
        appputvar(FDTD_session,'population_num',length(population));
        appevalscript(FDTD_session, 'nm = 1e-9;');
        
        appputvar(FDTD_session,'i',I);
        appputvar(FDTD_session,'W',pop); %FDTD sim runs one at a time; so send one population value at a time
        %     appevalscript(FDTD_session, 'Random_num(1,i) = W;'); %Random values are stored for later use
        
        %Get ZnO's y min
        appevalscript(FDTD_session, 'select("ZnO");');
        appevalscript(FDTD_session, 'ZnO_ymin = (get("y min"))/nm;');
        
        %Set thickness of ZnO (optical spacer) layer
        appevalscript(FDTD_session, 'select("ZnO");');
        %y_min for ZnO is ZnO_ymin. So we add ZnO_ymin + W to give its thickness
        appevalscript(FDTD_session, 'set("y max",((ZnO_ymin*nm) + (W*nm)));');
        appevalscript(FDTD_session, 'ZnO_ymax = get("y max");');
        
        appevalscript(FDTD_session, 'select("Al");');
        %Al layer's y_min = ZnO's y_max
        appevalscript(FDTD_session, 'set("y min",ZnO_ymax);');
        %Al layer's y_max = Al y_min + 100 (Al thickness = 100nm)
        appevalscript(FDTD_session, 'set("y max",(ZnO_ymax+(100*nm)));');
        appevalscript(FDTD_session, 'Al_ymax = get("y max");');
        
        appevalscript(FDTD_session, 'select("mesh_full");');
        appevalscript(FDTD_session, 'set("y max",Al_ymax);'); %Mesh y_max = Al y_max
        
        appevalscript(FDTD_session, 'select("field");');
        appevalscript(FDTD_session, 'set("y max",Al_ymax);'); %Field y_max = Al y_max
        
        appevalscript(FDTD_session, 'select("FDTD");');
        appevalscript(FDTD_session, 'set("y max",(Al_ymax+(500*nm)));'); %Set FDTD ymax 1 micrometer more than Al ymax
        
        appevalscript(FDTD_session, 'run;'); %Run the simulation
        
        %Jsc_sim column 1 = simulated Jsc result
        %Jsc_sim column 2 = Random number population
        appevalscript(FDTD_session, 'Jsc_sim = getresult("solar_generation","Jsc");');
        
        Jsc_output(1,I) = appgetvar(FDTD_session, 'Jsc_sim');
        
        
        appevalscript(FDTD_session, 'switchtolayout;');
        
        jsc_dictionary_ZnO(pop) = Jsc_output(1,I);
        
        %close FDTD session
        appclose(FDTD_session);
        simulation_num = simulation_num + 1;
    end
end
%disp(['Jsc outputs: ', num2str(Jsc_output/10)]);
Jsc = (1./Jsc_output).*1000000;
end




