function next_parents = selection(y_sorted, pop_sorted, n_pop, num_children, type)
%SELECTION Summary of this function goes here
%   Detailed explanation goes here
    format longG;
    switch type
        case 'random'
            next_parents = pop_sorted(randperm(n_pop, round(n_pop/2));
        case 'roulette'
            rounded_int_pop = round(n_pop/2);
            % Elements should be between 0 and 1 and sum of all elements should add to 1
            y = y_sorted./sum(y_sorted);
            % Vector from min_val to 1 where v_i += v_{i-1}
            for i=2:n_pop
                y(i) = y(i-1) + y(i);
            end
            % Calculate next_parents
            next_parents = zeros(1, rounded_int_pop);
            rng('shuffle');
            r = randn(1, rounded_int_pop);
            rng('default');
            for i=1:rounded_int_pop
                for j=1:n_pop
                    if r(i) < y(j)
                        next_parents(i) = pop_sorted(j);
                        break;
                    end
                end
            end
        case 'tournament'
            rounded_int_pop = round(n_pop/2);
            next_parents = zeros(1, rounded_int_pop);
            if(length(n_pop) >= 5)
                K = 5;
            else
                K = length(n_pop);
            end
            j = 1;
            for i=1:rounded_int_pop
                candidates = randperm(n_pop, K);
                candidates_fitness = y_sorted(candidates);
                candidates_pop = pop_sorted(candidates);
                
                % Chose best fitness from candidates
                [~, idx] = min(candidates_fitness);  % minimization problem
                next_parents(j) = candidates_pop(idx);
                j = j + 1;
            end
        case 'breeder'
            % Breeding: top parents + lucky few
            % Sources: https://pdfs.semanticscholar.org/26b4/c7112283a85c8b8af43aea73e3c8e8581e9d.pdf
            % https://blog.sicara.com/getting-started-genetic-algorithms-python-tutorial-81ffa1dd72f9
            N = round(n_pop/(num_children*2));  % n_pop=10, N=3
%             N = round((length(pop_sorted))/(num_children*2));  % n_pop=10, N=3
            M = round(n_pop/num_children - N);  % n_pop=10, M=2
%             M = round((length(pop_sorted)/num_children) -1 - N);  % n_pop=10, M=2


            best_sample = [1:1:N];
            lucky_few = randi([N, n_pop], [1, M]);
            next_parents = pop_sorted(best_sample);
            next_parents = [next_parents, pop_sorted(lucky_few)];

            %Shuffle next population
            next_parents = next_parents(randperm(length(next_parents)));
        otherwise
            fprintf('Error, no such selection method was found! Try again!\n')
    end

end

