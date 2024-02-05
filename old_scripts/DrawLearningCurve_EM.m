%% Load last updated Session Summary.mat
clear all
close all

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
cd([mother_drive animal_id '\processed_data\behavior\' date_Analysis])
program_folder= [mother_drive '\program'];

addpath(genpath(program_folder))


cd(program_folder)

Sample = SessionSummary(:,:,1);
%%

nSession = size(SessionSummary,3);
for k = 1:nSession
    if ~isnan(SessionSummary(1,1,k))
        figure;
        TempSessionSummary = SessionSummary(find(SessionSummary(:,3,k)==1),:,k);
        [Prob,PoL(k,1)] = DrawLCMacro(animal_id,'end', 60, 1,k, TempSessionSummary,'EM Forest'); 
        cd([mother_drive animal_id '\processed_data\behavior\' date_Analysis])
        saveas(gcf,[animal_id '_Day' num2str(k) '_EM_Forest.jpg'])
    end
end


for k = 1:nSession
    if ~isnan(SessionSummary(1,1,k))
%         subplot(fix(nSession/10)+1,10,k)
        figure;
        TempSessionSummary = SessionSummary(find(SessionSummary(:,3,k)==2),:,k);
        [Prob,PoL(k,2)] = DrawLCMacro(animal_id,'end', 60, 1,k, TempSessionSummary,'EM City'); 
        cd([mother_drive animal_id '\processed_data\behavior\' date_Analysis])
        saveas(gcf,[animal_id '_Day' num2str(k) '_EM_City.jpg'])
    end
end


%%

nSession = size(SessionSummary,3);
for o=0:5
for k = 1:nSession
    if ~isnan(SessionSummary(1,1,k))
        figure;
        Obj = ObjName(o);
        TempSessionSummary = SessionSummary(find(or(SessionSummary(:,7,k)==o,SessionSummary(:,6,k)==o)),:,k);
        [Prob{k,o+1},PoL(k,o+1)] = DrawLCMacro(animal_id,'end', 60, 1,k, TempSessionSummary,['EM ' Obj]); 
        cd([mother_drive animal_id '\processed_data\behavior\' date_Analysis])
        saveas(gcf,[animal_id '_Day' num2str(k) '_EM_' Obj '.jpg'])
        close
    end
end
end

%%
clear Prob
nSession = size(SessionSummary,3);
for p=1:3
for k = 1:nSession
    if ~isnan(SessionSummary(1,1,k))
        figure;
        TempSessionSummary = SessionSummary(find(or(and(SessionSummary(:,7,k)<2*p,SessionSummary(:,7,k)>=2*(p-1)),and(SessionSummary(:,6,k)<2*p,SessionSummary(:,6,k)>=2*(p-1)))),:,k);
        [Prob{k,p},PoL(k,p)] = DrawLCMacro(animal_id,'end', 60, 1,k, TempSessionSummary,['EM-pair ' num2str(p)]); 
        cd([mother_drive animal_id '\processed_data\behavior\' date_Analysis])
        saveas(gcf,[animal_id '_Day' num2str(k) '_EM_pair ' num2str(p) '.jpg'])
        close
    end
end
end
%%
%     figure;
%     SessionSummary_Forest_D40 = SessionSummary(find(SessionSummary(:,3,40)==1),:,40);
% [Prob,PoL] = DrawLCMacro(animal_id,'end', 60, 1, SessionSummary_Forest_D40,'EM');
% figure;
%     SessionSummary_City_D40 = SessionSummary(find(SessionSummary(:,3,40)==2),:,40);
% [Prob,PoL] = DrawLCMacro(animal_id,'end', 60, 1, SessionSummary_City_D40,'EM');

%%
PoLScatter(1:nSession,1) = 1:nSession;
PoLScatter(1:nSession,2) = 1;
PoLScatter(1:nSession,3) = PoL(:,1);

PoLScatter(nSession+1:nSession*2,1) = 1:nSession;
PoLScatter(nSession+1:nSession*2,2) = 2;
PoLScatter(nSession+1:nSession*2,3) = PoL(:,2);
PoLScatter(find(PoLScatter(:,3)==0),3)=nan;

save(['PointOfLearning' SessionName '.mat'],'PoLScatter');

MeanPoL(1,1) = nanmean(PoLScatter(find(PoLScatter(:,2)==1),3));
MeanPoL(1,2) = nanmean(PoLScatter(find(PoLScatter(:,2)==2),3));
StdPoL(1,1) = nanstd(PoLScatter(find(PoLScatter(:,2)==1),3));
StdPoL(1,2) = nanstd(PoLScatter(find(PoLScatter(:,2)==2),3));

%%
clear PoLScatter
PoLScatter = nan(nSession*6,3);
for o = 0:5
PoLScatter((nSession*o)+1:(nSession*(o+1)),1) = 1:nSession;
PoLScatter((nSession*o)+1:(nSession*(o+1)),2) = o;
PoLScatter((nSession*o)+1:(nSession*(o+1)),3) = PoL(:,o+1);

MeanPoL(1,o+1) = nanmean(PoLScatter(find(PoLScatter(:,2)==o),3));
StdPoL(1,o+1) = nanstd(PoLScatter(find(PoLScatter(:,2)==o),3));
end
%%
figure;
x = 1:6;
y = [MeanPoL(1,:)];
b = bar(x,y,'LineWidth',1.5);
b.FaceColor = 'flat';
% b.CData(1,:) = [213 17 87]/255;
% b.CData(2,:) = [64 111 223]/255;

set(gca,'fontsize',15,'linewidth',1.5)
hold on
% err = [StdPoL(1,:)];
% er = errorbar(x,y,[0 0],err,'LineWidth',1.5);    
% er.Color = [0 0 0];                            
% er.LineStyle = 'none'; 

hold on 
scatter(PoLScatter(:,2),PoLScatter(:,3),40,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[0 0 0])

% xlim([0 3]); xticks([0:1:3]); xticklabels({'' 'Forest', 'City'}); 
xlabel('Context','FontSize',15); ylabel('Point of learning (trial)','FontSize',15)
title('Nabi Point of Learning (Cxt-Obj Association, 2 Objs,1st Pair)','FontSize',20)
saveas(gcf,['Nabi Point of Learning_' SessionName '.jpg'])

%%
figure;
x = PoLScatter(1:nSession,1); F = PoLScatter(1:nSession,3); C = PoLScatter(nSession+1:nSession*2,3);
hold on
plot(x,F,'LineWidth',1.5,'Color',[213 17 87]/255)
scatter(x,F,40,'MarkerEdgeColor',[213 17 87]/255,'MarkerFaceColor',[213 17 87]/255)
Ff = fillmissing(F,'linear','SamplePoints',x); 
plot(x(min(find(~isnan(F))):end),Ff(min(find(~isnan(F))):end),'-','Color',[213 17 87]/255)

plot(x,C,'LineWidth',1.5,'Color',[64 111 223]/255)
scatter(x,C,30,'MarkerEdgeColor',[64 111 223]/255,'MarkerFaceColor',[64 111 223]/255)
Cf = fillmissing(C,'linear','SamplePoints',x);
plot(x(min(find(~isnan(C))):end),Cf(min(find(~isnan(C))):end),'-','MarkerSize',5,'Color',[64 111 223]/255)

title('Nabi Point of Learning (Cxt-Obj Association, 6 Objs)','FontSize',20)
legend({'Forest','','','City','',''},'Location','eastoutside')
set(gca,'fontsize',15,'linewidth',1.5)
xlim([1 nSession]);ylim([0 max(max(F),max(C))*1.1]);
ylabel('Point of Learning (trial)'); xlabel('Day ');

saveas(gcf,['Nabi Point of Learning_' SessionName '_1.jpg'])

%%
figure;
x = PoLScatter(1:nSession,1); F = PoLScatter(1:nSession,3); C = PoLScatter(nSession+1:nSession*2,3);
hold on
plot(x,F,'LineWidth',1.5,'Color',[213 17 87]/255)
scatter(x,F,40,'MarkerEdgeColor',[213 17 87]/255,'MarkerFaceColor',[213 17 87]/255)
Ff = fillmissing(F,'linear','SamplePoints',x); 
plot(x(min(find(~isnan(F))):end),Ff(min(find(~isnan(F))):end),'-','Color',[213 17 87]/255)

plot(x,C,'LineWidth',1.5,'Color',[64 111 223]/255)
scatter(x,C,30,'MarkerEdgeColor',[64 111 223]/255,'MarkerFaceColor',[64 111 223]/255)
Cf = fillmissing(C,'linear','SamplePoints',x);
plot(x(min(find(~isnan(C))):end),Cf(min(find(~isnan(C))):end),'-','MarkerSize',5,'Color',[64 111 223]/255)

title('Nabi Point of Learning (Cxt-Obj Association, 6 Objs)','FontSize',20)
legend({'Forest','','','City','',''},'Location','eastoutside')
set(gca,'fontsize',15,'linewidth',1.5)
xlim([1 nSession]);ylim([0 max(max(F),max(C))*1.1]);
ylabel('Point of Learning (trial)'); xlabel('Day ');

saveas(gcf,['Nabi Point of Learning_' SessionName '_1.jpg'])
%%
 save(['DailyLearningCurve.mat']);
        %%
        function [Prob,PoL] = DrawLCMacro(animal_id,nTrial, Range, Column, Day, Data,Option)
        if strcmp(nTrial,'end')
            Length = size(Data,1);
        else
            Length = nTrial;
        end
        
        Responses = Data(1:Length,9,Column)';
        Responses(isnan(Responses))=[];
        UpdaterFlag = 0;
        Chance = 0.5;
        if Length ~=0
            if contains(Option,'EM')
                [Prob, cback] = LearningCurve_EM(Responses,UpdaterFlag);
            elseif contatins(Option,'WinBugs')
                [pdata cdata] = LearningCurve_WinBugs(Responses);
                Prob.pmid = pdata(:,3)';
                Prob.p05 = pdata(:,2)';
                Prob.p95 = pdata(:,4)';
            end
        end
        PoL = NaN;
        PoC = NaN;
        Xlength = 0;
        exist Prob;
        
        if ans
            PoL = find(Prob.p05>0.5,1,'first');
            PoC = find(Prob.pmid>0.8,1,'first');
            Xlength = size(Prob.p05,2);
            
            
            ha = shadedplot([1:Xlength], Prob.p05, Prob.p95, [0.7 0.7 0.7], 'k');
            hold on
            plot(Prob.pmid,'r','LineWidth',1.5)
            plot(Prob.p05,'k','LineWidth',1.5)
            plot(Prob.p95,'k','LineWidth',1.5)
            if ~isempty(PoL)
                line([PoL PoL],[0 1],'LineWidth',1.5,'Color','b')
            end
            if ~isempty(PoC)
                line([PoC PoC],[0 1],'LineWidth',1.5,'Color','b','LineStyle','--')
            end
        else
            Prob = NaN;
        end
        line([0 Xlength],[0.5 0.5],'Color','k','LineStyle','--')
        imagesc([0 Xlength],[1.05 1.03],~Responses-0.2);
        colormap(gray); caxis([0 1])
        
        xlim([1 Range]); ylim([0.2 1.05]);
        xlabel('Trial','FontSize',15); ylabel('Performance','FontSize',15)
        set(gca,'fontsize',15,'linewidth',1.5)
        title([animal_id ' - Day ' num2str(Day) '-' Option],'FontSize',15)
        
        if isempty(PoL)
            PoL = nan;
        end
        
        end
        

   