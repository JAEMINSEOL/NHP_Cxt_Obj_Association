%%
Int_Fix = []; Ori_Fix=[];
for l=1:76
    for d=1:2

id = find(and(and((TickLog_sync_recording_info(:,12)>=(l-1)*8+1),(TickLog_sync_recording_info(:,12)<=l*8)),...
    and(and((TickLog_sync_recording_info(:,5)>=10*(d-1)),(TickLog_sync_recording_info(:,5)<=10*d)),TickLog_sync_recording_info(:,6)<=0)));


Fix = squeeze(FixPoint_InterTrial(l,d,:,:)); Fix(isnan(Fix(:,4)),:)=[];
Int = squeeze(intersection(l,d,:,:)); Int(isnan(Int(:,4)),:)=[]; 
Ori = squeeze(origin(l,d,:,:)); Ori(isnan(Ori(:,4)),:)=[];

Int(:,5)= id(1:size(Int,1));
Ori(:,5)= id(1:size(Ori,1));

% Fix(:,4)=knnsearch(TickLog_sync_recording_info(:,1),Eye_Analog_sync_recording_info(Fix(:,3),1));
% Fix(:,5)=squeeze(FixPoint_InterTrial(l,d,knnsearch(squeeze(FixPoint_InterTrial(l,d,:,4)),Fix(:,4)),5));
Fix(Fix(:,4)>length(Int),:)=[]; 
[C,ia,ic] = unique(Fix(:,4),'rows');
Fix = Fix(ia,:);
Fix(Fix(:,4)==0,:)=[];
Int_Fix_temp = [Int(Fix(:,4),:)];

Int_Fix_temp(Int_Fix_temp(:,4)==0,:)=[];
Int_Fix_temp(:,6:15) = TickLog_sync_recording_info(Int_Fix_temp(:,5),4:13);
Int_Fix_temp(:,16) = Fix(:,5);
Int_Fix = vertcat(Int_Fix,Int_Fix_temp);

Ori_Fix_temp = [Ori(Fix(:,4),:)];

Ori_Fix_temp(Ori_Fix_temp(:,4)==0,:)=[];
Ori_Fix_temp(:,6:15) = TickLog_sync_recording_info(Ori_Fix_temp(:,5),4:13);
Ori_Fix_temp(:,16) = Fix(:,5);
Ori_Fix = vertcat(Ori_Fix,Ori_Fix_temp);

    end
end
id_r = find(or(Int_Fix(:,3)<0,and(Int_Fix(:,1)<1500,Ori_Fix(:,1)<800)));
Int_Fix(id_r,:)=[]; Ori_Fix(id_r,:)=[];
% Int_Fix(and(Int_Fix(:,16)==1,Int_Fix(:,1)<800),:)=[];
% Int_Fix(Int_Fix(:,3)<0,:)=[];
%%

lw = 1;
sz = 80;

for cxt = 1:2
    for dir = 1:2
        Cxt = Cxt_Name(cxt);
        Dir = Dir_Name(dir);
        
if cxt==1
    F = STL_Forest;
    G = STL_Forest_Sky;
else
    F = STL_City;
    G = STL_City_Sky;
end

fig = figure;
ax1 = axes;
patch(ax1,F,'FaceColor',       [0.8 0.8 0.8], ...
    'EdgeColor',       'none',        ...
    'FaceLighting',    'gouraud',     ...
    'AmbientStrength', 0.15);
hold on
patch(ax1,G,'FaceColor',       [0.8 0.8 0.8], ...
    'EdgeColor',       'none',        ...
    'FaceLighting',    'gouraud',     ...
    'AmbientStrength', 0.15);
material('dull');
camlight('headlight');
axis('image');
view([-70 50]);
alpha(0.5)




hold on


id = find(and(and(Int_Fix(:,6)==cxt, Int_Fix(:,8)==-1),and(Int_Fix(:,7)>=(10*(dir-1)),Int_Fix(:,7)<=(10*(dir)))));
p2 = scatter3(Int_Fix(id,1),Int_Fix(id,2),Int_Fix(id,3),sz,'r+','LineWidth',lw);

