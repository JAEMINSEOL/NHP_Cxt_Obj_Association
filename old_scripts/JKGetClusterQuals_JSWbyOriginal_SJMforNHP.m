function [nSPKS withinREFRACPortion SPKWIDTHAMP SPKWIDTH ttSPKWIDTH MaximumChannel thisCLAP thisCLTS maxAPMat ISODIST LRATIO PEAKMat VALLEYMat ttSPKPEAK ttSPKVALLEY] = JKGetClusterQuals_JSWbyOriginal_SJMforNHP(Dir_Data, channel_validity, thisCLTS)
% function [nSPKS FRRate onmazeMaxFR onmazeAvgFR withinREFRACPortion SPKWIDTHAMP SPKWIDTH ttSPKWIDTH LRATIO ISODIST SpaInfoScore LogISIPEAKTIME] = JKGetClusterQuals(clusterID, ChannelValidity_file)
%Cluster Quality Assesment
%Code by Jangjin Kim, 2011-Sep-22nd
%Revised by S.W.Jin 1/18/2018
%Revised by Jaemin 1/8/2020
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

TetrodeNumber=1;
nttDirectory=[Dir_Data];
nttName=['TT' num2str(TetrodeNumber) '.ntt'];

% g.ARMENTRANCELINE = 300; % Y position limit. Do not need 
f=strfind(nttName,'.');
%Basic param
currentROOT = pwd;
sFr = 1 / 32000;
microSEC = 10^6;

%it's not correct value. but I don't use the value made using this variables. 2/14/2014
imROW = 720;
imCOL = 480;
thisFRMapSCALE = 10;
videoSamplingRate = 30;

szDOT = 3;
colTRACE = [.4 .4 .4];
colSPK = [1 0 0];

szFONT = 8; 
ISIREFRACTORY = 1; isiWINDOW = 7; isiSCALE = 100; histEDGE = -1:1 / isiSCALE:isiWINDOW;
szLINE = 2;

% close all; picID = figure('Color', [1 1 1], 'Position', [50 50 800 1000]);

% thisCLTS = dlmread(Clusterfile, ',', 13, 0);
% thisCLTS = Clusterfile;
thisTIMESTAMP = thisCLTS(:,3)./10^6;
thisINDEX=thisCLTS(:,1);

channel_nb=sum(channel_validity);
% 
% %set Redish feautres
clear FeatureData;
cd(nttDirectory);
Write_fd_file(nttDirectory, nttName, {'Energy', 'WavePC1'}, channel_validity, 10000, 0, 0);
load([nttName(1:f-1) '_energy.fd'], '-mat'); [fszROW fszCOL] = size(FeatureData); inputFEATUREDATA = zeros(fszROW, 2*fszCOL); inputFEATUREDATA(:, 1:fszCOL) = FeatureData(:, 1:fszCOL); clear FeatureData;
load([nttName(1:f-1) '_wavePC1.fd'], '-mat'); inputFEATUREDATA(:, (fszCOL+1):(2*fszCOL)) = FeatureData(:, 1:fszCOL); delete *.fd;

nSPKS = size(thisTIMESTAMP, 1); %to calculate firing rate
% FRRate = nSPKS / (presleepStart - postsleepEnd);

% thisCLTSforSpatialInfo = thisCLTS;
% thisCLTSforSpatialInfo(thisCLTS(:, end - 1) > g.ARMENTRANCELINE,:) = [];
% 


% %Isolation distance & L-Ratio
ISODIST = IsolationDistance(inputFEATUREDATA(1:length(FeatureTimestamps), :), (thisINDEX + 1));
[L LRATIO df] = L_Ratio(inputFEATUREDATA(1:length(FeatureTimestamps), :), (thisINDEX + 1) );


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


