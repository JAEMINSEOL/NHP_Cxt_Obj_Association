%% Defining by In & Outbound

BehaviorData_info = TickLog_sync_recording_info;

ForestOutboundIndex = logical((SpikeData_info(:,4)==1) .* (SpikeData_info(:,5)<10).*(SpikeData_info(:,13)==0));
ForestOutboundIndices = find(ForestOutboundIndex==1);
ForestOutboundSpikePosition = SpikeData_info(ForestOutboundIndices,2);
ForestOutboundSpikeTime = SpikeData_info(ForestOutboundIndices,1);

ForestOutboundBehaviorIndex = logical((TickLog_sync_recording_info(:,4)==1) .* (TickLog_sync_recording_info(:,5)>0).* (TickLog_sync_recording_info(:,5)<10).* (TickLog_sync_recording_info(:,13)==0));
ForestOutboundBehaviorIndices = find(ForestOutboundBehaviorIndex==1);
ForestOutboundBehaviorPosition = TickLog_sync_recording_info(ForestOutboundBehaviorIndices,2);
ForestOutboundBehaviorTime = TickLog_sync_recording_info(ForestOutboundBehaviorIndices,1);

ForestInboundIndex = logical((SpikeData_info(:,4)==1).* (SpikeData_info(:,5)>10).*(SpikeData_info(:,13)==0));
ForestInboundIndices = find(ForestInboundIndex==1);
ForestInboundSpikePosition = SpikeData_info(ForestInboundIndices,2);
ForestInboundSpikeTime = SpikeData_info(ForestInboundIndices,1);

ForestInboundBehaviorIndex = logical((TickLog_sync_recording_info(:,4)==1) .* (TickLog_sync_recording_info(:,5)>10).* (TickLog_sync_recording_info(:,13)==0));
ForestInboundBehaviorIndices = find(ForestInboundBehaviorIndex==1);
ForestInboundBehaviorPosition = TickLog_sync_recording_info(ForestInboundBehaviorIndices,2);
ForestInboundBehaviorTime = TickLog_sync_recording_info(ForestInboundBehaviorIndices,1);


ForestIndices = vertcat(ForestOutboundIndices, ForestInboundIndices);
ForestSpikePosition = vertcat(ForestOutboundSpikePosition, 20400-ForestInboundSpikePosition);
ForestSpikeTime = vertcat(ForestOutboundSpikeTime, ForestInboundSpikeTime);
ForestSpikeInfo = sortrows(horzcat(ForestIndices, ForestSpikePosition, ForestSpikeTime),2);
% ForestSpikeInfo(find(ForestSpikeInfo(:,2)==10900),:) = [];


ForestBehaviorIndices = vertcat(ForestOutboundBehaviorIndices, ForestInboundBehaviorIndices);
ForestBehaviorPosition = vertcat(ForestOutboundBehaviorPosition, 20400-ForestInboundBehaviorPosition);
ForestBehaviorTime = vertcat(ForestOutboundBehaviorTime, ForestInboundBehaviorTime);
ForestBehaviorInfo = sortrows(horzcat(ForestBehaviorIndices, ForestBehaviorPosition, ForestBehaviorTime));
% ForestBehaviorInfo(find(ForestBehaviorInfo(:,2)==10900),:) = [];

ForestSpikeTimeT = (((ForestSpikeInfo(:,3)-min(TickLog_sync_recording(:,1))))./1000000);
ForestBehaviorTimeT = (((ForestBehaviorInfo(:,3)-min(TickLog_sync_recording(:,1))))./1000000);


CityOutboundIndex = logical((SpikeData_info(:,4)==2) .* (SpikeData_info(:,5)>0) .* (SpikeData_info(:,5)<10).*(SpikeData_info(:,13)==0));
CityOutboundIndices = find(CityOutboundIndex==1);
CityOutboundSpikePosition = SpikeData_info(CityOutboundIndices,2);
CityOutboundSpikeTime = SpikeData_info(CityOutboundIndices,1);

CityOutboundBehaviorIndex = logical((TickLog_sync_recording_info(:,4)==2) .* (TickLog_sync_recording_info(:,5)>0).* (TickLog_sync_recording_info(:,5)<10).* (TickLog_sync_recording_info(:,13)==0));
CityOutboundBehaviorIndices = find(CityOutboundBehaviorIndex==1);
CityOutboundBehaviorPosition = TickLog_sync_recording_info(CityOutboundBehaviorIndices,2);
CityOutboundBehaviorTime = TickLog_sync_recording_info(CityOutboundBehaviorIndices,1);

