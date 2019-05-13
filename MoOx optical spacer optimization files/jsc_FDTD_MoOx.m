function [Jsc, jsc_dictionary_MoOx, simulations_required, simulation_num] = jsc_FDTD_MoOx(population, jsc_dictionary_MoOx, simulations_required, simulation_num)
format longG;

%% BRUTE FORCE TESTING ONLY --- start
% population = 0:1:30; %test population
% jsc_dictionary_MoOx = containers.Map('KeyType','int32', 'ValueType','any');
% simulations_required = containers.Map('KeyType','int32', 'ValueType','any');
% simulation_num = 0;
%% BRUTE FORCE TESTING ONLY --- end

Jsc_output = zeros(1,length(population));
% Thicknesses in nm
ZnO_thickness = 30; 
Al_thickness = 100;
ITO_thickness = 200;

for (I=1:length(population))
    %checking if I = index of repeating value
    pop = population(I);
    
    %% ONLY FOR TESTING (used to get simulation numbers when all the results through brute force are known) -------------- start
    if ~(isKey(simulations_required, pop))
        simulations_required(pop) = I;
        simulation_num = simulation_num + 1;
    end
    %% ONLY FOR TESTING -------------- end
    
    %%
    if (isKey(jsc_dictionary_MoOx, pop))
        Jsc_output(1,I) = jsc_dictionary_MoOx(pop);
    else
        %Open FDTD session
        FDTD_session=appopen('fdtd');
        
        %Load simulation file
        appevalscript(FDTD_session,'load("D:\_Research files\Evolutionary algorithm works\Reference study (optical spacer)\_Newest\ITO-MoOx-P3HT.ICBA-ZnO-Ag\Evo_alg__P3HT-ICBA.fsp");');
        appevalscript(FDTD_session, 'switchtolayout;');
        
        %Set global variable
        appputvar(FDTD_session,'population_num',length(population));
        appevalscript(FDTD_session, 'nm = 1e-9;');
        
        appputvar(FDTD_session,'i',I);
        appputvar(FDTD_session,'varying_thickness',pop); %FDTD sim runs one at a time; so send one population value at a time
        %     appevalscript(FDTD_session, 'Random_num(1,i) = W;'); %Random values are stored for later use
        
        %Get ZnO's y min
        appevalscript(FDTD_session, 'select("ZnO");');
        appevalscript(FDTD_session, 'ZnO_ymin = (get("y min"))/nm;');
        
        %Set thickness of ZnO (optical spacer) layer
        appputvar(FDTD_session,'ZnO_thickness',ZnO_thickness);
        appevalscript(FDTD_session, 'select("ZnO");');
        %y_min for ZnO is ZnO_ymin. So we add ZnO_ymin + W to give its thickness
        appevalscript(FDTD_session, 'set("y max",((ZnO_ymin*nm) + (ZnO_thickness*nm)));');
        appevalscript(FDTD_session, 'ZnO_ymax = get("y max");');
        
        appputvar(FDTD_session,'Al_thickness',Al_thickness);
        appevalscript(FDTD_session, 'select("Al");');
        %Al layer's y_min = ZnO's y_max
        appevalscript(FDTD_session, 'set("y min",ZnO_ymax);');
        %Al layer's y_max = Al y_min + 100 (Al thickness = 100nm)
        appevalscript(FDTD_session, 'set("y max",(ZnO_ymax+(Al_thickness*nm)));');
        appevalscript(FDTD_session, 'Al_ymax = get("y max");');
        
        appevalscript(FDTD_session, 'select("mesh_full");');
        appevalscript(FDTD_session, 'set("y max",Al_ymax);'); %Mesh y_max = Al y_max
        
        appevalscript(FDTD_session, 'select("field");');
        appevalscript(FDTD_session, 'set("y max",Al_ymax);'); %Field y_max = Al y_max
        
        appevalscript(FDTD_session, 'select("FDTD");');
        appevalscript(FDTD_session, 'set("y max",(Al_ymax+(500*nm)));'); %Set FDTD ymax 500 nm more than Al ymax

        %Get MoOx's y max
        appevalscript(FDTD_session, 'select("MoOx");');
        appevalscript(FDTD_session, 'MoOx_ymax = (get("y max"))/nm;'); 
        
        %Set thickness of MoOx (optical spacer) layer
        appevalscript(FDTD_session, 'select("MoOx");');
        %y_max for MoOx is MoOx_ymax. So we subtract MoOx_ymax - varying_thickness to give its thickness
        %(since we are going in negative axis)
        appevalscript(FDTD_session, 'set("y min",((MoOx_ymax*nm) - (varying_thickness*nm)));');
        appevalscript(FDTD_session, 'MoOx_ymin = get("y min");');
        
        appputvar(FDTD_session,'ITO_thickness',ITO_thickness);
        appevalscript(FDTD_session, 'select("ITO");');
        %ITO layer's y_max = MoOx's y_min
        appevalscript(FDTD_session, 'set("y max",MoOx_ymin);');
        %ITO layer's y_min = ITO y_max + 200 (ITO thickness = 200 nm)
        %(since we are going in negative axis)
        appevalscript(FDTD_session, 'set("y min",(MoOx_ymin - (ITO_thickness*nm)));');
        appevalscript(FDTD_session, 'ITO_ymin = get("y min");'); 
        
        appevalscript(FDTD_session, 'select("mesh_full");');
        appevalscript(FDTD_session, 'set("y min",ITO_ymin);'); %Mesh y_min = ITO y_min
        
        appevalscript(FDTD_session, 'select("field");');
        appevalscript(FDTD_session, 'set("y min",ITO_ymin);'); %Field y_min = ITO y_min
        
        appevalscript(FDTD_session, 'select("FDTD");');
        appevalscript(FDTD_session, 'set("y min",(ITO_ymin - (500*nm)));'); %Set FDTD ymin -500 nm more than ITO ymin
        
        appevalscript(FDTD_session, 'select("source");');
        appevalscript(FDTD_session, 'set("y",(ITO_ymin - (200*nm)));'); %Set source ymin -200 nm more than ITO ymin
               
        appevalscript(FDTD_session, 'run;'); %Run the simulation
        
        %Jsc_sim column 1 = simulated Jsc result
        %Jsc_sim column 2 = Random number population
        appevalscript(FDTD_session, 'Jsc_sim = getresult("solar_generation","Jsc");');
        
        Jsc_output(1,I) = appgetvar(FDTD_session, 'Jsc_sim');
        
        
        appevalscript(FDTD_session, 'switchtolayout;');
        
        jsc_dictionary_MoOx(pop) = Jsc_output(1,I);
        
        %close FDTD session
        appclose(FDTD_session);
        simulation_num = simulation_num + 1;
    end
end
%disp(['Jsc outputs: ', num2str(Jsc_output/10)]);
Jsc = (1./Jsc_output).*1000000;
end




