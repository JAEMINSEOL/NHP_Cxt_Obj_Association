%% FR btw Choice phase

figure
subplot(1,3,1)
x = (1:3);
y = mean(FR_Trial(:,:,1));
sem = [];
for i = 1:3
sem(1,i) = std(FR_Trial(:,i,1))/sqrt(length(FR_Trial(:,i,1)));
end
hold on
bar(x,y,'w','LineWidth',l_width)
errorbar(y,sem ,'k','LineStyle','none','LineWidth',l_width)
% xlabel('Object')
ylabel('Firing Rate (Hz)','fontsize',f_axis)
title('Forest','fontsize',f_title)
xticks([0.5 1.5 2.5 3.5])
xticklabels({'Cursor On', 'Object On' 'Go cue' 'Choice'})
ax = gca;
ax.XAxis.FontWeight = 'bold';
ax.YAxis.FontWeight = 'bold';
ax.XAxis.LineWidth = l_width;
ax.YAxis.LineWidth = l_width;
ax.XAxis.FontSize = f_legend;
ax.YAxis.FontSize = f_legend;

subplot(1,3,2)
x = (1:3);
y = mean(FR_Trial(:,:,2));
for i = 1:3
sem(i) = std(FR_Trial(:,i,2))/sqrt(length(FR_Trial(:,i,2)));
end
hold on
bar(x,y,'w','LineWidth',l_width)
errorbar(y,sem ,'k','LineStyle','none','LineWidth',l_width)
% xlabel('Object')
ylabel('Firing Rate (Hz)','fontsize',f_axis)
title('City','fontsize',f_title)
xticks([0.5 1.5 2.5 3.5])
xticklabels({'Cursor On', 'Object On' 'Go cue' 'Choice'})
ax = gca;
ax.XAxis.FontWeight = 'bold';
ax.YAxis.FontWeight = 'bold';
ax.XAxis.LineWidth = l_width;
ax.YAxis.LineWidth = l_width;
ax.XAxis.FontSize = f_legend;
ax.YAxis.FontSize = f_legend;

