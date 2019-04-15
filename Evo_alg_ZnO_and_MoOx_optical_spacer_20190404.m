clear;
close all;
clc;

format longG;

%% Initializing xlsx file name
filename = 'RESULTS_OUTPUT.xlsx';
temp=1;
while(true)
    if(isfile(filename))
        filename = strtok(filename,'.');
        filename=filename + string(temp+1) + ".xlsx";
    else
        break;
    end
end

%% GUI for obtaining the number of runs per selection method
prompt = {'Breeder:','Tournament:', 'Roulette:', 'Random:'};
dlgtitle = 'Enter the number of runs. Please enter whole integers.';
answer = inputdlg(prompt,dlgtitle); % Obtain the number of repetitive runs required per selection method
answer = cell2mat(answer);
answer = str2num(answer);
answer = round(answer');
total_repetitive_runs = sum(answer);    % Total number of repeat runs

selection_mat = strings([1,total_repetitive_runs]);
xls_sheet_mat = strings([1,total_repetitive_runs]);
zz_temp = 0;
zz=0;
for zz = 1:1:answer(1,1)
    selection_mat(1,zz_temp+zz) = "breeder";
    xls_sheet_mat(1,zz_temp+zz) = "breeder"+zz;
end
if(~(isempty(zz)))
    zz_temp = zz_temp+zz;
end
for zz = 1:1:answer(1,2)
    selection_mat(1,zz_temp+zz) = "tournament";
    xls_sheet_mat(1,zz_temp+zz) = "tournament"+zz;
end
if(~(isempty(zz)))
    zz_temp = zz_temp+zz;
end
for zz = 1:1:answer(1,3)
    selection_mat(1,zz_temp+zz) = "roulette";
    xls_sheet_mat(1,zz_temp+zz) = "roulette"+zz;
end
if(~(isempty(zz)))
    zz_temp = zz_temp+zz;
end
for zz = 1:1:answer(1,4)
    selection_mat(1,zz_temp+zz) = "random";
    xls_sheet_mat(1,zz_temp+zz) = "random"+zz;
end

%Initializing number of workers to number of physical cores in the CPU
myCluster=parcluster('local'); 
myCluster.NumWorkers=eval('feature(''numcores'')'); 
parpool(myCluster,eval('feature(''numcores'')'));

%%
for selection_iteration_run_count = 1:1:length(selection_mat)

temp_count = 0;
overall_success_rate = zeros(1400,1);
sd_simulation = zeros(1400,1);
mean_simulation = zeros(1400,1);

for pop_recursive=10:10:70
    for gen_recursive=10:10:100
        for mutation_recursive=5:5:100
            % Number of runs
            repeat_runs = 1000;
            success = 0;
            temp_count = temp_count + 1;
            tic;
            
            total_simulation_num = zeros(1,1000);
            
            parfor(z=1:repeat_runs)
%                 disp(['RUN no. = ', num2str(z)]);
                tstart = tic;
                simulation_num = 0;
                
                %% GA 1D: Custom code
                
                % Decides whether initial population has a random seed or the same (for fidelity)
                testing = 0;
                % Provide the ZnO optical spacer thickness limits
                thickness_min = 0;
                thickness_max = 80;
                % Initial population
                n_pop = pop_recursive;
                % randi function gives numbers from 1 to max_value.
                % So to obtain numbers from 20 to 80, we made 19+randi(80,1 (array size), num of digits));
                rand_min = thickness_min-1;  % -1
                rand_max = thickness_max-thickness_min+1;  % 81
                
                if testing == 1
                    rng('default');
                    pop = rand_min + randi(rand_max,1,n_pop);
                else
                    rng('shuffle');
                    pop = randperm(rand_max,n_pop) + rand_min;  % non repeating population from thickness_min to thickness_max
                end
                % pop = rand_min + randi(rand_max,1,n_pop);
                %                 disp(['Initial random population: ', num2str(pop)]);
                
                max_generation = gen_recursive;
                generation = 0;
                float_precision = 0;  % 10^float_precision
                num_bits_per_sample = length(de2bi(thickness_max));
                num_children = 2;
                mutation_prob_percentage = mutation_recursive; % Give number in percentage and avoid decimals
                mutation_prob = mutation_prob_percentage/100;
                
                %Hash table or dictionary
                %Use the JscKey and JscValueSet for testing purpose only
                %----------------
                jscKey = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80];
                jscValueSet = [11.36403326,11.37808746,11.39211672,11.40919261,11.42375246,11.4382067,11.45249909,11.4668977,11.48134774,11.44024933,11.52220068,11.5369408,11.55166802,11.58253793,11.58261261,11.58271356,11.58282227,11.58296949,11.63442572,11.63420369,11.63399039,11.63378551,11.63357474,11.63339016,11.66226863,11.66142731,11.66056859,11.6597022,11.65881999,11.65794652,11.66700404,11.66526872,11.66350918,11.66172902,11.65993235,11.65811383,11.64995379,11.64713925,11.64430909,11.64144499,11.63854352,11.61636099,11.61239355,11.60839757,11.60435575,11.60027296,11.59616788,11.45520714,11.48632298,11.4734731,11.45684888,11.43972747,11.42214682,11.40450509,11.38605891,11.367231,11.34805409,11.32856584,11.30879808,11.28880113,11.26860299,11.29368857,11.27417064,11.25453095,11.23511565,11.21530445,11.19546453,11.17562456,11.15582121,11.13608112,11.11643737,11.09692473,11.07757239,11.05840471,11.07547562,11.05725604,11.03900931,11.0210098,11.00328281,10.98584797,10.96872866];
                jsc_dictionary = containers.Map(jscKey,jscValueSet);
                %----------------
