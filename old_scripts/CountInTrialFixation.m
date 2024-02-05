function CountInTrialFixation
%%

Fix_InObjRate = [];
% 
% figure;
% subplot(2,1,1)
for ol=1:6
    for i=1:5
        Fix_InObjRate(ol,i,1) = length(find(Fix_InObj(ol,:,3*i)==2));
        Fix_InObjRate(ol,i,2) = length(find((Fix_InObj(ol,:,3*i))==1));
         Fix_InObjRate(ol,i,3) = length(find((Fix_InObj(ol,:,3*i))==0));
%         Fix_InObjRate(3,ol,i) = Fix_InObjRate(1,ol,i) ./ (Fix_InObjRate(2,ol,i));
    end
    
end
plotBarStackGroups(Fix_InObjRate, {'Donut','Pumpkin','Turtle','Jellyfish','Octopus','Pizza'})
% for ol = 1:6
%     line([0.5+ol-1 0.5+ol], [ObjChanceLevel(2,ol) ObjChanceLevel(2,ol)],'Color', 'r'); line([0.5+ol-1 0.5+ol], [ObjChanceLevel(3,ol) ObjChanceLevel(3,ol)],'Color', 'b');
% end

xlabel('Object'); ylabel('# Fixation Point')
ylim([0 130]); xlim([0.5 6.5])
xticklabels({'Donut','Pumpkin','Turtle','Jellyfish','Octopus','Pizza'})



set(gca,'FontSize',15,'FontWeight','b')
% legend({'1st','2nd','3rd','4th','5th'},'Location','westoutside')
title('Number of Fixation Points on Object, Disc and Scene, left object only')

%%
% subplot(2,1,2)
Fix_InObjRate = [];
for ol=1:6
    or=ol+6;
    for i=1:5
        Fix_InObjRate(ol,i,1) = length(find(Fix_InObj(or,:,3*i)==2));
        Fix_InObjRate(ol,i,2) = length(find((Fix_InObj(or,:,3*i))==1));
         Fix_InObjRate(ol,i,3) = length(find((Fix_InObj(or,:,3*i))==0));
%         Fix_InObjRate(3,ol,i) = Fix_InObjRate(1,ol,i) ./ (Fix_InObjRate(2,ol,i));
    end
end
plotBarStackGroups(Fix_InObjRate, {'Donut','Pumpkin','Turtle','Jellyfish','Octopus','Pizza'})
% for ol = 1:6
%     line([0.5+ol-1 0.5+ol], [ObjChanceLevel(2,ol) ObjChanceLevel(2,ol)],'Color', 'r'); line([0.5+ol-1 0.5+ol], [ObjChanceLevel(3,ol) ObjChanceLevel(3,ol)],'Color', 'b');
% end

xlabel('Object'); ylabel('# Fixation Point')
ylim([0 130]); xlim([0.5 6.5])
xticklabels({'Donut','Pumpkin','Turtle','Jellyfish','Octopus','Pizza'})



set(gca,'FontSize',15,'FontWeight','b')
% legend({'1st','2nd','3rd','4th','5th'},'Location','westoutside')
title('Number of Fixation Points on Object, Disc and Scene, right object only')

%%
% subplot(2,1,2)
Fix_InObjRate_All = zeros(5,10); Fix_InObjRate_temp=NaN(NTrials,10);
% Fix_InObj=1;
for ol=1:6
    or=ol+6;
    for i=1:5
        
        Fix_InObjRate_All(2,i) = Fix_InObjRate_All(2,i)+length(find(Fix_InObj(ol,:,3*i,1)==1));
        Fix_InObjRate_All(3,i) = Fix_InObjRate_All(3,i)+length(find(Fix_InObj(ol,:,3*i,1)==2));
        Fix_InObjRate_All(4,i) = Fix_InObjRate_All(4,i)+length(find(Fix_InObj(or,:,3*i,1)==1));
        Fix_InObjRate_All(5,i) = Fix_InObjRate_All(5,i)+length(find(Fix_InObj(or,:,3*i,1)==2));
        
        Fix_InObjRate_All(2,i+5) = Fix_InObjRate_All(2,i+5)+length(find(Fix_InObj(ol,:,3*i,2)==1));
        Fix_InObjRate_All(3,i+5) = Fix_InObjRate_All(3,i+5)+length(find(Fix_InObj(ol,:,3*i,2)==2));
        Fix_InObjRate_All(4,i+5) = Fix_InObjRate_All(4,i+5)+length(find(Fix_InObj(or,:,3*i,2)==1));
        Fix_InObjRate_All(5,i+5) = Fix_InObjRate_All(5,i+5)+length(find(Fix_InObj(or,:,3*i,2)==2));
    end