CityInboundIndex = logical((SpikeData_info(:,4)==2).* (SpikeData_info(:,5)>10).*(SpikeData_info(:,13)==0));
CityInboundIndices = find(CityInboundIndex==1);
CityInboundSpikePosition = SpikeData_info(CityInboundIndices,2);
CityInboundSpikeTime = SpikeData_info(CityInboundIndices,1);

CityInboundBehaviorIndex = logical((TickLog_sync_recording_info(:,4)==2) .* (TickLog_sync_recording_info(:,5)>10).* (TickLog_sync_recording_info(:,13)==0));
CityInboundBehaviorIndices = find(CityInboundBehaviorIndex==1);
CityInboundBehaviorPosition = TickLog_sync_recording_info(CityInboundBehaviorIndices,2);
CityInboundBehaviorTime = TickLog_sync_recording_info(CityInboundBehaviorIndices,1);


CityIndices = vertcat(CityOutboundIndices, CityInboundIndices);
CitySpikePosition = vertcat(CityOutboundSpikePosition, 20400-CityInboundSpikePosition);
CitySpikeTime = vertcat(CityOutboundSpikeTime, CityInboundSpikeTime);
CitySpikeInfo = sortrows(horzcat(CityIndices, CitySpikePosition, CitySpikeTime));
% CitySpikeInfo(find(CitySpikeInfo(:,2)==10900),:) = [];

CityBehaviorIndices = vertcat(CityOutboundBehaviorIndices, CityInboundBehaviorIndices);
CityBehaviorPosition = vertcat(CityOutboundBehaviorPosition, 20400-CityInboundBehaviorPosition);
CityBehaviorTime = vertcat(CityOutboundBehaviorTime, CityInboundBehaviorTime);
CityBehaviorInfo = sortrows(horzcat(CityBehaviorIndices, CityBehaviorPosition, CityBehaviorTime));
% CityBehaviorInfo(find(CityBehaviorInfo(:,2)==10900),:) = [];

CitySpikeTimeT = (((CitySpikeInfo(:,3)-min(TickLog_sync_recording(:,1))))./1000000);
CityBehaviorTimeT = (((CityBehaviorInfo(:,3)-min(TickLog_sync_recording(:,1))))./1000000);

%% Binning
Bins = 82;
BinSize = 250;

ForestBin = cell(1,Bins);
CityBin = cell(1,Bins);


for h=1:Bins
    if length(find((ForestBehaviorPosition< BinSize*h) == (ForestBehaviorPosition > (BinSize*(h-1))))) >0
   ForestBin{1,h} = ((((length(find((ForestSpikeInfo(:,2)< BinSize*h) == (ForestSpikeInfo(:,2) > (BinSize*(h-1))))))))./ (((length(find((ForestBehaviorPosition< BinSize*h) == (ForestBehaviorPosition > (BinSize*(h-1)))))))*(1/30)));
    else
        ForestBin{1,h} = 0;
    end
        
    if length(find((CityBehaviorPosition< BinSize*h) == (CityBehaviorPosition > (BinSize*(h-1))))) >0
   CityBin{1,h} = ((((length(find((CitySpikeInfo(:,2)< BinSize*h) == (CitySpikeInfo(:,2) > (BinSize*(h-1))))))))./ (((length(find((CityBehaviorPosition< BinSize*h) == (CityBehaviorPosition > (BinSize*(h-1)))))))*(1/30)));
    else
        CityBin{1,h} = 0;
    end
end

ForestArray= cell2mat(ForestBin);
CityArray= cell2mat(CityBin);
%% Plot raw spike map (overall)

subplot('Position',Coordinate_RawData)
set(gcf,'renderer','Painters')
plot((ForestBehaviorInfo(:,2)),(ForestBehaviorTimeT),'MarkerSize',0.1,'Marker','.','LineWidth',2,'LineStyle','none',...
    'Color',[0.501960813999176 0.501960813999176 0.501960813999176]);
set(gca,'YDir','reverse');
xlabel('Position (cm)','FontSize',10);
ylabel('Time (s)','FontSize',10);
hold on
plot((ForestSpikeInfo(:,2)),(ForestSpikeTimeT), 'MarkerSize',5,'Marker','.','LineWidth',2,'LineStyle','none',...
    'Color','r');
set(gca,'YDir','reverse');
axis([0 max((ForestBehaviorInfo(:,2))) 0 max(ForestSpikeTimeT)]);

hold on

plot((CityBehaviorInfo(:,2)),(CityBehaviorTimeT),'MarkerSize',0.1,'Marker','.','LineWidth',2,'LineStyle','none',...
    'Color',[0.501960813999176 0.501960813999176 0.501960813999176]);
