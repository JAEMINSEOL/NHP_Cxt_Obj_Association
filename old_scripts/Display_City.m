%% Defining by In & Outbound
CityOutboundIndex = logical((SpikeData_info(:,3)==2) .* (SpikeData_info(:,4)>0) .* (SpikeData_info(:,4)<10));
CityOutboundIndices = find(CityOutboundIndex==1);
CityOutboundSpikePosition = SpikePosition(CityOutboundIndices);
CityOutboundSpikeTime = SpikeTime(CityOutboundIndices);

CityOutboundBehaviorIndex = logical((TickLog_sync_recording_info(:,3)==2) .* (TickLog_sync_recording_info(:,4)>0).* (TickLog_sync_recording_info(:,4)<10));
CityOutboundBehaviorIndices = find(CityOutboundBehaviorIndex==1);
CityOutboundBehaviorPosition = TickLog_sync_recording_info(CityOutboundBehaviorIndices,2);
CityOutboundBehaviorTime = TickLog_sync_recording_info(CityOutboundBehaviorIndex,1);

CityInboundIndex = logical((SpikeData_info(:,3)==2).* (SpikeData_info(:,4)>10));
CityInboundIndices = find(CityInboundIndex==1);
CityInboundSpikePosition = SpikePosition(CityInboundIndices);
CityInboundSpikeTime = SpikeTime(CityInboundIndices);

CityInboundBehaviorIndex = logical((TickLog_sync_recording_info(:,3)==2) .* (TickLog_sync_recording_info(:,4)>10));
CityInboundBehaviorIndices = find(CityInboundBehaviorIndex==1);
CityInboundBehaviorPosition = TickLog_sync_recording_info(CityInboundBehaviorIndices,2);
CityInboundBehaviorTime = TickLog_sync_recording_info(CityInboundBehaviorIndex,1);

CityIndex = (SpikeData_info(:,3)==2);
CityIndices = vertcat(CityOutboundIndices, CityInboundIndices);
CitySpikePosition = vertcat(CityOutboundSpikePosition, CityInboundSpikePosition);
CitySpikeTime = vertcat(CityOutboundSpikeTime, CityInboundSpikeTime);
CitySpikeInfo = horzcat(CityIndices, CitySpikePosition, CitySpikeTime);

CityBehaviorIndex = (TickLog_sync_recording_info(:,3)==2);
CityBehaviorIndices = vertcat(CityOutboundBehaviorIndices, CityInboundBehaviorIndices);
CityBehaviorPosition = vertcat(CityOutboundBehaviorPosition, CityInboundBehaviorPosition);
CityBehaviorTime = vertcat(CityOutboundBehaviorTime, CityInboundBehaviorTime);

CityOutboundSpikeTimeT = (((CityOutboundSpikeTime-min(TickLog_sync_recording(:,1))))./1000000);
CityInboundSpikeTimeT = (((CityInboundSpikeTime-min(TickLog_sync_recording(:,1))))./1000000);
CityOutboundBehaviorTimeT = (((CityOutboundBehaviorTime-min(TickLog_sync_recording(:,1))))./1000000);
CityInboundBehaviorTimeT = (((CityInboundBehaviorTime-min(TickLog_sync_recording(:,1))))./1000000);

CitySpikeTimeT = (((CitySpikeTime-min(TickLog_sync_recording(:,1))))./1000000);
%% Binning
Bins = 39;
BinSize = 250;
CityOutBin = cell(1,Bins);
CityInBin = cell(1,Bins);


for h=1:Bins
    
    CityOutBin{1,h} = ((((length(find((CityOutboundSpikePosition< BinSize*h) == (CityOutboundSpikePosition > (BinSize*(h-1))))))))./ (((length(find((CityOutboundBehaviorPosition< BinSize*h) == (CityOutboundBehaviorPosition > (BinSize*(h-1)))))))*(1/BinSize)));
    CityInBin{1, h} = ((((length(find((CityInboundSpikePosition< BinSize*h) == (CityInboundSpikePosition > (BinSize*(h-1))))))))./ (((length(find((CityInboundBehaviorPosition< BinSize*h) == (CityInboundBehaviorPosition > (BinSize*(h-1)))))))*(1/BinSize)));
    
