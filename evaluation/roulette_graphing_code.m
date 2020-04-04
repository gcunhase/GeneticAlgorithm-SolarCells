clear all;
close all;
clc;

gen = 10:10:100;
mutate = gen; % Generation array and Mutation probability (%) array should be same to work properly (for interp3)
pop = 5:5:20;
[generation, mutation_rate, population] = meshgrid(gen,mutate,pop);

% Change 'primary_path' with the path of xlsx file
primary_path = './RESULTS/';
% Change 'filename' with the name of the xlsx file
filename = strcat(primary_path, 'GA-Roulette_Accuracy_results.xlsx');
[accuracy_xlsx, mean_xlsx, accuracy, mean, sd, pop_slice, gen_slice, mutation_slice] = slicepoints_min_mean(filename);

for x = gen/(gen(2)-gen(1))
    for y = mutate/(mutate(2)-mutate(1))
        for z = pop/(pop(2)-pop(1))
            index_xlsx = ((z-1)*100 + (y-1)*10 + x).*2;
            accuracy_4d_data(x,y,z) = accuracy_xlsx(index_xlsx,1);
            mean_4d_data(x,y,z) = mean_xlsx(index_xlsx,1);
        end
    end
end

%%Testing only
% pop_slice = 1000;
% gen_slice = 50;
% mutation_slice = 50;
%%

interp_gen_dx = 0.25;
interp_mutate_dy = 0.25;
interp_pop_dz = 0.25;

[generation_interp,mutation_rate_interp,population_interp] = meshgrid(gen(1):interp_gen_dx:gen(end),mutate(1):interp_mutate_dy:mutate(end),pop(1):interp_pop_dz:pop(end));
accuracy_4d_data = interp3(generation, mutation_rate, population,accuracy_4d_data,generation_interp,mutation_rate_interp,population_interp);
mean_4d_data = interp3(generation, mutation_rate, population,mean_4d_data,generation_interp,mutation_rate_interp,population_interp);

% Graphing Accuracy data
f1 = figure;
set(f1,'Position',[40,45,1255,952]);
acc_slice_graph = slice(generation_interp, mutation_rate_interp, population_interp, accuracy_4d_data,gen_slice,mutation_slice,pop_slice,'linear');
hold on
set(acc_slice_graph,'EdgeColor','none','FaceColor','interp','FaceAlpha','interp');
graph = gca;
set(graph,'LineWidth',4, 'FontWeight', 'bold', 'FontName', 'Times New Roman', 'FontSize', 22);
graph.OuterPosition = [0.012,0,0.91,1];
graph.Position = [0.13,0.11,0.70,0.815];
graph.XLabel.String = 'Generation count';
graph.YLabel.String = 'Mutation probability (%)';
graph.ZLabel.String = 'Population count';
title({'Method: Roulette; k = 1', 'Accuracy rate (%)'});
set(get(graph,'xlabel'),'rotation',-44, 'Position',[58.55,15.29,-3.09], 'FontSize', 26);
set(get(graph,'ylabel'),'rotation',20', 'Position',[111.65,58.23,4.185], 'FontSize', 26);
set(get(graph,'zlabel'),'rotation',95', 'Position',[36.44,-10.54,17.77], 'FontSize', 26);
alpha('color');
alphamap('rampdown')
alphamap('increase',0.9)
axis tight
camproj perspective
colormap (jet(256));
clr_bar = colorbar;
clr_bar.Position = [0.892,0.116,0.017,0.815];
%slider_range = caxis; %For slider option
shading flat
grid off;
view(59.30,43.20);
lower_legend_value_adjuster = 30; %adjustable---------------->for visualization
caxis([(max(accuracy_xlsx)-lower_legend_value_adjuster),max(accuracy_xlsx)]); 
str = {sprintf('Population count = %d', pop_slice), sprintf('Generation count = %d', gen_slice),...
    sprintf('Mutation probability (%%) = %d', mutation_slice), sprintf('Accuracy (%%) = %g', accuracy),...
    sprintf('Mean count = %.2f ± %.2f', mean, sd)};
annotation('textarrow',[0.56,0.62],[0.52,0.615],'String',str,...
    'HorizontalAlignment', 'left', 'FontName', 'Times New Roman', 'FontSize', 20,...
    'FontWeight', 'bold', 'TextBackgroundColor', [1.00,1.00,1.00]);
hold off

% % Graphing mean number of simulations
f2 = figure;
set(f2,'Position',[100,45,1255,952]);
mean_slice_graph = slice(generation_interp, mutation_rate_interp, population_interp, mean_4d_data,gen_slice,mutation_slice,pop_slice,'linear');
hold on
set(mean_slice_graph,'EdgeColor','none','FaceColor','interp','FaceAlpha','interp');
graph = gca;
set(graph,'LineWidth',4, 'FontWeight', 'bold', 'FontName', 'Times New Roman', 'FontSize', 22);
graph.OuterPosition = [0.012,0,0.91,1];
graph.Position = [0.13,0.11,0.70,0.815];
graph.XLabel.String = 'Generation count';
graph.YLabel.String = 'Mutation probability (%)';
graph.ZLabel.String = 'Population count';
title({'Method: Roulette; k = 1', 'Average number of simulations'});
set(get(graph,'xlabel'),'rotation',-44, 'Position',[58.55,15.29,-3.09], 'FontSize', 26);
set(get(graph,'ylabel'),'rotation',20', 'Position',[111.65,58.23,4.185], 'FontSize', 26);
set(get(graph,'zlabel'),'rotation',95', 'Position',[36.44,-10.54,17.77], 'FontSize', 26);
alpha('color');
alphamap('rampdown')
alphamap('increase',0.7)
axis tight
camproj perspective
colormap (jet(256));
clr_bar = colorbar;
clr_bar.Position = [0.892,0.116,0.017,0.815];
%slider_range = caxis; %For slider option
shading flat
grid off;
view(59.30,43.20);
lower_legend_value_adjuster = 30; %adjustable---------------->for visualization
% caxis([(max(accuracy_xlsx)-lower_legend_value_adjuster),max(accuracy_xlsx)]); 
str = {sprintf('Population count = %d', pop_slice), sprintf('Generation count = %d', gen_slice),...
    sprintf('Mutation probability (%%) = %d', mutation_slice), sprintf('Accuracy (%%) = %g', accuracy),...
    sprintf('Mean count = %.2f ± %.2f', mean, sd)};
annotation('textarrow',[0.56,0.62],[0.52,0.615],'String',str,...
    'HorizontalAlignment', 'left', 'FontName', 'Times New Roman', 'FontSize', 20,...
    'FontWeight', 'bold', 'TextBackgroundColor', [1.00,1.00,1.00]);
hold off