end
for i = 1:5
for j = 1:NTrials
    if max(max(~isnan(Fix_InObj(:,j,3*i,1))))
        Fix_InObjRate_temp(j,i) = nansum(Fix_InObj(:,j,3*i,1),1)';
    else
        Fix_InObjRate_temp(j,i) = NaN;
    end
    
    
    if max(max(~isnan(Fix_InObj(:,j,3*i,2))))
        Fix_InObjRate_temp(j,i+5) = nansum(Fix_InObj(:,j,3*i,2),1)';
    else
        Fix_InObjRate_temp(j,i+5) = NaN;
    end
    
end
  Fix_InObjRate_All(1,i) = length(find(Fix_InObjRate_temp(:,i)==0));  
  Fix_InObjRate_All(1,i+5) = length(find(Fix_InObjRate_temp(:,i+5)==0));
end



figure;
p1 = plot((1:10),Fix_InObjRate_All(1,:),'-ko','LineWidth',2,'MarkerSize',10);
hold on
p2 = plot((1:10),Fix_InObjRate_All(2,:),'-o','Color',	'#EDB120','LineWidth',2,'MarkerSize',10);
p3 = plot((1:10),Fix_InObjRate_All(3,:),'-ro','LineWidth',2,'MarkerSize',10);
p4 = plot((1:10),Fix_InObjRate_All(4,:),'-o','Color','#4DBEEE','LineWidth',2,'MarkerSize',10);
p5 = plot((1:10),Fix_InObjRate_All(5,:),'-o','Color','#0072BD','LineWidth',2,'MarkerSize',10);
line([5.5 5.5],[0 max(max(Fix_InObjRate_All(:,:)))],'Color','k')

set(gca,'FontSize',15,'FontWeight','b')
xticks(1:1:10); xticklabels({'1','2','3','4','5','1','2','3','4','5'})
legend([p1 p2 p3 p4 p5], {'Scene','L-Disc','L-Obj','R-Disc','R-Obj'},'Location','north')
title('Number of Fixation Points, All Choice Directions','Fontsize', 20)
ylabel('Number of Fixation Points'); ylim([0 600])

%%
Fix_Sequence=[];
for o = 1:6
Fix_Sequence(o,:,1:5) = Fix_InObj(o,:,3:3:15,1);
Fix_Sequence(o,:,6:10) = Fix_InObj(o,:,3:3:15,2);
end

%%
Fix_Seq=[];

for a1 = 0:2
    Fix_Seq_temp = isequal_All(Fix_Sequence,[a1],NTrials);
    Fix_Seq(a1*9+1,1) = length(Fix_Seq_temp);
    
    for a2 = 0:2
        Fix_Seq_temp = isequal_All(Fix_Sequence,[a1 a2],NTrials);
        Fix_Seq(a1*9+a2*3+1,2) = length(Fix_Seq_temp);
        
        for a3 = 0:2
            Fix_Seq_temp = isequal_All(Fix_Sequence,[a1 a2 a3],NTrials);
            Fix_Seq(a1*9+a2*3+a3+1,3) = length(Fix_Seq_temp);
            
        end
    end
    
end
%%
% figure;
% img= imread('Cursor_L5.jpg');
% imshow(img);
% hold on
% id = find(and(and(FixPoint_All(:,6)==3,FixPoint_All(:,15)==-5),FixPoint_All(:,16)==5));
% scatter(FixPoint_All(id,1),FixPoint_All(id,2),'r','filled')
% id = find(and(and(FixPoint_All(:,6)==3,FixPoint_All(:,15)==-5),FixPoint_All(:,16)~=5));
% scatter(FixPoint_All(id,1),FixPoint_All(id,2),'b','filled')

