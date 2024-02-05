
f_title = 20;
f_axis = 15;
f_legend = 12;
l_width = 1.5;

%% Set Coordinate
TitleFontsize = 15;

Coordinate_Title=[0.75 0.97 0.58 0.03];

Coordinate_RawData = [0.05 0.87 0.27 0.10];
Coordinate_Binning_Forest = [0.05 0.73 0.27 0.1];
Coordinate_Binning_City = [0.05 0.59 0.27 0.1];
Coordinate_ColorMap = [0.02 0.46 0.3 0.1];

% Coordinate_RawData_Forest = [0.05 0.82 0.27 0.10];
% Coordinate_Binning_Forest = [0.05 0.57 0.27 0.2];
% Coordinate_ColorMap_Forest = [0.05 0.47 0.27 0.08];
%
% Coordinate_RawData_City = [0.36 0.82 0.27 0.10];
% Coordinate_Binning_City = [0.36 0.57 0.27 0.2];
% Coordinate_ColorMap_City = [0.36 0.47 0.27 0.08];


Coordinate_Waveform=[0.65 0.85 0.1 0.1]; Coordinate_Waveform_1sthalf=[0.65 0.78 0.05 0.05]; Coordinate_Waveform_2ndhalf=[0.72 0.78 0.05 0.05];
Coordinate_Time=[0.79 0.86 0.20 0.10];

Coordinate_Histology=[0.85 0.83 0.15 0.15];
Coordinate_AutoCorrelogram=[0.65 0.67 0.15 0.1];
Coordinate_ISI=[0.65 0.52 0.15 0.1];
Coordinate_CellDescription=[0.81 0.70 0.45 0.1];

Coordinate_Eye_ratemap = [0.65 0.25 0.1 0.2];


szDOT = 3;
colTRACE = [.4 .4 .4];
colSPK = [1 0 0];
Fontsize=13;
szFONT = 8;
ISIREFRACTORY = 1; isiWINDOW = 7; isiSCALE = 100; histEDGE = -1:1 / isiSCALE:isiWINDOW;
szLINE = 2;

%%
SPKWIDTHAMP = nanmean(ttSPKWIDTH);
PeakAmplitude = nanmean(ttSPKPEAK);
ValleyAmplitude = nanmean(ttSPKVALLEY);

%% Title
fig=figure;
set(0,'DefaultTextInterpreter','none')
set(fig,'position', [0 0 1782 1260]);
sheetTitle = subplot('Position', Coordinate_Title);
set(sheetTitle, 'visible', 'off');
TitleText = [animal_id '_' session_date '_std' '_s' num2str(Session_num) '_c' num2str(ClusterNum) '_Cell Profiling Sheet']; 

text(0,0.5,TitleText,'Fontsize',TitleFontsize);

