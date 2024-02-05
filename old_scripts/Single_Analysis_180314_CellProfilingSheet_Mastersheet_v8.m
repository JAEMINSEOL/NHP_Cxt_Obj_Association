%%
Coordinate_Title=[0.1 0.95 0.58 0.05];
Coordinate_Waveform=[0.05 0.82 0.1 0.10; 0.15 0.82 0.1 0.10; 0.25 0.82 0.1 0.10; 0.35 0.82 0.1 0.10];
Coordinate_Time=[0.55 0.83 0.22 0.10];

Coordinate_Histology=[0.85 0.83 0.15 0.15];
Coordinate_AutoCorrelogram=[0.78 0.54 0.2 0.2];
Coordinate_ISI=[0.5 0.54 0.2 0.2];
Coordinate_CellDescription=[0.05 0.54 0.45 0.25];

Coordinate_RF_rawMap=[0.03 0.3 0.2 0.2];
Coordinate_RF_rateMap=[0.23 0.3 0.2 0.2];
Coordinate_RF_Bar=[0.43 0.3 0.06 0.2];
Coordinate_RF_description=[0.05 0.05 0.4 0.2];
Coordinate_ALT_rawMap=[0.53 0.3 0.2 0.2];
Coordinate_ALT_rateMap=[0.73 0.3 0.2 0.2];
Coordinate_ALT_Bar=[0.93 0.3 0.06 0.2];

Coordinate_ALT_description=[0.52 0.05 0.4 0.2];

szDOT = 3;
colTRACE = [.4 .4 .4];
colSPK = [1 0 0];
Fontsize=15;
szFONT = 8; 
ISIREFRACTORY = 1; isiWINDOW = 7; isiSCALE = 100; histEDGE = -1:1 / isiSCALE:isiWINDOW;
szLINE = 2;
%%
Define_SessionNumber;
Define_SessionType;
load('E:\EphysAnalysis\Result\matFile-Utility\ClusterAssessment_v7.mat');
for d=1:length(ClusterAssessment_Numeric_v7)
    if isequal(Type,'Main')&&(ClusterAssessment_Numeric_v7(d,1)==str2num(Rat))&&(ClusterAssessment_Numeric_v7(d,2)==str2num(Day))&&(ClusterAssessment_Numeric_v7(d,3)==str2num(TetrodeNumber))&&(ClusterAssessment_Numeric_v7(d,4)==str2num(ClusterNumber))
        Ai=d; break;
    elseif isequal(Type,'Pilot')&&(ClusterAssessment_Numeric_v7(d,1)==str2num(Rat))&&isequal(ClusterAssessment_Text_v7{d,2},['P' Day])&&(ClusterAssessment_Numeric_v7(d,3)==str2num(TetrodeNumber))&&(ClusterAssessment_Numeric_v7(d,4)==str2num(ClusterNumber))
        Ai=d; break;
    end
end
        
%% Title
fig=figure;
set(fig,'position', [0 0 1440 1440]);
sheetTitle = subplot('Position', Coordinate_Title);
set(sheetTitle, 'visible', 'off');
text(0,0.5,[titleName '-Cell profiling Sheet'],'Fontsize',TitleFontsize);
%% Histology
if exist(['E:\EphysAnalysis\TTreconstruction\r' Rat '\TT' TetrodeNumber '.jpg'],'file')
    sheetTitle=subplot('Position',Coordinate_Histology);
    % img=imread(['D:\EphysAnalysis\PalmsData\TTreconstruction\r' Rat '\TT' TetrodeNumber '.jpg']);
    img=imread(['E:\EphysAnalysis\TTreconstruction\r' Rat '\TT' TetrodeNumber '.jpg']);
    Simg=imresize(img,0.4);
    if isequal(Rat,'473')
        img2=Simg(20:610, 10:400,:);
    else
        img2=Simg(20:610,400:820,:);
    end
    imshow(img2);
end
%%

