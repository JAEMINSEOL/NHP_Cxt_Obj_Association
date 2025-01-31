% cal_PETH_RDI

clear; close all
warning off

% mother_drive = 'D:\Data stroage\'; % typo on folder name
% data_drive = [mother_drive 'Exp_data\Results\1.data_preprocessing\'];

mother_drive = 'D:\NHP_project\Analysis\'; % for SJM PC
data_drive = ['\\147.47.203.207\leelab-office\NHP\Data\Results\1.data_preprocessing\']; % for SJM PC
addpath(genpath(mother_drive))

Sessio_info_array = readtable([data_drive '\Exp_info.csv']);
crit_fr_low = 0.25;
crit_fr_high = 10;
crit_num_spk = 100;

EList_long={'Trial Start','Object Onset','Go-cue Onset', 'Trial End'};
EList_short={'TS','OO','GO', 'TE'};
time_interval = 1.5; bin_sz = .03; nbins = time_interval/bin_sz;

UnitsTable = readtable([data_drive 'Firing_table_forAnalysis.xlsx']);
UnitsTable.SpkLapRatio = UnitsTable.LapNumberFromFirstSpikeToLastSpike ./ UnitsTable.RecordLapNumber;

for uid=1:size(UnitsTable,1)
    UnitsTable.Animal{uid} = UnitsTable.CellId{uid}(1:4);
end
%%
Animal_list = {'Nabi','Yoda'};
tbl_S = table;
UnitsTable_S = UnitsTable(strcmp(UnitsTable.CellType,'S'),:);
for aid=1:2
tbl_S.all(aid) = sum(strcmp(UnitsTable_S.Animal,Animal_list{aid}));
tbl_S.HighFR(aid) = sum(strcmp(UnitsTable_S.Animal,Animal_list{aid}) & min([UnitsTable_S.ForestAverageFiringRate,UnitsTable_S.CityAverageFiringRate],[],2)>crit_fr_high);
tbl_S.LowFR(aid) = sum(strcmp(UnitsTable_S.Animal,Animal_list{aid}) & max([UnitsTable_S.ForestAverageFiringRate,UnitsTable_S.CityAverageFiringRate],[],2)<crit_fr_low);
Units_temp_S = UnitsTable_S(min([UnitsTable_S.ForestAverageFiringRate,UnitsTable_S.CityAverageFiringRate],[],2)<=crit_fr_high &...
    max([UnitsTable_S.ForestAverageFiringRate,UnitsTable_S.CityAverageFiringRate],[],2)>=crit_fr_low,:);
tbl_S.Stability(aid) = sum(strcmp(Units_temp_S.Animal,Animal_list{aid}) & (Units_temp_S.Std_mean>1));

tbl_S.ForAnalysis(aid) = tbl_S.all(aid) - (tbl_S.HighFR(aid) + tbl_S.LowFR(aid)+tbl_S.Stability(aid));
end


tbl_M = table;
UnitsTable_M = UnitsTable(strcmp(UnitsTable.CellType,'M'),:);
for aid=1:2
tbl_M.all(aid) = sum(strcmp(UnitsTable_M.Animal,Animal_list{aid}));
tbl_M.HighFR(aid) = sum(strcmp(UnitsTable_M.Animal,Animal_list{aid}) & min([UnitsTable_M.ForestAverageFiringRate,UnitsTable_M.CityAverageFiringRate],[],2)>crit_fr_high);
tbl_M.LowFR(aid) = sum(strcmp(UnitsTable_M.Animal,Animal_list{aid}) & max([UnitsTable_M.ForestAverageFiringRate,UnitsTable_M.CityAverageFiringRate],[],2)<crit_fr_low);
Units_temp_M = UnitsTable_M(min([UnitsTable_M.ForestAverageFiringRate,UnitsTable_M.CityAverageFiringRate],[],2)<=crit_fr_high &...
    max([UnitsTable_M.ForestAverageFiringRate,UnitsTable_M.CityAverageFiringRate],[],2)>=crit_fr_low,:);
tbl_M.Stability(aid) = sum(strcmp(Units_temp_M.Animal,Animal_list{aid}) & (Units_temp_M.Std_mean>1));

tbl_M.ForAnalysis(aid) = tbl_M.all(aid) - (tbl_M.HighFR(aid) + tbl_M.LowFR(aid)+tbl_M.Stability(aid));
end

%%
writetable(UnitsTable_S,[data_drive 'Firing_table_forAnalysis.xlsx'])

%% FR > 30 Hz
figure
subplot(1,2,1)
histogram(min([UnitsTable.ForestAverageFiringRate UnitsTable.CityAverageFiringRate],[],2),'binwidth',2,'Normalization','probability')
xline(30,'color','r'); 
xlim([0 50])
xlabel('avg FR (min. between Forest & City)'); ylabel('cell proportion')
set(gca,'fontsize',12','FontWeight','b')

subplot(1,2,2)
scatter(UnitsTable.ForestAverageFiringRate, UnitsTable.CityAverageFiringRate)
xline(30,'color','r');
yline(30,'color','r');
xlabel('Forest avg FR (Hz)'); ylabel('City avg FR (Hz)')
xlim([0 50]); ylim([0 50])
set(gca,'fontsize',12','FontWeight','b')

%% FR < .25Hz
figure
subplot(1,2,1)
histogram(max([UnitsTable.ForestAverageFiringRate UnitsTable.CityAverageFiringRate],[],2),'binwidth',.05,'Normalization','probability')
xline(.25,'color','r')
xlim([0 2])
xlabel('avg FR (max. between Forest & City)'); ylabel('cell proportion')
set(gca,'fontsize',12','FontWeight','b')

subplot(1,2,2)
scatter(UnitsTable.ForestAverageFiringRate, UnitsTable.CityAverageFiringRate)
xline(.25,'color','r')
yline(.25,'color','r')
xlabel('Forest avg FR (Hz)'); ylabel('City avg FR (Hz)')
xlim([0 2]); ylim([0 2])
set(gca,'fontsize',12','FontWeight','b')

%% Stability_hist
figure
subplot(1,2,1)
histogram(UnitsTable.Std_mean,'binwidth',.1,'Normalization','probability')
% xline(.25,'color','r')
xlim([0 5])
xlabel('lap-by-lap #spike stdev., normalized'); ylabel('cell proportion')
set(gca,'fontsize',12','FontWeight','b')

subplot(1,2,2)
histogram(UnitsTable.LapNumberFromFirstSpikeToLastSpike./UnitsTable.RecordLapNumber,'binwidth',.05,'Normalization','probability')
% xline(.25,'color','r')
xlim([0 1])
xlabel('proportion of lap with spikes'); ylabel('cell proportion')
set(gca,'fontsize',12','FontWeight','b')

%% Stability_scatter
figure
y = UnitsTable.LapNumberFromFirstSpikeToLastSpike./UnitsTable.RecordLapNumber;
x = UnitsTable.Std_mean;
scatter(x,y)
% xline(.25,'color','r')
ylim([0 1]); xlim([0 5])
ylabel('proportion of lap with spikes'); xlabel('lap-by-lap #spike stdev., normalized');
set(gca,'fontsize',12','FontWeight','b')

%% table_sort
UnitsTable.LapwSpks = UnitsTable.LapNumberFromFirstSpikeToLastSpike./UnitsTable.RecordLapNumber;
Utbl = sortrows(UnitsTable,'Std_mean','descend');
Utbl(max([Utbl.ForestAverageFiringRate Utbl.CityAverageFiringRate],[],2)<0.1,:)=[];

%%

% Units_temp = Units_temp(~(Units_temp.Std_mean>1 | Units_temp.SpkLapRatio<0.8),:);
Units_temp = UnitsTable;
%%
figure
subplot(1,2,1)
histogram(max([Units_temp.ForestSessionSI Units_temp.CitySessionSI],[],2),'binwidth',.05)
% xlim([0 1.2])
xlabel('max SI (Forest vs.  City)'); ylabel('number of cells')
set(gca,'fontsize',12','FontWeight','b')

subplot(1,2,2)
x = Units_temp.ForestSessionSI;
y = Units_temp.CitySessionSI;
scatter(x,y)
ylim([0 2.5]); xlim([0 2.5])
xlabel('Forest SI'); ylabel('City SI');
set(gca,'fontsize',12','FontWeight','b')

sum(Units_temp.ForestSessionSI>0.2 | Units_temp.CitySessionSI>0.2)