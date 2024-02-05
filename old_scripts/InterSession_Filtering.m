% Edited by JM (200318)
% 
% DESCRIPTION: Inter-session analysis, Criterion setting
% Prerequisite: SessionSummary

%%
clear all
close all
%% Load last updated Session Summary.mat
mother_drive = 'F:\NHP project\Data\';
animal_id=input('Nabi or Yoda?','s');
SessionName=input('Session Name?','s');
cd([mother_drive animal_id '\processed_data'])

if animal_id == 'Nabi'
    animal_id_num = 1;
    if ~exist(['SessionSummary_' SessionName '.mat'])
    SessionSummary = [];
else
    load(['SessionSummary_' SessionName '.mat']);
end	% ~exist('SessionSummary.mat')

SessionSummary = SessionSummary;
SessionSummary(:,15,:) = animal_id_num;

SessionSummary_Yoda = SessionSummary;

elseif animal_id == 'Yoda'
    animal_id_num = 2;
    
    if ~exist(['SessionSummary_' SessionName '.mat'])
    SessionSummary = [];
else
    load(['SessionSummary_' SessionName '.mat']);
end	% ~exist('SessionSummary.mat')

else
    animal_id_num = 0;
end

SessionSummary(:,15,:) = animal_id_num;
%%

cd([mother_drive animal_id '\processed_data\behavior'])

program_folder= [mother_drive '\program'];

addpath(genpath(program_folder))
%%

sample = SessionSummary(:,:,1);

nLap = squeeze(max(SessionSummary(:,1,:)));
nSession = size(SessionSummary,3);
%%
Fsize = 15;
clear nTrial

for i = 1: nSession
    x = size(SessionSummary,1);
    nTrial(x*(i-1)+1:x*i,1) = i;
    nTrial(x*(i-1)+1:x*i,2:12) = SessionSummary(:,1:11,i);
%     nTrial(x*(i-1)+1:x*i,13) = SessionSummary(:,15,i);
end
nTrial(isnan(nTrial(:,2)),:)=[];

MeanLatency = mean(nTrial(:,12));
MedianLatency = median(nTrial(:,12));
StdLatency = std(nTrial(:,12));
CritLatency95 = MeanLatency + 1*StdLatency;
CritLatency99 = MeanLatency + 2*StdLatency;

figure;
X = nTrial(:,12);
nbins =150;
histogram(X(X<5),nbins)

Ymax = 14000;
line([MeanLatency MeanLatency],[0 Ymax],'Color','r')
text(MeanLatency,5500,['Mean = ' num2str(MeanLatency)],'Color','r')
line([MedianLatency MedianLatency],[0 Ymax],'Color','k')
line([CritLatency99 CritLatency99],[0 Ymax],'Color','b')
line([CritLatency95 CritLatency95],[0 Ymax],'Color','b')
text(CritLatency95,5300,['Mean+std = ' num2str(CritLatency95)],'Color','b','FontSize',Fsize)
text(CritLatency99,5300,['Mean+2std = ' num2str(CritLatency99)],'Color','b','FontSize',Fsize)

FigTitle = [animal_id '_ ChoiceLatencyHist'];
title(FigTitle,'FontSize',30)

% cd([mother_drive animal_id '\processed_data\behavior'])
saveas(gcf,FigTitle)
%%
figure;

edges = [0:20:450];
% nLapY = squeeze(max(SessionSummary_Yoda(:,1,:)));
% X = nLapY;
% histogram(X,edges)
alpha(.5)
hold on

nLapN = squeeze(max(SessionSummary(:,1,:)));
X = nLapN;
histogram(X,edges)

nLap = squeeze(max(SessionSummary(:,1,:)));
X = nLap;

MeanNLaps = nanmean(nLap);
MedianNLaps = nanmedian(nLap);
StdNLaps = nanstd(nLap);
CritNLaps95 = MeanNLaps - StdNLaps;
CritNLaps99 = MeanNLaps - 2*StdNLaps;
Filter1NLaps = nLap(nLap<CritNLaps95);
nLap(nLap<CritNLaps95,2) = nLap(nLap<CritNLaps95,1)*8;
Filtered1nTrials = sum(nLap(:,2));

line([MeanNLaps MeanNLaps],[0 10],'Color','r')
text(MeanNLaps,9.5,['Mean = ' num2str(MeanNLaps)],'Color','r','FontSize',Fsize)
line([MedianNLaps MedianNLaps],[0 10],'Color','k')
text(MedianNLaps,9,['Median = ' num2str(MedianNLaps)],'Color','k','FontSize',Fsize)
line([CritNLaps99  CritNLaps99 ],[0 10],'Color','b')
text(CritNLaps99 ,9,['Mean-2std = ' num2str(CritNLaps99)],'Color','b','FontSize',Fsize)