for ttRUN = 1:1:4	 %Spk shape
	subplot('Position',Coordinate_Waveform(ttRUN,:));
	if mean(maxAPMat(ttRUN, :)) > 10^2  
		hold on;
			thisMEANAP = mean(thisCLAP(:, ttRUN, :), 3); thisMEANMAXLOC = min(find(thisMEANAP == max(thisMEANAP))); thisMEANminLOC = max(find(thisMEANAP == min(thisMEANAP))); thisPEAKTOVALLEY = thisMEANminLOC - thisMEANMAXLOC + 1;
			%errorbar(mean(thisCLAP(:, ttRUN, :), 3), std(transpose(squeeze(thisCLAP(:, ttRUN, :)))) ./ sqrt(size(thisCLAP, 3)));	%STE as error bars
			errorbar(thisMEANAP, std(transpose(squeeze(thisCLAP(:, ttRUN, :)))));						%STD as error bars
			if thisMEANMAXLOC < thisMEANminLOC
				plot(thisMEANMAXLOC:thisMEANminLOC, thisMEANAP(thisMEANMAXLOC:thisMEANminLOC, 1), '-r');
			end	%thisMEANMAXLOC < thisMEANminLOC
		hold off;
		clear thisMEANAP thisMEANMAXLOC thisMEANminLOC;
	else
		plot(1:1:size(mean(thisCLAP(:, ttRUN, :), 3), 1), ones(1, size(mean(thisCLAP(:, ttRUN, :), 3), 1))); thisPEAKTOVALLEY = nan;
	end	%mean(maxAPMat(ttRUN, :)) > 10^4
	title(['width = ' jjnum2str(ttSPKWIDTH(1, ttRUN)) '\mus (' num2str(thisPEAKTOVALLEY) ')']); set(gca, 'FontSize', szFONT); axis off; clear thisPEAKTOVALLEY;
end	%ttRUN = 1:1:4
%%
subplot('Position',Coordinate_Time);
plot(thisTIME, channel(MaximumChannel,:)*10^6,'k.')
xlabel('Time(s)'); ylabel('Peak Amplitude(\muv)');title('Time vs Peak Amplitude(\muv)');

line([presleepStart presleepStart], [get(gca,'YLim')],'color','r')
line([presleepEnd presleepEnd], [get(gca,'YLim')],'color','r')
line([openfieldStart-Shift_1 openfieldStart-Shift_1], [get(gca,'YLim')],'color','m')
line([openfieldEnd-Shift_1 openfieldEnd-Shift_1], [get(gca,'YLim')],'color','m')
line([alternationStart-Shift_2 alternationStart-Shift_2], [get(gca,'YLim')],'color','b')
line([alternationEnd-Shift_2 alternationEnd-Shift_2], [get(gca,'YLim')],'color','b')
line([postsleepStart-Shift_3 postsleepStart-Shift_3], [get(gca,'YLim')],'color','r')
line([postsleepEnd-Shift_3 postsleepEnd-Shift_3], [get(gca,'YLim')],'color','r')
xlim([(presleepStart-200) (postsleepEnd-Shift_3+200)]) % Pre/Open/Main/Post sleep 
% line([thisSEGMENT_Main(end) thisSEGMENT_Main(end)], [get(gca,'YLim')],'color','b')
% line([thisSEGMENT_Post(1) thisSEGMENT_Post(1)], [get(gca,'YLim')],'color','r')
% line([thisSEGMENT_Post(end) thisSEGMENT_Post(end)], [get(gca,'YLim')],'color','r')

%%
sheetTitle = subplot('Position',Coordinate_AutoCorrelogram);
set(sheetTitle, 'visible', 'off');
[correlogram corrXlabel] = CrossCorr(thisCLTS(:, end) ./ 100, thisCLTS(:, end) ./ 100, 1, 1000);
correlogram((length(corrXlabel)+1)/2) = 0; % to adjust y limit

bar(corrXlabel, correlogram);
title(['AutoCorrelogram']); set(gca, 'FontSize', szFONT, 'XLim', [min(corrXlabel) max(corrXlabel)], 'YLim', [0 max(log10(correlogram))]); xlabel(['Time (ms)']); axis tight;

%% Get theta modulation
[TMI1, TMI_fft_power, TMI_fft_abs, fft_frequency] = GetThetaModulation(correlogram);

fft_max_index = find(TMI_fft_power(7:11) == max(TMI_fft_power(7:11))) + 6;  % theta range : 6Hz ~ 10Hz
fft_max_frequency = fft_frequency(fft_max_index);
fft_peak = TMI_fft_power(fft_max_index);

