%% Defining by In & Outbound
ForestOutboundIndex = logical((SpikeData_info(:,3)==1) .* (SpikeData_info(:,4)>0) .* (SpikeData_info(:,4)<10));
ForestOutboundIndices = find(ForestOutboundIndex==1);
ForestOutboundSpikePosition = SpikePosition(ForestOutboundIndices);
ForestOutboundSpikeTime = SpikeTime(ForestOutboundIndices);

ForestOutboundBehaviorIndex = logical((TickLog_sync_recording_info(:,3)==1) .* (TickLog_sync_recording_info(:,4)>0).* (TickLog_sync_recording_info(:,4)<10));
ForestOutboundBehaviorIndices = find(ForestOutboundBehaviorIndex==1);
ForestOutboundBehaviorPosition = TickLog_sync_recording_info(ForestOutboundBehaviorIndices,2);
ForestOutboundBehaviorTime = TickLog_sync_recording_info(ForestOutboundBehaviorIndex,1);

ForestInboundIndex = logical((SpikeData_info(:,3)==1).* (SpikeData_info(:,4)>10));
ForestInboundIndices = find(ForestInboundIndex==1);
ForestInboundSpikePosition = SpikePosition(ForestInboundIndices);
ForestInboundSpikeTime = SpikeTime(ForestInboundIndices);

ForestInboundBehaviorIndex = logical((TickLog_sync_recording_info(:,3)==1) .* (TickLog_sync_recording_info(:,4)>10));
ForestInboundBehaviorIndices = find(ForestInboundBehaviorIndex==1);
ForestInboundBehaviorPosition = TickLog_sync_recording_info(ForestInboundBehaviorIndices,2);
ForestInboundBehaviorTime = TickLog_sync_recording_info(ForestInboundBehaviorIndex,1);

ForestIndex = (SpikeData_info(:,3)==1);
ForestIndices = vertcat(ForestOutboundIndices, ForestInboundIndices);
ForestSpikePosition = vertcat(ForestOutboundSpikePosition, 9700-ForestInboundSpikePosition+1000);
ForestSpikeTime = vertcat(ForestOutboundSpikeTime, ForestInboundSpikeTime);
ForestSpikeInfo = sortrows(horzcat(ForestIndices, ForestSpikePosition, ForestSpikeTime));

ForestBehaviorIndex = (TickLog_sync_recording_info(:,3)==1);
ForestBehaviorIndices = vertcat(ForestOutboundBehaviorIndices, ForestInboundBehaviorIndices);
ForestBehaviorPosition = vertcat(ForestOutboundBehaviorPosition, 9700-ForestInboundBehaviorPosition+1000);
ForestBehaviorTime = vertcat(ForestOutboundBehaviorTime, ForestInboundBehaviorTime);
ForestBehaviorInfo = sortrows(horzcat(ForestBehaviorIndices, ForestBehaviorPosition, ForestBehaviorTime));


ForestOutboundSpikeTimeT = (((ForestOutboundSpikeTime-min(TickLog_sync_recording(:,1))))./1000000);
ForestInboundSpikeTimeT = (((ForestInboundSpikeTime-min(TickLog_sync_recording(:,1))))./1000000);
ForestOutboundBehaviorTimeT = (((ForestOutboundBehaviorTime-min(TickLog_sync_recording(:,1))))./1000000);
ForestInboundBehaviorTimeT = (((ForestInboundBehaviorTime-min(TickLog_sync_recording(:,1))))./1000000);




ForestSpikeTimeT = (((ForestSpikeTime-min(TickLog_sync_recording(:,1))))./1000000);
%% Binning
Bins = 40;
BinSize = 250;
ForestOutBin = cell(1,Bins);
ForestInBin = cell(1,Bins);


for h=1:Bins
    
    ForestOutBin{1,h} = ((((length(find((ForestOutboundSpikePosition< BinSize*h) == (ForestOutboundSpikePosition > (BinSize*(h-1))))))))./ (((length(find((ForestOutboundBehaviorPosition< BinSize*h) == (ForestOutboundBehaviorPosition > (BinSize*(h-1)))))))*(1/30)));
    ForestInBin{1, h} = ((((length(find((ForestInboundSpikePosition< BinSize*h) == (ForestInboundSpikePosition > (BinSize*(h-1))))))))./ (((length(find((ForestInboundBehaviorPosition< BinSize*h) == (ForestInboundBehaviorPosition > (BinSize*(h-1)))))))*(1/30)));
    
end

ForestOutArray = cell2mat(ForestOutBin);
ForestInArray= cell2mat(ForestInBin);


