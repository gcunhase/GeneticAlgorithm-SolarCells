function [accuracy_xlsx, mean_xlsx, accuracy, mean, sd, pop_slice, gen_slice, mutation_slice] = slicepoints_min_mean(filename)
% %%test
% filename = 'Breeder_Accuracy_results.xlsx'
% %%

table_data = readtable(filename);

accuracy_xlsx = str2double(string(table2array(table_data(2:end,5))));
mean_xlsx = str2double(string(table2array(table_data(2:end,6))));
sd_xlsx = str2double(string(table2array(table_data(2:end,7))));
pop_gen_mutate_xlsx = str2double(string(table2array(table_data(2:end,1:3))));

[row_acc,~] = find(accuracy_xlsx==max(accuracy_xlsx));
mean_acc_100_sorted = mean_xlsx(row_acc);
[min_mean_value,~] = min(mean_acc_100_sorted);
[row_mean,~] = find(mean_xlsx == min_mean_value & accuracy_xlsx==max(accuracy_xlsx));

pop_slice = pop_gen_mutate_xlsx(row_mean,1);
gen_slice = pop_gen_mutate_xlsx(row_mean,2);
mutation_slice = pop_gen_mutate_xlsx(row_mean,3);
accuracy = accuracy_xlsx(row_mean,1);
sd = sd_xlsx(row_mean,1);
mean = round(min_mean_value,2);
sd = round(sd,2);
end