if fft_frequency(fft_max_index + 1) > 10
    fft_peak = fft_peak + TMI_fft_power(fft_max_index - 1);
elseif fft_frequency(fft_max_index - 1) < 6
    fft_peak = fft_peak + TMI_fft_power(fft_max_index + 1);
else
    if TMI_fft_power(fft_max_index - 1) < TMI_fft_power(fft_max_index + 1)
        fft_peak = fft_peak + TMI_fft_power(fft_max_index + 1);
    else
        fft_peak = fft_peak + TMI_fft_power(fft_max_index - 1);
    end
end

fft_mean = mean(TMI_fft_power(1:70));
fft_selectivity = fft_peak/fft_mean;
%%
sheetTitle = subplot('Position',Coordinate_ISI);
isiHIST = histc(log10(diff(thisCLTS(:, end))), histEDGE);
withinREFRACPortion = (sum(diff(thisCLTS(:, end)) < (ISIREFRACTORY * 10^3)) / length(thisCLTS(:, end))) * 100;
hold on;
	bar(isiHIST);	%plot(ones(1, max(isiHIST) + 1) .* find(histEDGE == 0), 0:1:max(isiHIST), 'r:', 'LineWidth', szLINE);
	text(min(find(isiHIST == min(max(isiHIST)))), min(max(isiHIST)), [jjnum2str((10^histEDGE(min(find(isiHIST == min(max(isiHIST)))))) / 1000) ' ms']); LogISIPEAKTIME = (10^histEDGE(min(find(isiHIST == min(max(isiHIST)))))) / 1000;
hold off;
line([401 401], [get(gca,'YLim')],'color','r')
line([491 491], [get(gca,'YLim')],'color','m')

title(['log ISI']); xlabel(['time (ms)']); axis tight; set(gca, 'FontSize', szFONT, 'XLim', [350 size(histEDGE, 2)], 'XTick', 350:((size(histEDGE, 2) - 350) / 2):size(histEDGE, 2), 'XTickLabel', {['.31'], ['55'], ['10000']});
%%
sheetTitle = subplot('Position',Coordinate_CellDescription);
set(sheetTitle, 'visible', 'off');
txtINIX=0;txtINIY=1; txtADJX=0.5; txtADJY=0.2;
%180131 Need to compare SPKWIDTHAMP and PeakToValleyTime
text(txtINIX - txtADJX * 0, txtINIY - txtADJY * 0, ['Spike width = ' jjnum2str(SPKWIDTHAMP) ' \mus'],'Fontsize',Fontsize); 
text(txtINIX - txtADJX * 0, txtINIY - txtADJY * 1, ['Spike Peak = ' jjnum2str(PeakAmplitude) ' \muv'],'Fontsize',Fontsize);
text(txtINIX - txtADJX * 0, txtINIY - txtADJY * 2, ['Spike Valley = ' jjnum2str(ValleyAmplitude) ' \muv'],'Fontsize',Fontsize);
text(txtINIX - txtADJX * 0, txtINIY - txtADJY * 3, ['# of spks in pre= ' num2str(presleepspike)],'Fontsize',Fontsize);
text(txtINIX - txtADJX * 0, txtINIY - txtADJY * 4, ['# of spks in post= ' num2str(postsleepspike)],'Fontsize',Fontsize);
text(txtINIX - txtADJX * 0, txtINIY - txtADJY * 5, ['Spikes within r.p. = ' num2str(withinREFRACPortion) ' %'],'Fontsize',Fontsize);

