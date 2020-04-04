function [new_child_bin] = crossover(parent1_bin, parent2_bin, type, k)
%CROSSOVER Genetic operator for reproduction 
%   Returns child according to the type of crossover (uniform and k-point)
%     Uniform: bitwise reproduction
%     One-point: k=1
%     Multi-point: 1 < k < P, where P is the length of the parent. If k=P, 
%       we have uniform crossover.

    l_p = length(parent1_bin);
    switch type
        case 'uniform'
            new_child_bin = parent1_bin;
            for i=1:1:l_p
                if (rand() < 0.5)
                    new_child_bin(i) = parent2_bin(i);
                end
            end
        case 'k-point'
            new_child_bin = parent1_bin;
            l_p_segment = round(l_p/(k+1));
            if k == 1 % One-point
                if (rand() < 0.5)
                    new_child_bin(1:l_p_segment) = parent2_bin(1:l_p_segment);
                else
                    new_child_bin(l_p_segment+1:end) = parent2_bin(l_p_segment+1:end);
                end
            else % Multi-point
                for i=1:k
                    if (rand() < 0.5)
                        new_child_bin(l_p_segment*(i-1)+1:l_p_segment*i) = parent2_bin(l_p_segment*(i-1)+1:l_p_segment*i);
                    end
                end
            end
        otherwise
            fprintf('Error, no such crossover method was found! Try again!\n')
    end

end

