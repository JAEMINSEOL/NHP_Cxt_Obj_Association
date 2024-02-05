%% Load last updated Session Summary.mat
clear all
close all

mother_drive = 'F:\NHP project\Data\';
animal_id=input('Nabi or Yoda?','s');
cd([mother_drive animal_id '\processed_data'])

if ~exist('SessionSummary.mat')
    SessionSummary = [];
else
    load('SessionSummary.mat');
end	% ~exist('SessionSummary.mat')

date_Analysis=input('Analysis date(YYYYMMDD)? ::','s');

cd([mother_drive animal_id '\processed_data\behavior'])
mkdir(date_Analysis)
cd([mother_drive animal_id '\processed_data\behavior\' date_Analysis])
program_folder= [mother_drive '\program'];

addpath(genpath(program_folder))


cd(program_folder)

Sample = SessionSummary(1,:,:);

%%
nSession = size(SessionSummary,3);
nLapMax = max(max(SessionSummary(:,1,:)));
MeanLap_F = nan(nLapMax,nSession);
MeanLap_C = nan(nLapMax,nSession);
MeanLap_F_O = nan(nLapMax,nSession,6);
MeanLap_C_O = nan(nLapMax,nSession,6);


% for k = 1:nSession
%     for i = 1: max(SessionSummary(:,1,k))
%         id = find(SessionSummary(:,1,k) == i & SessionSummary(:,3,k) == 1);
%         MeanLap_F(i,k) = nanmean(SessionSummary(id,9,k));
%         id = find(SessionSummary(:,1,k) == i & SessionSummary(:,3,k) == 2);
%         MeanLap_C(i,k) = nanmean(SessionSummary(id,9,k));
%     end
% end




for k = 1:nSession
    for i = 1: max(SessionSummary(:,1,k))
        if ~isnan(SessionSummary(1,1,k))
        id = find(SessionSummary(:,1,k) == i & SessionSummary(:,3,k) == 1 & SessionSummary(:,4,k) == 0 & SessionSummary(:,13,k) == 1 & SessionSummary(:,14,k) == 1);
        MeanLap_F(i,k) = nanmean(SessionSummary(id,9,k));
        id = find(SessionSummary(:,1,k) == i & SessionSummary(:,3,k) == 2 & SessionSummary(:,4,k) == 0  & SessionSummary(:,13,k) == 1 & SessionSummary(:,14,k) == 1);
        MeanLap_C(i,k) = nanmean(SessionSummary(id,9,k));
        end
    end
end
save('ACCMeanLap_Cxt.mat','MeanLap_F','MeanLap_C')

for o = 1:6
    for k = 1:nSession
        for i = 1: max(SessionSummary(:,1,k))
            if ~isnan(SessionSummary(1,1,k))
            id = find(SessionSummary(:,1,k) == i & SessionSummary(:,3,k) == 1 & SessionSummary(:,4,k) == 0 & (SessionSummary(:,5,k) == o-1  | SessionSummary(:,6,k) == o-1 ) & SessionSummary(:,13,k) == 1 & SessionSummary(:,14,k) == 1);
            MeanLap_F_O(i,k,o) = nanmean(SessionSummary(id,9,k));
            id = find(SessionSummary(:,1,k) == i & SessionSummary(:,3,k) == 2 & SessionSummary(:,4,k) == 0 & (SessionSummary(:,5,k) == o-1  | SessionSummary(:,6,k) == o-1 ) & SessionSummary(:,13,k) == 1 & SessionSummary(:,14,k) == 1);
            MeanLap_C_O(i,k,o) = nanmean(SessionSummary(id,9,k));
            end
        end
    end
end
save('ACCMeanLap_Cxt_Obj.mat','MeanLap_F_O','MeanLap_C_O')

% for k = 1:1
%     for i = 1: max(SessionSummary(:,1,k))
%         id = find(SessionSummary(:,1,k) == i & SessionSummary(:,3,k) == 1);
%         MeanLap_F(i,k) = nanmean(SessionSummary(id,9,k));
%     id = find(SessionSummary(:,1,k) == i & SessionSummary(:,3,k) == 2);
%         MeanLap_C(i,k) = nanmean(SessionSummary(id,9,k));
%     end
% end


%%
clear AccCum_Cxt
AccCum_Cxt = nan(300,3,k);
Fit_AccCum_Cxt = nan(k,3,2);

for k = 1:nSession
    if ~isnan(SessionSummary(1,1,k))
    id_F = find(SessionSummary(:,3,k) == 1 & SessionSummary(:,4,k) == 0 & SessionSummary(:,13,k) == 1 & SessionSummary(:,14,k) == 1);
    x_f = 1:length(unique(SessionSummary(id_F,1,k)));
    y = MeanLap_F(:,k);
    y(isnan(y))=[];
    clear y_n_f
    for i = 1:size(y)
        y_n_f(i,1) = sum(y(1:i))/i;
    end
    
    
    id_C = find(SessionSummary(:,3,k) == 2 & SessionSummary(:,4,k) == 0 & SessionSummary(:,13,k) == 1 & SessionSummary(:,14,k) == 1);
    x_c = 1:length(unique(SessionSummary(id_C,1,k)));
    y = MeanLap_C(:,k);
    y(isnan(y))=[];
    clear y_n_c
    for i = 1:size(y)
        y_n_c(i,1) = sum(y(1:i))/i;
    end
    
    
    if ~isempty(x_c) && ~isempty(x_f)
    AccCum_Cxt(1:size(AccCum_Cxt,1),1,k) = 1:size(AccCum_Cxt,1);
    AccCum_Cxt(1:length(y_n_f),2,k) = y_n_f;
    AccCum_Cxt(1:length(y_n_c),3,k) = y_n_c;
    AccCum_Cxt(~any(~isnan(AccCum_Cxt(:,2:end,k)),2),1,k)=nan;
    csvwrite([animal_id '_AccCum_Cxt_D' num2str(k) '.csv'],AccCum_Cxt(:,:,k),1,0);
    end
    end
end


%%
figure

for k = 1: nSession
    if ~isnan(SessionSummary(1,1,k))
    subplot(fix(nSession/10)+1,10,k)
    id_F = find(SessionSummary(:,3,k) == 1 & SessionSummary(:,4,k) == 0 & SessionSummary(:,13,k) == 1 & SessionSummary(:,14,k) == 1);
    x = 1:length(unique(SessionSummary(id_F,1,k)));
    y = MeanLap_F(:,k);
    y(isnan(y))=[];
    clear y_n
    for i = 1:size(y)
        y_n(i) = sum(y(1:i))/i;
    end
    if ~isempty(x)
    plot(x,y_n,'LineWidth',1.5,'Color',[213 72 87]/255)
    % ylim([0 1.05])
    ylim([0.4 1.05])
    xlim([0 40])
    FigTitle = [animal_id ', Day ' num2str(k)];
    title(FigTitle,'FontWeight','b'); xlabel('Lap'); ylabel('Choice Accuracy')
    end
    
    hold on
    id_C = find(SessionSummary(:,3,k) == 2 & SessionSummary(:,4,k) == 0 & SessionSummary(:,13,k) == 1 & SessionSummary(:,14,k) == 1);
    x = 1:length(unique(SessionSummary(id_C,1,k)));
    y = MeanLap_C(:,k);
    y(isnan(y))=[];
    clear y_n
    for i = 1:size(y)
        y_n(i) = sum(y(1:i))/i;
    end
    if ~isempty(x)
    plot(x,y_n,'LineWidth',1.5,'Color',[64 111 223]/255)
    end
    hold on
    end
end
saveas(gcf,FigTitle)
%%
figure
clear AccCum_Obj_Forest
AccCum_Obj_Forest = nan(300,7,k);

for k = 1: nSession
    if ~isnan(SessionSummary(1,1,k))
    for o = 1:6
        subplot(fix(nSession/10)+1,10,k)
        id_F = find(SessionSummary(:,3,k) == 1 & SessionSummary(:,4,k) == 0 & (SessionSummary(:,5,k) == o-1  | SessionSummary(:,6,k) == o-1 )& SessionSummary(:,13,k) == 1 & SessionSummary(:,14,k) == 1);
        x = 1:length(unique(SessionSummary(id_F,1,k)));
        y = MeanLap_F_O(:,k,o);
        y(isnan(y))=[];
        clear y_n
        for i = 1:size(y)
            y_n(i) = sum(y(1:i))/i;
        end
        % plot(x,y_n,'LineWidth',1.5,'Color',[213 72 87]/255)
        if ~isempty(x)
        plot(x,y_n)
        ylim([0.4 1.05])
        % xlim([0 40])
        % ylim([0 1.05])
        % ylim([0 1.05])
        % xlim([0 30])
        FigTitle = [animal_id ', Forest, Day ' num2str(k)];
        title(FigTitle,'FontWeight','b'); xlabel('Lap'); ylabel('Choice Accuracy')
        
        % hold on
        % id_C = find(SessionSummary(:,3,k) == 2 & SessionSummary(:,4,k) == 0 & (SessionSummary(:,5,k) == o-1  | SessionSummary(:,6,k) == o-1 ));
        % x = 1:length(unique(SessionSummary(id_C,1,k)));
        % y = MeanLap_C(:,k,o);
        % y(isnan(y))=[];
        % clear y_n
        % for i = 1:size(y)
        %     y_n(i) = sum(y(1:i))/i;
        % end
        % plot(x,y_n,'LineWidth',1.5,'Color',[64 111 223]/255)
        hold on
        
        
        AccCum_Obj_Forest(1:300,1,k) = 1:300;
        AccCum_Obj_Forest(1:length(y_n),o+1,k) = y_n;
        end

        
    end
    AccCum_Obj_Forest(~any(~isnan(AccCum_Obj_Forest(:,2:end,k)),2),1,k)=nan;
    csvwrite([animal_id '_AccCum_Obj_Forest_D' num2str(k) '.csv'],AccCum_Obj_Forest(:,:,k),1,0);
    end
end

saveas(gcf,FigTitle)
%%
figure

clear AccCum_Obj_City
AccCum_Obj_City = nan(300,7,k);

for k = 1: nSession
    if ~isnan(SessionSummary(1,1,k))
    for o = 1:6
        subplot(fix(nSession/10)+1,10,k)
        % id_F = find(SessionSummary(:,3,k) == 1 & SessionSummary(:,4,k) == 0 & (SessionSummary(:,5,k) == o-1  | SessionSummary(:,6,k) == o-1 ));
        % x = 1:length(unique(SessionSummary(id_F,1,k)));
        % y = MeanLap_F(:,k,o);
        % y(isnan(y))=[];
        % clear y_n
        % for i = 1:size(y)
        %     y_n(i) = sum(y(1:i))/i;
        % end
        % % plot(x,y_n,'LineWidth',1.5,'Color',[213 72 87]/255)
        % plot(x,y_n)
        % ylim([0 1.05])
        % xlim([0 30])
        ylim([0 1.05])
%         xlim([0 40])
FigTitle = [animal_id ', City, Day ' num2str(k)];
        title(FigTitle,'FontWeight','b'); xlabel('Lap'); ylabel('Choice Accuracy')
        
        % hold on
        id_C = find(SessionSummary(:,3,k) == 2 & SessionSummary(:,4,k) == 0 & (SessionSummary(:,5,k) == o-1  | SessionSummary(:,6,k) == o-1 )& SessionSummary(:,13,k) == 1 & SessionSummary(:,14,k) == 1);
        x = 1:length(unique(SessionSummary(id_C,1,k)));
        y = MeanLap_C_O(:,k,o);
        y(isnan(y))=[];
        y_n = [];
        for i = 1:size(y)
            y_n(i) = sum(y(1:i))/i;
        end
        % plot(x,y_n,'LineWidth',1.5,'Color',[64 111 223]/255)
        if ~isempty(x)
        plot(x,y_n)
        % if length(x)<30
        %     text(1,0.1,'InSufficient nLaps','Color','red')
        % end
        hold on
        
        
        AccCum_Obj_City(1:300,1,k) = 1:300;
        AccCum_Obj_City(1:length(y_n),o+1,k) = y_n;
        end
        
    end
    AccCum_Obj_City(~any(~isnan(AccCum_Obj_City(:,2:end,k)),2),1,k)=nan;
    csvwrite([animal_id '_AccCum_Obj_City_D' num2str(k) '.csv'],AccCum_Obj_City(:,:,k),1,0);
    end
end

saveas(gcf,FigTitle)
%%
Crit = 0.7;
Fit_AccCum_Cxt = CurveFitIndex(AccCum_Cxt,nSession,Crit);
Fit_AccCum_Obj_Forest = CurveFitIndex(AccCum_Obj_Forest,nSession,Crit);
Fit_AccCum_Obj_City = CurveFitIndex(AccCum_Obj_City,nSession,Crit);
save('FitAccCum.mat','Fit_AccCum_Cxt','Fit_AccCum_Obj_Forest','Fit_AccCum_Obj_City')
%%
figure;
scatter(1:nSession,Fit_AccCum_Cxt(:,5,1),'r','filled')

hold on
DrawLineFit(Fit_AccCum_Cxt(:,5,1),nSession,'r')

scatter(1:nSession,Fit_AccCum_Cxt(:,5,2),'b','filled')
DrawLineFit(Fit_AccCum_Cxt(:,5,2),nSession,'b')

title(['InitialAcc-Cxt, R^2>' num2str(Crit)],'fontsize',15)
xlabel('Session'); ylabel('Accuracy'); 
legend({'Forest','Linear Fit(Forest)','City','Linear Fit(City)'},'Location','eastoutside')


figure;
scatter(1:nSession,Fit_AccCum_Cxt(:,4,1),'r','filled')

hold on
DrawLineFit(Fit_AccCum_Cxt(:,4,1),nSession,'r')

scatter(1:nSession,Fit_AccCum_Cxt(:,4,2),'b','filled')
DrawLineFit(Fit_AccCum_Cxt(:,4,2),nSession,'b')

title(['AsymptoteLap-Cxt, R^2>' num2str(Crit)],'fontsize',15)
xlabel('Session'); ylabel('First Lap above Asymptote'); 
legend({'Forest','Linear Fit(Forest)','City','Linear Fit(City)'},'Location','eastoutside')


figure;
scatter(1:nSession,Fit_AccCum_Cxt(:,3,1),'r','filled')

hold on
DrawLineFit(Fit_AccCum_Cxt(:,3,1),nSession,'r')

scatter(1:nSession,Fit_AccCum_Cxt(:,3,2),'b','filled')
DrawLineFit(Fit_AccCum_Cxt(:,3,2),nSession,'b')

title(['Asymptote-Cxt, R^2>' num2str(Crit)],'fontsize',15)
xlabel('Session'); ylabel('Asymptote Accuracy'); ylim([0.9 1])
legend({'Forest','Linear Fit(Forest)','City','Linear Fit(City)'},'Location','eastoutside')


figure;
scatter(1:nSession,Fit_AccCum_Cxt(:,2,1),'r','filled')
hold on
DrawLineFit(Fit_AccCum_Cxt(:,2,1),nSession,'r')

scatter(1:nSession,Fit_AccCum_Cxt(:,2,2),'b','filled')

DrawLineFit(Fit_AccCum_Cxt(:,2,2),nSession,'b')

title(['Inflection Point X-Cxt, R^2>' num2str(Crit)],'fontsize',15)
xlabel('Session'); ylabel('Infelction Point X value');
legend({'Forest','Linear Fit(Forest)','City','Linear Fit(City)'},'Location','eastoutside')




figure;
scatter(1:nSession,Fit_AccCum_Cxt(:,1,1),'r','filled')

hold on
DrawLineFit(Fit_AccCum_Cxt(:,1,1),nSession,'r')

hold on
scatter(1:nSession,Fit_AccCum_Cxt(:,1,2),'b','filled')

hold on
DrawLineFit(Fit_AccCum_Cxt(:,1,2),nSession,'b')

title(['Growth Rate-Cxt, R^2>' num2str(Crit)],'fontsize',15)
xlabel('Session'); ylabel('Growth Rate');
legend({'Forest','Linear Fit(Forest)','City','Linear Fit(City)'},'Location','eastoutside')

%%
figure;

for c = 1:6
    scatter(1:nSession,Fit_AccCum_Obj_City(:,5,c),'filled')
    hold on    
end
title(['InitialAcc-Obj-City, R^2>' num2str(Crit)],'fontsize',15)
xlabel('Session'); ylabel('Accuracy'); 
legend({'Donut','Pumpkin', 'Turtle','Jellyfish', 'Octopus','Pizza'},'Location','eastoutside')

figure;
for c = 1:6
    scatter(1:nSession,Fit_AccCum_Obj_City(:,4,c),'filled')
    hold on    
end
title(['AsymptoteLap-Obj-City, R^2>' num2str(Crit)],'fontsize',15)
xlabel('Session'); ylabel('First Lap above Asymptote'); 
legend({'Donut','Pumpkin', 'Turtle','Jellyfish', 'Octopus','Pizza'},'Location','eastoutside')

figure;
for c = 1:6
    scatter(1:nSession,Fit_AccCum_Obj_City(:,3,c),'filled')
    hold on    
end
title(['Asymptote-Obj-City, R^2>' num2str(Crit)],'fontsize',15)
xlabel('Session'); ylabel('Asymptote Accuracy'); ylim([0.9 1])
legend({'Donut','Pumpkin', 'Turtle','Jellyfish', 'Octopus','Pizza'},'Location','eastoutside')

figure;
for c = 1:6
    scatter(1:nSession,Fit_AccCum_Obj_City(:,2,c),'filled')
    hold on    
end
title(['Inflection Point X-Obj-City, R^2>' num2str(Crit)],'fontsize',15)
xlabel('Session'); ylabel('Inflection Point X'); 
legend({'Donut','Pumpkin', 'Turtle','Jellyfish', 'Octopus','Pizza'},'Location','eastoutside')

figure;
for c = 1:6
    scatter(1:nSession,Fit_AccCum_Obj_City(:,1,c),'filled')
    hold on    
end
title(['Growth Rate-Obj-City, R^2>' num2str(Crit)],'fontsize',15)
xlabel('Session'); ylabel('Growth Rate'); 
legend({'Donut','Pumpkin', 'Turtle','Jellyfish', 'Octopus','Pizza'},'Location','eastoutside')

%%
figure;
    image(squeeze(Fit_AccCum_Cxt(:,end,:))','CDataMapping','scaled')
    caxis([0 1])
    yticks([1 2])
    set(gca,'YTickLabel',{'Forest','City'},'fontsize',15,'TickDir','out')
    xlabel('Session'); ylabel('Context')
%     set(gca,'colorscale','log')
    colormap('jet')
colorbar
title([animal_id '-RSquare-Cxt'])

figure;
    image(squeeze(Fit_AccCum_Obj_Forest(:,end,:))','CDataMapping','scaled')
    caxis([0 1])
    set(gca,'YTickLabel',{'Donut','Pumpkin', 'Turtle','Jellyfish', 'Octopus','Pizza'},'fontsize',15,'TickDir','out')
    xlabel('Session'); ylabel('Object')
%     set(gca,'colorscale','log')
    colormap('jet')
colorbar
title([animal_id '-RSquare-Obj-Forest'])

figure;
    image(squeeze(Fit_AccCum_Obj_City(:,end,:))','CDataMapping','scaled')
    caxis([0 1])
    set(gca,'YTickLabel',{'Donut','Pumpkin', 'Turtle','Jellyfish', 'Octopus','Pizza'},'fontsize',15,'TickDir','out')
    xlabel('Session'); ylabel('Object')
%     set(gca,'colorscale','log')
    colormap('jet')
colorbar
title([animal_id '-RSquare-Obj-City'])
%%
% SampleX = AccCum_Cxt(:,1,40); SampleX(isnan(SampleX)) = [];
% SampleY1 = AccCum_Cxt(:,2,40); SampleY1(size(SampleX,1)+1:end) = [];
% SampleY2 = AccCum_Cxt(:,3,40); SampleY2(size(SampleX,1)+1:end) = [];
% 
% xy = [SampleX,SampleY2];
% xy(find(isnan(xy(:,2))),:) = [];
% [f,gof] = fit(xy(:,1),xy(:,2), 'c/(1+exp(-a*(x-b)))');
% figure;
% plot(f,xy(:,1),xy(:,2))
% for o = 1:6
%     subplot(7,10,k+1)
% plot(x,y_n)
% hold on
% end
% legend({'Donut','Pumpkin','Turtle','Jellyfish','Ocotpus','Pizza'},'Location','eastoutside')

%%
function DrawLineFit(RawData,nSession,c)
RawX = (1:nSession)';
RawY = RawData;
RawX(isnan(RawY))=[];
 RawY(isnan(RawY))=[];

[p,S] = polyfit(RawX,RawY,1);
LineFit = fitlm(RawX,RawY,1);
[f,d] = polyval(p,RawX,S);
plot(RawX,f,c)
% plot(RawX,f+2*d,'b--',RawX,f-2*d,'b--')



if c=='b'
    text(nSession/2,nanmedian(RawY)*0.95,['R^2 = ' num2str(LineFit.Rsquared.Adjusted)],'Color',c)
else
    text(nSession/2,nanmedian(RawY),['R^2 = ' num2str(LineFit.Rsquared.Adjusted)],'Color',c)
end
end