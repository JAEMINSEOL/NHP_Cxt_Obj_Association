clc;
clear all;
close all;

% File directory

filename = 'C:\Users\사용자\Desktop\SampleData\Events.csv';
delimiter = ',';
formatSpec = '%*s%*s%*s%f%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%s%[^\n\r]';
fileID = fopen(filename,'r');

dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN, 'ReturnOnError', false);

fclose(fileID);

Timestamp = dataArray{:, 1};
Event = dataArray{:, 2};

clearvars filename delimiter formatSpec fileID dataArray ans;



str1 = 'TTL Input on AcqSystem1_0 board 0 port 2 value (0x0010).';
str2 = 'TTL Input on AcqSystem1_0 board 0 port 2 value (0x0040).';
str3 = 'TTL Input on AcqSystem1_0 board 0 port 3 value (0x0004).';
str4 = 'TTL Input on AcqSystem1_0 board 0 port 3 value (0x0008).';
str5 = 'TTL Input on AcqSystem1_0 board 0 port 2 value (0x0050).';

TTL1 = find(strcmp(Event, str1));
TTL2 = find(strcmp(Event, str2));
TTL3 = find(strcmp(Event, str3));
TTL4 = find(strcmp(Event, str4));
TTL5 = find(strcmp(Event, str5));


TTL1Time = Timestamp(TTL1);
TTL2Time = Timestamp(TTL2);
TTL3Time = Timestamp(TTL3);
TTL4Time = Timestamp(TTL4);
TTL5Time = Timestamp(TTL5); 

 
for i=1:length(TTL1Time)-1;
 latency(i) = TTL1Time(i+1)-TTL1Time(i);
end





%Importing behavior data

filename = 'C:\Users\사용자\Desktop\Data\r578\Behavior\Snow\2019.01.23-15.24.35.247Time_Data.csv';
delimiter = ',';
formatSpec = '%s%f%*s%f%[^\n\r]';
fileID = fopen(filename,'r');

dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN, 'ReturnOnError', false);

fclose(fileID);

X = dataArray{:, 1};
Time = dataArray{:, 2};
Position = dataArray{:, 3};
RewardEvent = 'Reward';
Position([1:end])=((Position(1:end))./20);

clearvars filename delimiter formatSpec fileID dataArray ans;

Position(Position<0) = 0;
Filtered = ~isnan(Position);
FilteredPositionIndex = find(Filtered==1);
FilteredTime = Time(FilteredPositionIndex);
FilteredPosition = Position(FilteredPositionIndex);

RewardedIndex = find(strcmp(X, RewardEvent));
RewardTime = Time(RewardedIndex+1); 
RewardPosition = Position(RewardedIndex+1);


for n=1:(length(FilteredPosition)-1)

Teleport(n) = (FilteredPosition(n)-FilteredPosition(n+1))>50;
Reset(n+1) = (FilteredPosition(n)-FilteredPosition(n+1))>25;

end


for n=1:(length(FilteredPosition)-1)

ReForest(n) = (FilteredPosition(n+1)-FilteredPosition(n))>95;
ReCity(n) = ((FilteredPosition(n+1)-FilteredPosition(n)) >4) && ((FilteredPosition(n+1)-FilteredPosition(n)) < 10) ;

end


Cycle= find(Teleport==1);
ResetIndices = find(Reset==1);
CycleTime=Time(Cycle); 
ReForest = find(ReForest==1);
ReCity = find(ReCity==1);


for i=1:length(FilteredTime)-1
 FilterdTimelatency(i) = FilteredTime(i+1)-FilteredTime(i);
end

EventArray = [TTL1Time, FilteredPosition]; 
TTL1TimeT = (((TTL1Time-min(TTL1Time)))./1000000);
% 
for n=1:length(CycleTime-1)
CycleLantency(n)= CycleTime(n+1)-CycleTime(n);
end

% Importing spike data