xlabel('Position (cm)','FontSize',10);
ylabel('Time (s)','FontSize',10);
hold on
plot((CitySpikeInfo(:,2)),(CitySpikeTimeT), 'MarkerSize',5,'Marker','.','LineWidth',2,'LineStyle','none',...
    'Color','b');
set(gca,'YDir','reverse');
axis([0 max(max(CityBehaviorInfo(:,2)), max(ForestBehaviorInfo(:,2))) 0 max(max(CitySpikeTimeT), max(ForestSpikeTimeT))]);
title({'Raw spike map Forest: red, City: blue)'},'FontWeight','bold');

%% Plot forest & City raw spike map
% subplot('Position',Coordinate_RawData_Forest)
% set(gcf,'renderer','Painters')
% plot((ForestBehaviorInfo(:,2)),(ForestBehaviorTimeT),'MarkerSize',0.1,'Marker','.','LineWidth',2,'LineStyle','none',...
%     'Color',[0.501960813999176 0.501960813999176 0.501960813999176]);
% set(gca,'YDir','reverse');
% xlabel('Position (cm)','FontSize',10);
% ylabel('Time (s)','FontSize',10);
% hold on
% plot((ForestSpikeInfo(:,2)),(ForestSpikeTimeT), 'MarkerSize',5,'Marker','.','LineWidth',2,'LineStyle','none',...
%     'Color',[1 0 0]);
% set(gca,'YDir','reverse');
% axis([0 max((ForestBehaviorInfo(:,2))) 0 max(ForestSpikeTimeT)]);
% title({'Raw spike map (Forest)'},'FontWeight','bold');
% 
% line([1110 1110], get(gca,'YLim'),'color','b')
% line([3110 3110], get(gca,'YLim'),'color','b')
% line([5110 5110], get(gca,'YLim'),'color','b')
% line([7110 7110], get(gca,'YLim'),'color','b')
% line([11500 11500], get(gca,'YLim'),'color','b')
% line([13500 13500], get(gca,'YLim'),'color','b')
% line([15500 15500], get(gca,'YLim'),'color','b')
% line([17500 17500], get(gca,'YLim'),'color','b')
% line([9700 9700], get(gca,'YLim'),'color','k')
% line([10700 10700], get(gca,'YLim'),'color','k')
% 
% subplot('Position',Coordinate_RawData_City)
% set(gcf,'renderer','Painters')
% plot((CityBehaviorInfo(:,2)),(CityBehaviorTimeT),'MarkerSize',0.1,'Marker','.','LineWidth',2,'LineStyle','none',...
%     'Color',[0.501960813999176 0.501960813999176 0.501960813999176]);
% set(gca,'YDir','reverse');
% xlabel('Position (cm)','FontSize',10);
% ylabel('Time (s)','FontSize',10);
% hold on
% plot((CitySpikeInfo(:,2)),(CitySpikeTimeT), 'MarkerSize',5,'Marker','.','LineWidth',2,'LineStyle','none',...
%     'Color',[1 0 0]);
% set(gca,'YDir','reverse');
% axis([0 max((CityBehaviorInfo(:,2))) 0 max(CitySpikeTimeT)]);
% title({'Raw spike map (City)'},'FontWeight','bold');
% 
% line([1110 1110], get(gca,'YLim'),'color','b')
% line([3110 3110], get(gca,'YLim'),'color','b')
% line([5110 5110], get(gca,'YLim'),'color','b')
% line([7110 7110], get(gca,'YLim'),'color','b')
% line([11500 11500], get(gca,'YLim'),'color','b')
% line([13500 13500], get(gca,'YLim'),'color','b')
% line([15500 15500], get(gca,'YLim'),'color','b')
% line([17500 17500], get(gca,'YLim'),'color','b')
% line([9700 9700], get(gca,'YLim'),'color','k')
% line([10700 10700], get(gca,'YLim'),'color','k')