%                 jsc_dictionary = containers.Map('KeyType','int32','ValueType','any');
                simulations_required = containers.Map('KeyType','int32', 'ValueType','any');
                
                % Check criteria
                while generation <= max_generation
                    %         disp(['Generation: ', num2str(generation), '/', num2str(max_generation)]);
                    % Fitness
                    FitnessFunction = @jsc_FDTD;
                    [y, jsc_dictionary, simulations_required, simulation_num] = FitnessFunction(pop, jsc_dictionary, simulations_required, simulation_num);
                    
                    % Selection: rank population by lowest y score (minimization problem)
                    [y_sorted, index] = sort(y, 'ascend');
                    pop_sorted = pop(index);
                    
                    %%
                    pop_sorted_breed = pop_sorted(2:length(pop_sorted));
                    y_sorted_breed = y_sorted(2:length(y_sorted));
                    pop_sorted_max = pop_sorted(1);
                    y_sorted_max = y_sorted(1);
                    if(mod(n_pop,2))
                        n_pop_withoutmax = n_pop - (num_children - 1);
                    else
                        n_pop_withoutmax = n_pop - num_children;
                    end
                    %%
                    
                    if generation < max_generation
                        next_parents = selection(y_sorted_breed, pop_sorted_breed, n_pop_withoutmax, num_children, selection_mat(1,selection_iteration_run_count));
                        
                        % Crossover (reproduction)
                        % num_children = n_pop - (M + N);
                        new_pop = [];
                        
                        for i=1:round(length(next_parents)) %"for i=1:round(n_pop/2)" was changed to "for i=1:round(length(next_parents))"
                            parent1 = next_parents(i);
                            parent2 = next_parents(length(next_parents) - i + 1);
                            for j=1:1:num_children
                                while true
                                    child = create_child(parent1, parent2,...
                                        float_precision, num_bits_per_sample, mutation_prob);
                                    %Check if between range
                                    if ((child <= thickness_max) && (child >= thickness_min))
                                        break;
                                    end
                                end
                                new_pop = [new_pop, child];
                            end
                        end
                        
                        new_pop = [pop_sorted_max, new_pop];
                        
                        for pop_num = (length(new_pop)+1):(n_pop)
                            parent1 = pop_sorted_max;
                            parent2 = pop_sorted_max;
                            %                     for j=1:1:num_children
                            while true
                                child = create_child(parent1, parent2,...
                                    float_precision, num_bits_per_sample, mutation_prob);
                                %Check if between range
                                if ((child <= thickness_max) && (child >= thickness_min))
                                    break;
                                end
                            end
                            new_pop = [new_pop, child];
                        end
                        pop = new_pop;
                        %             fprintf('\n');
                        %             disp(['Length of New population: ', num2str(length(new_pop))]);
                        %             fprintf('\n');
                        %             disp(['New population: ', num2str(pop)]);
                        %
                    end
                    generation = generation + 1;
                end
                telapsed = toc(tstart);
                %     fprintf('\n');
                %                 disp(['Simulations run: ', num2str(simulation_num)]);
                %                 disp('Completed Result: ');
                %                 disp(['best_thickness: ', num2str(pop_sorted(1)), ', best_Jsc: ', num2str(100000/y_sorted(1)), ' mA/cm^2']);
                %                 disp(['Simulations run: ', num2str(telapsed)]);
                %                 fprintf('\n');
                
                %Success parameter
                if(pop_sorted(1) == 30)
                    success = success + 1;
                end
                total_simulation_num(1,z) = simulation_num;
            end
            disp(['OVERALL SUCCESS RATE = ', num2str(success/repeat_runs*100)]);
            disp(['AVERAGE TIME = ', num2str(toc/repeat_runs)]);
            fprintf('\n');
            overall_success_rate(temp_count,1) = success/repeat_runs*100;
            mean_simulation(temp_count,1) = mean(total_simulation_num);
            sd_simulation(temp_count,1) = std(total_simulation_num,1);

            if(temp_count*100/1400 ~= 100)
                cprintf('*red',['----------Completion (%%) = ', num2str(round(temp_count*100/1400, 2)),' %% = (',num2str(temp_count),'/',num2str(length(overall_success_rate)),' simulations)----------\n']);
                cprintf('*blue', 'Simulation running; Please do not shutdown\n\n');
            else
                cprintf('*[0.4,0.8,0.5]',['----------Completion (%%) = ', num2str(round(temp_count*100/1400, 2)),' %% = (',num2str(temp_count),'/',num2str(length(overall_success_rate)),' simulations)----------\n']);
                cprintf('*blue', 'Simulation completed\n\n');
            end
        end
    end
end

    
    %% Storing output data to RESULTS_OUTPUT.xlsx file
    headers = {'Accuracy','Mean', 'Standard deviation'};
    sheet = selection_iteration_run_count;
    xlRange = 'A1';
    xlswrite(filename,headers,sheet,xlRange);
    
    
    cumulative_outputs = [overall_success_rate, mean_simulation, sd_simulation];
    xlRange = 'A2';
    xlswrite(filename,cumulative_outputs,sheet,xlRange);
    
    e = actxserver('Excel.Application'); % # open Activex server
    ewb = e.Workbooks.Open(pwd+"\"+filename); % # open file (enter full path!)
    ewb.Worksheets.Item(sheet).Name = xls_sheet_mat(1,selection_iteration_run_count); % # rename 1st sheet
    ewb.Save % # save to the same file
    ewb.Close(false)
    e.Quit
    
    delete(gcp('nocreate')); % Stop parallel workers
end

disp('OVER and out');