filename = 'F:\NHP project\Data\Nabi\processed_data\2019-11-18_10-53-46\nabi_20191118_strict.1';
delimiter = ',';
startRow = 14;
formatSpec = '%f%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fileID);
SpikeIndex = dataArray{:, 1};
SpikeTime = dataArray{:, 2};

clearvars filename delimiter startRow formatSpec fileID dataArray ans;

SpikePosition = interp1(TTL1Time, FilteredPosition, SpikeTime, 'nearest');
SpikeTimeT = (((SpikeTime-min(TTL1Time)))./1000000);
Frequency = length(SpikeTime)/max(TTL1TimeT);
SpikeData = [SpikeTime, SpikePosition];

% Defining by Context 

ForestIndex = (SpikePosition<500);
ForestIndices = find(ForestIndex==1);
ForestSpikePosition = SpikePosition(ForestIndices);
ForestSpikeTime = SpikeTime(ForestIndices);

CityIndex = (SpikePosition>500 & SpikePosition<1000);
CityIndices = find(CityIndex==1);
CitySpikePosition = SpikePosition(CityIndices);
CitySpikeTime = SpikeTime(CityIndices);

ForestBehaviorIndex = (FilteredPosition<500);
ForestBehaviorIndices = find(ForestBehaviorIndex==1);
ForestBehaviorPosition = FilteredPosition(ForestBehaviorIndices);
ForestBehaviorTime = FilteredTime(ForestBehaviorIndex);

CityBehaviorIndex = (FilteredPosition>500 & FilteredPosition<1000);
CityBehaviorIndices = find(CityBehaviorIndex==1);
CityBehaviorPosition = FilteredPosition(CityBehaviorIndices);
CityBehaviorTime = FilteredTime(CityBehaviorIndices);

%Binning 

ForestBin = cell(1,40);
CityBin = cell(1,40);

for h=1:40
    
    ForestBin{1,h} = ((((length(find((ForestSpikePosition< 25*h) == (ForestSpikePosition > (25*(h-1))))))))./ (((length(find((ForestBehaviorPosition< 25*h) == (ForestBehaviorPosition > (25*(h-1)))))))*(1/25)));
    CityBin{1, h} = ((((length(find((CitySpikePosition< 25*h) == (CitySpikePosition > (25*(h-1))))))))./ (((length(find((CityBehaviorPosition< 25*h) == (CityBehaviorPosition > (25*(h-1)))))))*(1/25)));
    
end

ForestArray = cell2mat(ForestBin);
CityArray= cell2mat(CityBin);


figure(1);
subplot(2,2,1)
set(gcf,'renderer','Painters')
plot((FilteredPosition./5*3),(FilteredTime),'MarkerSize',0.1,'Marker','.','LineWidth',2,'LineStyle','none',...
    'Color',[0.501960813999176 0.501960813999176 0.501960813999176]);
set(gca,'YDir','reverse');

xlabel('Position (cm)','FontWeight','bold','FontSize',14);
ylabel('Time (s)','FontWeight','bold','FontSize',14);

hold on 


plot((SpikePosition./5*3),(SpikeTimeT), 'MarkerSize',5,'Marker','.','LineWidth',2,'LineStyle','none',...
    'Color',[1 0 0]);

set(gca,'YDir','reverse');
axis([0 600 0 850]);
title({'Raw spike map'},'FontWeight','bold');

hold on 

% plot((RewardPosition./5*3),(RewardTime), 'Marker','square','LineWidth',1,'LineStyle','none', 'Color',[0 0.447058826684952 0.74117648601532])


subplot(2,2,3)


stem(ForestArray,'DisplayName','Forest','Marker','none','LineWidth',3);

hold on

stem(CityArray,'DisplayName','Forest','Marker','none','LineWidth',3);

xlabel('Bin (1 bin = 15cm)','FontWeight','bold','FontSize',14);
title({'Linearized firing rate on track'},'FontWeight','bold');
ylabel('Firing rate (Hz)','FontWeight','bold','FontSize',14);

%
for j = 1 : 1000/10
    section = [1 100] + 10 * (j-1);
    Duration(j) = length(find(Position >= section(1) & Position < section(2)));     
