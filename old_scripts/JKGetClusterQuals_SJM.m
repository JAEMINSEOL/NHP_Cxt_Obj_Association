function [nSPKS, withinREFRACPortion, SPKWIDTHAMP, SPKWIDTH, ttSPKWIDTH, MaximumChannel, thisCLAP,thisCLTS, maxAPMat, ISODIST, LRATIO, PEAKMat, VALLEYMat, ttSPKPEAK, ttSPKVALLEY] = JKGetClusterQuals(Dir_Data, TetrodeNumber, ClusterNum, Session_num, ChannelValidity, epochST, epochED)
% function [nSPKS FRRate onmazeMaxFR onmazeAvgFR withinREFRACPortion SPKWIDTHAMP SPKWIDTH ttSPKWIDTH LRATIO ISODIST SpaInfoScore LogISIPEAKTIME] = JKGetClusterQuals(clusterID, ChannelValidity_file)
%Cluster Quality Assesment
%Code by Jangjin Kim, 2011-Sep-22nd
%References: MClust package by David Redish; Custom codes from Sebastien Delcasso
%
%Pre-requisites
%1. Write_fd_file.m [from MClust package]
%2. IsolationDistance.m [from MClust package]
%3. L_Ratio.m [from MClust package]
%
%Input
%clusterID: strings denoting cluster ID. It contains rat, day, and TT information
%
%Output
%nSPKS: number of spikes observed during the entire behavioral session
%FRRate: firing rate observed during the entire behavioral session
%onmazeMaxFR: maximal firing rate observed on the maze [OB + IB]
%onmazeAvgFR: average firing rate observed on the maze [OB + IB]
%withinREFRACPortion: proportion of spikes within the refractory period [1 msec]
%SPKWIDTHAMP: Peak-to-valley, half width due to the tail parts do not come back to the baseline in some cases [from the channel with maximal amp]
%SPKWIDTH: Peak-to-valley, half width due to the tail parts do not come back to the baseline in some cases [avg. of four tips]
%ttSPKWIDTH: [1 x 4] Peak-to-valley, half width due to the tail parts do not come back to the baseline in some cases [each tetrode tip]
%LRATIO: L-ratio [Harris et al.]
%ISODIST: isolation distance [Harris et al.]
%SpaInfoScore: Skaggs et al., 1993
%LogISIPEAKTIME: ISI peak position [70 ~100 ms interneuons]
%
%ENDOF-----HEADER
ISODIST = 0; L=0; LRATIO=0; df=0 ;
g.ARMENTRANCELINE = 300;

%Basic param
currentROOT = pwd;
clusterROOT = Dir_Data;
sFr = 1 / 32000;
microSEC = 10^6;

%it's not correct value. but I don't use the value made using this variables. 2/14/2014
imROW = 500;
imCOL = 650;
thisFRMapSCALE = 10;
videoSamplingRate = 30;

szDOT = 3;
colTRACE = [.4 .4 .4];
colSPK = [1 0 0];

szFONT = 8;
txtINIX = 1; txtINIY = 9.5; txtADJ = 1;

ISIREFRACTORY = 1; isiWINDOW = 7; isiSCALE = 100; histEDGE = -1:1 / isiSCALE:isiWINDOW;
szLINE = 2;

% close all; picID = figure('Color', [1 1 1], 'Position', [50 50 800 1000]);

% %Parse clusterID - Use ClusterFile instead
% findHYPHEN = find(clusterID == '-');
% 
% thisRID = clusterID(1, 1:findHYPHEN(1) - 1);
% thisDID = clusterID(1, findHYPHEN(1) + 1:findHYPHEN(2) - 1);
% thisTTID = clusterID(1, findHYPHEN(2) + 1:findHYPHEN(3) - 1);
% thisCLID = clusterID(1, findHYPHEN(3) + 1:end);


