% cell_property_sheet_append
clear; close all

% mother_drive = 'D:\Data stroage\'; % typo on folder name
% data_drive = [mother_drive 'Exp_data\Results\1.data_preprocessing\'];

mother_drive = 'D:\NHP_project\Analysis\'; % for SJM PC
data_drive = ['\\147.47.203.207\leelab-office\NHP\Data\Results\1.data_preprocessing\']; % for SJM PC
addpath(genpath(mother_drive))

UnitsTable = readtable([data_drive 'Firing_table_forAnalysis.xlsx']);
UnitsTable.SpkLapRatio = UnitsTable.LapNumberFromFirstSpikeToLastSpike ./ UnitsTable.RecordLapNumber;

crit_fr_low = .25;
crit_fr_high_1 = 10;
crit_fr_high_2 = 30;
crit_stability = 1;
% crit_lap_spks = .8;

%%

% % UnitsTable.Filtering(UnitsTable.Std_mean>crit_stability | UnitsTable.SpkLapRatio<crit_lap_spks) = 3;
% UnitsTable.Filtering(UnitsTable.Std_mean>crit_stability) = 3;
% UnitsTable.Filtering(max([UnitsTable.ForestAverageFiringRate,UnitsTable.CityAverageFiringRate],[],2)<crit_fr_low) = 1;
% UnitsTable.Filtering(min([UnitsTable.ForestAverageFiringRate,UnitsTable.CityAverageFiringRate],[],2)>crit_fr_high_1) = 2;
% UnitsTable.Filtering(min([UnitsTable.ForestAverageFiringRate,UnitsTable.CityAverageFiringRate],[],2)>crit_fr_high_2) = 2.5;

%%

for uid =1:size(UnitsTable,1)
    try
        UnitID_full = [jmnum2str(UnitsTable.CellNumber(uid),3) '_' UnitsTable.CellId{uid}];

        figure('position',[20 60 2000 850],'Color','w')

        subplot('position',[0 .95 1 .05]);
        text(2,3,['lap numbers between first and last spike = ' jjnum2str(UnitsTable.LapNumberFromFirstSpikeToLastSpike(uid),3) ...
            ' (' jjnum2str(UnitsTable.SpkLapRatio(uid)*100,0) '%)'],'fontsize',12,'FontWeight','b')
        text(2,7,['Z-scored stdev of spks/lap = ' jjnum2str(UnitsTable.Std_mean(uid),3)],'fontsize',12,'FontWeight','b')
        xlim([0 100]); ylim([0 10])
        axis off

        subplot('position',[0 0 .4 .95]);
        im_ori = imread([data_drive 'plots\cell property sheet_ori\' UnitID_full '.jpg']);
        imagesc(imresize(im_ori, 10))
        axis off
    catch
    end
    try
        subplot('position',[.4 0 .6 .95]);
        try
        im_peth = imread([data_drive 'plots\cell property sheet_PETH\' UnitID_full(1:end-3) 'S_PETH_sheet.jpg']);
        catch
            im_peth = imread([data_drive 'plots\cell property sheet_PETH\' UnitID_full(1:end-3) 'M_PETH_sheet.jpg']);
        end

        imagesc(imresize(im_peth, 10))
        axis off

        switch UnitsTable.Filtering(uid)
            case 0, fname = 'forAnalysis';
            case 1, fname = 'low fr';
            case 2, fname = 'high fr (10~30)';
            case 2.5, fname = 'high fr (30~)';
            case 3, fname = 'low stability';
            otherwise, 'unknown';
        end

        if strcmp(UnitsTable.CellType{uid},'S')
            ctype = 'Single';
        elseif strcmp(UnitsTable.CellType{uid},'M')
            ctype = 'Multi';
        end
        fig_drive = [data_drive 'plots\cell property sheet_append_final\' ctype '\' fname];
        if ~exist(fig_drive) mkdir(fig_drive); end

        saveas(gca,[fig_drive '\' UnitID_full '.png'])
    catch
        uid
    end

    close all
end