end
Duration_norm = Duration / size(Position,1);

%% For VR ratemap construction

    XsizeOfVideo = 640;
    YsizeOfVideo = 160;
    samplingRate = 30;
    scaleForRateMap = 10;
    
    binXForRateMap = XsizeOfVideo / scaleForRateMap;
    binYForRateMap = YsizeOfVideo / scaleForRateMap;
    
% Forest    
    
    SpikePositionY = ones(length(ForestSpikePosition),1);
    FilteredPositionY = ones(length(ForestBehaviorPosition), 1);
    
        [ForestoccMat, spkMat, rawMat, ForestskaggsrateMat] = abmFiringRateMap( ...
            [ForestSpikeTime, ForestSpikePosition, SpikePositionY],...
            [ForestBehaviorTime, ForestBehaviorPosition, FilteredPositionY],...
        binYForRateMap, binXForRateMap, scaleForRateMap, samplingRate);
        ForestSpaInfoScore = GetSpaInfo(ForestoccMat, ForestskaggsrateMat);
        ForestMaxFR = nanmax(nanmax(ForestskaggsrateMat));
        ForestAvgFR = nanmean(nanmean(ForestskaggsrateMat));
        ForestnumOfSpk = length(ForestSpikeTime);
    
            
% City  
CitySpikePosition = (CitySpikePosition - 500);
CityBehaviorPosition = (CityBehaviorPosition - 500);


      SpikePositionY = ones(length(CitySpikePosition),1);
        FilteredPositionY = ones(length(CityBehaviorPosition), 1);

    
        [CityoccMat, spkMat, rawMat, CityskaggsrateMat] = abmFiringRateMap( ...
            [CitySpikeTime, CitySpikePosition, SpikePositionY],...
            [CityBehaviorTime, CityBehaviorPosition, FilteredPositionY],...
        binYForRateMap, binXForRateMap, scaleForRateMap, samplingRate);
        CitySpaInfoScore = GetSpaInfo(CityoccMat, CityskaggsrateMat);
        CityMaxFR = nanmax(nanmax(CityskaggsrateMat));
        CityAvgFR = nanmean(nanmean(CityskaggsrateMat));
        CitynumOfSpk = length(CitySpikeTime);  
        
     Range = max( [ForestMaxFR CityMaxFR] ) * 1.1;    
        
        R = corrcoef(ForestskaggsrateMat(1,1:50), CityskaggsrateMat(1,1:50));
R = R(2);
        
        subplot(2,2,2)
  
        
    imagesc((ForestskaggsrateMat));
    colormap(jet);
    thisAlphaZ = ForestskaggsrateMat;
    thisAlphaZ(isnan(ForestskaggsrateMat)) = 0;
    thisAlphaZ(~isnan(ForestskaggsrateMat)) = 1;
    hold on
    
       alpha(thisAlphaZ);axis off;
      j=1;
    minmaxColor = get(gca, 'CLim');
    if minmaxColor(1) == -1 && minmaxColor(2) == 1
        minmaxColor(2)=0.1;
    end
    
    maxColor(j) = minmaxColor(2);
    j=j+1;
   text(0,13,sprintf(['Max frequency = ' num2str(ForestMaxFR) '(Hz)'], 'fontsize',10));
   text(0,7,sprintf(['Spatial information = ' num2str(ForestSpaInfoScore)],'fontsize',10));
   text(0,10,sprintf(['Average frequency =' num2str(ForestAvgFR) '(Hz)'], 'fontsize', 10));
   title({'Forest'},'FontWeight','bold');
   colorbar;   
   
   hold on
    
    MAXcolor=max(maxColor);
    if MAXcolor<1
        MAXcolor=1;
    end
    
set(gca,'CLim', [0 maxColor(1)]);    
    caxis([0 Range])