id = find(and(and(Int_Fix(:,6)==cxt, Int_Fix(:,8)==0),and(Int_Fix(:,7)>=(10*(dir-1)),Int_Fix(:,7)<=(10*(dir)))));
p3 = scatter3(Int_Fix(id,1),Int_Fix(id,2),Int_Fix(id,3),sz,'g+','LineWidth',lw);


title([Cxt '_' Dir],'FontSize', 20,'Color', 'k','Interpreter','none','FontWeight','b')
legend([p2 p3],{'Pre-Cursor','Inter-Trial'},'Location','west')
    end
end


%%
for cxt = 1:2
    for dir = 1:2
Cxt = Cxt_Name(cxt);
Dir = Dir_Name(dir);
if cxt==1
    F = STL_Forest;
    G = STL_Forest_Sky;
else
    F = STL_City;
    G = STL_City_Sky;
end

fig = figure;
ax1 = axes;
patch(ax1,F,'FaceColor',       [0.8 0.8 0.8], ...
    'EdgeColor',       'none',        ...
    'FaceLighting',    'gouraud',     ...
    'AmbientStrength', 0.15);
hold on
patch(ax1,G,'FaceColor',       [0.8 0.8 0.8], ...
    'EdgeColor',       'none',        ...
    'FaceLighting',    'gouraud',     ...
    'AmbientStrength', 0.15);
camlight('headlight');
material('dull');
axis('image');
view([-70 50]);
alpha(0.5)


hold on


id = find(and(and(Int_Fix(:,6)==cxt, Int_Fix(:,7)==1+10*(dir-1)),Int_Fix(:,7)<3+10*(dir-1)));
scatter3(Int_Fix(id,1),Int_Fix(id,2),Int_Fix(id,3),sz,'r+','LineWidth',lw);

id = find(and(and(Int_Fix(:,6)==cxt, Int_Fix(:,7)==3+10*(dir-1)),Int_Fix(:,7)<5+10*(dir-1)));
scatter3(Int_Fix(id,1),Int_Fix(id,2),Int_Fix(id,3),sz,'y+','LineWidth',lw);

id = find(and(and(Int_Fix(:,6)==cxt, Int_Fix(:,7)==5+10*(dir-1)),Int_Fix(:,7)<7+10*(dir-1)));
scatter3(Int_Fix(id,1),Int_Fix(id,2),Int_Fix(id,3),sz,'g+','LineWidth',lw);

id = find(and(and(Int_Fix(:,6)==cxt,Int_Fix(:,7)==7+10*(dir-1)),Int_Fix(:,7)<9+10*(dir-1)));
scatter3(Int_Fix(id,1),Int_Fix(id,2),Int_Fix(id,3),sz,'c+','LineWidth',lw);

id = find(and(and(Int_Fix(:,6)==cxt,Int_Fix(:,7)==9+10*(dir-1)),Int_Fix(:,7)<11+10*(dir-1)));
scatter3(Int_Fix(id,1),Int_Fix(id,2),Int_Fix(id,3),sz,'m+','LineWidth',lw);


title([Cxt '_' Dir],'FontSize', 20,'Color', 'k','Interpreter','none','FontWeight','b')
    end
end
%%
for cxt = 1:2
    for dir = 1:2
Cxt = Cxt_Name(cxt);
Dir = Dir_Name(dir);
if cxt==1
    F = STL_Forest;
    G = STL_Forest_Sky;
else
    F = STL_City;
    G = STL_City_Sky;
end

fig = figure;
ax1 = axes;
patch(ax1,F,'FaceColor',       [0.8 0.8 0.8], ...
    'EdgeColor',       'none',        ...
    'FaceLighting',    'gouraud',     ...
    'AmbientStrength', 0.15);
hold on
patch(ax1,G,'FaceColor',       [0.8 0.8 0.8], ...
    'EdgeColor',       'none',        ...
    'FaceLighting',    'gouraud',     ...
    'AmbientStrength', 0.15);
camlight('headlight');
material('dull');
axis('image');
view([-70 50]);
alpha(0.5)


hold on