figure(1);
subplot(2,3,1)
set(gcf,'renderer','Painters')
plot((ForestOutboundBehaviorPosition),(ForestOutboundBehaviorTimeT),'MarkerSize',0.1,'Marker','.','LineWidth',2,'LineStyle','none',...
    'Color',[0.501960813999176 0.501960813999176 0.501960813999176]);
set(gca,'YDir','reverse');
xlabel('Position (cm)','FontWeight','bold','FontSize',14);
ylabel('Time (s)','FontWeight','bold','FontSize',14);

hold on
plot((ForestOutboundSpikePosition),(ForestOutboundSpikeTimeT), 'MarkerSize',5,'Marker','.','LineWidth',2,'LineStyle','none',...
    'Color',[1 0 0]);

set(gca,'YDir','reverse');
axis([0 max(ForestOutboundBehaviorPosition) 0 max(ForestOutboundSpikeTimeT)]);
title({'Raw spike map (Forest, Outbound)'},'FontWeight','bold');

hold on

figure(1);
subplot(2,3,4)
set(gcf,'renderer','Painters')
plot((ForestInboundBehaviorPosition),(ForestInboundBehaviorTimeT),'MarkerSize',0.1,'Marker','.','LineWidth',2,'LineStyle','none',...
    'Color',[0.501960813999176 0.501960813999176 0.501960813999176]);
set(gca,'YDir','reverse');
xlabel('Position (cm)','FontWeight','bold','FontSize',14);
ylabel('Time (s)','FontWeight','bold','FontSize',14);

hold on
plot((ForestInboundSpikePosition),(ForestInboundSpikeTimeT), 'MarkerSize',5,'Marker','.','LineWidth',2,'LineStyle','none',...
    'Color',[1 0 0]);

set(gca,'YDir','reverse');
axis([0 max(ForestInboundBehaviorPosition) 0 max(ForestInboundSpikeTimeT)]);
title({'Raw spike map (Forest, Inbound)'},'FontWeight','bold');

hold on

% plot((RewardPosition./5*3),(RewardTime), 'Marker','square','LineWidth',1,'LineStyle','none', 'Color',[0 0.447058826684952 0.74117648601532])


subplot(2,3,2)


stem(ForestOutArray,'DisplayName','Forest','Marker','none','LineWidth',3);

hold on

xlabel(['Bin (1 bin = ' num2str(BinSize) 'cm)'],'FontWeight','bold','FontSize',14);
title({'Linearized firing rate on track (Forest, Outbound)'},'FontWeight','bold');
ylabel('Firing rate (Hz)','FontWeight','bold','FontSize',14);
axis([0 Bins 0 max(max(ForestOutArray), max(ForestOutArray))*1.2]);


subplot(2,3,5)


stem(ForestInArray,'DisplayName','Forest','Marker','none','LineWidth',3);

hold on

xlabel(['Bin (1 bin = ' num2str(BinSize) 'cm)'],'FontWeight','bold','FontSize',14);
title({'Linearized firing rate on track (Forest, Inbound)'},'FontWeight','bold');
ylabel('Firing rate (Hz)','FontWeight','bold','FontSize',14);
axis([0 Bins 0 max(max(ForestOutArray), max(ForestInArray))*1.2]);
%
for j = 1 : 1000/10
    section = [1 100] + 10 * (j-1);
    Duration(j) = length(find(Position >= section(1) & Position < section(2)));
end
Duration_norm = Duration / size(Position,1);
%% For VR ratemap construction

XsizeOfVideo = 9600;
    YsizeOfVideo = 2400;
samplingRate = 30;
scaleForRateMap = 150;

binXForRateMap = XsizeOfVideo / scaleForRateMap;
binYForRateMap = YsizeOfVideo / scaleForRateMap;

% Forest Outbound

SpikePositionY = ones(length(ForestOutboundSpikePosition),1);
FilteredPositionY = ones(length(ForestOutboundBehaviorPosition), 1);

[ForestOutoccMat, spkMat, rawMat, ForestOutskaggsrateMat] = abmFiringRateMap( ...
    [ForestOutboundSpikeTime, ForestOutboundSpikePosition, SpikePositionY],...
    [ForestOutboundBehaviorTime, ForestOutboundBehaviorPosition, FilteredPositionY],...
    binYForRateMap, binXForRateMap, scaleForRateMap, samplingRate);
