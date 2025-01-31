clear all
ROOT.program = 'D:\NHP_project\Analysis\Program\Recording_Analysis_SJM';
ROOT.raw.data = 'X:\E-Phys Analysis\NHP project\Eye_parsed';
% ROOT.raw.fig = 'D:\NHP project\Unreal Assets';
ROOT.raw.fig = 'D:\NHP_project\실험 셋업 자료\Unreal Assets';
ROOT.raw.stl = [ROOT.raw.fig '\3D_recon'];
% Load Context .stl Image
addpath(genpath(ROOT.program))
%%
cd([ROOT.raw.stl])

STL_Forest_Landscape = stlread_NHP('Forest_context_b.stl');
STL_Forest_Foliage = stlread_NHP('Forest_Foliage2_Poly.stl');
STL_City = stlread_NHP('City_context_b.stl');
STL_Forest = stlread_NHP('Forest_context_b.stl');

STL_Forest_Sky = stlread_NHP('Forest_Sky.stl');
STL_City_Sky = stlread_NHP('City_Sky.stl');
%%
STL_City_Sky.vertices(:,2) = STL_City_Sky.vertices(:,2)+200.8;
STL_City_Sky.vertices(:,1) = STL_City_Sky.vertices(:,1)-81.7;
STL_City_Sky.vertices = STL_City_Sky.vertices*50000;
% STL_City_Sky.vertices(STL_City_Sky.vertices(:,3)<-2000,:) = NaN;

STL_Forest_Sky.vertices(:,2) = STL_Forest_Sky.vertices(:,2)-8.9;
STL_Forest_Sky.vertices(:,1) = STL_Forest_Sky.vertices(:,1)-81.2;
STL_Forest_Sky.vertices = STL_Forest_Sky.vertices*50000;
STL_Forest_Sky.vertices(STL_Forest_Sky.vertices(:,3)<-2000,:) = NaN;


STL_Forest.faces = [];
for f = 1:length(STL_Forest.vertices)/3-1
    STL_Forest.faces(f,1:3) = [3*(f-1)+1,3*(f-1)+2,3*(f-1)+3];
end



STL_City_o = stlread_NHP('City_context_o.stl');
STL_City_All.vertices = vertcat(STL_City_o.vertices,STL_City.vertices);
STL_City_All.faces = [];
for f = 1:length(STL_City_All.vertices)/3-1
    STL_City_All.faces(f,1:3) = [3*(f-1)+1,3*(f-1)+2,3*(f-1)+3];
end
%
% clear origin direction intersection FixPoint
% origin = NaN(nLap,8,20000,5); intersection = NaN(nLap,8,20000,4); direction = NaN(nLap,8,20000,4); FixPoint_InterTrial = NaN(nLap,8,20000,5);
%%
template_array = zeros(1200,600,500);
% screen_vector=[];
screen_vector = zeros(size(template_array,1)*size(template_array,2)*size(template_array,3),3);
t=1;
for pi = 1:size(template_array,3)
    for xi=1:size(template_array,1)
        for yi = 1:size(template_array,2)
            screen_vector(t,1) = xi/120-5;
            screen_vector(t,2) = yi/60-5;
            screen_vector(t,3) = pi*20;
            t=t+1;
        end
    end
end
screen_vector(:,3)=1;
%%
cxt=1;
if cxt==1
    Context_STL=STL_Forest;
    Sky_box = STL_Forest_Sky;
    centerY= 0;
else
    Context_STL=STL_City;
    Sky_box = STL_City_Sky;
    centerY = -20050;
end


p1 = Context_STL.vertices(1:3:end,1:3);
q1 = Context_STL.vertices(2:3:end,1:3);
r1 = Context_STL.vertices(3:3:end,1:3);

p2 = Sky_box.vertices(1:3:end,1:3); p2(isnan(p2(:,1)),:)=[];
q2 = Sky_box.vertices(2:3:end,1:3); q2(isnan(q2(:,1)),:)=[];
r2 = Sky_box.vertices(3:3:end,1:3); r2(isnan(r2(:,1)),:)=[];



%%

% X_lp = screen_vector(:,1); Y_lp = screen_vector(:,2); time = ones(size(screen_vector,1),1); id_e = ones(size(screen_vector,1),1);
% Ypos = screen_vector(:,3);  Xpos = 100*ones(size(screen_vector,1),1);
for direction=1:2
    %%
    [origin_cxt, direction_cxt,intersection_cxt] = Cal3DGazePosition(p2,q2,r2, ones(size(screen_vector,1),1),100*ones(size(screen_vector,1),1),...
        screen_vector(:,3),screen_vector(:,1),screen_vector(:,2),ones(size(screen_vector,1),1),direction);
    tic
    [origin_sky, direction_sky,intersection_sky] = Cal3DGazePosition(p1,q1,r1, ones(size(screen_vector,1),1),100*ones(size(screen_vector,1),1),...
        screen_vector(:,3),screen_vector(:,1),screen_vector(:,2),ones(size(screen_vector,1),1),direction);
    toc
    %%
    intersection_cxt(find(intersection_sky(:,4)~=0),:)=0;

    direction_sky(:,4)=0; direction_cxt(:,4)=0;
    intersection2 = sortrows(vertcat(intersection_sky,intersection_cxt),4);
    intersection2(find(intersection2(:,4)==0),:)=[];

    intersection = intersection_sky;
    intersection(find(intersection(:,4)==0),:)=[];
    %%
    sz=20000;

    if length(origin_sky)<=sz
        origin2(1:length(origin_sky),1:5) = origin_sky(:,1:5);
    else
        origin2(1:sz,1:5) = origin_sky(1:sz,1:5);
    end
    if length(origin_sky)<=sz
        direction2(1:length(direction_sky),1:4) = direction_sky(:,1:4);
    else
        direction2(1:sz,1:4) = direction_sky(1:sz,1:4);
    end

    if length(intersection2)<=sz
        intersection3(1:length(intersection2),1:4) = intersection2(:,1:4);
    else
        intersection3(1:sz,1:4) = intersection2(1:sz,1:4);
    end


    save(['Cxt' num2str(cxt) '_Dir' num2str(direction) '_all.mat'],'screen_vector','origin2', 'direction2', 'intersection3')
    clear origin2 direction2 intersection3 intersection2 direction origin_cxt origin_sky intersection_sky intersection_cxt
end


%%

%% Inter Trial Interval 3D Eyegaze Map
nLap=53;
origin = NaN(nLap,8,20000,5); intersection = NaN(nLap,8,20000,4); direction = NaN(nLap,8,20000,4); FixPoint_InterTrial = NaN(nLap,8,20000,5);
tic;
for l=1:2
    for d=1:2
[origin(l,d,:,:), direction(l,d,:,:), intersection(l,d,:,:),FixPoint_InterTrial(l,d,:,:),FigTitle,fig,ax1] = Eye_Plotting_InterTrial(STL_Forest,STL_City,STL_Forest_Sky,STL_City_Sky,...
    2,l,d,Datapixx_eye_T,Eye_sacc_XY_index_lp(:,1),X_lp,Y_lp);

% savefig(fig,[FigTitle '.fig']);
% saveas(fig,[FigTitle '.jpg']);
close gcf
toc;
    end
end
cd([ROOT.Program '\EyeData'])
save(['Eye_InterTrial_example_ num2str(l)' '_' num2str(d) '.mat'],'FixPoint_InterTrial')

toc;