%%
Fix_InObjRate_Cursor = [];
for c=1:12
    if c==6
        for i = 1:6
            Fix_InObjRate_Cursor(i,c) = length(find(and(and(and(FixPoint_All(:,6)==3,FixPoint_All(:,15)==0),FixPoint_All(:,16)==i-1),FixPoint_All(:,9)==1)));
        end
    elseif c==7
        for i = 1:6
            Fix_InObjRate_Cursor(i,c) = length(find(and(and(and(FixPoint_All(:,6)==3,FixPoint_All(:,15)==0),FixPoint_All(:,16)==i-1),FixPoint_All(:,9)==2)));
        end
    elseif c>7
        for i = 1:6
            Fix_InObjRate_Cursor(i,c) = length(find(and(and(and(FixPoint_All(:,6)==3,FixPoint_All(:,15)==c-7),FixPoint_All(:,16)==i-1),FixPoint_All(:,9)==2)));
        end
    elseif c<6
        for i = 1:6
            Fix_InObjRate_Cursor(i,c) = length(find(and(and(and(FixPoint_All(:,6)==3,FixPoint_All(:,15)==c-6),FixPoint_All(:,16)==i-1),FixPoint_All(:,9)==1)));
        end
    end
        
    Fix_InObjRate_Cursor(:,c) = Fix_InObjRate_Cursor(:,c)/sum(Fix_InObjRate_Cursor(:,c));
end

y=size(Fix_InObjRate_Cursor,2);
figure;
p1 = plot((1:y),Fix_InObjRate_Cursor(1,:),'-ko','LineWidth',2,'MarkerSize',10);
hold on
p6 = plot((1:y),Fix_InObjRate_Cursor(6,:),'-*','Color',[0.5 0.5 0.5],'LineWidth',2,'MarkerSize',10);
% p2 = plot((1:y),Fix_InObjRate_Cursor(2,:),'-o','Color',	'#EDB120','LineWidth',2,'MarkerSize',10);
p3 = plot((1:y),Fix_InObjRate_Cursor(3,:),'-ro','LineWidth',2,'MarkerSize',10);
% p4 = plot((1:y),Fix_InObjRate_Cursor(4,:),'-o','Color','#4DBEEE','LineWidth',2,'MarkerSize',10);
p5 = plot((1:y),Fix_InObjRate_Cursor(5,:),'-o','Color','#0072BD','LineWidth',2,'MarkerSize',10);

line([6.5 6.5],[0 1],'Color','k')

set(gca,'FontSize',15,'FontWeight','b')
xticks(1:1:y); xticklabels({'L5','L4','L3','L2','L1','L0','R0','R1','R2','R3','R4','R5'}); xlabel('Cursor Position'); xlim([0 13])
legend([p1 p6 p3 p5], {'Out-Object','In-Cursor','In-Left Obj','In-Right Obj'},'Location','eastoutside')
title('Number of Fixation Points, All Choice Directions (normalized)','Fontsize', 20)
ylabel('Number of Fixation Points'); ylim([0 1])

%%
cmap = jet(6);
sz = 15;
figure;
im = imread('Cxt_AllLocCI.png');
imshow(im);
hold on
colormap jet
for c=1:6

            id = find(and(and(and(FixPoint_All(:,6)==3,FixPoint_All(:,15)==c-6),1),FixPoint_All(:,9)==1));
            scatter(FixPoint_All(id,1),FixPoint_All(id,2),sz,cmap(c,:),'filled');
end
legend({'L0','L1','L2','L3','L4','L5'});

figure;
imshow(im);
hold on
colormap jet
for c=6:11
c1=12-c;

            id = find(and(and(and(FixPoint_All(:,6)==3,FixPoint_All(:,15)==c-6),1),FixPoint_All(:,9)==2));
            scatter(FixPoint_All(id,1),FixPoint_All(id,2),sz,cmap(7-c1,:),'filled');