line([CritNLaps95  CritNLaps95 ],[0 10],'Color','b')
text(CritNLaps95 ,9,['Mean-std = ' num2str(CritNLaps95)],'Color','b','FontSize',Fsize)
text(CritNLaps95,8.5,['Samples below Mean-std = ' num2str(length(Filter1NLaps)) ' sessions (' num2str(100*(Filtered1nTrials/length(nTrial))) '% of total sessions)'],'Color','b','FontSize',Fsize)

% text(100,9.5,['Total sessions = ' num2str(length(nLap))],'Color','k','FontSize',Fsize)


title(['nLaps Histogram'],'FontSize',30); xlabel('nLaps','FontSize',Fsize); ylabel('Samples','FontSize',Fsize)
FigTitle = [animal_id '_ NLapsHist'];
title(FigTitle)

% cd([mother_drive animal_id '\processed_data\behavior'])
saveas(gcf,FigTitle)

%%
figure;
for i = 1:nSession
SessionSummary(find(SessionSummary(:,8,i)==0),8,i) = -1;
end

for i = 1:size(SessionSummary,3)
SessionSummary(find(SessionSummary(:,8,i)==0),8,i) = -1;
end

% for i = 1:size(SessionSummary_Yoda,3)
% SessionSummary_Yoda(find(SessionSummary_Yoda(:,8,i)==0),8,i) = -1;
% end

edges = [0:0.05:1];

% biasY = squeeze(nanmean(SessionSummary_Yoda(:,8,:)));
% biasY = abs(biasY);
% X = biasY;
% histogram(X,edges)
alpha(.5)
hold on


biasN = squeeze(nanmean(SessionSummary(:,8,:)));
biasN = abs(biasN);
X = biasN;
histogram(X,edges)

bias = squeeze(nanmean(SessionSummary(:,8,:)));
bias = abs(bias);

MeanBias = nanmean(bias);
MedianBias = nanmedian(bias);
StdNBias = nanstd(bias);
CritBias95 = MeanBias + StdNBias;
CritBias99 = MeanBias + 2*StdNBias;
Filter1Bias = bias(bias>CritBias95);
bias(bias>CritBias95,2) = bias(bias>CritBias95,1)*8;
Filtered1nTrials = sum(bias(:,2));

Ymax = 60;
line([MeanBias MeanBias],[0 Ymax],'Color','r')
text(MeanBias,Ymax-1,['Mean = ' num2str(MeanBias)],'Color','r','FontSize',Fsize)
line([MedianBias MedianBias],[0 Ymax],'Color','k')
text(MedianBias,Ymax-2,['Median = ' num2str(MedianBias)],'Color','k','FontSize',Fsize)
line([CritBias99  CritBias99 ],[0 Ymax],'Color','b')
text(CritBias99 ,Ymax-3,['Mean+2std = ' num2str(CritBias99)],'Color','b','FontSize',Fsize)

line([CritBias95  CritBias95 ],[0 Ymax],'Color','b')
text(CritBias95 ,Ymax-6,['Mean+std = ' num2str(CritBias95)],'Color','b','FontSize',Fsize)
text(CritBias95,Ymax-4,['Samples above Mean+std = ' num2str(length(Filter1Bias)) ' sessions (' num2str(100*(Filtered1nTrials/length(nTrial))) '% of total trials)'],'Color','b','FontSize',Fsize)

text(200,9.5,['Total sessions = ' num2str(length(bias))],'Color','k','FontSize',Fsize)


title(['Bias(abs) Histogram'],'FontSize',30); xlabel('Bias','FontSize',Fsize); ylabel('Samples','FontSize',Fsize)
FigTitle = [animal_id '_ Bias(abs)Hist'];
title(FigTitle)

% cd([mother_drive animal_id '\processed_data\behavior'])
saveas(gcf,FigTitle)

%%
figure;

edges = [0.4:0.05:1];
% ChoiceAccY = squeeze(nanmean(SessionSummary_Yoda(:,9,:)));
% X = ChoiceAccY;
histogram(X,edges)
hold on

ChoiceAccN = squeeze(nanmean(SessionSummary(:,9,:)));
X = ChoiceAccN;
histogram(X,edges)

ChoiceAcc = squeeze(nanmean(SessionSummary(:,9,:)));
X = ChoiceAcc;

