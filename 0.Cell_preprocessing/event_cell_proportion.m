clear; close all
warning off

% mother_drive = 'D:\Data stroage\'; % typo on folder name
% data_drive = [mother_drive 'Exp_data\Results\1.data_preprocessing\'];

mother_drive = 'D:\NHP_project\Analysis\'; % for SJM PC
data_drive = ['\\147.47.203.207\leelab-office\NHP\Data\Results\1.data_preprocessing\']; % for SJM PC
addpath(genpath(mother_drive))

Sessio_info_array = readtable([data_drive '\plots\6.5.Profile_sheet_asterisk_0.001\sign_results_0.001_interval_abjust.xls']);
SI_array = readtable([data_drive '\plots\6.5.Profile_sheet_asterisk_0.001\SI_results.xls']);
%%

UnitsTable=table;
UnitsTable.UnitNum = Sessio_info_array.Var1;
UnitsTable.UnitID = Sessio_info_array.Var2;
UnitsTable.Num_EventPeak = sum(table2array(Sessio_info_array(:,3:18)),2);
UnitsTable.Num_EventPeak_Forest = sum(table2array(Sessio_info_array(:,3:10)),2);
UnitsTable.Num_EventPeak_City = sum(table2array(Sessio_info_array(:,11:18)),2);

UnitsTable.SI_Forest = SI_array.SI_Forest_Raw;
UnitsTable.SI_City = SI_array.SI_City_Raw;

%%

figure;

x = UnitsTable.Num_EventPeak_Forest;
y =UnitsTable.SI_Forest(UnitsTable.Num_EventPeak_Forest>=0);
% y2 =UnitsTable.SI_Forest(UnitsTable.Num_EventPeak_Forest==0);
subplot(1,2,1)
scatter(x,y,40,'red','filled')
corrcoef(x,y)
title('Forest'); xlabel('Event peak trials'); ylabel('SI (Raw)')
set(gca,'fontsize',12,'FontWeight','b')
ylim([0 5.5]); xlim([0 8])

x = UnitsTable.Num_EventPeak_City;
y=UnitsTable.SI_City;

subplot(1,2,2)
scatter(x,y,40,'b','filled')
corrcoef(x,y)
ylim([0 5.5]); xlim([0 8])
title('City'); xlabel('Event peak trials'); ylabel('SI (Raw)')
set(gca,'fontsize',12,'FontWeight','b')
sgtitle('p<0.001')
%%
figure
subplot(1,2,1)
histogram(UnitsTable.Num_EventPeak_Forest,'normalization','probability','faceColor','r')
xlabel('Event peak trials'); title('Forest')
ylabel('unit proportion')
xlim([-.5 8])

subplot(1,2,2)
histogram(UnitsTable.Num_EventPeak_City,'normalization','probability','faceColor','b')
xlabel('Event peak trials'); title('City')
ylabel('unit proportion')
xlim([-.5 8])
sgtitle('p<0.001')

%%
figure

histogram(UnitsTable.Num_EventPeak_Forest+UnitsTable.Num_EventPeak_City,'normalization','probability')
xlabel('Event peak trials'); title('All')
ylabel('unit proportion')
xlim([-.5 16])
%%
x1 = UnitsTable.SI_Forest(Sessio_info_array.Var3==1);