id = find(and(and(and(Int_Fix(:,6)==cxt, 1),Int_Fix(:,16)==1),and(Int_Fix(:,7)>=10*(dir-1),Int_Fix(:,7)<=10*(dir))));
scatter3(Int_Fix(id,1),Int_Fix(id,2),Int_Fix(id,3),sz,'r+','LineWidth',lw);

id = find(and(and(and(Int_Fix(:,6)==cxt, 1),Int_Fix(:,16)==2),and(Int_Fix(:,7)>=10*(dir-1),Int_Fix(:,7)<=10*(dir))));
scatter3(Int_Fix(id,1),Int_Fix(id,2),Int_Fix(id,3),sz,'y+','LineWidth',lw);

id = find(and(and(and(Int_Fix(:,6)==cxt, 1),Int_Fix(:,16)==3),and(Int_Fix(:,7)>=10*(dir-1),Int_Fix(:,7)<=10*(dir))));
scatter3(Int_Fix(id,1),Int_Fix(id,2),Int_Fix(id,3),sz,'g+','LineWidth',lw);

id = find(and(and(and(Int_Fix(:,6)==cxt, 1),Int_Fix(:,16)==4),and(Int_Fix(:,7)>=10*(dir-1),Int_Fix(:,7)<=10*(dir))));
scatter3(Int_Fix(id,1),Int_Fix(id,2),Int_Fix(id,3),sz,'c+','LineWidth',lw);

id = find(and(and(and(Int_Fix(:,6)==cxt, 1),Int_Fix(:,16)==5),and(Int_Fix(:,7)>=10*(dir-1),Int_Fix(:,7)<=10*(dir))));
scatter3(Int_Fix(id,1),Int_Fix(id,2),Int_Fix(id,3),sz,'m+','LineWidth',lw);


title([Cxt '_' Dir],'FontSize', 20,'Color', 'k','Interpreter','none','FontWeight','b')

    end
end

%%
lw=1;
for cxt = 1:2
    for dir = 1:2
Cxt = Cxt_Name(cxt);
Dir = Dir_Name(dir);
if cxt==1
    F = STL_Forest;
    G = STL_Forest_Sky;
else
    F = STL_City;
    G = STL_City_Sky;
end

if dir==1
    caz = 300;
else
caz = 130;
end
cel = 50;

fig = figure;
ax1 = axes;
patch(ax1,F,'FaceColor',       [0.8 0.8 0.8], ...
    'EdgeColor',       'none',        ...
    'FaceLighting',    'gouraud',     ...
    'AmbientStrength', 0.15);
camlight('headlight');
material('dull');
axis('image');


view([caz cel]);
alpha(0.5)


hold on


id = find(and(and(and(Int_Fix(:,6)==cxt, Int_Fix(:,7)<3+10*(dir-1)),Int_Fix(:,7)>=1+10*(dir-1)),Int_Fix(:,16)~=2));
scatter3(Int_Fix(id,1),Int_Fix(id,2),Int_Fix(id,3),sz,'r+','LineWidth',lw);

id = find(and(and(and(Int_Fix(:,6)==cxt, Int_Fix(:,7)<5+10*(dir-1)),Int_Fix(:,7)>=3+10*(dir-1)),Int_Fix(:,16)~=2));
scatter3(Int_Fix(id,1),Int_Fix(id,2),Int_Fix(id,3),sz,'y+','LineWidth',lw);

id = find(and(and(and(Int_Fix(:,6)==cxt, Int_Fix(:,7)<7+10*(dir-1)),Int_Fix(:,7)>=5+10*(dir-1)),Int_Fix(:,16)~=2));
scatter3(Int_Fix(id,1),Int_Fix(id,2),Int_Fix(id,3),sz,'g+','LineWidth',lw);

id = find(and(and(and(Int_Fix(:,6)==cxt, Int_Fix(:,7)<9+10*(dir-1)),Int_Fix(:,7)>=7+10*(dir-1)),Int_Fix(:,16)~=2));
scatter3(Int_Fix(id,1),Int_Fix(id,2),Int_Fix(id,3),sz,'c+','LineWidth',lw);