ForestOutSpaInfoScore = GetSpaInfo(ForestOutoccMat, ForestOutskaggsrateMat);
ForestOutMaxFR = nanmax(nanmax(ForestOutskaggsrateMat));
ForestOutAvgFR = nanmean(nanmean(ForestOutskaggsrateMat));
ForestOutnumOfSpk = length(ForestOutboundSpikeTime);
ForestOutskaggsrateMat(1,:) = fillmissing(ForestOutskaggsrateMat(1,:),'constant',0) ;

% Forest Inbound

SpikePositionY = ones(length(ForestInboundSpikePosition),1);
FilteredPositionY = ones(length(ForestInboundBehaviorPosition), 1);

[ForestInoccMat, spkMat, rawMat, ForestInskaggsrateMat] = abmFiringRateMap( ...
    [ForestInboundSpikeTime, ForestInboundSpikePosition, SpikePositionY],...
    [ForestInboundBehaviorTime, ForestInboundBehaviorPosition, FilteredPositionY],...
    binYForRateMap, binXForRateMap, scaleForRateMap, samplingRate);
ForestInSpaInfoScore = GetSpaInfo(ForestInoccMat, ForestInskaggsrateMat);
ForestInMaxFR = nanmax(nanmax(ForestInskaggsrateMat));
ForestInAvgFR = nanmean(nanmean(ForestInskaggsrateMat));
ForestInnumOfSpk = length(ForestInboundSpikeTime);
ForestInskaggsrateMat(1,:) = fillmissing(ForestInskaggsrateMat(1,:),'constant',0) ;

Range = max( [ForestOutMaxFR ForestInMaxFR] ) * 1.1;

R = corrcoef(ForestOutskaggsrateMat(1,1:50), ForestInskaggsrateMat(1,1:50));
R = R(2);


subplot(4,3,3)
plot(ForestOutskaggsrateMat(1,:),'LineWidth',2)
xticks(0:4:64); xlim([1 64])
title({'Forest, Outbound'},'FontWeight','bold');
subplot(4,3,6)
imagesc((ForestOutskaggsrateMat));
colormap(jet);
thisAlphaZ = ForestOutskaggsrateMat;
thisAlphaZ(isnan(ForestOutskaggsrateMat)) = 0;
thisAlphaZ(~isnan(ForestOutskaggsrateMat)) = 1;
hold on

alpha(thisAlphaZ);axis off;
j=1;
minmaxColor = get(gca, 'CLim');
if minmaxColor(1) == -1 && minmaxColor(2) == 1
    minmaxColor(2)=0.1;
end

maxColor(j) = minmaxColor(2);
j=j+1;
text(0,3,sprintf(['Max frequency = ' num2str(ForestOutMaxFR) '(Hz)'], 'fontsize',10));
text(0,2,sprintf(['Spatial information = ' num2str(ForestOutSpaInfoScore)],'fontsize',10));
text(0,4,sprintf(['Average frequency =' num2str(ForestOutAvgFR) '(Hz)'], 'fontsize', 10));

colorbar('south');

hold on

MAXcolor=max(maxColor);
if MAXcolor<1
    MAXcolor=1;
end

set(gca,'CLim', [0 maxColor(1)]);
caxis([0 Range])


subplot(4,3,9)
plot(ForestInskaggsrateMat(1,:),'LineWidth',2)
xticks(0:4:64); xlim([1 64]) 
title({'Forest, Inbound'},'FontWeight','bold');
hold on
subplot(4,3,12)
imagesc((ForestInskaggsrateMat));
colormap(jet);
thisAlphaZ = ForestInskaggsrateMat;
thisAlphaZ(isnan(ForestInskaggsrateMat)) = 0;
thisAlphaZ(~isnan(ForestInskaggsrateMat)) = 1;
hold on
alpha(thisAlphaZ);axis off;
j=1;
minmaxColor = get(gca, 'CLim');
if minmaxColor(1) == -1 && minmaxColor(2) == 1
    minmaxColor(2)=0.1;
end
maxColor(j) = minmaxColor(2);
j=j+1;
text(0,3,sprintf(['Max frequency = ' num2str(ForestInMaxFR) '(Hz)'], 'fontsize',10));
text(0,2,sprintf(['Spatial information = ' num2str(ForestInSpaInfoScore)],'fontsize',10));
text(0,4,sprintf(['Average frequency =' num2str(ForestInAvgFR) '(Hz)'], 'fontsize', 10));


colorbar('south');

hold on


MAXcolor=max(maxColor);
if MAXcolor<1
    MAXcolor=1;
end

set(gca,'CLim', [0 maxColor(1)]);
caxis([0 Range])


x0=600;
y0=300;
width=600;
height=400;
set(gcf,'units','points','position',[x0,y0,width,height])