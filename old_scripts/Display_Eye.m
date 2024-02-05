%%  Eye gaze ratemap
img = imread('Diagram.png');
figure
subplot(2,3,1)
image(1:190,1:106,img)
hold on
Display_EyeGaze(Eye_Analog_sync_recording_forest_left)
title('Forest, Left choice','fontsize',f_title)
alpha(0.5)

subplot(2,3,2)
image(1:190,1:106,img)
hold on
Display_EyeGaze(Eye_Analog_sync_recording_forest_right)
title('Forest, Right choice','fontsize',f_title)
alpha(0.5)

subplot(2,3,3)
image(1:190,1:106,img)
hold on
Display_EyeGaze(Eye_Analog_sync_recording_forest_COnly)
title('Forest, Object Absent','fontsize',f_title)
alpha(0.5)

subplot(2,3,4)
image(1:190,1:106,img)
hold on
Display_EyeGaze(Eye_Analog_sync_recording_city_left)
title('City, Left choice','fontsize',f_title)
alpha(0.5)

subplot(2,3,5)
image(1:190,1:106,img)
hold on
Display_EyeGaze(Eye_Analog_sync_recording_city_right)
title('City, Right choice','fontsize',f_title)
alpha(0.5)

subplot(2,3,6)
image(1:190,1:106,img)
hold on
Display_EyeGaze(Eye_Analog_sync_recording_city_COnly)
title('City, Object Absent','fontsize',f_title)
alpha(0.5)


%% Eye gaze skaggsmap
%
% img = imread('Diagram.png');
% Range = max( [Eye_ForestMaxFR Eye_CityMaxFR] ) * 1.1;
%
% subplot('Position',[0.65 0.22 0.1 0.15])
% image(1:65,1:49,img)
% hold on
% Display_EyegazeRatemap(Eye_forest_left_skaggsrateMat, Range)
% title('Forest, Left choice')
% alpha(0.5)
%
%
%
% subplot('Position',[0.76 0.22 0.1 0.15])
% image(1:65,1:49,img)
% hold on
% Display_EyegazeRatemap(Eye_forest_right_skaggsrateMat, Range)
% title('Forest, Right choice')
% alpha(0.5)
%
% subplot('Position',[0.87 0.22 0.12 0.15])
% image(1:65,1:49,img)
% hold on
% Display_EyegazeRatemap(Eye_forest_COnly_skaggsrateMat, Range)
% title('Forest, Object Absent')
% alpha(0.5)
% colorbar('eastoutside');
%
% subplot('Position',[0.65 0.05 0.1 0.15])
% image(1:65,1:49,img)
% hold on
% Display_EyegazeRatemap(Eye_city_left_skaggsrateMat, Range)
% title('City, Left choice')
% alpha(0.5)
%
% subplot('Position',[0.76 0.05 0.1 0.15])
% image(1:65,1:49,img)
% hold on
% Display_EyegazeRatemap(Eye_city_right_skaggsrateMat, Range)
% title('City, Right choice')
% alpha(0.5)
%
% subplot('Position',[0.87 0.05 0.1 0.15])
% image(1:65,1:49,img)
% hold on
% Display_EyegazeRatemap(Eye_city_COnly_skaggsrateMat, Range)
% title('City, Object Absent')
% alpha(0.5)
%
% % subplot('Position',[0.98 0.03 0.02 0.47])
%
%
% function Display_EyegazeRatemap(Eye_skaggsrateMat, Range)
% imagesc((Eye_skaggsrateMat));
%         colormap(jet);
%     thisAlphaZ = Eye_skaggsrateMat;
%     thisAlphaZ(isnan(Eye_skaggsrateMat)) = 0;
%     thisAlphaZ(~isnan(Eye_skaggsrateMat)) = 1;
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
%     hold on
% MAXcolor=max(maxColor);
% if MAXcolor<1
%     MAXcolor=1;
% end
% set(gca,'CLim', [0 maxColor(1)]);
% caxis([0 Range])
% end