end
legend({'R0','R1','R2','R3','R4','R5'});

%% Choice Phase scatter with line
index = horzcat(Eye_Analog_sync_recording_info,JoystickID_Eye);

cmap = jet(NTrials);
sz = 20; lw=2; n=1000;
cd = [uint8(jet(n)*255) uint8(ones(n,1))].';
im = imread('Cxt_AllLocCI_NC.jpg');



for c = 1:6
figure;
imshow(im);
hold on
im2 = image(squeeze(CursorBoundary(c,:,:)));
im2.AlphaData = squeeze(CursorBoundary(c,:,:)*255);




hold on
for t = 1:NTrials

id = find(and(and(and(and(index(:,6)==3,index(:,15)==c-6),index(:,11)==1),index(:,9)==1),index(:,12)==t));
if ~isempty(id)
    x = (X_lp(id)+5)*200; u = (X_lp(id(end))+5)*200;
    y = (Y_lp(id)+5)*112.5; v = (Y_lp(id(end))+5)*112.5;
plot(x,y,'color', 'y','LineWidth',lw);
scatter(u,v,sz,'y','filled')
end
end
id = find(and(and(and(and(FixPoint_All(:,6)==3,FixPoint_All(:,15)==c-6),FixPoint_All(:,11)==1),FixPoint_All(:,9)==1),1));
scatter(FixPoint_All(id,1),FixPoint_All(id,2),sz,'r','filled');
hold off
end

for c = 6:11

figure;
imshow(im);
hold on
im2 = image(squeeze(CursorBoundary(c,:,:)));
im2.AlphaData = squeeze(CursorBoundary(c,:,:)*255);
hold on
for t = 1:NTrials
id = find(and(and(and(and(index(:,6)==3,index(:,15)==c-6),index(:,11)==1),index(:,9)==2),index(:,12)==t));
if ~isempty(id)
    x = (X_lp(id)+5)*200; u = (X_lp(id(end))+5)*200;
    y = (Y_lp(id)+5)*112.5; v = (Y_lp(id(end))+5)*112.5;
plot(x,y,'color', 'y','LineWidth',lw);
scatter(u,v,sz,'y','filled')
end
end
id = find(and(and(and(and(FixPoint_All(:,6)==3,FixPoint_All(:,15)==c-6),FixPoint_All(:,11)==1),FixPoint_All(:,9)==2),1));
scatter(FixPoint_All(id,1),FixPoint_All(id,2),sz,'r','filled');
hold off
end

%% Sample Phase scatter
index = horzcat(Eye_Analog_sync_recording_info,JoystickID_Eye);

cmap = jet(NTrials);
sz = 20; lw=2; n=1000;
cd = [uint8(jet(n)*255) uint8(ones(n,1))].';
im = imread('Cxt_AllLocCI.png');



figure;
imshow(im);
hold on
id = find(and(and(and(and(FixPoint_All(:,6)==2,1),FixPoint_All(:,11)==1),FixPoint_All(:,9)==1),1));
scatter(FixPoint_All(id,1),FixPoint_All(id,2),sz,'r','filled');
hold off



figure;
imshow(im);
hold on

id = find(and(and(and(and(FixPoint_All(:,6)==2,1),FixPoint_All(:,11)==1),FixPoint_All(:,9)==2),1));
scatter(FixPoint_All(id,1),FixPoint_All(id,2),sz,'b','filled');
hold off


%% Fixation Point Pie Plot_1

