function [new_child] = create_child(parent1, parent2, float_precision,...
    num_bits_per_sample, mutation_prob, type, k)
% Creates new child by going through the parents bit by bit and choosing
%   the bit according to whether a random number is smaller or bigger than
%   0.5
% type (crossover): uniform, k-point (with k also being provided as parameter)
    
    if nargin == 5
        type = 'uniform';
        k = 1;
    end
    % Reproduction (Crossover)
    parent1_bin = de2bi(round(parent1 * 10^float_precision), num_bits_per_sample);
    parent2_bin = de2bi(round(parent2 * 10^float_precision), num_bits_per_sample);
    new_child_bin = crossover(parent1_bin, parent2_bin, type, k);
    
    % Mutation
    if rand() < mutation_prob
        % Choose random index in new_child_bin to switch
        i = randi([1, length(new_child_bin)]);
        new_child_bin(i) = not(new_child_bin(i));
    end
    
    new_child = bi2de(new_child_bin)/(10^float_precision);
    
end