subplot(2,2,4)

        
    imagesc((CityskaggsrateMat));
    colormap(jet);
    thisAlphaZ = CityskaggsrateMat;
    thisAlphaZ(isnan(CityskaggsrateMat)) = 0;
    thisAlphaZ(~isnan(CityskaggsrateMat)) = 1;
    hold on
    
       alpha(thisAlphaZ);axis off;
      j=1;
    minmaxColor = get(gca, 'CLim');
    if minmaxColor(1) == -1 && minmaxColor(2) == 1
        minmaxColor(2)=0.1;
    end
    maxColor(j) = minmaxColor(2);
    j=j+1;
   text(0,13,sprintf(['Max frequency = ' num2str(CityMaxFR) '(Hz)'], 'fontsize',10));
   text(0,7,sprintf(['Spatial information = ' num2str(CitySpaInfoScore)],'fontsize',10));
   text(0,10,sprintf(['Average frequency =' num2str(CityAvgFR) '(Hz)'], 'fontsize', 10));
   title({'City'},'FontWeight','bold');
   colorbar;   
   
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


% figure(3);
% 
% subplot(1,2,1);
% 
%     imagesc((ForestskaggsrateMat));
%     colormap(jet);
%     thisAlphaZ = ForestskaggsrateMat;
%     thisAlphaZ(isnan(ForestskaggsrateMat)) = 0;
%     thisAlphaZ(~isnan(ForestskaggsrateMat)) = 1;
%     hold on
%     
%        alpha(thisAlphaZ);axis off;
%       j=1;
%     minmaxColor = get(gca, 'CLim');
%     if minmaxColor(1) == -1 && minmaxColor(2) == 1
%         minmaxColor(2)=0.1;
%     end
%     
%     maxColor(j) = minmaxColor(2);
%     j=j+1;
% 
%    hold on
%     
%     MAXcolor=max(maxColor);
%     if MAXcolor<1
%         MAXcolor=1;
%     end
%     
% set(gca,'CLim', [0 maxColor(1)]);   
%     caxis([0 Range])
%     

% subplot(1,2,2);
% 
%     imagesc((CityskaggsrateMat));
%     colormap(jet);
%     thisAlphaZ = CityskaggsrateMat;
%     thisAlphaZ(isnan(CityskaggsrateMat)) = 0;
%     thisAlphaZ(~isnan(CityskaggsrateMat)) = 1;
%     hold on
%     
%        alpha(thisAlphaZ);axis off;
%       j=1;
%     minmaxColor = get(gca, 'CLim');
%     if minmaxColor(1) == -1 && minmaxColor(2) == 1
%         minmaxColor(2)=0.1;
%     end
%     
%     maxColor(j) = minmaxColor(2);
%     j=j+1;
% 
%    hold on
%     
%     MAXcolor=max(maxColor);
%     if MAXcolor<1
%         MAXcolor=1;
%     end
%     
% set(gca,'CLim', [0 maxColor(1)]);   
%     caxis([0 Range])
%     
%      text(0,3,sprintf([' r = ' num2str(R) '(Hz)'], 'fontsize',12));
%      



% figure(3);
% set(gcf,'renderer','Painters')
% plot((FilteredPosition./5*3),(FilteredTime),'MarkerSize',0.1,'Marker','.','LineWidth',2,'LineStyle','none',...
%     'Color',[0.501960813999176 0.501960813999176 0.501960813999176]);
% set(gca,'YDir','reverse');
% 
% xlabel('Position (cm)','FontWeight','bold','FontSize',14);
% ylabel('Time (s)','FontWeight','bold','FontSize',14);
% 
% hold on 
% 
% 
% plot((SpikePosition./5*3),(SpikeTimeT), 'MarkerSize',5,'Marker','.','LineWidth',2,'LineStyle','none',...
%     'Color',[1 0 0]);
% 
% set(gca,'YDir','reverse');
% axis([0 300 0 1950]);
% title({'Raw spike map'},'FontWeight','bold');
% 
% hold on 
% 
% % plot((RewardPosition./5*3),(RewardTime), 'Marker','square','LineWidth',1,'LineStyle','none', 'Color',[0 0.447058826684952 0.74117648601532])