text(txtINIX + txtADJX * 1, txtINIY - txtADJY * 0, ['L-Ratio = ' jjnum2str(LRATIO)],'Fontsize',Fontsize);
text(txtINIX + txtADJX * 1, txtINIY - txtADJY * 1, ['Isolation Distance = ' jjnum2str(ISODIST)],'Fontsize',Fontsize);
text(txtINIX + txtADJX * 1, txtINIY - txtADJY * 2, ['Theta Modulation Index = ' jjnum2str(TMI1)],'Fontsize',Fontsize);
text(txtINIX + txtADJX * 1, txtINIY - txtADJY * 3, ['Cluster Score = ' jjnum2str(ClusterAssessment_Numeric_v7(Ai,6))],'Fontsize',Fontsize);
text(txtINIX + txtADJX * 1, txtINIY - txtADJY * 4, ['Maximum Channel = ' jjnum2str(MaximumChannel)],'Fontsize',Fontsize);
text(txtINIX + txtADJX * 1, txtINIY - txtADJY * 5, ['Session Number = ' jjnum2str(SessionNumber)],'Fontsize',Fontsize);
%%
sheetTitle=subplot('Position',Coordinate_RF_rawMap);
plot(x(RandomForaging_Pos{1,3}),y(RandomForaging_Pos{1,3}),'.','color',[0.5 0.5 0.5],'markersize',markersize);
hold on
h=plot(thisX_positionLocked(RandomForaging_Spk{1,3}),thisY_positionLocked(RandomForaging_Spk{1,3}),'r.');
set(h,'markersize',markersize);
set(sheetTitle, 'visible', 'off');
set(gca, 'YDir', 'rev', 'XLim', RF_Raw_X_Range, 'YLim', RF_Raw_Y_Range, 'FontSize', 9);

%%
subplot('Position',Coordinate_RF_rateMap);
imagesc((skaggsrateMat_RF_Total));
%         imagesc((rawMat_RF_1stHalf));
colormap(jet);
thisAlphaZ_RF_Total = skaggsrateMat_RF_Total;
thisAlphaZ_RF_Total(isnan(skaggsrateMat_RF_Total)) = 0;
thisAlphaZ_RF_Total(~isnan(skaggsrateMat_RF_Total)) = 1;
hold on
alpha(thisAlphaZ_RF_Total);axis off;
MAXcolorRF=max(max(skaggsrateMat_RF_Total));
if MAXcolorRF<0.5
    MAXcolorRF=0.5;
end
set(gca,'CLim', [0 MAXcolorRF]);
set(gca, 'YDir', 'rev', 'XLim', RF_Rate_X_Range, 'YLim', RF_Rate_Y_Range, 'FontSize', 9);
%%
subplot('Position', Coordinate_RF_Bar);
colorbar('FontSize', 12, 'FontName', 'Arial');
set(gca, 'visible', 'off');
set(gca,'CLim', [0 MAXcolorRF]);
%%
sheetTitle =subplot('Position',Coordinate_RF_description);
set(sheetTitle, 'visible', 'off');
txtINIX=0;txtINIY=0.875; txtADJX=0.5; txtADJY=0.2;
text(txtINIX - txtADJX * 0, txtINIY - txtADJY * 0, ['On-map Max FR = ' jjnum2str(onarmMaxFR_RF_Total) '(Hz)'],'Fontsize',Fontsize);
text(txtINIX - txtADJX * 0, txtINIY - txtADJY * 1, ['On-map Avg. FR = ' jjnum2str(onarmAvgFR_RF_Total) '(Hz)'],'Fontsize',Fontsize);
text(txtINIX - txtADJX * 0, txtINIY - txtADJY * 2, ['# of spks = ' num2str(numOfSpk_RF_Total) '(' num2str(openfieldspike) ')'],'Fontsize',Fontsize);
text(txtINIX - txtADJX * 0, txtINIY - txtADJY * 3, ['Spatial correlation = ' jjnum2str(RF_Corr)],'Fontsize',Fontsize);

text(txtINIX + txtADJX * 1, txtINIY - txtADJY * 0, ['Spatial Information(S.I.) = ' jjnum2str(SpaInfoScore_RF_Total) '(bit/spk)'],'Fontsize',Fontsize);
if isequal(p_Spainfo_RF,'NaN')
    text(txtINIX + txtADJX * 1, txtINIY - txtADJY * 1, ['p-value of S.I. = NaN' ],'Fontsize',Fontsize);    
elseif p_Spainfo_RF < 0.001
    text(txtINIX + txtADJX * 1, txtINIY - txtADJY * 1, ['p-value of S.I. = ' num2str(p_Spainfo_RF) ' ( p < 0.001 )' ],'Fontsize',Fontsize);
elseif p_Spainfo_RF >= 0.001 && p_Spainfo_RF < 0.01
    text(txtINIX + txtADJX * 1, txtINIY - txtADJY * 1, ['p-value of S.I. = ' num2str(p_Spainfo_RF) ' ( p < 0.01 )' ],'Fontsize',Fontsize);
