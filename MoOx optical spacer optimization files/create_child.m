function [new_child] = create_child(parent1, parent2, float_precision,...
    num_bits_per_sample, mutation_prob)
% Creates new child by going through the parents bit by bit and choosing
% the bit according to whether a random number is smaller or bigger than
% 0.5
    
    % Reproduction
    parent1_bin = de2bi(round(parent1 * 10^float_precision), num_bits_per_sample);
    parent2_bin = de2bi(round(parent2 * 10^float_precision), num_bits_per_sample);
    new_child_bin = parent1_bin;
    for i=1:1:length(parent1_bin)
        if (rand() < 0.5)
            new_child_bin(i) = parent2_bin(i);
        end
    end
    
    % Mutation
    if rand() < mutation_prob
        % Choose random index in new_child_bin to switch
        i = randi([1, length(new_child_bin)]);
        new_child_bin(i) = not(new_child_bin(i));
    end
    
    new_child = bi2de(new_child_bin)/(10^float_precision);
    
end