MeanChoiceAcc = nanmean(ChoiceAcc);
MedianChoiceAcc = nanmedian(ChoiceAcc);
StdNChoiceAcc = nanstd(ChoiceAcc);
CritChoiceAcc95 = MeanChoiceAcc - StdNChoiceAcc;
CritChoiceAcc99 = MeanChoiceAcc - 2*StdNChoiceAcc;
Filter2ChoiceAcc = ChoiceAcc(ChoiceAcc<CritChoiceAcc99);
ChoiceAcc(ChoiceAcc<CritChoiceAcc99,2) = ChoiceAcc(ChoiceAcc<CritChoiceAcc99,1)*8;
Filtered2nTrials = sum(ChoiceAcc(:,2));

Ymax = 60;
line([MeanChoiceAcc MeanChoiceAcc],[0 Ymax ],'Color','r')
text(MeanChoiceAcc,Ymax-1,['Mean = ' num2str(MeanChoiceAcc)],'Color','r','FontSize',Fsize)
line([MedianChoiceAcc MedianChoiceAcc],[0 Ymax ],'Color','k')
text(MedianChoiceAcc,Ymax-2,['Median = ' num2str(MedianChoiceAcc)],'Color','k','FontSize',Fsize)
line([CritChoiceAcc99  CritChoiceAcc99 ],[0 Ymax ],'Color','b')
text(CritChoiceAcc99 ,Ymax-3,['Mean-2std = ' num2str(CritChoiceAcc99)],'Color','b','FontSize',Fsize)

line([CritChoiceAcc95  CritChoiceAcc95 ],[0 Ymax ],'Color','b')
text(CritChoiceAcc95 ,Ymax-6,['Mean-std = ' num2str(CritChoiceAcc95)],'Color','b','FontSize',Fsize)
text(CritChoiceAcc99,Ymax-4,['Samples below Mean-2std = ' num2str(length(Filter2ChoiceAcc)) ' sessions (' num2str(100*(Filtered2nTrials/length(nTrial))) '% of total trials)'],'Color','b','FontSize',Fsize)

text(200,9.5,['Total sessions = ' num2str(length(ChoiceAcc))],'Color','k','FontSize',Fsize)


title(['ChoiceAcc Histogram'],'FontSize',30); xlabel('ChoiceAcc','FontSize',Fsize); ylabel('Samples','FontSize',Fsize)
FigTitle = [animal_id '_ ChoiceAccHist'];
title(FigTitle)

% cd([mother_drive animal_id '\processed_data\behavior'])
saveas(gcf,FigTitle)

%%
Filter1Latency = nTrial(nTrial(:,12)<CritLatency95,12);

MeanF1Latency = mean(Filter1Latency);
MedianF1Latency = median(Filter1Latency);
StdF1Latency = std(Filter1Latency);
CritF1Latency95 = MeanF1Latency + 1*StdF1Latency;
CritF1Latency99 = MeanF1Latency + 2*StdF1Latency;

figure;
X = Filter1Latency;
nbins =150;
histogram(X)
line([MeanF1Latency MeanF1Latency],[0 6000],'Color','r')
line([MedianF1Latency MedianF1Latency],[0 6000],'Color','k')

% line([CritLatency95 CritLatency95],[0 6000],'Color','r')
FigTitle = [animal_id '_ Choice Latency, Filter values above Mean+1std'];
title(FigTitle,'FontSize',30)

cd([mother_drive animal_id '\processed_data\behavior'])
saveas(gcf,FigTitle)
%%
Fsize = 15;
edges = [0:0.05:3];
Filter2Latency = nTrial(nTrial(:,12)<CritLatency99,12);
% Filter2Latency_N = nTrial(and(nTrial(:,12)<CritLatency99, nTrial(:,13)==1),12);
% Filter2Latency_Y = nTrial(and(nTrial(:,12)<CritLatency99, nTrial(:,13)==2),12);

MeanF2Latency = mean(Filter2Latency);
MedianF2Latency = median(Filter2Latency);
StdF2Latency = std(Filter2Latency);
CritF2Latency95 = MeanF2Latency + 1*StdF2Latency;
CritF2Latency99 = MeanF2Latency + 2*StdF2Latency;


Filter2_2Latency = nTrial(nTrial(:,12)<CritF2Latency99,12);

figure;
% X = Filter2Latency_Y;
% histogram(X(X<3),edges);
hold on
% X = Filter2Latency_N;
% histogram(X(X<3),edges);

