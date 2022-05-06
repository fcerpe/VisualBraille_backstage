
% import data

%% age vs. words read 
f1 = figure('Units','pixels','Position',[200 200 400 300])
scatter(expertise{:,2}',expertise{:,3}','filled');
xlabel('age');
ylabel('words read in a minute');
ylim([-1 30])
xlim([-1 40]);

corrcoef(expertise{:,2}',expertise{:,3}')
%% age v. reading time single word
f2 = figure('Units','pixels','Position',[200 200 400 300])
scatter(expertise{:,2}',expertise{:,4}','filled');
xlabel('age');
ylabel('reading time (1st presentation)');
ylim([0 8]);
xlim([0 40]);

corrcoef(expertise{:,2}',expertise{:,4}')

%% age v. reading time single word
f3 = figure('Units','pixels','Position',[200 200 400 300])
scatter(expertise{:,2}',expertise{:,6}','filled');
xlabel('expertise');
ylabel('reading time (3rd presentation)');
ylim([0 8]);
xlim([0 40]);

corrcoef(expertise{:,2}',expertise{:,6}')