% Spike width [peak to valley; since spike sometimes doesn't come back to the baseline]
cd(nttDirectory);
% [thisEpochCLTS thisEpochCLAP] = Nlx2MatSpike(['TT' thisTTID '.ntt'], [1 0 0 0 1], 0, 4, [epochST epochED]);
[Timestamps, ScNumbers, CellNumbers, Features, Samples, Header] =Nlx2MatSpike([nttName], [1 1 1 1 1], 1, 1, [] );

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
for ttRUN = 1:1:4
    for clRUN = 1:1:size(thisCLAP, 3)	
		if mean(maxAPMat(ttRUN, :)) > 10^2 & min(find(thisCLAP(:, ttRUN, clRUN) == maxAPMat(ttRUN, clRUN))) & max(find(thisCLAP(:, ttRUN, clRUN) == minAPMat(ttRUN, clRUN))) & (min(find(thisCLAP(:, ttRUN, clRUN) == maxAPMat(ttRUN, clRUN))) < max(find(thisCLAP(:, ttRUN, clRUN) == minAPMat(ttRUN, clRUN))))
			halfWIDTHMat(clRUN, ttRUN) = abs(max(find(thisCLAP(:, ttRUN, clRUN) == minAPMat(ttRUN, clRUN))) - min(find(thisCLAP(:, ttRUN, clRUN) == maxAPMat(ttRUN, clRUN))) + 1) * sFr * microSEC;
            PEAKMat(clRUN, ttRUN) = thisCLAP(min(find(thisCLAP(:, ttRUN, clRUN) == maxAPMat(ttRUN, clRUN))), ttRUN, clRUN)/100;
            VALLEYMat(clRUN, ttRUN) = thisCLAP(max(find(thisCLAP(:, ttRUN, clRUN) == minAPMat(ttRUN, clRUN))), ttRUN, clRUN)/100;
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


% %Visual summary
% cd(currentROOT);
% for ttRUN = 1:1:4	 %Spk shape
% 	subplot(3, 4, ttRUN);
% 	if mean(maxAPMat(ttRUN, :)) > 10^2
% 		hold on;
% 			thisMEANAP = mean(thisCLAP(:, ttRUN, :), 3); thisMEANMAXLOC = min(find(thisMEANAP == max(thisMEANAP))); thisMEANminLOC = max(find(thisMEANAP == min(thisMEANAP))); thisPEAKTOVALLEY = thisMEANminLOC - thisMEANMAXLOC + 1;
% 			%errorbar(mean(thisCLAP(:, ttRUN, :), 3), std(transpose(squeeze(thisCLAP(:, ttRUN, :)))) ./ sqrt(size(thisCLAP, 3)));	%STE as error bars
% 			errorbar(thisMEANAP, std(transpose(squeeze(thisCLAP(:, ttRUN, :)))));						%STD as error bars
% 			if thisMEANMAXLOC < thisMEANminLOC
% 				plot(thisMEANMAXLOC:thisMEANminLOC, thisMEANAP(thisMEANMAXLOC:thisMEANminLOC, 1), '-r');
% 			end	%thisMEANMAXLOC < thisMEANminLOC
% 		hold off;
% 		clear thisMEANAP thisMEANMAXLOC thisMEANminLOC;
% 	else
% 		plot(1:1:size(mean(thisCLAP(:, ttRUN, :), 3), 1), ones(1, size(mean(thisCLAP(:, ttRUN, :), 3), 1))); thisPEAKTOVALLEY = nan;
% 	end	%mean(maxAPMat(ttRUN, :)) > 10^4
% 	title(['width = ' jjnum2str(ttSPKWIDTH(1, ttRUN)) '\mus (' num2str(thisPEAKTOVALLEY) ')']); set(gca, 'FontSize', szFONT); axis off; clear thisPEAKTOVALLEY;
% end	%ttRUN = 1:1:4
% 
% subplot(3, 4, 5:6);	%avg. spk shape
% %errorbar(mean(mean(thisCLAP, 2), 3), std(transpose(squeeze(mean(thisCLAP, 2)))) ./ sqrt(size(thisCLAP, 3)));
% errorbar(mean(mean(thisCLAP, 2), 3), std(transpose(squeeze(mean(thisCLAP, 2)))));			%STD as error bars
% title(['Avg.: spk width = ' jjnum2str(SPKWIDTH) '\mus']); set(gca, 'FontSize', szFONT); axis off;
% 
% subplot(3, 4, 7:8);	%text descriptions
% set(gca, 'XLim', [0 10], 'YLim', [0 10], 'FontSize', szFONT); axis off;
% text(txtINIX, txtINIY + txtADJ * 2, ['Cluster summary - ' clusterID]);
% text(txtINIX, txtINIY + txtADJ * 1, [' ']);
% % text(txtINIX, txtINIY - txtADJ * 0, ['Isolation Distance = ' jjnum2str(ISODIST)]);
% % text(txtINIX, txtINIY - txtADJ * 1, ['L-Ratio = ' jjnum2str(LRATIO)]);
% text(txtINIX, txtINIY - txtADJ * 2, ['Spatial Information Score = ' jjnum2str(SpaInfoScore) ' (bit / spk)']);
% text(txtINIX, txtINIY - txtADJ * 3, ['# of spks = ' num2str(nSPKS)]);
% text(txtINIX, txtINIY - txtADJ * 4, ['Session FR = ' jjnum2str(FRRate) ' Hz']);
% text(txtINIX, txtINIY - txtADJ * 5, ['On-map Max FR = ' jjnum2str(onmazeMaxFR) ' (Hz)']);
% text(txtINIX, txtINIY - txtADJ * 6, ['On-map Avg. FR = ' jjnum2str(onmazeAvgFR) ' (Hz)']);
% text(txtINIX, txtINIY - txtADJ * 7, ['Spike width (peak-to-valley) = ' jjnum2str(SPKWIDTHAMP) ' \mus']);
% text(txtINIX, txtINIY - txtADJ * 8, ['Spikes within refractory period = ' jjnum2str(withinREFRACPortion) ' %']);

% subplot(3, 4, 9);	%spk map
% hold on;
% 	scatter(thisPos(:, 2), thisPos(:, 3), szDOT, colTRACE, 'filled');
% 	scatter(thisCLTS(:, end - 2), thisCLTS(:, end - 1), szDOT, colSPK, 'filled');
% hold off;
% title(['raw spk map']); set(gca, 'YDir', 'rev', 'XLim', [0 imCOL], 'YLim', [0 imROW], 'FontSize', szFONT); axis off;
% 
% subplot(3, 4, 10);	%fr map
% set(gca, 'YDir', 'rev', 'XLim', [0 imCOL / thisFRMapSCALE], 'YLim', [0 imROW / thisFRMapSCALE], 'nextplot', 'add', 'FontSize', szFONT); axis off;
% thisAlphaZ = skaggsMap; thisAlphaZ(isnan(skaggsMap)) = 0; thisAlphaZ(~isnan(skaggsMap)) = 1;
% imagesc(skaggsMap); alpha(thisAlphaZ); title(['Skaggs firing rate map']);
% 
% subplot(3, 4, 11);	 %auto-correlogram
% bar(corrXlabel, correlogram);
% title(['AutoCorrelogram']); set(gca, 'FontSize', szFONT, 'XLim', [min(corrXlabel) max(corrXlabel)], 'YLim', [0 max(log10(correlogram))]); xlabel(['Time (ms)']); axis tight;
% 
% subplot(3, 4, 12);	 %inter-spike interval
% hold on;
% 	bar(isiHIST);	%plot(ones(1, max(isiHIST) + 1) .* find(histEDGE == 0), 0:1:max(isiHIST), 'r:', 'LineWidth', szLINE);
% 	text(min(find(isiHIST == min(max(isiHIST)))), min(max(isiHIST)), [jjnum2str((10^histEDGE(min(find(isiHIST == min(max(isiHIST)))))) / 1000) ' ms']); LogISIPEAKTIME = (10^histEDGE(min(find(isiHIST == min(max(isiHIST)))))) / 1000;
% hold off;
% title(['log ISI']); xlabel(['time (ms)']); axis tight; set(gca, 'FontSize', szFONT, 'XLim', [350 size(histEDGE, 2)], 'XTick', 350:((size(histEDGE, 2) - 350) / 2):size(histEDGE, 2), 'XTickLabel', {['.31'], ['55'], ['10000']});
% 
% fprintf('\n%s is processed\n', clusterID);
% clear thisWholeCLTS thisEpochCLTS thisEpochCLAP nvtTS nvtX nvtY nvtHD;
% 
%% old
% Timestamps=Timestamps';
% for indexRUN = 1:1:size(thisTIMESTAMP, 1)
% 	if find(Timestamps == thisTIMESTAMP(indexRUN, 1)) %% Match beetwween total spiking and cluster spiking
% 		thisCLTSIndex(indexRUN, 1) = min(find(Timestamps == thisTIMESTAMP(indexRUN, end)));
% 	end	%find(thisEpochCLTS == thisCLTS(indexRUN, end))
% end	%indexRUN = 1:1:size(thisCLTS, 1)