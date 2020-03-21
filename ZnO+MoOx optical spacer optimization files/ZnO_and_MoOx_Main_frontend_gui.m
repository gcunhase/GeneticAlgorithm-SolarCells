delete(gcp('nocreate'));
clear;
close all;
clc;

format longG;

%% Initializing xlsx file name
filename = 'RESULTS/RESULTS_OUTPUT_ZnO_MoOx_Roulette_k4_b12_runs500.xlsx';
filename_base = strtok(filename,'.');
filename = filename_base + "_" + string(datetime('today')) + ".xlsx";
temp=1;
while(true)
    if(isfile(filename))
        filename=filename_base + "_" + string(datetime('today')) + "_" + string(temp+1) + ".xlsx";
        temp = temp+1;
    else
        break;
    end
end

%% GUI for obtaining the number of runs per selection method
prompt = {'Breeder:','Tournament:', 'Roulette:', 'Random:'};
dlgtitle = 'Enter the number of runs. Please enter whole integers.';
selection_method_run_num = inputdlg(prompt,dlgtitle); % Obtain the number of repetitive runs required per selection method
selection_method_run_num = cell2mat(selection_method_run_num);
selection_method_run_num = str2num(selection_method_run_num);
selection_method_run_num = round(selection_method_run_num');
 breeder_count = 0;
 tournament_count = 0;
 roulette_count = 0;
 random_count = 0;
total_repetitive_runs = sum(selection_method_run_num);    % Total number of repeat runs

selection_mat = strings([1,total_repetitive_runs]);
xls_sheet_mat = strings([1,total_repetitive_runs]);
zz_temp = 0;
zz=0;
for zz = 1:1:selection_method_run_num(1,1)
    selection_mat(1,zz_temp+zz) = "breeder";
    xls_sheet_mat(1,zz_temp+zz) = "breeder"+zz;
end
if(~(isempty(zz)))
    zz_temp = zz_temp+zz;
end
for zz = 1:1:selection_method_run_num(1,2)
    selection_mat(1,zz_temp+zz) = "tournament";
    xls_sheet_mat(1,zz_temp+zz) = "tournament"+zz;
end
if(~(isempty(zz)))
    zz_temp = zz_temp+zz;
end
for zz = 1:1:selection_method_run_num(1,3)
    selection_mat(1,zz_temp+zz) = "roulette";
    xls_sheet_mat(1,zz_temp+zz) = "roulette"+zz;
end
if(~(isempty(zz)))
    zz_temp = zz_temp+zz;
end
for zz = 1:1:selection_method_run_num(1,4)
    selection_mat(1,zz_temp+zz) = "random";
    xls_sheet_mat(1,zz_temp+zz) = "random"+zz;
end

run_count = 1;

%Initializing number of workers to number of physical cores in the CPU
myCluster=parcluster('local');
myCluster.NumWorkers=eval('feature(''numcores'')');
parpool(myCluster,eval('feature(''numcores'')'));

for selection_iteration_run_count = 1:1:length(selection_mat)
    
    [overall_success_rate, mean_simulation, sd_simulation] = Evo_alg_ZnO_and_MoOx_optical_spacer_20190521(selection_mat,selection_method_run_num,run_count,selection_iteration_run_count);
    
    % For finding the run number
    if(selection_iteration_run_count ~= length(selection_mat))
    if(selection_mat(1,(selection_iteration_run_count+1)) == selection_mat(1,selection_iteration_run_count))
        run_count = run_count + 1;
    else
        run_count = 1;
    end
    end
    %% Storing output data to RESULTS_OUTPUT.xlsx file
    sheet = selection_iteration_run_count;
    
    xlRange = 'A2';
    cumulative_outputs = table(overall_success_rate, mean_simulation, sd_simulation, 'VariableNames', {'Accuracy','Mean', 'Standard_deviation'});
    writetable(cumulative_outputs, filename, 'Sheet', sheet, 'Range', xlRange);

    xlRange = 'B1';
    writematrix(xls_sheet_mat(1,selection_iteration_run_count), filename, 'Sheet', sheet, 'Range', xlRange);

    if ispc
    e = actxserver('Excel.Application'); % # open Activex server
    ewb = e.Workbooks.Open(pwd+"\"+filename); % # open file (enter full path!)
    ewb.Worksheets.Item(sheet).Name = xls_sheet_mat(1,selection_iteration_run_count); % # rename sheet
    ewb.Save % # save to the same file
    ewb.Close(false)
    e.Quit
    end
    
    delete(gcp('nocreate')); % Stop parallel workers
end

disp('OVER and out');
