%% Load last updated Session Summary.mat
clear all
close all
%%
SessionSummary_Sample = SessionSummary_6;
Sample_day = SessionSummary_Sample(:,:,end);
%%
mother_drive = 'F:\NHP project\Data\';
animal_id=input('Nabi or Yoda?','s');
SessionName=input('Session Name?','s');
cd([mother_drive animal_id '\processed_data'])

if ~exist(['SessionSummary_' SessionName '.mat'])
    SessionSummary = [];
else
    load(['SessionSummary_' SessionName '.mat']);
end	% ~exist('SessionSummary.mat')

date_Analysis=input('Analysis date(YYYYMMDD)? ::','s');

cd([mother_drive animal_id '\processed_data\behavior'])
mkdir(date_Analysis)
% cd([mother_drive animal_id '\processed_data\behavior\' date_Analysis])
cd([mother_drive animal_id '\processed_data\behavior\' date_Analysis])
program_folder= [mother_drive '\program'];

addpath(genpath(program_folder))


cd(program_folder)
%%
%  load(['SessionSummary_2_3.mat']);
%  SessionSummary_2_3 = SessionSummary;
% Sample_2_3 = SessionSummary_2_3(:,:,1);
% 
% SessionSummary(end+1:3500,:,:) = nan;
%%
SessionSummary_all = cat(3,SessionSummary_2_1,SessionSummary_2_2);
SessionSummary = SessionSummary_all;
Sample = SessionSummary(:,:,end);
cd([mother_drive animal_id '\processed_data'])
%% Context
clear MeanAcc MedianLatency VoidProportion MaxLap
for k=1:size(SessionSummary_all,3)
    for c = 1:2
        
    MeanAcc(k,c) = nanmean(SessionSummary(find(SessionSummary(:,3,k)==c),9,k));
    MedianLatency(k,c) = nanmedian(SessionSummary(find(SessionSummary(:,3,k)==c),11,k));
    if ~isempty(SessionSummary(find(SessionSummary(:,3,k)==c),1,k))
    MaxLap(k,c) = max(SessionSummary(find(SessionSummary(:,3,k)==c),1,k));
    end
    VoidProportion(k,c) = nanmean(SessionSummary(find(SessionSummary(:,3,k)==c),10,k));
    end
end
%%
nSession = size(SessionSummary,3);
x = 1:nSession; 

figure;
y=MedianLatency(:,1); cf = [213 17 87]/255; ce = [213 17 87]/255;
DrawHistoryScatterAndLine(x,y,cf,ce)

y=MedianLatency(:,2); cf = [64 111 223]/255; ce = [64 111 223]/255;
DrawHistoryScatterAndLine(x,y,cf,ce)

figure;
y=MedianLatency(:,1); cf = 'k'; ce = 'k';
DrawHistoryScatterAndLine(x,y,cf,ce)
figure;
y=MedianLatency(:,2); 
DrawHistoryScatterAndLine(x,y,cf,ce)

title([animal_id ' Mean Accuracy (Cxt-Obj Association, All Sessions)'],'FontSize',20)
% 
% saveas(gcf,[animal_id '_Mean Acc_all_cxts.jpg'])
%% Target/Lure Object
clear MeanAcc MedianLatency VoidProportion
SessionSummary = SessionSummary_all;
for k=1:size(SessionSummary,3)
    for o = 0:5
        
    MeanAcc(k,o+1) = nanmean(SessionSummary(find(or(SessionSummary(:,7,k)==o,SessionSummary(:,6,k)==o)),9,k));
    MedianLatency(k,o+1) = nanmedian(SessionSummary(find(or(SessionSummary(:,7,k)==o,SessionSummary(:,6,k)==o)),11,k));
    if ~isempty(SessionSummary(find(or(SessionSummary(:,7,k)==o,SessionSummary(:,6,k)==o)),1,k))
    MaxLap(k,o+1) = max(SessionSummary(find(or(SessionSummary(:,7,k)==o,SessionSummary(:,6,k)==o)),1,k));
    end
    VoidProportion(k,o+1) = nanmean(SessionSummary(find(or(SessionSummary(:,7,k)==o,SessionSummary(:,6,k)==o)),10,k));
    end
end

%% Target Object
clear MeanAcc MedianLatency VoidProportion
SessionSummary = SessionSummary_all;
for k=1:size(SessionSummary,3)
    for o = 0:5
        id = find(or(and(SessionSummary(:,7,k)==o,(mod(SessionSummary(:,7,k),2)==mod(SessionSummary(:,3,k),2))),...
            and(SessionSummary(:,6,k)==o,(mod(SessionSummary(:,6,k),2)==mod(SessionSummary(:,3,k),2)))));
        
        MeanAcc(k,o+1) = nanmean(SessionSummary(id,9,k));
        MedianLatency(k,o+1) = nanmedian(SessionSummary(id,11,k));
        if ~isempty(SessionSummary(id,1,k))
            MaxLap(k,o+1) = max(SessionSummary(id,1,k));
        end
        VoidProportion(k,o+1) = nanmean(SessionSummary(id,10,k));
    end
end
%%
nSession = size(SessionSummary,3);
x = 1:nSession; 

figure;
y=MeanAcc(:,2); cf = [218,85,15]/255; ce = [71 99 67]/255;
DrawHistoryScatterAndLine(x,y,cf,ce)

y=MeanAcc(:,1); cf = [255 209 108]/255; ce = [245,95,115]/255;
DrawHistoryScatterAndLine(x,y,cf,ce)

y=MeanAcc(:,4); cf = [21,130,249]/255; ce = [46 45 146]/255;
DrawHistoryScatterAndLine(x,y,cf,ce)

y=MeanAcc(:,3); cf = [44,132,149]/255; ce = [170 204 195]/255;
DrawHistoryScatterAndLine(x,y,cf,ce)
 
y=MeanAcc(:,6); cf = [246,180,91]/255; ce = [218 50 16]/255;
DrawHistoryScatterAndLine(x,y,cf,ce)

y=MeanAcc(:,5); cf = [244,100,63]/255; ce = [249 187 61]/255;
DrawHistoryScatterAndLine(x,y,cf,ce)

figure;
y=MeanAcc(:,1); cf = 'k'; ce = 'k';
DrawHistoryScatterAndLine(x,y,cf,ce)
figure;
y=MeanAcc(:,2); 
DrawHistoryScatterAndLine(x,y,cf,ce)
figure;
y=MeanAcc(:,3); 
DrawHistoryScatterAndLine(x,y,cf,ce)
figure;
y=MeanAcc(:,4); 
DrawHistoryScatterAndLine(x,y,cf,ce)
 figure;
y=MeanAcc(:,5); 
DrawHistoryScatterAndLine(x,y,cf,ce)
figure;
y=MeanAcc(:,6); 
DrawHistoryScatterAndLine(x,y,cf,ce)
% title([animal_id ' Mean Accuracy (Cxt-Obj Association, All Sessions)'],'FontSize',20)



% saveas(gcf,['Nabi Mean Acc_all_objs.jpg'])

%% Target/Lure Object Pair
clear MeanAcc MedianLatency VoidProportion
SessionSummary = SessionSummary_all;
for k=1:size(SessionSummary,3)
    for p = 1:3
        
    MeanAcc(k,p) = nanmean(SessionSummary(find(or(and(SessionSummary(:,7,k)<2*p,SessionSummary(:,7,k)>=2*(p-1)),and(SessionSummary(:,6,k)<2*p,SessionSummary(:,6,k)>=2*(p-1)))),9,k));
    MedianLatency(k,p) = nanmedian(SessionSummary(find(or(and(SessionSummary(:,7,k)<2*p,SessionSummary(:,7,k)>=2*(p-1)),and(SessionSummary(:,6,k)<2*p,SessionSummary(:,6,k)>=2*(p-1)))),11,k));
    if ~isempty(SessionSummary(find(or(and(SessionSummary(:,7,k)<2*p,SessionSummary(:,7,k)>=2*(p-1)),and(SessionSummary(:,6,k)<2*p,SessionSummary(:,6,k)>=2*(p-1)))),1,k))
    MaxLap(k,p) = max(SessionSummary(find(or(and(SessionSummary(:,7,k)<2*p,SessionSummary(:,7,k)>=2*(p-1)),and(SessionSummary(:,6,k)<2*p,SessionSummary(:,6,k)>=2*(p-1)))),1,k));
    end
    VoidProportion(k,p) = nanmean(SessionSummary(find(or(and(SessionSummary(:,7,k)<2*p,SessionSummary(:,7,k)>=2*(p-1)),and(SessionSummary(:,6,k)<2*p,SessionSummary(:,6,k)>=2*(p-1)))),10,k));
    end
end

%% Target Object Pair
clear MeanAcc MedianLatency VoidProportion
SessionSummary = SessionSummary_all;
for k=1:size(SessionSummary,3)
    for p = 1:3
        id = find(or(and(and(SessionSummary(:,7,k)<2*p,SessionSummary(:,7,k)>=2*(p-1)),(mod(SessionSummary(:,7,k),2)==mod(SessionSummary(:,3,k),2))),...
            and(and(SessionSummary(:,6,k)<2*p,SessionSummary(:,6,k)>=2*(p-1)),(mod(SessionSummary(:,6,k),2)==mod(SessionSummary(:,3,k),2)))));
        
        MeanAcc(k,p) = nanmean(SessionSummary(id,9,k));
        MedianLatency(k,p) = nanmedian(SessionSummary(id,11,k));
        if ~isempty(SessionSummary(id,1,k))
            MaxLap(k,p) = max(SessionSummary(id,1,k));
        end
        VoidProportion(k,p) = nanmean(SessionSummary(id,10,k));
    end
end

%% Target Familiar/Novel Object Pair
clear MeanAcc MedianLatency VoidProportion
SessionSummary = SessionSummary_all;
for k=1:size(SessionSummary,3)
    for p1 = 1:3
        for p2 = 1:3
            id = find(and(or(and(fix(SessionSummary(:,7,k)/2)==(p1-1),(mod(SessionSummary(:,7,k),2)==mod(SessionSummary(:,3,k),2))),...
                and(fix(SessionSummary(:,6,k)/2)==(p1-1),(mod(SessionSummary(:,6,k),2)==mod(SessionSummary(:,3,k),2)))),...
                or(fix(SessionSummary(:,7,k)/2)==(p2-1),fix(SessionSummary(:,6,k)/2)==(p2-1))));
            
            MeanAcc(k,p2,p1) = nanmean(SessionSummary(id,9,k));
            MedianLatency(k,p2,p1) = nanmedian(SessionSummary(id,11,k));
            if ~isempty(SessionSummary(id,1,k))
                MaxLap(k,p2,p1) = max(SessionSummary(id,1,k));
            end
            VoidProportion(k,p2,p1) = nanmean(SessionSummary(id,10,k));
        end
    end
end
%%
nSession = size(SessionSummary,3);
x = 1:nSession; 

% figure;
% y=MeanAcc(:,1); cf = 'r'; ce = 'r';
% DrawHistoryScatterAndLine(x,y,cf,ce)
% 
% y=MeanAcc(:,2); cf = 'b'; ce = 'b';
% DrawHistoryScatterAndLine(x,y,cf,ce)
% 
% y=MeanAcc(:,3); cf = 'k'; ce = 'k';
% DrawHistoryScatterAndLine(x,y,cf,ce)

% title([animal_id ' Mean Accuracy (Cxt-Obj Association, All Sessions)'],'FontSize',20)

for p1=1:3
    figure;
    y=MeanAcc(:,1,p1); cf = 'r'; ce = 'r';
    DrawHistoryScatterAndLine(x,y,cf,ce)
    
    y=MeanAcc(:,2,p1); cf = 'b'; ce = 'b';
    DrawHistoryScatterAndLine(x,y,cf,ce)
    
    y=MeanAcc(:,3,p1); cf = 'k'; ce = 'k';
    DrawHistoryScatterAndLine(x,y,cf,ce)

end

%% Location
clear MeanAcc MedianLatency VoidProportion
for k=1:size(SessionSummary_all,3)
    for c=1:2
    for l = 1:4
        id = find(and(SessionSummary(:,5,k)==l,SessionSummary(:,3,k)==c));
    MeanAcc(k,l,c) = nanmean(SessionSummary(id,9,k));
    MedianLatency(k,l,c) = nanmedian(SessionSummary(id,11,k));
    if ~isempty(SessionSummary(id,1,k))
    MaxLap(k,l,c) = max(SessionSummary(id,1,k));
    end
    VoidProportion(k,l,c) = nanmean(SessionSummary(id,10,k));
    end
    end
end
%%
nSession = size(SessionSummary,3);
x = 1:nSession; 

% figure;
% y=MeanAcc(:,1); cf = [213 17 87]/255; ce = [213 17 87]/255;
% DrawHistoryScatterAndLine(x,y,cf,ce)
% 
% y=MeanAcc(:,2); cf = [64 111 223]/255; ce = [64 111 223]/255;
% DrawHistoryScatterAndLine(x,y,cf,ce)
figure;
for l = 1:4
subplot(4,1,l)
y=MeanAcc(:,l,1); cf = 'r'; ce = 'r';
DrawHistoryScatterAndLine(x,y,cf,ce)
hold on
y=MeanAcc(:,l,2); cf = 'b'; ce = 'b';
DrawHistoryScatterAndLine(x,y,cf,ce)
end

% title([animal_id ' Mean Accuracy (Cxt-Obj Association, All Sessions)'],'FontSize',20)
% 
% saveas(gcf,[animal_id '_Mean Acc_all_cxts.jpg'])

%%

x = 1:nSession; F = MedianLatency(:,1); C = MedianLatency(:,2);
 figure; 
 
 plot(x,F,'LineWidth',1.5,'Color',[213 17 87]/255)
hold on
scatter(x,F,40,'MarkerEdgeColor',[213 17 87]/255,'MarkerFaceColor',[213 17 87]/255)
Ff = fillmissing(F,'linear','SamplePoints',x); 
plot(x,Ff,'-','Color',[213 17 87]/255)

plot(x,C,'LineWidth',1.5,'Color',[64 111 223]/255)
scatter(x,C,30,'MarkerEdgeColor',[64 111 223]/255,'MarkerFaceColor',[64 111 223]/255)
Cf = fillmissing(C,'linear','SamplePoints',x);
plot(x,Cf,'-','MarkerSize',5,'Color',[64 111 223]/255)

title([animal_id ' Median Choice Latency (Cxt-Obj Association, 6 Objs)'],'FontSize',20)
legend({'Forest','','','City','',''},'Location', 'eastoutside')
set(gca,'fontsize',15,'linewidth',1.5)
xlim([1 nSession]); 
ylabel('Choice Latency(s)'); xlabel('Day');

saveas(gcf,['Nabi Median Choice Latency_' SessionName '_2.jpg'])

%%
Z = size(SessionSummary_Sample,3);

clear MeanAcc_day StdAcc MeanAcc_day StdAcc_day NTrial_day
for c=1:2
    for d = 1:2
        for l = 1:4
            for k = 1:Z
                id = find(and(and(SessionSummary_Sample(:,5,k)==l,SessionSummary_Sample(:,4,k)==d),SessionSummary_Sample(:,3,k)==c));
                MeanAcc_day(d,l,c,k) = nanmean(SessionSummary_Sample(id,9,k));
                
                if ~isempty(nanmax(SessionSummary_Sample(id,2,k)))
                    NTrial_day(d,l,c,k) = nanmax(SessionSummary_Sample(id,2,k));
                else
                    NTrial_day(d,l,c,k) = 0;
                end
                
                
                StdAcc_day(d,l,c,k) = nanstd(SessionSummary_Sample(id,9,k)) * NTrial_day(d,l,c,k);

            end
            
            MeanAcc(d,l,c) = nanmean(MeanAcc_day(d,l,c,:));
%             StdAcc(d,l,c) = nansum(StdAcc_day(d,l,c,:),'all')/nansum(NTrial_day(d,l,c,:));
            StdAcc(d,l,c) = nanstd(MeanAcc_day(d,l,c,:));
            StEAcc(d,l,c) = StdAcc(d,l,c)/sqrt(k);
        end
    end
end

%%
x = [1:4];
y1 = MeanAcc(1,:,2);
y2 = MeanAcc(2,:,2);
figure('Position',[1000,918,770,420])

err = StEAcc(1,:,2);
errorbar(x,y1,err,'Color',[159,138,46]/255)
hold on
plot(x,y1,'Color',[159,138,46]/255,'LineWidth',2.5)
hold on
scatter(x,y1,40,[159,138,46]/255,'filled')
hold on
err = StEAcc(2,:,2);
errorbar(x,y2,err,'Color',[53,121,79]/255)
plot(x,y2,'Color',[53,121,79]/255,'LineWidth',2.5)
hold on
scatter(x,y2,40,[53,121,79]/255,'filled')
xlim([0.5 4.5]); ylim([0.895 0.955])
xticks([1 2 3 4]); yticks([0.90:0.01:0.95])
xticklabels({'Loc1' '2' '3' '4'})
set(gca,'fontsize',15,'linewidth',2.5,'FontWeight','b')
grid on


%%
for l = 1:4
    figure('Position',[1000,700,700,400])
    x = [1:2];

hold on
bar(x,y1)
y1 = MeanAcc(:,l,1);
    err = StEAcc(1:2,l,1);
errorbar(x,y1,err,'Color','k')
ylim([0.895 0.955])
end
%%
function DrawHistoryScatterAndLine(x,y,cf,ce)

plot(x,y,'LineWidth',1.5,'Color',ce)
hold on
scatter(x,y,40,'MarkerEdgeColor',ce,'MarkerFaceColor',cf)
yf = fillmissing(y,'linear','SamplePoints',x);
yf(1:min(find(~isnan(y))))=nan;
plot(x,yf,'-','Color',ce)
set(gca,'fontsize',15,'linewidth',1.5)
xlim([1 length(x)]); ylim([0.2 1]);
ylabel('Median Choice Latency'); xlabel('Day');
% line([1 length(x)],[0.8 0.8],'Color','b','LineStyle','--')
% line([1 length(x)],[0.5 0.5],'Color','k','LineStyle','--')
end