% I:\OBJ-PLC-PRh\ClusterCutting\Rat133\rat133-13\
%Load Epoch information from Defaults
% cd([clusterROOT '\rat' thisRID '\rat' thisRID '-' thisDID]);
% defID = fopen('Defaults');
% defSTR = fscanf(defID, '%c');
% fclose(defID);
% 
% if ~isempty(findstr(defSTR,'beh'))
%     thisEPOCHSTR = defSTR(findstr(defSTR, 'beh'):length(defSTR));
% elseif ~isempty(findstr(defSTR,'Beh'))
%     thisEPOCHSTR = defSTR(findstr(defSTR, 'Beh'):length(defSTR));    
% elseif ~isempty(findstr(defSTR, 'exp'))
%     thisEPOCHSTR = defSTR(findstr(defSTR, 'exp'):length(defSTR));
% end
% findNL = find(thisEPOCHSTR == sprintf('\n'));      %find newline character
% if isempty(findNL)
%     findNL = length(thisEPOCHSTR);
% end
% thisEPOCHSTR = thisEPOCHSTR(1:findNL(1));
% % if length(findNL) == 13 || length(findNL) == 14
% %     thisEPOCHSTR = defSTR(1, findNL(12):findNL(13));
% % elseif length(findNL) == 12
% %     thisEPOCHSTR = defSTR(1, findNL(11):findNL(12));
% % end
% 
% findCOL = find(thisEPOCHSTR == ':');
% findDQ = find(thisEPOCHSTR == '"');
% 
% thisEPOCH = thisEPOCHSTR(1, findCOL(1) + 1:findDQ(end) - 1);
% 
% findSPACE = find(thisEPOCH == ' ');
% epochST = str2num(thisEPOCH(1, 2:findSPACE(2) - 1));  % Epoch start
% epochED = str2num(thisEPOCH(1, findSPACE(2) + 1:end)); % Epoch end

%Load ntt file
cd(Dir_Data); 
thisWholeCLTS = Nlx2MatSpike(['TT2.nse'], [1 0 0 0 0], 0, 1, 0);

epochSTINDEX = min(find(thisWholeCLTS >= epochST));
epochEDINDEX = max(find(thisWholeCLTS <= epochED));

% channel_validity = CheckChannelValidity(ChannelValidity_file,thisRID ,thisDID, thisTTID, thisCLID);
% channel_nb=sum(channel_validity);

%set Redish feautres
clear FeatureData;
Write_fd_file(Dir_Data, 'TT2.nse', {'Energy', 'WavePC1'}, ChannelValidity, 10000, 0, 0);
load(['TT2_energy.fd'], '-mat'); [fszROW fszCOL] = size(FeatureData); inputFEATUREDATA = zeros(fszROW, 8); inputFEATUREDATA(:, 2) = FeatureData(:, 1); clear FeatureData fszROW fszCOL;
load(['TT2_wavePC1.fd'], '-mat'); inputFEATUREDATA(:, 6) = FeatureData(:, 1); delete *.fd;

%Load cluster
ClusterName=['TT' num2str(TetrodeNumber) '-0' num2str(Session_num) '.xls'];
thisCLTS = xlsread(ClusterName);
for i=1:size(thisCLTS,2)-1 thisCLTS(:,size(thisCLTS,2)-i+1) = thisCLTS(:,size(thisCLTS,2)-i); end
thisCLTS(:, 1) = [0:1:size(thisCLTS,1)-1]';
thisCLTS(:, 2) = thisCLTS(:, 2) * 10^6;
thisCLTS(thisCLTS(:, 4) ~= ClusterNum, :) = [];
% thisCLTS = dlmread(['TT' thisTTID '_cluster.' thisCLID], ',', 13, 0);
thisCLTS(thisCLTS(:, 1) < epochSTINDEX, :) = [];
thisCLTS(thisCLTS(:, 1) > epochEDINDEX, :) = [];
thisINDEX=thisCLTS(:,1);

nSPKS = size(thisCLTS, 1); %to calculate firing rate
FRRate = nSPKS / ((epochED - epochST) / 10^6);

thisCLTSforSpatialInfo = thisCLTS;
thisCLTSforSpatialInfo(thisCLTS(:, end - 1) > g.ARMENTRANCELINE,:) = [];



% %Isolation distance & L-Ratio
% ISODIST = IsolationDistance(inputFEATUREDATA(1:length(FeatureTimestamps), :), (thisINDEX + 1));
% [L LRATIO df] = L_Ratio(inputFEATUREDATA(1:length(FeatureTimestamps), :), (thisINDEX + 1) );

%spike constraint means %1/1/2014 by SB
if nSPKS <= 5
    onmazeMaxFR = -1;
    onmazeAvgFR = -1;
    withinREFRACPortion = -1;
    SPKWIDTHAMP = -1;
    SPKWIDTH = -1;
    ttSPKWIDTH = [-1 -1 -1 -1];
    SpaInfoScore = -1;
    LogISIPEAKTIME = -1;
    disp([clusterID ' : not sufficient spikes']);
    return;
end

% ISODIST = IsolationDistance(inputFEATUREDATA(epochSTINDEX:epochEDINDEX, :), (thisCLTS(:, 1) + 1) - (epochSTINDEX - 1));
% 
% [L LRATIO df] = L_Ratio(inputFEATUREDATA(epochSTINDEX:epochEDINDEX, :), (thisCLTS(:, 1) + 1) - (epochSTINDEX - 1));

