%OCSD (prh recording
%Assess cluster quality
%Pre-requisites: jkGetClusterQuals.m	[see the comments in that function for details]
%Code by Jangjin Kim, 2011-Sep-24
%Revised by Jaerong Ahn
%Preparation
%Revised by S.Park 4/18/2013
%Updated by Jhoseph Shin on 11/21/2019
%Updated by Jaemin Seol on 01/08/2020

%% Initializing

% add path

% mother_drive = 'D:\VR_Headfix_Data_Ephys';
% 
% addpath(genpath([mother_drive '\program\MClust-3.5']));
% addpath([mother_drive '\program']);
motherROOT = processed_folder_neuralynx;

if ~exist(motherROOT, 'dir') mkdir (motherROOT); end
saveROOT = processed_folder_neuralynx; 
if ~exist(saveROOT) mkdir(saveROOT); end

cd(saveROOT);

% nameCSVFILE = ['clusterSummary.csv'];
% csvHEADER = ['cellID,task,ratID,sessionID,TT,cluster No,GenRegion,SpecRegion,nSPKS, ForestAvgFR, CityAvgFR, withinREFRACPortion, max_width, max_peak, max_amp, peak_ratio, LRATIO, ISODIST, LogISIPEAKTIME, ForestSpaInfoScore, CitySpaInfoScore, RMI, TMI1, fft_max_frequency, fft_peak, fft_mean, fft selectivity\n'];
% 
% 
% 
% if ~exist(nameCSVFILE)
% 	hCSV = fopen(nameCSVFILE, 'W');
% 	fprintf(hCSV, csvHEADER);
% 	fclose(hCSV); clear hCSV;
% end	%~exist(nameCSVFILE)


%Load basic param

cd(motherROOT);
sessionStr = {'normal_environment', 'auditory_contextual_switch', 'fog_session', 'sensory_motor_gain_session', 'post_fog_session', 'day_night_session'};

%Load cluster list

cd(motherROOT);
inputCSV = fopen('ClusterID.csv', 'r');
inputLOAD = fscanf(inputCSV, '%c');
inputNewline = find(inputLOAD == sprintf('\n'));

%validity file
% ChannelValidity_file = [motherROOT '\Disabled_ch_info.csv'];

stCellRun = 1; %if it is finished due to an error, you can fix the error and restart from next cell.

%Calc. starts

tic;
for cellRUN = stCellRun:1:1
	cd(motherROOT);
	if cellRUN == 1
        
		clusterID = inputLOAD(1, 1:inputNewline(cellRUN) - 2);
	else
		clusterID = inputLOAD(1, 1 + inputNewline(cellRUN - 1):inputNewline(cellRUN) - 2);
	end	%cellRUN ~= 1
	findHYPHEN = find(clusterID == '-');
    
	thisRID = (clusterID(1, 1:findHYPHEN(1) - 1));
	thisSID = (clusterID(1, findHYPHEN(1) + 1:findHYPHEN(2) - 1));
    thisSession = ['rat' thisRID '-' thisSID];
	thisTTID = (clusterID(1, findHYPHEN(2) + 1:findHYPHEN(3) - 1));
	thisCLID = (clusterID(1, findHYPHEN(3) + 1:end));

    %find session type
    stIter = get_sessionType(thisRID, thisSID);
    thisSessionType = sessionStr{stIter};
      
    [nSPKS, ForestAvgFR, CityAvgFR, withinREFRACPortion, max_width, max_peak, max_amp, peak_ratio, LRATIO, ISODIST, LogISIPEAKTIME, ForestSpaInfoScore, CitySpaInfoScore, RMI, TMI1, fft_max_frequency, fft_peak, fft_mean, fft_selectivity] = JKGetClusterQuals_JS_SJM(clusterID, ChannelValidity_file, motherROOT, saveROOT);

	cd(saveROOT);
	hCSV = fopen(nameCSVFILE, 'A'); 
    fprintf(hCSV, '%s,%s,%s,%s,%s,%s,%c,%c,%d,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f\n', clusterID, thisSessionType, thisRID, thisSID, thisTTID, thisCLID, ...
        '?', '?', nSPKS, ForestAvgFR, CityAvgFR, withinREFRACPortion, max_width, max_peak, max_amp, peak_ratio, LRATIO, ISODIST, LogISIPEAKTIME, ForestSpaInfoScore, CitySpaInfoScore, RMI, TMI1, fft_max_frequency, fft_peak, fft_mean, fft_selectivity);
   
	
    fclose(hCSV); clear hCSV;
	clear findHYPHEN thisRID thisRatORDER thisSID  thisTTID thisCLID nSPKS ForestAvgFR CityAvgFR ForestSpaInfoScore withinREFRACPortion max_width max_peak max_amp peak_ratio LRATIO ISODIST CitySpaInfoScore LOGISIPEAKTIME RMI TMI1 fft_max_frequency fft_peak fft_mean fft_selectivity;
end	

cd(motherROOT); toc;