end

CityOutArray = cell2mat(CityOutBin);
CityInArray= cell2mat(CityInBin);


figure(2);
subplot(2,3,1)
set(gcf,'renderer','Painters')
plot((CityOutboundBehaviorPosition),(CityOutboundBehaviorTimeT),'MarkerSize',0.1,'Marker','.','LineWidth',2,'LineStyle','none',...
    'Color',[0.501960813999176 0.501960813999176 0.501960813999176]);
set(gca,'YDir','reverse');
xlabel('Position (cm)','FontWeight','bold','FontSize',14);
ylabel('Time (s)','FontWeight','bold','FontSize',14);

hold on
plot((CityOutboundSpikePosition),(CityOutboundSpikeTimeT), 'MarkerSize',5,'Marker','.','LineWidth',2,'LineStyle','none',...
    'Color',[1 0 0]);

set(gca,'YDir','reverse');
axis([0 max(CityOutboundBehaviorPosition) 0 max(CityOutboundSpikeTimeT)]);
title({'Raw spike map (City, Outbound)'},'FontWeight','bold');

hold on

figure(2);
subplot(2,3,4)
set(gcf,'renderer','Painters')
plot((CityInboundBehaviorPosition),(CityInboundBehaviorTimeT),'MarkerSize',0.1,'Marker','.','LineWidth',2,'LineStyle','none',...
    'Color',[0.501960813999176 0.501960813999176 0.501960813999176]);
set(gca,'YDir','reverse');
xlabel('Position (cm)','FontWeight','bold','FontSize',14);
ylabel('Time (s)','FontWeight','bold','FontSize',14);

hold on
plot((CityInboundSpikePosition),(CityInboundSpikeTimeT), 'MarkerSize',5,'Marker','.','LineWidth',2,'LineStyle','none',...
    'Color',[1 0 0]);

set(gca,'YDir','reverse');
axis([0 max(CityInboundBehaviorPosition) 0 max(CityInboundSpikeTimeT)]);
title({'Raw spike map (City, Inbound)'},'FontWeight','bold');

hold on

% plot((RewardPosition./5*3),(RewardTime), 'Marker','square','LineWidth',1,'LineStyle','none', 'Color',[0 0.447058826684952 0.74117648601532])


subplot(2,3,2)


stem(CityOutArray,'DisplayName','City','Marker','none','LineWidth',3);

hold on

xlabel(['Bin (1 bin = ' num2str(BinSize) 'cm)'],'FontWeight','bold','FontSize',14);
title({'Linearized firing rate on track (City, Outbound)'},'FontWeight','bold');
ylabel('Firing rate (Hz)','FontWeight','bold','FontSize',14);
axis([0 Bins 0 max(max(CityOutArray), max(CityOutArray))*1.2]);


subplot(2,3,5)


stem(CityInArray,'DisplayName','City','Marker','none','LineWidth',3);

hold on

xlabel(['Bin (1 bin = ' num2str(BinSize) 'cm)'],'FontWeight','bold','FontSize',14);
title({'Linearized firing rate on track (City, Inbound)'},'FontWeight','bold');
ylabel('Firing rate (Hz)','FontWeight','bold','FontSize',14);
axis([0 Bins 0 max(max(CityOutArray), max(CityInArray))*1.2]);
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

% City Outbound

SpikePositionY = ones(length(CityOutboundSpikePosition),1);
FilteredPositionY = ones(length(CityOutboundBehaviorPosition), 1);

[CityOutoccMat, spkMat, rawMat, CityOutskaggsrateMat] = abmFiringRateMap( ...
    [CityOutboundSpikeTime, CityOutboundSpikePosition, SpikePositionY],...
    [CityOutboundBehaviorTime, CityOutboundBehaviorPosition, FilteredPositionY],...
    binYForRateMap, binXForRateMap, scaleForRateMap, samplingRate);