%% Plot forest & city binning
subplot('Position',Coordinate_Binning_Forest)
s = stem(ForestArray,'DisplayName','Forest','Marker','none','LineWidth',3, 'color','r');
hold on
xlabel(['Bin (1 bin = ' num2str(BinSize) 'cm)'],'FontSize',10);
title({'Linearized firing rate on track (Forest)'},'FontWeight','bold');
ylabel('Firing rate (Hz)','FontSize',10);
Range = max(max(ForestArray), max(CityArray));
axis([0 Bins 0 Range*1.2]);
hold on
line([1110/BinSize 1110/BinSize], [0 Range*1.2],'color','k')
line([3110/BinSize 3110/BinSize], [0 Range*1.2],'color','k')
line([5110/BinSize 5110/BinSize], [0 Range*1.2],'color','k')
line([7110/BinSize 7110/BinSize], [0 Range*1.2],'color','k')
line([11500/BinSize 11500/BinSize], [0 Range*1.2],'color','k')
line([13500/BinSize 13500/BinSize], [0 Range*1.2],'color','k')
line([15500/BinSize 15500/BinSize], [0 Range*1.2],'color','k')
line([17500/BinSize 17500/BinSize], [0 Range*1.2],'color','k')
line([9700/BinSize 9700/BinSize], [0 Range*1.2],'color','k')
line([10700/BinSize 10700/BinSize], [0 Range*1.2],'color','k')


subplot('Position',Coordinate_Binning_City)
stem(CityArray,'DisplayName','City','Marker','none','LineWidth',3, 'color', 'b');
hold on
xlabel(['Bin (1 bin = ' num2str(BinSize) 'cm)'],'FontSize',10);
title({'Linearized firing rate on track (City)'},'FontWeight','bold');
ylabel('Firing rate (Hz)','FontSize',10);
axis([0 Bins 0 Range*1.2]);

line([1110/BinSize 1110/BinSize], [0 Range*1.2],'color','k')
line([3110/BinSize 3110/BinSize], [0 Range*1.2],'color','k')
line([5110/BinSize 5110/BinSize], [0 Range*1.2],'color','k')
line([7110/BinSize 7110/BinSize], [0 Range*1.2],'color','k')
line([11500/BinSize 11500/BinSize], [0 Range*1.2],'color','k')
line([13500/BinSize 13500/BinSize], [0 Range*1.2],'color','k')
line([15500/BinSize 15500/BinSize], [0 Range*1.2],'color','k')
line([17500/BinSize 17500/BinSize], [0 Range*1.2],'color','k')
line([9700/BinSize 9700/BinSize], [0 Range*1.2],'color','k')
line([10700/BinSize 10700/BinSize], [0 Range*1.2],'color','k')



for j = 1 : 1000/10
    section = [1 100] + 10 * (j-1);
    Duration(j) = length(find(PositionX >= section(1) & PositionX < section(2)));
end
Duration_norm = Duration / size(PositionX,1);
%% For VR ratemap construction

XsizeOfVideo = 19840;
    YsizeOfVideo = 2480;
samplingRate = 30;
scaleForRateMap = 318.9;

binXForRateMap = 64;
binYForRateMap = 8;

% Forest

SpikePositionY = ones(length(ForestSpikeInfo(:,2)),1);
FilteredPositionY = ones(length(ForestBehaviorInfo(:,2)), 1);

[ForestoccMat, spkMat, rawMat, ForestskaggsrateMat] = abmFiringRateMap( ...
    [ForestSpikeInfo(:,3), ForestSpikeInfo(:,2), SpikePositionY],...
    [ForestBehaviorInfo(:,3), ForestBehaviorInfo(:,2), FilteredPositionY],...
    binYForRateMap, binXForRateMap, scaleForRateMap, samplingRate);
ForestSpaInfoScore = GetSpaInfo(ForestoccMat, ForestskaggsrateMat);
ForestMaxFR = nanmax(nanmax(ForestskaggsrateMat));
ForestAvgFR = nanmean(nanmean(ForestskaggsrateMat));
ForestnumOfSpk = length(ForestSpikeInfo(:,3));
ForestskaggsrateMat(1,:) = fillmissing(ForestskaggsrateMat(1,:),'constant',0) ;

% City

SpikePositionY = ones(length(CitySpikeInfo(:,2)),1);
FilteredPositionY = ones(length(CityBehaviorInfo(:,2)), 1);

[CityoccMat, spkMat, rawMat, CityskaggsrateMat] = abmFiringRateMap( ...
    [CitySpikeInfo(:,3), CitySpikeInfo(:,2), SpikePositionY],...
    [CityBehaviorInfo(:,3), CityBehaviorInfo(:,2), FilteredPositionY],...
    binYForRateMap, binXForRateMap, scaleForRateMap, samplingRate);
CitySpaInfoScore = GetSpaInfo(CityoccMat, CityskaggsrateMat);
CityMaxFR = nanmax(nanmax(CityskaggsrateMat));
CityAvgFR = nanmean(nanmean(CityskaggsrateMat));
CitynumOfSpk = length(CitySpikeInfo(:,3));
CityskaggsrateMat(1,:) = fillmissing(CityskaggsrateMat(1,:),'constant',0) ;

Range = max( [ForestMaxFR CityMaxFR] ) * 1.1;   