%Spike width [peak to valley; since spike sometimes doesn't come back to the baseline]

[Timestamps, ScNumbers, CellNumbers, Features, Samples, Header] =Nlx2MatSpike(['TT2.nse'], [1 1 1 1 1], 1, 1, [] );

thisNTTCLTSIndex=thisINDEX+1;

%% thisCLTSIndex : Index which is indicated to matched index bewteen total and cluster spiking
thisCLAP = Samples(:, :, thisNTTCLTSIndex);
maxAPMat = squeeze(max(thisCLAP));
minAPMat = squeeze(min(thisCLAP));
halfWIDTHMat = nan(size(thisCLAP, 3), 4);
PEAKMat = nan(size(thisCLAP, 3), 4);
VALLEYMat = nan(size(thisCLAP, 3), 4);
%%
% tic
for ttRUN = 1:1:1
    for clRUN = 1:1:size(thisCLAP, 3)	
		if mean(maxAPMat(ttRUN, :)) > 10^2 & min(find(thisCLAP(:, ttRUN, clRUN) == maxAPMat(clRUN, ttRUN))) & max(find(thisCLAP(:, ttRUN, clRUN) == minAPMat(clRUN, ttRUN))) & (min(find(thisCLAP(:, ttRUN, clRUN) == maxAPMat(clRUN, ttRUN))) < max(find(thisCLAP(:, ttRUN, clRUN) == minAPMat(clRUN, ttRUN))))
			halfWIDTHMat(clRUN, ttRUN) = abs(max(find(thisCLAP(:, ttRUN, clRUN) == minAPMat(clRUN, ttRUN))) - min(find(thisCLAP(:, ttRUN, clRUN) == maxAPMat(clRUN, ttRUN))) + 1) * sFr * microSEC;
                        PEAKMat(clRUN, ttRUN) = thisCLAP(min(find(thisCLAP(:, ttRUN, clRUN) == maxAPMat(clRUN, ttRUN))), ttRUN, clRUN)/100;
            VALLEYMat(clRUN, ttRUN) = thisCLAP(max(find(thisCLAP(:, ttRUN, clRUN) == minAPMat(clRUN, ttRUN))), ttRUN, clRUN)/100;
		else
			halfWIDTHMat(clRUN, ttRUN) = nan;
		end	%mean(maxAPMat(ttRUN, :)) > 10^2 & min(find(thisCLAP(:, ttRUN, clRUN) == maxAPMat(ttRUN, clRUN))) & max(find(thisCLAP(:, ttRUN, clRUN) == minAPMat(ttRUN, clRUN))) & (min(find(thisCLAP(:, ttRUN, clRUN) == maxAPMat(ttRUN, clRUN))) < max(find(thisCLAP(:, ttRUN, clRUN) == minAPMat(ttRUN, clRUN))))
    end	%ttRUN = 1:1:4
end	%clRUN = 1:1:size(thisCLAP, 3)
%%
% toc


ttSPKWIDTH = nanmean(halfWIDTHMat);
ttSPKPEAK = nanmean(PEAKMat);
ttSPKVALLEY = nanmean(VALLEYMat);
ttSPKWIDTH_STE = nanstd(halfWIDTHMat) / sqrt(size(thisCLAP, 3));

%%Modified by LHW code, 180301
meanAPMat = mean(transpose(maxAPMat));
SPKWIDTHAMP = ttSPKWIDTH(1, min(find(meanAPMat == max(meanAPMat))));
MaximumChannel=min(find(meanAPMat == max(meanAPMat)));
%%Ealier version JSW used until 1800228    
% MAXTRANSmaxAPMat = max(transpose(maxAPMat));
% SPKWIDTHAMP = ttSPKWIDTH(1, min(find(MAXTRANSmaxAPMat == max(MAXTRANSmaxAPMat))));

SPKWIDTH = nanmean(nanmean(halfWIDTHMat, 2));
SPKWIDTH_STE = nanstd(nanmean(halfWIDTHMat, 2)) / sqrt(size(thisCLAP, 3));

rowSpike = length(Timestamps);

%Auto-correlogram
[correlogram corrXlabel] = CrossCorr(thisCLTS(:, end) ./ 100, thisCLTS(:, end) ./ 100, 1, 500);

% %Inter-spike interval (ISI)
isiHIST = histc(log10(diff(thisCLTS(:, end))), histEDGE);
withinREFRACPortion = (sum(diff(thisCLTS(:, end)) < (ISIREFRACTORY * 10^3)) / length(thisCLTS(:, end))) * 100;