clear FixPoint_Sample_order FixPoint_Sample_order_length
phase = FixPoint_All(:,6); corr = FixPoint_All(:,11); void = FixPoint_All(:,13);
NTrials = max(FixPoint_All(:,12));
FixPoint_Sample = sortrows(FixPoint_All(and(phase==2,and(corr,~void)),:),12);
for t = 1:NTrials
    ID = mink(FixPoint_Sample(FixPoint_Sample(:,12)==t,3),3);
    if length(ID) >= 3
        id = ID(3);
        FixPoint_Sample_order(t,:,5) = FixPoint_Sample(find(FixPoint_Sample(:,3)==id),:);
        FixPoint_Sample_order(t,:,4) = FixPoint_Sample(find(FixPoint_Sample(:,3)==id),:);
        FixPoint_Sample_order(t,1:2,4) = sum([FixPoint_Sample(find(FixPoint_Sample(:,3)==ID(1)),1:2);FixPoint_Sample(find(FixPoint_Sample(:,3)==ID(2)),1:2);FixPoint_Sample(find(FixPoint_Sample(:,3)==ID(3)),1:2)],1)/3;
        FixPoint_Sample_order(t,16,4) = FixPoint_Sample(find(FixPoint_Sample(:,3)==id),17);
    end
    
    if length(ID) >= 2
        id = ID(2);
        FixPoint_Sample_order(t,:,3) = FixPoint_Sample(find(FixPoint_Sample(:,3)==id),:);
        FixPoint_Sample_order(t,:,2) = FixPoint_Sample(find(FixPoint_Sample(:,3)==id),:);
        FixPoint_Sample_order(t,1:2,2) = sum([FixPoint_Sample(find(FixPoint_Sample(:,3)==ID(1)),1:2);FixPoint_Sample(find(FixPoint_Sample(:,3)==ID(2)),1:2)],1)/2;
        FixPoint_Sample_order(t,16,2) = FixPoint_Sample(find(FixPoint_Sample(:,3)==id),17);
    end
    
    if length(ID) >= 1
        id = ID(1);
    FixPoint_Sample_order(t,:,1) = FixPoint_Sample(find(FixPoint_Sample(:,3)==id),:);
    end
end
%% Fixation Point Pie Plot_2
for i = 1:5
    for d = 1:2
        for c = 1:6
            FixPoint_Sample_order_length(d,c,i) = length(find(and(FixPoint_Sample_order(:,10,i)==d,FixPoint_Sample_order(:,16,i)==c-1)));
        end
    end
end
%% Fixation Point Pie Plot_3
figure
for i1 = 1:3
i = (i1-1)*2+1;

c = ([0 0 0; 1 0.7 0.7; 1 0 0; 0.7 0.7 1; 0 0 1; 0.7 0.7 0.7]);

for p=1:2
    subplot(3,2,2*(i1-1)+p)
Res = Res_Name(p);
data = FixPoint_Sample_order_length(p,:,i);
data(data==0)=10^(-6);
nonZeroIndexes = find([data] > 0);
labels = {'Out-Disc','Left Disc','Left Obj.','Right Disc','Right Obj.','Cursor'};

pie(data);
colormap(c(nonZeroIndexes,:))
title(['Fixation #' num2str(i1) ', ' Res ' Choice (' num2str(sum(FixPoint_Sample_order_length(p,:,i))) ' points total)' ],'FontSize',10,'FontWeight','b')
% legend(labels,'Location','southoutside')
saveas(gcf,[animal_id '_FixPoint_Sample_' Res num2str(i) '.png'])

end

end

%%
cmap = jet(5);
sz = 20; lw=2; n=1000;
cd = [uint8(jet(n)*255) uint8(ones(n,1))].';
figure;
im = imread('Cxt_AllLocCI_NC.jpg');
imshow(im)
phase = FixPoint_All(:,6); corr = FixPoint_All(:,11); void = FixPoint_All(:,13);
hold on
id = find(FixPoint_Sample_order(:,9,1)==1);

scatter(FixPoint_Sample_order(id,1,1),FixPoint_Sample_order(id,2,1),sz,cmap(1,:),'filled')

hold on
id = find(FixPoint_Sample_order(:,9,3)==1);
scatter(FixPoint_Sample_order(id,1,3),FixPoint_Sample_order(id,2,3),sz,cmap(3,:),'filled')

hold on
id = find(FixPoint_Sample_order(:,9,5)==1);
scatter(FixPoint_Sample_order(id,1,5),FixPoint_Sample_order(id,2,5),sz,cmap(5,:),'filled')

end