X = Filter2Latency;
histogram(X(X<3),edges);

% histogram(X)
Ymax = 15000;
line([MeanF2Latency MeanF2Latency],[0 Ymax],'Color','r')
text(MeanF2Latency,Ymax*0.9,['Filtered Mean = ' num2str(MeanF2Latency)],'Color','r','FontSize',Fsize)
line([MedianF2Latency MedianF2Latency],[0 Ymax],'Color','k')
text(MedianF2Latency,Ymax*0.8,['Filtered Median = ' num2str(MedianF2Latency)],'Color','k','FontSize',Fsize)
line([CritF2Latency99 CritF2Latency99],[0 Ymax],'Color','b')
text(CritF2Latency99,Ymax*0.7,['Filtered Mean+2std = ' num2str(CritF2Latency99)],'Color','b','FontSize',Fsize)
text(CritF2Latency99,Ymax*0.6,['Samples above Filtered Mean+2std = ' num2str(length(nTrial)-length(Filter2_2Latency)) ' (' num2str(100*(length(nTrial)-length(Filter2_2Latency))/length(nTrial)) '% of total)'],'Color','b','FontSize',Fsize)

text(2.5,Ymax*0.5,['Total samples = ' num2str(length(nTrial))],'Color','k','FontSize',Fsize)
text(2.5,Ymax*0.45,['Filtered Max. = ' num2str(max(Filter2Latency))],'Color','k','FontSize',Fsize)
text(2.5,Ymax*0.4,['Removed samples = ' num2str(length(nTrial)-length(Filter2Latency)) ' (' num2str(100*(length(nTrial)-length(Filter2Latency))/length(nTrial)) '% of total)'],'Color','k','FontSize',Fsize)


xlabel('Latency(s)','FontSize',Fsize); ylabel('Samples','FontSize',Fsize)
% line([CritLatency95 CritLatency95],[0 6000],'Color','r')

FigTitle = [animal_id '_ Choice Latency, Filter values above Mean+2std'];
title(FigTitle,'FontSize',30)

% cd([mother_drive animal_id '\processed_data\behavior'])
saveas(gcf,FigTitle)
%% Indexing

nTrial(:,13)=~nTrial(:,11);

nLapIndex = find(nLap(:,1)<CritNLaps99);
nBiasIndex = find(abs(bias(:,1))>CritBias99);
nChoiceAccIndex = find(ChoiceAcc(:,1)<CritChoiceAcc99);
nLatencyIndex = find(nTrial(:,12)>=CritF2Latency99);

nTrial(:,14) = 1;
% nTrial(nLatencyIndex,14) = 0;

nTrial(:,15) = 1;
for i = 1:length(nLapIndex)
nTrial(nTrial(:,1)==nLapIndex(i),15) = 0;

end
% for i = 1:length(nBiasIndex)
% nTrial(nTrial(:,1)==nBiasIndex(i),15) = 0;
% end
% 
% for i = 1:length(nChoiceAccIndex)
% nTrial(nTrial(:,1)==nChoiceAccIndex(i),15) = 0;
% end

%% Save Index to SessionSummary
for i=1:size(SessionSummary,3)
    SessionSummary(1:length(find(nTrial(:,1)==i)),12:14,i) = nTrial(nTrial(:,1)==i,13:15);
end

% cd([mother_drive animal_id '\processed_data'])
% save('SessionSummary_2_2.mat','SessionSummary');

date_Analysis=input('Analysis date(YYYYMMDD)? ::','s');

% a=1;b=1;
% clear SessionSummary_Nabi_F SessionSummary_Yoda_F
% for d = 1:nSession
%     if SessionSummary(1,15,d) ==1
%         SessionSummary_Nabi_F(:,:,a) = SessionSummary(:,:,d);
%         a=a+1;
%     end
%     if SessionSummary(1,15,d) ==2
%         SessionSummary_Yoda_F(:,:,b) = SessionSummary(:,:,d);
%         b=b+1;
%     end
%     
% end
% nanmean(~isnan(SessionSummary(:,12,:)) && logical(SessionSummary(:,12,:) .* SessionSummary(:,13,:) .* SessionSummary(:,14,:)),'all')

cd([mother_drive animal_id '\processed_data'])
save(['SessionSummary_' SessionName '_' date_Analysis '.mat'],'SessionSummary');
% save(['SessionSummary_' SessionName '.mat'],'SessionSummary');

% cd([mother_drive 'Yoda\processed_data'])
% save(['SessionSummary' date_Analysis '.mat'],'SessionSummary_Yoda_F');