%% Eye raw firing scatterplot

img = imread('Diagram.png');
Range = max( [Eye_ForestMaxFR Eye_CityMaxFR] ) * 1.1;
figure;
subplot(2,3,1)
hold on
plot((Eye_Analog_sync_recording_forest_left(:,2)),(Eye_Analog_sync_recording_forest_left(:,3)),'MarkerSize',5,'Marker','.','LineWidth',2,'LineStyle','none',...
    'Color',[0.501960813999176 0.501960813999176 0.501960813999176]);
hold on
plot((spk_eye_forest_left(:,2)),(spk_eye_forest_left(:,3)), 'MarkerSize',10,'Marker','.','LineWidth',2,'LineStyle','none',...
    'Color','r');
title('Forest, Left choice')
xlim([0 1910]); ylim([0 1080])
set(gca,'YDir','reverse');
hold on
Diagram = image(1:1920,1:1080,img);
Diagram.AlphaData = 0.5;

subplot(2,3,2)
hold on
plot((Eye_Analog_sync_recording_forest_right(:,2)),(Eye_Analog_sync_recording_forest_right(:,3)),'MarkerSize',5,'Marker','.','LineWidth',2,'LineStyle','none',...
    'Color',[0.501960813999176 0.501960813999176 0.501960813999176]);
hold on
plot((spk_eye_forest_right(:,2)),(spk_eye_forest_right(:,3)), 'MarkerSize',10,'Marker','.','LineWidth',2,'LineStyle','none',...
    'Color','r');
title('Forest, Right choice')
xlim([0 1910]); ylim([0 1080])
set(gca,'YDir','reverse');
hold on
Diagram = image(1:1920,1:1080,img);
Diagram.AlphaData = 0.5;

subplot(2,3,3)
hold on
plot((Eye_Analog_sync_recording_forest_COnly(:,2)),(Eye_Analog_sync_recording_forest_COnly(:,3)),'MarkerSize',5,'Marker','.','LineWidth',2,'LineStyle','none',...
    'Color',[0.501960813999176 0.501960813999176 0.501960813999176]);
hold on
plot((spk_eye_forest_COnly(:,2)),(spk_eye_forest_COnly(:,3)), 'MarkerSize',10,'Marker','.','LineWidth',2,'LineStyle','none',...
    'Color','r');
title('Forest, Object Absent')
xlim([0 1910]); ylim([0 1080])
set(gca,'YDir','reverse');
hold on
Diagram = image(1:1920,1:1080,img);
Diagram.AlphaData = 0.5;

subplot(2,3,4)
hold on
plot((Eye_Analog_sync_recording_city_left(:,2)),(Eye_Analog_sync_recording_city_left(:,3)),'MarkerSize',5,'Marker','.','LineWidth',2,'LineStyle','none',...
    'Color',[0.501960813999176 0.501960813999176 0.501960813999176]);
hold on
plot((spk_eye_city_left(:,2)),(spk_eye_city_left(:,3)), 'MarkerSize',10,'Marker','.','LineWidth',2,'LineStyle','none',...
    'Color','r');
title('City, Left choice')
xlim([0 1910]); ylim([0 1080])
set(gca,'YDir','reverse');
hold on
Diagram = image(1:1920,1:1080,img);
Diagram.AlphaData = 0.5;

subplot(2,3,5)
hold on
plot((Eye_Analog_sync_recording_city_right(:,2)),(Eye_Analog_sync_recording_city_right(:,3)),'MarkerSize',5,'Marker','.','LineWidth',2,'LineStyle','none',...
    'Color',[0.501960813999176 0.501960813999176 0.501960813999176]);
hold on
plot((spk_eye_city_right(:,2)),(spk_eye_city_right(:,3)), 'MarkerSize',10,'Marker','.','LineWidth',2,'LineStyle','none',...
    'Color','r');
title('City, Right choice')
xlim([0 1910]); ylim([0 1080])
set(gca,'YDir','reverse');
hold on
Diagram = image(1:1920,1:1080,img);
Diagram.AlphaData = 0.5;

