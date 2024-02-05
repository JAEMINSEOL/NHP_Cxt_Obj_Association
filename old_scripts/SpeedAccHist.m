%%
close all
SessionSummary_Sample = SessionSummary_6;
i = size(SessionSummary_Sample,1);
k = size(SessionSummary_Sample,3);
x = reshape(squeeze(SessionSummary_Sample(:,9,:)),i*k,1);
y = reshape(squeeze(SessionSummary_Sample(:,11,:)),i*k,1);
%%
Sample_day = SessionSummary_Sample(:,:,end);
RT_median = squeeze(nanmedian(SessionSummary_Sample(:,11,:)));
%%
crit99p = nanmean(y)+2*nanstd(y);
crit99n = nanmean(y)-2*nanstd(y);
crit95p = nanmean(y)+1*nanstd(y);
crit95n = nanmean(y)-1*nanstd(y);
y_c = y;
y_c(y>crit95p) = NaN; y_c(y<0) = NaN;
figure('Position',[1,500,2501,650]);
scatter(y,x,20)

set(gca,'fontsize',20,'linewidth',1.5)
yticks([0 1]); yticklabels({'0 (Incorrect)','1 (Correct)'})
xlabel('Choice Latency (s)')
ylabel('Correctness')
xlim([0 10])
title('Nabi Choice Latency ScatterPlot, 4 Objects Sessions')
%%
clear counts_n counts_c
y_correct = y(x==1); 
y_incorrect = y(x==0); y_incorrect(end+1:length(y_correct)) = NaN;
y_correct(end+1) = 0; y_incorrect(end+1)=0;

lbins = 0.1;
nbins = max(y)/lbins;
[counts,centers] = hist([y_correct y_incorrect],nbins);
counts_n(:,1) = counts(:,1)/max(counts(:,1));
counts_n(:,2) = counts(:,2)/max(counts(:,2));
counts_n(:,3) = centers;

counts_c(:,1) = counts(:,1)/sum(counts(:,1));
counts_c(:,2) = counts(:,2)/sum(counts(:,2));
counts_c(:,3) = centers;

%%
figure('Position',[1000,500,1300,800])
c_correct = [0 114 189]/225;
c_incorrect = [217 83 25]/225;
p1 = plot(counts_c(:,3),counts_c(:,1:2)*100,'linewidth',1.5);
xlim([0 5]); 

set(gca,'fontsize',20,'linewidth',1.5)
xlabel('Choice Latency (s)')
ylabel('Proportion (%)')
title('Nabi Choice Latency Distribution, 4 Objects Sessions')
hold on
l1 = line([nanmedian(y_correct) nanmedian(y_correct)],[0 30],'Color',c_correct,'LineStyle','--');
text(nanmedian(y_correct),25,['median = ' num2str(nanmedian(y_correct))],'FontSize',15,'Color',c_correct);
l2 = line([nanmedian(y_incorrect) nanmedian(y_incorrect)],[0 30],'Color',c_incorrect,'LineStyle','--');
text(nanmedian(y_incorrect),20,['median = ' num2str(nanmedian(y_incorrect))],'FontSize',15,'Color',c_incorrect);
legend([p1],{'Correct','Incorrect'})

%%
clear AccMean
lbins = 0.1;
for n = 1:10/lbins-1
    BinMin = lbins*n;
    BinMax = lbins*(n+1);
    AccMean(1,n) = mean([BinMin BinMax]);
    AccMean(2,n) = nanmean(x(and(y>=BinMin,y<BinMax)));
    AccMean(3,n) = nanstd(x(and(y>=BinMin,y<BinMax)));
    AccMean(4,n) = length(x(and(y>=BinMin,y<BinMax)));
end

AccMean_Y_6 = AccMean;
%%
figure('Position',[1000,500,1300,800]);
% plot(AccMean_N_6(1,:),AccMean_N_6(2,:),'linewidth',1.5)
% hold on
% plot(AccMean_N_6(1,:),AccMean_Y_6(2,:),'linewidth',1.5)
% hold on
AccSample = AccMean_N_6;
    x1 = AccSample(1,:);
    y1 = AccSample(2,:);
    y2 = AccSample(3,:);
    y3 = AccSample(4,:);
% shadedplot(x1, y1, y1+y2, [0.7 0.7 1], 'k');
% hold on
% shadedplot(x1, y1, y1-y2, [0.7 0.7 1], 'k');
hold on
plot(x1,y1,'linewidth',1.5,'Color','b','MarkerSize',10)

AccSample = AccMean_Y_6;
    x1 = AccSample(1,:);
    y1 = AccSample(2,:);
    y2 = AccSample(3,:);
    y3 = AccSample(4,:);
% shadedplot(x1, y1, y1+y2, [1 0.7 0.7], 'k');
% hold on
% shadedplot(x1, y1, y1-y2, [1 0.7 0.7], 'k');
hold on
plot(x1,y1,'linewidth',1.5,'Color','r','MarkerSize',10)


% plot(AccMean_N_6(1,:),AccMean_N_6(4,:),'linewidth',1.5,'Color','b','MarkerSize',10)
% hold on 
% scatter(AccMean_N_6(1,:),AccMean_N_6(4,:),40,'b','Filled')
% 
% plot(AccMean_Y_6(1,:),AccMean_Y_6(4,:),'linewidth',1.5,'Color','r','MarkerSize',10)
% hold on 
% scatter(AccMean_Y_6(1,:),AccMean_Y_6(4,:),40,'r','Filled')
% set(gca, 'YScale', 'log')


% plot(AccMean_Y_6(1,:),AccMean_Y_All(2,:),'linewidth',1.5)
% legend

set(gca,'fontsize',20,'linewidth',1.5)
xlabel(['Choice Latency (s), bin size = '  num2str(lbins) 's'])
ylabel('Accuracy')
xlim([0 3]); ylim([0.5 1.01])
title(['Nabi and Yoda Choice Accureacy-Latency, 6 Objects Sessions'])