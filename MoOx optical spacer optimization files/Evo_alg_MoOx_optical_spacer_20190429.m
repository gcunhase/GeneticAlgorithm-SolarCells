function [overall_success_rate, mean_simulation, sd_simulation] = Evo_alg_MoOx_optical_spacer_20190429(selection_mat,selection_method_run_num,run_count,selection_iteration_run_count)

temp_count = 0;
overall_success_rate = zeros(800,1);
sd_simulation = zeros(800,1);
mean_simulation = zeros(800,1);
MoOx_thickness = 30;
for pop_recursive=5:5:(MoOx_thickness-10)
    for gen_recursive=10:10:100
        for mutation_recursive=5:5:100
            % Number of runs
            repeat_runs = 500; % 1000;
            success = 0;
            temp_count = temp_count + 1;
            tic;
            
            total_simulation_num = zeros(1,repeat_runs);
            
            parfor(z=1:repeat_runs)
                %                 disp(['RUN no. = ', num2str(z)]);
                tstart = tic;
                simulation_num = 0;
                
                %% GA 1D: Custom code
                
                % Decides whether initial population has a random seed or the same (for fidelity)
                testing = 2; %0; % testing = 1 is for fixed population instead of random. testing = 2 is for using Jsc (fittness value) database if FDTD software is not avaialble.
                % Provide the MoOx optical spacer thickness limits
                thickness_min = 0;
                thickness_max = MoOx_thickness;
                % Initial population
                n_pop = pop_recursive;
                % randi function gives numbers from 1 to max_value.
                % So to obtain numbers from 20 to MoOx_thickness, we made 19+randi(30,1 (array size), num of digits));
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
                num_bits_per_sample = length(de2bi(thickness_max)); %5
                num_children = 2;
                mutation_prob_percentage = mutation_recursive; % Give number in percentage and avoid decimals
                mutation_prob = mutation_prob_percentage/100;
                
                %Hash table or dictionary
                %Use the JscKey and JscValueSet for testing purpose only
                %The below values are brute-force Jsc results within this simulation range. It is used when FDTD software is not available and for testing purposes.
                %simulations_required and jsc_dictionary_MoOx are the same when not in testing mode. This redundancy is known and exists for ease of future testing.
                %----------------
                if testing == 2
                jscKey_MoOx = 0:1:30;
                jscValueSet_MoOx = [120.0773176,120.8456837,120.860436,120.9146849,120.9701946,121.0270251,121.0851881,121.1446717,121.2054897,116.5022856,116.6620336,116.8399258,119.1426906,118.9432454,118.7839258,118.6024644,118.4148925,118.2272443,118.6293086,118.4874841,118.3768759,118.2389213,118.1160135,117.987314,117.8609946,117.7335726,117.6156901,117.9393804,117.8397217,117.7541059,117.6622976];
                jsc_dictionary_MoOx = containers.Map(jscKey_MoOx,jscValueSet_MoOx);
                %----------------
                else
                jsc_dictionary_MoOx = containers.Map('KeyType','int32','ValueType','any');
                end
                simulations_required = containers.Map('KeyType','int32', 'ValueType','any');

                % Check criteria
                while generation <= max_generation
                    %         disp(['Generation: ', num2str(generation), '/', num2str(max_generation)]);
                    % Fitness
                    FitnessFunction = @jsc_FDTD_MoOx;
                    [y, jsc_dictionary_MoOx, simulations_required, simulation_num] = FitnessFunction(pop, jsc_dictionary_MoOx, simulations_required, simulation_num,testing);
                    
                    % Selection: rank population by lowest y score (minimization problem)
                    [y_sorted, index] = sort(y, 'ascend');
                    pop_sorted = pop(index);
                    
                    % Adding the best speciment to the selection population
                    % This is done since the best speciment (pop_sorted(1)) will be kept aside as a backup
                    pop_sorted(end) = pop_sorted(1);
                    pop_sorted = circshift(pop_sorted, [2,1]);

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
                if(pop_sorted(1) == 8)
                    success = success + 1;
                end
                total_simulation_num(1,z) = simulation_num;
            end
            
            breeder_total = selection_method_run_num(1);
            tournament_total = selection_method_run_num(2);
            roulette_total = selection_method_run_num(3);
            random_total = selection_method_run_num(4);
            
            switch selection_mat(1,selection_iteration_run_count)
                case 'breeder'
                    run_count_total = breeder_total;
                case 'tournament'
                    run_count_total = tournament_total;
                case 'roulette'
                    run_count_total = roulette_total;
                case 'random'
                    run_count_total = random_total;
            end
            cprintf('*blue', ['-----Selection methods-----\nBreeder\t\t: ', num2str(breeder_total), '\nTournament\t: ', num2str(tournament_total), '\nRoulette\t: ', num2str(roulette_total), '\nRandom\t\t: ', num2str(random_total),'\n']);
            selection_method = cellstr(selection_mat(1,selection_iteration_run_count));
            cprintf('*blue', ['----------Selection method: ', selection_method{1}, '; Run count: ', num2str(run_count),'/',num2str(run_count_total),'----------\n']);
            
            disp(['OVERALL SUCCESS RATE = ', num2str(success/repeat_runs*100)]);
            disp(['AVERAGE TIME = ', num2str(toc/repeat_runs)]);
            %             fprintf('\n');
            overall_success_rate(temp_count,1) = success/repeat_runs*100;
            mean_simulation(temp_count,1) = mean(total_simulation_num);
            sd_simulation(temp_count,1) = std(total_simulation_num,1);
            
            if((temp_count*100/length(overall_success_rate)) ~= 100)
                cprintf('*red',['----------Completion (%%) = ', num2str(round(temp_count*100/length(overall_success_rate), 2)),' %% = (',num2str(temp_count),'/',num2str(length(overall_success_rate)),' simulations)----------\n']);
                cprintf('*blue', 'Simulation running; Please do not shutdown\n\n');
            else
                cprintf('*[0.4,0.8,0.5]',['----------Completion (%%) = ', num2str(round(temp_count*100/length(overall_success_rate), 2)),' %% = (',num2str(temp_count),'/',num2str(length(overall_success_rate)),' simulations)----------\n']);
                cprintf('*blue', 'Simulation completed\n\n');
            end
        end
    end
end
end