%% Spike Waveform
for ttRUN = 1:1:1	 %Spk shape
%     subplot('Position',Coordinate_Waveform
figure;
    if mean(maxAPMat(ttRUN, :)) > 10^2
        hold on;
        thisMEANAP = mean(thisCLAP(:, ttRUN, :), 3); thisMEANMAXLOC = min(find(thisMEANAP == max(thisMEANAP))); thisMEANminLOC = max(find(thisMEANAP == min(thisMEANAP))); thisPEAKTOVALLEY = thisMEANminLOC - thisMEANMAXLOC + 1;
        %errorbar(mean(thisCLAP(:, ttRUN, :), 3), std(transpose(squeeze(thisCLAP(:, ttRUN, :)))) ./ sqrt(size(thisCLAP, 3)));	%STE as error bars
        errorbar(thisMEANAP, std(transpose(squeeze(thisCLAP(:, ttRUN, :)))),'LineWidth',2);						%STD as error bars
        if thisMEANMAXLOC < thisMEANminLOC
            plot(thisMEANMAXLOC:thisMEANminLOC, thisMEANAP(thisMEANMAXLOC:thisMEANminLOC, 1), '-r','LineWidth',2);
        end	%thisMEANMAXLOC < thisMEANminLOC
        hold off;
        clear thisMEANAP thisMEANMAXLOC thisMEANminLOC;
    else
        plot(1:1:size(mean(thisCLAP(:, ttRUN, :), 3), 1), ones(1, size(mean(thisCLAP(:, ttRUN, :), 3), 1))); thisPEAKTOVALLEY = nan;
    end	%mean(maxAPMat(ttRUN, :)) > 10^4
    title(['width = ' jjnum2str(ttSPKWIDTH(1, ttRUN)) 'レs (' num2str(thisPEAKTOVALLEY) ')']); set(gca, 'FontSize', szFONT); axis off; clear thisPEAKTOVALLEY;
end	%ttRUN = 1:1:4


thisCLTSHalf = (thisCLTS(1,2)+thisCLTS(end,2))/2;
thisCLTSHalfIndex = knnsearch(thisCLTS(:,2),thisCLTSHalf);

for ttRUN = 1:1:1	 %Spk shape
    subplot('Position',Coordinate_Waveform_1sthalf);
    if mean(maxAPMat(ttRUN, :)) > 10^2
        hold on;
        thisMEANAP = mean(thisCLAP(:, ttRUN, 1:thisCLTSHalfIndex), 3); thisMEANMAXLOC = min(find(thisMEANAP == max(thisMEANAP))); thisMEANminLOC = max(find(thisMEANAP == min(thisMEANAP))); thisPEAKTOVALLEY = thisMEANminLOC - thisMEANMAXLOC + 1;
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
    title(['1st half']); set(gca, 'FontSize', szFONT); axis off; clear thisPEAKTOVALLEY;
end	%ttRUN = 1:1:4

for ttRUN = 1:1:1	 %Spk shape
    subplot('Position',Coordinate_Waveform_2ndhalf);
    if mean(maxAPMat(ttRUN, :)) > 10^2
        hold on;
        thisMEANAP = mean(thisCLAP(:, ttRUN, thisCLTSHalfIndex:end), 3); thisMEANMAXLOC = min(find(thisMEANAP == max(thisMEANAP))); thisMEANminLOC = max(find(thisMEANAP == min(thisMEANAP))); thisPEAKTOVALLEY = thisMEANminLOC - thisMEANMAXLOC + 1;
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
    title(['2nd half']); set(gca, 'FontSize', szFONT); axis off; clear thisPEAKTOVALLEY;
end	%ttRUN = 1:1:4

%% Time vs. Peak Amplitude
subplot('Position',Coordinate_Time);
plot(SpikeTime, PEAKMat(:, MaximumChannel),'k.')
xlabel('Time(s)'); ylabel('Peak Amplitude(\muv)');title('Time vs Peak Amplitude(レv)');
ylim([0 max(max(PEAKMat))])

%% AutoCorrelogram
sheetTitle = subplot('Position',Coordinate_AutoCorrelogram);
set(sheetTitle, 'visible', 'off');
[correlogram corrXlabel] = CrossCorr(thisCLTS(:, 2) ./ 100, thisCLTS(:, 2) ./ 100, 1, 1000);
correlogram((length(corrXlabel)+1)/2) = 0; % to adjust y limit

bar(corrXlabel, correlogram);
title('AutoCorrelogram'); set(gca, 'FontSize', szFONT, 'XLim', [min(corrXlabel) max(corrXlabel)], 'YLim', [0 max(log10(correlogram))]); xlabel('Time (ms)'); axis tight;
%% Log ISI
sheetTitle = subplot('Position',Coordinate_ISI);
isiHIST = histc(log10(diff(thisCLTS(:, 2))), histEDGE);
withinREFRACPortion = (sum(diff(thisCLTS(:, 2)) < (ISIREFRACTORY * 10^3)) / length(thisCLTS(:, 2))) * 100;
hold on;
bar(isiHIST);	%plot(ones(1, max(isiHIST) + 1) .* find(histEDGE == 0), 0:1:max(isiHIST), 'r:', 'LineWidth', szLINE);
text(min(find(isiHIST == min(max(isiHIST)))), min(max(isiHIST)), [jjnum2str((10^histEDGE(min(find(isiHIST == min(max(isiHIST)))))) / 1000) ' ms']);
text(min(find(isiHIST)), min(max(isiHIST)), [jjnum2str((10^histEDGE(min(find(isiHIST)))) / 1000) ' ms']);
line([min(find(isiHIST)) min(find(isiHIST))], [get(gca,'YLim')])
LogISIPEAKTIME = (10^histEDGE(min(find(isiHIST == min(max(isiHIST)))))) / 1000;
hold off;


title(['log ISI']); xlabel(['time (ms)']); axis tight; set(gca, 'FontSize', szFONT,'XLim', [350 size(histEDGE, 2)], 'XTick', 350:((size(histEDGE, 2) - 350) / 2):size(histEDGE, 2), 'XTickLabel', {['.31'], ['55'], ['10000']});
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
%% Spike Property Index
sheetTitle = subplot('Position',Coordinate_CellDescription);
set(sheetTitle, 'visible', 'off');
txtINIX=0;txtINIY=1; txtADJX=0.4; txtADJY=0.2;
%180131 Need to compare SPKWIDTHAMP and PeakToValleyTime
text(txtINIX - txtADJX * 0, txtINIY - txtADJY * 0, ['Spike width = ' jjnum2str(SPKWIDTHAMP) ' レs'],'Fontsize',Fontsize);
% text(txtINIX - txtADJX * 0, txtINIY - txtADJY * 1, ['Spike height (from baseline) = ' jjnum2str(PeakAmplitude) ' \muv'],'Fontsize',Fontsize);
text(txtINIX - txtADJX * 0, txtINIY - txtADJY * 1, ['Spike height (peak to valley) = ' jjnum2str(PeakAmplitude-ValleyAmplitude) ' レv'],'Fontsize',Fontsize);
text(txtINIX - txtADJX * 0, txtINIY - txtADJY * 2, ['Spikes within r.p. = ' num2str(withinREFRACPortion) ' %'],'Fontsize',Fontsize);

% text(txtINIX + txtADJX * 1, txtINIY - txtADJY * 0, ['L-Ratio = ' jjnum2str(LRATIO)],'Fontsize',Fontsize);
% text(txtINIX + txtADJX * 1, txtINIY - txtADJY * 1, ['Isolation Distance = ' jjnum2str(ISODIST)],'Fontsize',Fontsize);
% text(txtINIX + txtADJX * 1, txtINIY - txtADJY * 2, ['Theta Modulation Index = ' jjnum2str(TMI1)],'Fontsize',Fontsize);
text(txtINIX + txtADJX * 0, txtINIY - txtADJY * 3, ['# of spikes total = ' jjnum2str(nSPKS)],'Fontsize',Fontsize);
text(txtINIX + txtADJX * 0, txtINIY - txtADJY * 4, ['Average F. R. = ' num2str(nSPKS/((TickLog_sync_recording(end,1) - TickLog_sync_recording(1,1))*10^(-6))) ' Hz'],'Fontsize',Fontsize);

Grid= imread('RecordingCoordinate.jpg');
subplot('Position',[0.8 0.5 0.2 0.2])
imshow(Grid);


%% Display_Forest_City
RecordnLaps = size(LapType_unreal_recording,1);
RecordACC = mean((Choice_unreal_recording(:,end)-1)==TrialInfo_sync_recording(:,9));
sheetTitle = subplot('Position',[0.33 0.5 0.1 0.09]);
set(sheetTitle, 'visible', 'off');
text(0, 0, ['nLaps = ' num2str(RecordnLaps)],'Fontsize',10);
text(0, -0.1, ['ACC = ' num2str(RecordACC)],'Fontsize',10);

Display_Forest_City



%% Display Histogram in the Choice Phase
sheetTitle = subplot('Position',[0.43 0.5 0.1 0.09]);
set(sheetTitle, 'visible', 'off');
text(0, 0, ['PreCr: Pre-Cursor'],'Fontsize',10);
text(0, -0.1, ['PreSp: Pre-Sample'],'Fontsize',10);
text(0, -0.2, ['Sp: Sample'],'Fontsize',10);
text(0, -0.3, ['Ch: Choice'],'Fontsize',10);


YMax = max(max(ChoiceArray));
cxt = 0.02; baseY = 0.385; AxisXTick = 0.085; AxisYTick = 0.075; sizeX = 0.07; sizeY = 0.052;

for c = 1:2
    if c==1
        Color = 'r';
    else
        Color = 'b';
    end
for i = 0:2
hold on
subplot('Position',[cxt+AxisXTick*i baseY-AxisYTick*0 sizeX sizeY])
DrawHistogramFromArray(ChoiceArray(c*18+i*6-17,:),c, 2*i+1, 0, YMax)



hold on
subplot('Position',[cxt+AxisXTick*i baseY-AxisYTick*1 sizeX sizeY])
DrawHistogramFromArray(ChoiceArray(c*18+i*6-16,:),c, 0, 2*i+1, YMax)

hax = axes('Position', [cxt+AxisXTick*i-0.007 0.3 0.08 0.15]);
axis off
rectangle(hax,'Position',[0 0 1 1],'FaceColor','none', 'EdgeColor', Color)

subplot('Position',[cxt+AxisXTick*i baseY-AxisYTick*2 sizeX sizeY])
DrawHistogramFromArray(ChoiceArray(c*18+i*6-15,:),c, 2*i+1, 2, YMax)
subplot('Position',[cxt+AxisXTick*i baseY-AxisYTick*3 sizeX sizeY])
DrawHistogramFromArray(ChoiceArray(c*18+i*6-14,:),c, 2, 2*i+1, YMax)

hax = axes('Position', [cxt+AxisXTick*i-0.007 0.15 0.08 0.15]);
axis off
rectangle(hax,'Position',[0 0 1 1],'FaceColor','none', 'EdgeColor', Color)

subplot('Position',[cxt+AxisXTick*i baseY-AxisYTick*4 sizeX sizeY])
DrawHistogramFromArray(ChoiceArray(c*18+i*6-13,:),c, 2*i+1, 4, YMax)
subplot('Position',[cxt+AxisXTick*i baseY-AxisYTick*5 sizeX sizeY])
DrawHistogramFromArray(ChoiceArray(c*18+i*6-12,:),c, 4, 2*i+1, YMax)

hax = axes('Position', [cxt+AxisXTick*i-0.007 0.0 0.08 0.15]);
axis off
rectangle(hax,'Position',[0 0 1 1],'FaceColor','none', 'EdgeColor', Color)
end
cxt = 0.28;
end
%% Eye raw firing scatterplot
img = imread('Diagram_small.png');
% Range = max( [Eye_ForestMaxFR Eye_CityMaxFR] ) * 1.1;
baseX = 0.54; baseY = 0.44; AxisXTick = 0.075; AxisYTick = 0.06; sizeX = 0.065; sizeY = 0.04;

for i = 1:8
subplot('Position',[baseX+AxisXTick*0 baseY-AxisYTick*(i-1) sizeX sizeY])
plot((Eye_Analog_sync_recording_forest_COnly(:,2,i)),(Eye_Analog_sync_recording_forest_COnly(:,3,i)),'MarkerSize',5,'Marker','.','LineWidth',2,'LineStyle','none',...
    'Color',[0.501960813999176 0.501960813999176 0.501960813999176]);
hold on
plot((spk_eye_forest_COnly(:,2,i)),(spk_eye_forest_COnly(:,3,i)), 'MarkerSize',10,'Marker','.','LineWidth',2,'LineStyle','none',...
    'Color','k');
title(['Forest, Cursor Only, loc ' num2str(i)])
EyeRaster_Setting(img)

subplot('Position',[baseX+AxisXTick*1 baseY-AxisYTick*(i-1) sizeX sizeY])
plot((Eye_Analog_sync_recording_forest_left(:,2,i)),(Eye_Analog_sync_recording_forest_left(:,3,i)),'MarkerSize',5,'Marker','.','LineWidth',2,'LineStyle','none',...
    'Color',[0.501960813999176 0.501960813999176 0.501960813999176]);
hold on
plot((spk_eye_forest_left(:,2,i)),(spk_eye_forest_left(:,3,i)), 'MarkerSize',10,'Marker','.','LineWidth',2,'LineStyle','none',...
    'Color','k');
title(['Forest, Choice L, loc ' num2str(i)])
EyeRaster_Setting(img)


subplot('Position',[baseX+AxisXTick*2 baseY-AxisYTick*(i-1) sizeX sizeY])
plot((Eye_Analog_sync_recording_forest_right(:,2)),(Eye_Analog_sync_recording_forest_right(:,3)),'MarkerSize',5,'Marker','.','LineWidth',2,'LineStyle','none',...
    'Color',[0.501960813999176 0.501960813999176 0.501960813999176]);
hold on
plot((spk_eye_forest_right(:,2,i)),(spk_eye_forest_right(:,3,i)), 'MarkerSize',10,'Marker','.','LineWidth',2,'LineStyle','none',...
    'Color','k');
title(['Forest, Choice R, loc ' num2str(i)])
EyeRaster_Setting(img)

subplot('Position',[baseX+AxisXTick*3 baseY-AxisYTick*(i-1) sizeX sizeY])
plot((Eye_Analog_sync_recording_city_COnly(:,2,i)),(Eye_Analog_sync_recording_city_COnly(:,3,i)),'MarkerSize',5,'Marker','.','LineWidth',2,'LineStyle','none',...
    'Color',[0.501960813999176 0.501960813999176 0.501960813999176]);
hold on
plot((spk_eye_city_COnly(:,2,i)),(spk_eye_city_COnly(:,3,i)), 'MarkerSize',10,'Marker','.','LineWidth',2,'LineStyle','none',...
    'Color','k');
title(['City, Cursor Only, loc ' num2str(i)])
EyeRaster_Setting(img)

subplot('Position',[baseX+AxisXTick*4 baseY-AxisYTick*(i-1) sizeX sizeY])
plot((Eye_Analog_sync_recording_city_left(:,2,i)),(Eye_Analog_sync_recording_city_left(:,3,i)),'MarkerSize',5,'Marker','.','LineWidth',2,'LineStyle','none',...
    'Color',[0.501960813999176 0.501960813999176 0.501960813999176]);
hold on
plot((spk_eye_city_left(:,2,i)),(spk_eye_city_left(:,3,i)), 'MarkerSize',10,'Marker','.','LineWidth',2,'LineStyle','none',...
    'Color','k');
title(['City, Choice L, loc ' num2str(i)])
EyeRaster_Setting(img)

subplot('Position',[baseX+AxisXTick*5 baseY-AxisYTick*(i-1) sizeX sizeY])
plot((Eye_Analog_sync_recording_city_right(:,2,i)),(Eye_Analog_sync_recording_city_right(:,3,i)),'MarkerSize',5,'Marker','.','LineWidth',2,'LineStyle','none',...
    'Color',[0.501960813999176 0.501960813999176 0.501960813999176]);
hold on
plot((spk_eye_city_right(:,2,i)),(spk_eye_city_right(:,3,i)), 'MarkerSize',10,'Marker','.','LineWidth',2,'LineStyle','none',...
    'Color','k');
title(['City, Choice R, loc ' num2str(i)])
EyeRaster_Setting(img)

end
hax = axes('Position', [baseX-0.007 baseY-AxisYTick*7-0.006 AxisXTick*3 AxisYTick*8]);
axis off
rectangle(hax,'Position',[0 0 1 1],'FaceColor','none', 'EdgeColor', 'r')

hax = axes('Position', [baseX+AxisXTick*3-0.007 baseY-AxisYTick*7-0.006 AxisXTick*3 AxisYTick*8]);
axis off
rectangle(hax,'Position',[0 0 1 1],'FaceColor','none', 'EdgeColor', 'b')

%%

baseX = 0.35; baseY = 0.82; AxisXTick = 0.155; AxisYTick = 0.23; sizeX = 0.12; sizeY = 0.15;
f_title = 10; f_axis = 10;

Range = max(max(max(FR_mean(:,:,:)))) * 1.1;
% sheetTitle = subplot('Position', Coordinate_Title);
% set(sheetTitle, 'visible', 'off');
% text(0,0.5,[session_date ' - Mean Firing Rate, from Object On to Choice'],'Fontsize',TitleFontsize);


subplot('Position',[baseX baseY sizeX sizeY])
SetColorMap(1,FR_mean,FR_sem,Range)
title('Forest, Left Choice','FontSize',f_title)
xlabel('Left Obj','FontSize',f_axis)
ylabel('Right Obj','FontSize',f_axis)

subplot('Position',[baseX+AxisXTick baseY sizeX sizeY])
SetColorMap(2,FR_mean,FR_sem,Range)
title('Forest, Right Choice','FontSize',f_title)
ylabel('Left Obj','FontSize',f_axis)
xlabel('Right Obj','FontSize',f_axis)

subplot('Position',[baseX+AxisXTick baseY-AxisYTick sizeX sizeY])
SetColorMap(3,FR_mean,FR_sem,Range)
title('City, Right Choice','FontSize',f_title)
xlabel('Left Obj','FontSize',f_axis)
ylabel('Right Obj','FontSize',f_axis)

subplot('Position',[baseX baseY-AxisYTick sizeX sizeY])
SetColorMap(4,FR_mean,FR_sem,Range)
title('City, Left Choice','FontSize',f_title)
ylabel('Left Obj','FontSize',f_axis)
xlabel('Right Obj','FontSize',f_axis)

colorbar('Position',[baseX+0.6*AxisXTick baseY-0.23*AxisYTick 0.6*AxisXTick 0.01],'location','south', 'Limits', [0 Range])

%%
cd(processed_folder_neuralynx)
savefilename=TitleText; 
savefig(savefilename)