subplot(2,3,6)
hold on
plot((Eye_Analog_sync_recording_city_COnly(:,2)),(Eye_Analog_sync_recording_city_COnly(:,3)),'MarkerSize',5,'Marker','.','LineWidth',2,'LineStyle','none',...
    'Color',[0.501960813999176 0.501960813999176 0.501960813999176]);
hold on
plot((spk_eye_city_COnly(:,2)),(spk_eye_city_COnly(:,3)), 'MarkerSize',10,'Marker','.','LineWidth',2,'LineStyle','none',...
    'Color','r');
title('City, Object Absent')
xlim([0 1910]); ylim([0 1080])
set(gca,'YDir','reverse');
hold on
Diagram = image(1:1920,1:1080,img);
Diagram.AlphaData = 0.5;

%%

figure
subplot(2,3,1)
x = (1:3);
y = [nanmean(Eye_FR_Overall_LeftDisc), nanmean(Eye_FR_Overall_InterDisc), nanmean(Eye_FR_Overall_RightDisc)];
hold on
b = bar(x,y,'w','LineWidth',l_width);
title('Overall','fontsize',f_title)
xticks([1 2 3])
xticklabels({'LeftDisc', 'Between-Disc', 'RightDisc'})
asterisk = draw_asterisk(p_eye_o);
text(0,max_graph*1.1,asterisk,'FontSize',15);
ylim([0 max_graph*1.2])
xlabel('Eye gaze','fontsize',f_axis)
ylabel('Firing Rate (Hz)','fontsize',f_axis)
ax = gca;
ax.XAxis.FontWeight = 'bold';
ax.YAxis.FontWeight = 'bold';
ax.XAxis.LineWidth = l_width;
ax.YAxis.LineWidth = l_width;
ax.XAxis.FontSize = f_legend;
ax.YAxis.FontSize = f_legend;
b.FaceColor = 'flat';
b.CData(1,:) = [0 0 255]/255;
b.CData(2,:) = [0 0 0]/255;
b.CData(3,:) = [255 0 0]/255;
 

subplot(2,3,2)
x = (1:3);
y = [nanmean(Eye_FR_Forest_Left_LeftDisc), nanmean(Eye_FR_Forest_Left_InterDisc), nanmean(Eye_FR_Forest_Left_RightDisc)];
hold on
b = bar(x,y,'w','LineWidth',l_width);
title('Forest, Left Choice','fontsize',f_title)
xlabel('Eye gaze','fontsize',f_axis)
ylabel('Firing Rate (Hz)','fontsize',f_axis)
xticks([1 2 3])
xticklabels({'LeftDisc', 'Between-Disc', 'RightDisc'})
asterisk = draw_asterisk(p_eye_f_l);
text(0,max_graph*1.1,asterisk,'FontSize',15);
ylim([0 max_graph*1.2])
ax = gca;
ax.XAxis.FontWeight = 'bold';
ax.YAxis.FontWeight = 'bold';
ax.XAxis.LineWidth = l_width;
ax.YAxis.LineWidth = l_width;
ax.XAxis.FontSize = f_legend;
ax.YAxis.FontSize = f_legend;
b.FaceColor = 'flat';
b.CData(1,:) = [0 0 255]/255;
b.CData(2,:) = [0 0 0]/255;
b.CData(3,:) = [255 0 0]/255;


subplot(2,3,3)
x = (1:3);
y = [nanmean(Eye_FR_Forest_Right_LeftDisc), nanmean(Eye_FR_Forest_Right_InterDisc), nanmean(Eye_FR_Forest_Right_RightDisc)];
sem = [nanstd(Eye_FR_Forest_Right_LeftDisc)/length(Eye_FR_Forest_Right_LeftDisc(~isnan(Eye_FR_Forest_Right_LeftDisc))),...
    nanstd(Eye_FR_Forest_Right_InterDisc)/length(Eye_FR_Forest_Right_InterDisc(~isnan(Eye_FR_Forest_Right_InterDisc))),...
    nanstd(Eye_FR_Forest_Right_RightDisc)/length(Eye_FR_Forest_Right_RightDisc(~isnan(Eye_FR_Forest_Right_RightDisc)))];