elseif p_Spainfo_RF >= 0.01 && p_Spainfo_RF < 0.05
    text(txtINIX + txtADJX * 1, txtINIY - txtADJY * 1, ['p-value of S.I. = ' num2str(p_Spainfo_RF) ' ( p < 0.05 )' ],'Fontsize',Fontsize);
elseif p_Spainfo_RF >= 0.05 
    text(txtINIX + txtADJX * 1, txtINIY - txtADJY * 1, ['p-value of S.I. = ' num2str(p_Spainfo_RF) ' ( p > 0.05 )' ],'Fontsize',Fontsize);    
end
text(txtINIX + txtADJX * 1, txtINIY - txtADJY * 2, ['Sparsity = ' jjnum2str(sparsity_RF)],'Fontsize',Fontsize);

if isequal(p_Sparsity_RF,'NaN')
    text(txtINIX + txtADJX * 1, txtINIY - txtADJY * 3, ['p-value of Sparsity = NaN' ],'Fontsize',Fontsize);    
elseif p_Sparsity_RF < 0.001
    text(txtINIX + txtADJX * 1, txtINIY - txtADJY * 3, ['p-value of Sparsity = ' num2str(p_Sparsity_RF) ' ( p < 0.001 )' ],'Fontsize',Fontsize);
elseif p_Sparsity_RF >= 0.001 && p_Sparsity_RF < 0.01
    text(txtINIX + txtADJX * 1, txtINIY - txtADJY * 3, ['p-value of Sparsity = ' num2str(p_Sparsity_RF) ' ( p < 0.01 )' ],'Fontsize',Fontsize);
elseif p_Sparsity_RF >= 0.01 && p_Sparsity_RF < 0.05
    text(txtINIX + txtADJX * 1, txtINIY - txtADJY * 3, ['p-value of Sparsity = ' num2str(p_Sparsity_RF) ' ( p < 0.05 )' ],'Fontsize',Fontsize);
elseif p_Sparsity_RF >= 0.05 
    text(txtINIX + txtADJX * 1, txtINIY - txtADJY * 3, ['p-value of Sparsity = ' num2str(p_Sparsity_RF) ' ( p > 0.05 )' ],'Fontsize',Fontsize);    
end

%%
sheetTitle = subplot('Position', Coordinate_ALT_rawMap);
plot(x(Alternation_Pos),y(Alternation_Pos),'.','color',[0.5 0.5 0.5],'markersize',markersize);
hold on
h=plot(thisX_positionLocked(Alternation_Spk),thisY_positionLocked(Alternation_Spk),'r.');
set(h,'markersize',markersize)
set(sheetTitle, 'visible', 'off');
set(gca, 'YDir', 'rev', 'XLim', Alt_Raw_Second_X_Range, 'YLim', Alt_Raw_Second_Y_Range, 'FontSize', 9);

%%
subplot('Position',Coordinate_ALT_rateMap);
imagesc((skaggsrateMat_Total));
colormap(jet);
thisAlphaZ_ALT_Total = skaggsrateMat_Total;
thisAlphaZ_ALT_Total(isnan(skaggsrateMat_Total)) = 0;
thisAlphaZ_ALT_Total(~isnan(skaggsrateMat_Total)) = 1;
hold on
alpha(thisAlphaZ_ALT_Total);axis off;
MAXcolorALT=max(max(skaggsrateMat_Total));
if MAXcolorALT<0.5
    MAXcolorALT=0.5;