%% Plot Ratemap_overall

subplot('Position',Coordinate_ColorMap)

SkaggsrateMat(1:4,:) = ForestskaggsrateMat(1:4,:);
SkaggsrateMat(5:8,:) = CityskaggsrateMat(1:4, :);

imagesc((SkaggsrateMat));
colormap(jet);
thisAlphaZ = SkaggsrateMat;
thisAlphaZ(isnan(SkaggsrateMat)) = 0;
thisAlphaZ(~isnan(SkaggsrateMat)) = 1;
hold on

alpha(thisAlphaZ);axis off;
j=1;
minmaxColor = get(gca, 'CLim');
if minmaxColor(1) == -1 && minmaxColor(2) == 1
    minmaxColor(2)=0.1;
end

maxColor(j) = minmaxColor(2);
j=j+1;
text(0,3,sprintf(['          Max frequency = ' num2str(ForestMaxFR) '(Hz)'], 'fontsize',10));
text(0,2,sprintf(['Forest: Spatial information = ' num2str(ForestSpaInfoScore)],'fontsize',10));
text(0,4,sprintf(['          Average frequency =' num2str(ForestAvgFR) '(Hz)'], 'fontsize', 10));

text(0,7,sprintf(['        Max frequency = ' num2str(CityMaxFR) '(Hz)'], 'fontsize',10));
text(0,6,sprintf(['City: Spatial information = ' num2str(CitySpaInfoScore)],'fontsize',10));
text(0,8,sprintf(['        Average frequency =' num2str(CityAvgFR) '(Hz)'], 'fontsize', 10));

colorbar('westoutside');
hold on
MAXcolor=max(maxColor);
if MAXcolor<1
    MAXcolor=1;
end
set(gca,'CLim', [0 maxColor(1)]);
caxis([0 Range])

%% Plot Ratemap 
% 
% subplot('Position',Coordinate_ColorMap_Forest)
% ForestskaggsrateMat = ForestskaggsrateMat(1:4,:);
% imagesc((ForestskaggsrateMat));
% colormap(jet);
% thisAlphaZ = ForestskaggsrateMat;
% thisAlphaZ(isnan(ForestskaggsrateMat)) = 0;
% thisAlphaZ(~isnan(ForestskaggsrateMat)) = 1;
% hold on
% 
% alpha(thisAlphaZ);axis off;
% j=1;
% minmaxColor = get(gca, 'CLim');
% if minmaxColor(1) == -1 && minmaxColor(2) == 1
%     minmaxColor(2)=0.1;
% end
% 
% maxColor(j) = minmaxColor(2);
% j=j+1;
% text(0,3,sprintf(['Max frequency = ' num2str(ForestMaxFR) '(Hz)'], 'fontsize',10));
% text(0,2,sprintf(['Spatial information = ' num2str(ForestSpaInfoScore)],'fontsize',10));
% text(0,4,sprintf(['Average frequency =' num2str(ForestAvgFR) '(Hz)'], 'fontsize', 10));
% colorbar('westoutside');
% 
% hold on
% MAXcolor=max(maxColor);
% if MAXcolor<1
%     MAXcolor=1;
% end
% set(gca,'CLim', [0 maxColor(1)]);
% caxis([0 Range])
% 
% subplot('Position',Coordinate_ColorMap_City)
% CityskaggsrateMat = CityskaggsrateMat(1:4, :);
% imagesc((CityskaggsrateMat));
% colormap(jet);
% thisAlphaZ = CityskaggsrateMat;
% thisAlphaZ(isnan(CityskaggsrateMat)) = 0;
% thisAlphaZ(~isnan(CityskaggsrateMat)) = 1;
% hold on
% 
% alpha(thisAlphaZ);axis off;
% j=1;
% minmaxColor = get(gca, 'CLim');
% if minmaxColor(1) == -1 && minmaxColor(2) == 1
%     minmaxColor(2)=0.1;
% end
% 
% maxColor(j) = minmaxColor(2);
% j=j+1;
% text(0,3,sprintf(['Max frequency = ' num2str(CityMaxFR) '(Hz)'], 'fontsize',10));
% text(0,2,sprintf(['Spatial information = ' num2str(CitySpaInfoScore)],'fontsize',10));
% text(0,4,sprintf(['Average frequency =' num2str(CityAvgFR) '(Hz)'], 'fontsize', 10));
% colorbar('south');
% hold on
% MAXcolor=max(maxColor);
% if MAXcolor<1
%     MAXcolor=1;
% end
% set(gca,'CLim', [0 maxColor(1)]);
% caxis([0 Range])