subplot(1,3,3)
x = (1:3);
y = vertcat(mean(FR_Trial(:,:,1)),mean(FR_Trial(:,:,2)));
hold on
b = bar(x,y','stacked','FaceColor','flat','LineWidth',l_width);
% errorbar(y(:,1),sem(1,:) ,'k','LineStyle','none')
b(2).CData = [237 195 49]/255;
b(1).CData = [146 208 80]/255;
ylabel('Firing Rate (Hz)','fontsize',f_axis)
xticks([0.5 1.5 2.5 3.5])
xticklabels({'Cursor On', 'Object On' 'Go cue' 'Choice'})
legend('Forest','City','Location','southoutside','Orientation','horizontal','fontsize',f_legend)
ax = gca;
ax.XAxis.FontWeight = 'bold';
ax.YAxis.FontWeight = 'bold';
ax.XAxis.LineWidth = l_width;
ax.YAxis.LineWidth = l_width;
ax.XAxis.FontSize = f_legend;
ax.YAxis.FontSize = f_legend;
%% FR btw Locations
figure
subplot(2,2,1)
y = nanmean(FR_Trial_Location(:,1:8,1));
for i = 1:8
sem(i) = nanstd(FR_Trial_Location(:,i,1))/sqrt(length(FR_Trial_Location((~isnan(FR_Trial_Location(:,i,1))),i,1)));
end
hold on
b = bar(y,'w','LineWidth',l_width,'FaceColor','flat');
errorbar(y,sem ,'k','LineStyle','none','LineWidth',l_width)
% errorbar(y,sem(1:4) ,'k','LineStyle','none')
% xlabel('Object')
ylabel('Firing Rate (Hz)','fontsize',f_axis)
title('Forest','fontsize',f_axis)
xticks(1:8)
xticklabels({'Loc1,out' 'Loc2,out', 'Loc3,out', 'Loc4,out', 'Loc4,in', 'Loc3,in', 'Loc2,in', 'Loc1,in'})
ax = gca;
ax.XAxis.FontWeight = 'bold';
ax.YAxis.FontWeight = 'bold';
ax.XAxis.LineWidth = l_width;
ax.YAxis.LineWidth = l_width;
ax.XAxis.FontSize = f_legend;
ax.YAxis.FontSize = f_legend;

asterisk = draw_asterisk(p_loc_f);

max_graph = max(y) + max(sem);
text(0,max_graph*1.1,asterisk,'FontSize',15);
ylim([0 max_graph*1.2])

subplot(2,2,2)
y = [nanmean(FR_Trial_Location(:,1:4,1));nanmean(FR_Trial_Location(:,5:8,1))];
% sem = std(FR_Trial_Location(:,:,1))/sqrt(length(FR_Trial_Location(:,:,1))/8);
hold on
b = bar(y','stacked','LineWidth',l_width,'FaceColor','flat');
% errorbar(y,sem(1:4) ,'k','LineStyle','none')
% xlabel('Object')
b(1).CData = [1 0 1];
b(2).CData= [0 1 1];
ylabel('Firing Rate (Hz)','fontsize',f_axis)
title('Forest','fontsize',f_axis)
xticks([1 2 3 4])
xticklabels({'Loc1' 'Loc2', 'Loc3', 'Loc4'})
legend('Outbound','Inbound','Location','southoutside','Orientation','horizontal','fontsize',f_legend)
ax = gca;
ax.XAxis.FontWeight = 'bold';
ax.YAxis.FontWeight = 'bold';
ax.XAxis.LineWidth = l_width;
ax.YAxis.LineWidth = l_width;
ax.XAxis.FontSize = f_legend;
ax.YAxis.FontSize = f_legend;

subplot(2,2,3)
y = nanmean(FR_Trial_Location(:,1:8,2));
for i = 1:8
sem(i) = nanstd(FR_Trial_Location(:,i,2))/sqrt(length(FR_Trial_Location((~isnan(FR_Trial_Location(:,i,2))),i,2)));
end
hold on
b = bar(y,'w','LineWidth',l_width,'FaceColor','flat');
errorbar(y,sem ,'k','LineStyle','none','LineWidth',l_width)
% errorbar(y,sem(1:4) ,'k','LineStyle','none')
% xlabel('Object')
ylabel('Firing Rate (Hz)','fontsize',f_axis)
title('Forest','fontsize',f_axis)
xticks(1:8)
xticklabels({'Loc1,out' 'Loc2,out', 'Loc3,out', 'Loc4,out', 'Loc4,in', 'Loc3,in', 'Loc2,in', 'Loc1,in'})
ax = gca;
ax.XAxis.FontWeight = 'bold';
ax.YAxis.FontWeight = 'bold';
ax.XAxis.LineWidth = l_width;
ax.YAxis.LineWidth = l_width;
ax.XAxis.FontSize = f_legend;
ax.YAxis.FontSize = f_legend;

asterisk = draw_asterisk(p_loc_c);

max_graph = max(y) + max(sem);
text(0,max_graph*1.1,asterisk,'FontSize',15);
ylim([0 max_graph*1.2])


subplot(2,2,4)
y = [nanmean(FR_Trial_Location(:,1:4,2));nanmean(FR_Trial_Location(:,5:8,2))];
% sem = std(FR_Trial_Location(:,:,1))/sqrt(length(FR_Trial_Location(:,:,1))/8);
hold on
b = bar(y','stacked','LineWidth',l_width,'FaceColor','flat');
% errorbar(y,sem(1:4) ,'k','LineStyle','none')
% xlabel('Object')
b(1).CData = [1 0 1];
b(2).CData= [0 1 1];
ylabel('Firing Rate (Hz)','fontsize',f_axis)
title('City','fontsize',f_axis)
xticks([1 2 3 4])
xticklabels({'Loc1' 'Loc2', 'Loc3', 'Loc4'})
legend('Outbound','Inbound','Location','southoutside','Orientation','horizontal','fontsize',f_legend)
ax = gca;
ax.XAxis.FontWeight = 'bold';
ax.YAxis.FontWeight = 'bold';
ax.XAxis.LineWidth = l_width;
ax.YAxis.LineWidth = l_width;
ax.XAxis.FontSize = f_legend;
ax.YAxis.FontSize = f_legend;


%% FR btw Contexts
figure
x = (1:2);
y = FR_Context_mean;
sem = FR_Context_sem;
hold on
b = bar(x,y,'w','LineWidth',l_width);
errorbar(y,sem ,'k','LineStyle','none','LineWidth',l_width)
xlabel('Context','fontsize',f_axis)
ylabel('Firing Rate (Hz)','fontsize',f_axis)
ax = gca;
ax.XAxis.FontWeight = 'bold';
ax.YAxis.FontWeight = 'bold';
ax.XAxis.LineWidth = l_width;
ax.YAxis.LineWidth = l_width;
ax.XAxis.FontSize = f_legend;
ax.YAxis.FontSize = f_legend;

xticks([1 2])
xticklabels({'Forest', 'City'})
b.FaceColor = 'flat';
b.CData(2,:) = [237 195 49]/255;
b.CData(1,:) = [146 208 80]/255;

asterisk = draw_asterisk(p_cxt);

max_graph = max(y) + max(sem);
line([1 2],[max_graph*1.1 max_graph*1.1],'Color','k','LineWidth',1.5);
line([1 1],[max_graph*1.05 max_graph*1.1],'Color','k','LineWidth',1.5);
line([2 2],[max_graph*1.05 max_graph*1.1],'Color','k','LineWidth',1.5);
text(1.4,max_graph*1.2,asterisk,'FontSize',15);
ylim([0 max_graph*1.3])
%% FR btw Objects
figure
subplot(1,3,1)
x = (1:6);
y = FR_Object_mean(1,1:6);
sem = FR_Object_sem(1,1:6);
hold on
bar(x,y,'w','LineWidth',l_width)
errorbar(y,sem ,'k','LineStyle','none','LineWidth',l_width)
xlabel('Object','fontsize',f_axis)
ylabel('Firing Rate (Hz)','fontsize',f_axis)
title('Forest','fontsize',f_title)
ax = gca;
ax.XAxis.FontWeight = 'bold';
ax.YAxis.FontWeight = 'bold';
ax.XAxis.LineWidth = l_width;
ax.YAxis.LineWidth = l_width;
ax.XAxis.FontSize = f_legend;
ax.YAxis.FontSize = f_legend;
xticks([1 2 3 4 5 6])
xticklabels({'Pumpkin', 'Donut', 'Jellyfish', 'Turtle', 'Pizza', 'Octopus'})
asterisk = draw_asterisk(p_obj_f);

max_graph = max(y) + max(sem);
text(0,max_graph*1.1,asterisk,'FontSize',15);
ylim([0 max_graph*1.2])


subplot(1,3,2)
x = (1:6);
y = FR_Object_mean(2,1:6);
sem = FR_Object_sem(2,1:6);
hold on
bar(x,y,'w','LineWidth',l_width)
errorbar(y,sem ,'k','LineStyle','none','LineWidth',l_width)
xlabel('Object','fontsize',f_axis)
ylabel('Firing Rate (Hz)','fontsize',f_axis)
ax = gca;
ax.XAxis.FontWeight = 'bold';
ax.YAxis.FontWeight = 'bold';
ax.XAxis.LineWidth = l_width;
ax.YAxis.LineWidth = l_width;
ax.XAxis.FontSize = f_legend;
ax.YAxis.FontSize = f_legend;
title('City','fontsize',f_title)
xticks([1 2 3 4 5 6])
xticklabels({'Pumpkin', 'Donut', 'Jellyfish', 'Turtle', 'Pizza', 'Octopus'})
asterisk = draw_asterisk(p_obj_c);

max_graph = max(y) + max(sem);
text(0,max_graph*1.1,asterisk,'FontSize',15);
ylim([0 max_graph*1.2])

subplot(1,3,3)
x = (1:6);
y = FR_Object_mean(1:2,1:6);
sem = FR_Object_sem(1:2,1:6);
sem = sem';
hold on
b = bar(x,y','stacked','FaceColor','flat','LineWidth',l_width);
ax = gca;
ax.XAxis.FontWeight = 'bold';
ax.YAxis.FontWeight = 'bold';
ax.XAxis.LineWidth = l_width;
ax.YAxis.LineWidth = l_width;
ax.XAxis.FontSize = f_legend;
ax.YAxis.FontSize = f_legend;
% errorbar(y(:,1),sem(1,:) ,'k','LineStyle','none')
b(2).CData = [237 195 49]/255;
b(1).CData = [146 208 80]/255;
xlabel('Object','fontsize',f_axis)
ylabel('Firing Rate (Hz)','fontsize',f_axis, 'fontweight','bold')
xticks([1 2 3 4 5 6])
xticklabels({'Pumpkin', 'Donut', 'Jellyfish', 'Turtle', 'Pizza', 'Octopus'})
legend('Forest','City','Location','southoutside','Orientation','horizontal','fontsize',f_legend)
%% FR btw Responses
figure
subplot(1,3,1)
x = (1:2);
y = FR_Response_mean(1,1:2);
sem = FR_Response_sem(1,1:2);
hold on
b = bar(x,y,'w','LineWidth',l_width);
errorbar(y,sem ,'k','LineStyle','none','LineWidth',l_width)
xlabel('Response','fontsize',f_axis)
ylabel('Firing Rate (Hz)','fontsize',f_axis)
xticks([1 2])
title('Forest','fontsize',f_title)
ax = gca;
ax.XAxis.FontWeight = 'bold';
ax.YAxis.FontWeight = 'bold';
ax.XAxis.LineWidth = l_width;
ax.YAxis.LineWidth = l_width;
ax.XAxis.FontSize = f_legend;
ax.YAxis.FontSize = f_legend;
xticklabels({'Left', 'Right'})
b.FaceColor = 'flat';
b.CData(1,:) = [0 0 255]/255;
b.CData(2,:) = [255 0 0]/255;

asterisk = draw_asterisk(p_resp_f);
max_graph = max(y) + max(sem);
line([1 2],[max_graph*1.1 max_graph*1.1],'Color','k','LineWidth',1.5);
line([1 1],[max_graph*1.05 max_graph*1.1],'Color','k','LineWidth',1.5);
line([2 2],[max_graph*1.05 max_graph*1.1],'Color','k','LineWidth',1.5);
text(1.4,max_graph*1.2,asterisk,'FontSize',15);
ylim([0 max_graph*1.3])


subplot(1,3,2)
x = (1:2);
y = FR_Response_mean(2,1:2);
sem = FR_Response_sem(2,1:2);
hold on
b = bar(x,y,'w','LineWidth',l_width);
errorbar(y,sem ,'k','LineStyle','none','LineWidth',l_width)
xlabel('Response','fontsize',f_axis)
ylabel('Firing Rate (Hz)','fontsize',f_axis)
xticks([1 2])
ax = gca;
ax.XAxis.FontWeight = 'bold';
ax.YAxis.FontWeight = 'bold';
ax.XAxis.LineWidth = l_width;
ax.YAxis.LineWidth = l_width;
ax.XAxis.FontSize = f_legend;
ax.YAxis.FontSize = f_legend;
title('City','fontsize',f_title)
xticklabels({'Left', 'Right'})
b.FaceColor = 'flat';
b.CData(1,:) = [0 0 255]/255;
b.CData(2,:) = [255 0 0]/255;

asterisk = draw_asterisk(p_resp_c);

max_graph = max(y) + max(sem);
line([1 2],[max_graph*1.1 max_graph*1.1],'Color','k','LineWidth',1.5);
line([1 1],[max_graph*1.05 max_graph*1.1],'Color','k','LineWidth',1.5);
line([2 2],[max_graph*1.05 max_graph*1.1],'Color','k','LineWidth',1.5);
text(1.4,max_graph*1.2,asterisk,'FontSize',15);
ylim([0 max_graph*1.3])

subplot(1,3,3)
x = (1:2);
y = FR_Response_mean(1:2,1:2);
sem = FR_Response_sem(1:2,1:2);
sem = sem';
hold on
b = bar(x,y','stacked','FaceColor','flat','LineWidth',l_width);
% errorbar(y(:,1),sem(1,:) ,'k','LineStyle','none')
b(2).CData = [237 195 49]/255;
b(1).CData = [146 208 80]/255;
xlabel('Object','fontsize',f_axis)
ylabel('Firing Rate (Hz)','fontsize',f_axis)
ax = gca;
ax.XAxis.FontWeight = 'bold';
ax.YAxis.FontWeight = 'bold';
ax.XAxis.LineWidth = l_width;
ax.YAxis.LineWidth = l_width;
ax.XAxis.FontSize = f_legend;
ax.YAxis.FontSize = f_legend;
xticks([1 2])
xticklabels({'Left', 'Right'})
legend('Forest','City','Location','southoutside','Orientation','horizontal','fontsize',f_legend)