end
set(gca,'CLim', [0 MAXcolorALT]);
set(gca, 'YDir', 'rev', 'XLim', Alt_Rate_X_Range, 'YLim', Alt_Rate_Y_Range, 'FontSize', 9);
%%
subplot('Position', Coordinate_ALT_Bar);
colorbar('FontSize', 12, 'FontName', 'Arial');
set(gca, 'visible', 'off');
set(gca,'CLim', [0 MAXcolorALT]);
%%
sheetTitle =subplot('Position',Coordinate_ALT_description);
set(sheetTitle, 'visible', 'off');
txtINIX=0;txtINIY=0.875; txtADJX=0.5; txtADJY=0.2;
text(txtINIX - txtADJX * 0, txtINIY - txtADJY * 0, ['On-map Max FR = ' jjnum2str(onarmMaxFr_Total) '(Hz)'],'Fontsize',Fontsize);
text(txtINIX - txtADJX * 0, txtINIY - txtADJY * 1, ['On-map Avg. FR = ' jjnum2str(onarmAvgFr_Total) '(Hz)'],'Fontsize',Fontsize);
text(txtINIX - txtADJX * 0, txtINIY - txtADJY * 2, ['# of spks = ' num2str(numOfSpk_Total) '(' num2str(alternationspike) ')'],'Fontsize',Fontsize);
text(txtINIX + txtADJX * 1, txtINIY - txtADJY * 0, ['Spatial Information = ' jjnum2str(SpaInfoScore_Total) '(bit/spk)'],'Fontsize',Fontsize);

if isequal(p_Spainfo_ALT,'NaN')
    text(txtINIX + txtADJX * 1, txtINIY - txtADJY * 1, ['p-value of S.I. = NaN' ],'Fontsize',Fontsize);    
elseif p_Spainfo_ALT < 0.001
    text(txtINIX + txtADJX * 1, txtINIY - txtADJY * 1, ['p-value of S.I. = ' num2str(p_Spainfo_ALT) ' ( p < 0.001 )' ],'Fontsize',Fontsize);
elseif p_Spainfo_ALT >= 0.001 && p_Spainfo_ALT < 0.01
    text(txtINIX + txtADJX * 1, txtINIY - txtADJY * 1, ['p-value of S.I. = ' num2str(p_Spainfo_ALT) ' ( p < 0.01 )' ],'Fontsize',Fontsize);
elseif p_Spainfo_ALT >= 0.01 && p_Spainfo_ALT < 0.05
    text(txtINIX + txtADJX * 1, txtINIY - txtADJY * 1, ['p-value of S.I. = ' num2str(p_Spainfo_ALT) ' ( p < 0.05 )' ],'Fontsize',Fontsize);
elseif p_Spainfo_ALT >= 0.05 
    text(txtINIX + txtADJX * 1, txtINIY - txtADJY * 1, ['p-value of S.I. = ' num2str(p_Spainfo_ALT) ' ( p > 0.05 )' ],'Fontsize',Fontsize);    
end
text(txtINIX + txtADJX * 1, txtINIY - txtADJY * 2, ['Sparsity = ' jjnum2str(sparsity_ALT)],'Fontsize',Fontsize);

if isequal(p_Sparsity_ALT,'NaN')
    text(txtINIX + txtADJX * 1, txtINIY - txtADJY * 3, ['p-value of Sparsity = NaN' ],'Fontsize',Fontsize);    
elseif p_Sparsity_ALT < 0.001
    text(txtINIX + txtADJX * 1, txtINIY - txtADJY * 3, ['p-value of Sparsity = ' num2str(p_Sparsity_ALT) ' ( p < 0.001 )' ],'Fontsize',Fontsize);
elseif p_Sparsity_ALT >= 0.001 && p_Sparsity_ALT < 0.01
    text(txtINIX + txtADJX * 1, txtINIY - txtADJY * 3, ['p-value of Sparsity = ' num2str(p_Sparsity_ALT) ' ( p < 0.01 )' ],'Fontsize',Fontsize);
elseif p_Sparsity_ALT >= 0.01 && p_Sparsity_ALT < 0.05
    text(txtINIX + txtADJX * 1, txtINIY - txtADJY * 3, ['p-value of Sparsity = ' num2str(p_Sparsity_ALT) ' ( p < 0.05 )' ],'Fontsize',Fontsize);
elseif p_Sparsity_ALT >= 0.05 
    text(txtINIX + txtADJX * 1, txtINIY - txtADJY * 3, ['p-value of Sparsity = ' num2str(p_Sparsity_ALT) ' ( p > 0.05 )' ],'Fontsize',Fontsize);    
end
fig = gcf;
fig.PaperPositionMode = 'auto';
print(['f:\EphysAnalysis\Result\JPEG-CellProfile\CellProfile-' titleName '.jpeg'],'-dpng','-r0')

%%