CityOutSpaInfoScore = GetSpaInfo(CityOutoccMat, CityOutskaggsrateMat);
CityOutMaxFR = nanmax(nanmax(CityOutskaggsrateMat));
CityOutAvgFR = nanmean(nanmean(CityOutskaggsrateMat));
CityOutnumOfSpk = length(CityOutboundSpikeTime);
CityOutskaggsrateMat(1,:) = fillmissing(CityOutskaggsrateMat(1,:),'constant',0) ;

% City Inbound

SpikePositionY = ones(length(CityInboundSpikePosition),1);
FilteredPositionY = ones(length(CityInboundBehaviorPosition), 1);

[CityInoccMat, spkMat, rawMat, CityInskaggsrateMat] = abmFiringRateMap( ...
    [CityInboundSpikeTime, CityInboundSpikePosition, SpikePositionY],...
    [CityInboundBehaviorTime, CityInboundBehaviorPosition, FilteredPositionY],...
    binYForRateMap, binXForRateMap, scaleForRateMap, samplingRate);
CityInSpaInfoScore = GetSpaInfo(CityInoccMat, CityInskaggsrateMat);
CityInMaxFR = nanmax(nanmax(CityInskaggsrateMat));
CityInAvgFR = nanmean(nanmean(CityInskaggsrateMat));
CityInnumOfSpk = length(CityInboundSpikeTime);
CityInskaggsrateMat(1,:) = fillmissing(CityInskaggsrateMat(1,:),'constant',0) ;

Range = max( [CityOutMaxFR CityInMaxFR] ) * 1.1;

R = corrcoef(CityOutskaggsrateMat(1,1:50), CityInskaggsrateMat(1,1:50));
R = R(2);


subplot(4,3,3)
plot(CityOutskaggsrateMat(1,:),'LineWidth',2)
xticks(0:4:64); xlim([1 64])
title({'City, Outbound'},'FontWeight','bold');
subplot(4,3,6)
imagesc((CityOutskaggsrateMat));
colormap(jet);
thisAlphaZ = CityOutskaggsrateMat;
thisAlphaZ(isnan(CityOutskaggsrateMat)) = 0;
thisAlphaZ(~isnan(CityOutskaggsrateMat)) = 1;
hold on

alpha(thisAlphaZ);axis off;
j=1;
minmaxColor = get(gca, 'CLim');
if minmaxColor(1) == -1 && minmaxColor(2) == 1
    minmaxColor(2)=0.1;
end

maxColor(j) = minmaxColor(2);
j=j+1;
text(0,3,sprintf(['Max frequency = ' num2str(CityOutMaxFR) '(Hz)'], 'fontsize',10));
text(0,2,sprintf(['Spatial information = ' num2str(CityOutSpaInfoScore)],'fontsize',10));
text(0,4,sprintf(['Average frequency =' num2str(CityOutAvgFR) '(Hz)'], 'fontsize', 10));

colorbar('south');

hold on

MAXcolor=max(maxColor);
if MAXcolor<1
    MAXcolor=1;
end

set(gca,'CLim', [0 maxColor(1)]);
caxis([0 Range])


subplot(4,3,9)
plot(CityInskaggsrateMat(1,:),'LineWidth',2)
xticks(0:4:64); xlim([1 64]) 
title({'City, Inbound'},'FontWeight','bold');
hold on
subplot(4,3,12)
imagesc((CityInskaggsrateMat));
colormap(jet);
thisAlphaZ = CityInskaggsrateMat;
thisAlphaZ(isnan(CityInskaggsrateMat)) = 0;
thisAlphaZ(~isnan(CityInskaggsrateMat)) = 1;
hold on
alpha(thisAlphaZ);axis off;
j=1;
minmaxColor = get(gca, 'CLim');
if minmaxColor(1) == -1 && minmaxColor(2) == 1
    minmaxColor(2)=0.1;
end
maxColor(j) = minmaxColor(2);
j=j+1;
text(0,3,sprintf(['Max frequency = ' num2str(CityInMaxFR) '(Hz)'], 'fontsize',10));
text(0,2,sprintf(['Spatial information = ' num2str(CityInSpaInfoScore)],'fontsize',10));
text(0,4,sprintf(['Average frequency =' num2str(CityInAvgFR) '(Hz)'], 'fontsize', 10));


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