id = find(and(and(and(Int_Fix(:,6)==cxt, Int_Fix(:,7)<10+10*(dir-1)),Int_Fix(:,7)>=9+10*(dir-1)),Int_Fix(:,16)~=2));
scatter3(Int_Fix(id,1),Int_Fix(id,2),Int_Fix(id,3),sz,'m+','LineWidth',lw);



title([Cxt '_' Dir],'FontSize', 20,'Color', 'k','Interpreter','none','FontWeight','b')

    end
end

%%
levels = 1000;
Resolution =1;
lw=1;
for cxt = 2:2
    for loc=2:2
    dir=1;

        figure;
Cxt = Cxt_Name(cxt);
Dir = Dir_Name(dir);
xmin = -5000; xmax = 20000;

if cxt==1

    ymin = -5000; ymax = 5000;
else

    
    ymin = 15000; ymax = 25000;
end


% 
% fig = figure;
% ax1 = axes;
% patch(ax1,F,'FaceColor',       [0.8 0.8 0.8], ...
%     'EdgeColor',       'none',        ...
%     'FaceLighting',    'gouraud',     ...
%     'AmbientStrength', 0.15);
% camlight('headlight');
% material('dull');
% axis('image');
% 
% 
% view([caz cel]);
% alpha(0.5)
% 
% 
% hold on

if loc==10 loc=9; end

id = find(and(and(and(Int_Fix(:,6)==cxt,1),1),Int_Fix(:,16)~=2));
% id = find(and(and(and(Int_Fix(:,6)==cxt,and(Int_Fix(:,7)>=10*(dir-1),Int_Fix(:,7)<=10*(dir))),1),Int_Fix(:,16)~=2));
X = vertcat(Int_Fix(id,1),[xmin;xmax]); Y = vertcat(Int_Fix(id,2)*(-1),[ymin;ymax]);

Y(X>xmax)=[]; X(X>xmax)=[];
Y(X<xmin)=[]; X(X<xmin)=[];

ax = DataDensityPlot( X, Y, levels,2100,1500,Resolution,xmin,xmax,ymin,ymax);

colormap(ax,jet)

ylim([0 1500]); xlim([00 2100])
alpha(1)
axis on



% id = find(and(and(and(Int_Fix(:,6)==cxt,Int_Fix(:,7)<10),1),Int_Fix(:,16)~=2));
% % id = find(and(and(and(Int_Fix(:,6)==cxt,and(Int_Fix(:,7)>=10*(dir-1),Int_Fix(:,7)<=10*(dir))),1),Int_Fix(:,16)~=2));
% X = vertcat(Int_Fix(id,1),[xmin;xmax]); Y = vertcat(Int_Fix(id,2)*(-1),[ymin;ymax]);
% 
% Y(X>xmax)=[]; X(X>xmax)=[];
% Y(X<xmin)=[]; X(X<xmin)=[];
% 
% ax = DataDensityPlot( X, Y, levels,2100,1400,5,xmax,ymax);
% redmap = [ones(levels,1),linspace(1,0,levels)',linspace(1,0,levels)'];
% colormap(ax,redmap)
% 
% ylim([0 1400]); xlim([0 2000])
% alpha(0.5)
% axis off
% 
% hold on
% id = find(and(and(and(Int_Fix(:,6)==cxt,Int_Fix(:,7)>10),1),Int_Fix(:,16)~=2));
% % id = find(and(and(and(Int_Fix(:,6)==cxt,and(Int_Fix(:,7)>=10*(dir-1),Int_Fix(:,7)<=10*(dir))),1),Int_Fix(:,16)~=2));
% X = vertcat(Int_Fix(id,1),[xmin;xmax]); Y = vertcat(Int_Fix(id,2)*(-1),[ymin;ymax]);
% 
% Y(X>xmax)=[]; X(X>xmax)=[];
% Y(X<xmin)=[]; X(X<xmin)=[];
% 
% ax2 = DataDensityPlot( X, Y, levels,2100,1400,5,xmax,ymax);
% bluemap = [linspace(1,0,levels)',linspace(1,0,levels)', ones(levels,1)];
% colormap(ax2,bluemap)
% ylim([0 1400]); xlim([0 2000])
% alpha(0.5)
% axis off
% set([ax,ax2],'Position',[.17 .173 .685 .689]);
    end
end