hold on
b = bar(x,y,'w','LineWidth',l_width);
errorbar(y,sem ,'k','LineStyle','none','LineWidth',l_width);
title('Forest, Right Choice','fontsize',f_title)
xlabel('Eye gaze','fontsize',f_axis)
ylabel('Firing Rate (Hz)','fontsize',f_axis)
xticks([1 2 3])
xticklabels({'LeftDisc', 'Between-Disc', 'RightDisc'})
asterisk = draw_asterisk(p_eye_f_r);
text(0,max_graph*1.1,asterisk,'FontSize',15);
ylim([0 max_graph*1.2])
ax = gca;
ax.XAxis.FontWeight = 'bold';
ax.YAxis.FontWeight = 'bold';
ax.XAxis.LineWidth = l_width;
ax.YAxis.LineWidth = l_width;
ax.XAxis.FontSize = f_legend;
ax.YAxis.FontSize = f_legend;
b.FaceColor = 'flat';
b.CData(1,:) = [0 0 255]/255;
b.CData(2,:) = [0 0 0]/255;
b.CData(3,:) = [255 0 0]/255;

subplot(2,3,5)
x = (1:3);
y = [nanmean(Eye_FR_City_Left_LeftDisc), nanmean(Eye_FR_City_Left_InterDisc), nanmean(Eye_FR_City_Left_RightDisc)];
hold on
b = bar(x,y,'w','LineWidth',l_width);
title('City, Left Choice','fontsize',f_title)
xlabel('Eye gaze','fontsize',f_axis)
ylabel('Firing Rate (Hz)','fontsize',f_axis)
xticks([1 2 3])
xticklabels({'LeftDisc', 'Between-Disc', 'RightDisc'})
asterisk = draw_asterisk(p_eye_c_l);
text(0,max_graph*1.1,asterisk,'FontSize',15);
ylim([0 max_graph*1.2])
ax = gca;
ax.XAxis.FontWeight = 'bold';
ax.YAxis.FontWeight = 'bold';
ax.XAxis.LineWidth = l_width;
ax.YAxis.LineWidth = l_width;
ax.XAxis.FontSize = f_legend;
ax.YAxis.FontSize = f_legend;
b.FaceColor = 'flat';
b.CData(1,:) = [0 0 255]/255;
b.CData(2,:) = [0 0 0]/255;
b.CData(3,:) = [255 0 0]/255;


subplot(2,3,6)
x = (1:3);
y = [nanmean(Eye_FR_City_Right_LeftDisc), nanmean(Eye_FR_City_Right_InterDisc), nanmean(Eye_FR_City_Right_RightDisc)];
hold on
b = bar(x,y,'w','LineWidth',l_width);
title('City, Right Choice','fontsize',f_title)
xlabel('Eye gaze','fontsize',f_axis)
ylabel('Firing Rate (Hz)','fontsize',f_axis)
xticks([1 2 3])
xticklabels({'LeftDisc', 'Between-Disc', 'RightDisc'})
asterisk = draw_asterisk(p_eye_c_r);
text(0,max_graph*1.1,asterisk,'FontSize',15);
ylim([0 max_graph*1.2])
ax = gca;
ax.XAxis.FontWeight = 'bold';
ax.YAxis.FontWeight = 'bold';
ax.XAxis.LineWidth = l_width;
ax.YAxis.LineWidth = l_width;
ax.XAxis.FontSize = f_legend;
ax.YAxis.FontSize = f_legend;
b.FaceColor = 'flat';
b.CData(1,:) = [0 0 255]/255;
b.CData(2,:) = [0 0 0]/255;
b.CData(3,:) = [255 0 0]/255;

