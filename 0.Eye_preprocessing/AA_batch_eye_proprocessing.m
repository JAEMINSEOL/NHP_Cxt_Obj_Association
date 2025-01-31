clear all; close all;
% eye_data_preprocessing

ROOT.Mother = 'Z:\NHP\Data';
ROOT.Program = ['D:\NHP_project\Analysis\Program'];
ROOT.Save = 'X:\E-Phys Analysis\NHP project';
addpath(genpath(ROOT.Program))
addpath(genpath('D:\Modules'))


Animal_id = 'Yoda';
Task_id = 'Cxt-Obj Association_6 Objects';

ROOT.Raw.Mother = [ROOT.Mother '\' Animal_id '\Behavior\' Task_id];
fd = dir(ROOT.Raw.Mother);

Eye_Yoda = readtable([ROOT.Save '\Yoda_Valid_Sessions.xlsx']);
Eye_Nabi = readtable([ROOT.Save '\Nabi_Valid_Sessions.xlsx']);

Session_summary = table;
%%
for f=1:87
% for f=1:size(fd,1)
    if length(fd(f).name)<8, continue; end
%%
date = fd(f).name;

% ROOT.fig_lap = [ROOT.Save '\Property sheet\Preprocessing\lap\' Animal_id '_' date]; if ~exist(ROOT.fig_lap), mkdir(ROOT.fig_lap); end
% ROOT.fig_trial = [ROOT.Save '\Property sheet\Preprocessing\trial\' Animal_id '_' date]; if ~exist(ROOT.fig_trial), mkdir(ROOT.fig_trial); end

ROOT.Datapixx = [ROOT.Mother '\' Animal_id '\Behavior\' Task_id '\' date '\Datapixx'];
ROOT.Unreal = [ROOT.Mother '\' Animal_id '\Behavior\' Task_id '\' date '\Unreal'];

temp=table;
temp.session = str2double(date);
temp.Behavior = logical(exist([ROOT.Unreal '\' Animal_id '_' date '.csv']));
temp.Datapixx = logical(exist([ROOT.Datapixx]));
temp.Error=1;
if temp.Datapixx>0

    try
[Datapixx_eye,Datapixx_ticks,Datapixx_events] = A_Eyedata_import(ROOT,date);

[Datapixx_eye_T,Datapixx_events,UE_log] = B_Unreal_parsing(ROOT,Animal_id,date,Datapixx_events,Datapixx_eye);

Eye_Raw = [Datapixx_eye(:,4) Datapixx_eye(:,1) Datapixx_eye(:,2) Datapixx_eye(:,3)];
[X_lp,Y_lp,X_lp_deg, Y_lp_deg,Eye_Speed_deg_inst_lp,Eye_Acc_deg_inst_lp] = C_Angular_NoiseFiltering_SpeedCalc(Eye_Raw);

[Eye_sacc_XY_index_lp] = D_Saccade_detection(Eye_Acc_deg_inst_lp,Eye_Speed_deg_inst_lp,X_lp_deg, Y_lp_deg);
Datapixx_eye_T.saccade = Eye_sacc_XY_index_lp(:,2);

[Eye_sacc_XY_index_lp_new,NonSacc] = E_NonSaccade_Categorize(Eye_sacc_XY_index_lp,Eye_Acc_deg_inst_lp,Eye_Speed_deg_inst_lp,X_lp_deg, Y_lp_deg);
Datapixx_eye_T.saccade = Eye_sacc_XY_index_lp_new;
% Calibration_Check(Datapixx_eye,Datapixx_events)

%     save([ROOT.Save '\Eye_parsed\' Animal_id '_' date '.mat'],'Datapixx_eye_T','UE_log','Datapixx_events','NonSacc')
    temp.Error=0;
    catch
        disp([date ' session is failed'])
        temp.Error=1;
    end
end

Session_summary = [Session_summary; temp];
%%

l=1;
end
% writetable(Session_summary,[ROOT.Save '\' Animal_id '_SessionSummary.xlsx'],'writemode','replacefile')

load([ROOT.Program '\Image\STLImportedContexts.mat'])

load('D:\NHP_project\Analysis\Figures\Property sheet\3DRecon_Nabi_20200108.mat')

Z3_display_lap_video
%% Load Context .stl Image

cd([program_folder '\Image'])

STL_Forest_Landscape = stlread_NHP('Forest_context_b.stl');
STL_Forest_Foliage = stlread_NHP('Forest_Foliage2_Poly.stl');
STL_City = stlread_NHP('City_context_b.stl');

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
%%
% clear origin direction intersection FixPoint
% origin = NaN(nLap,8,20000,5); intersection = NaN(nLap,8,20000,4); direction = NaN(nLap,8,20000,4); FixPoint_InterTrial = NaN(nLap,8,20000,5);
%% Inter Trial Interval 3D Eyegaze Map
tic;
l=1; d=2;
[origin(l,d,:,:), direction(l,d,:,:), intersection(l,d,:,:),FixPoint_InterTrial(l,d,:,:),FigTitle,fig,ax1] = Eye_Plotting_InterTrial(STL_Forest,STL_City,STL_Forest_Sky,STL_City_Sky,...
    2,l,d,Datapixx_eye_T,Eye_sacc_XY_index_lp(:,1),X_lp,Y_lp);
cd([ROOT.Program '\EyeData'])
% savefig(fig,[FigTitle '.fig']);
% saveas(fig,[FigTitle '.jpg']);
close gcf
toc;

save('Eye_InterTrial_example.mat','FixPoint_InterTrial')
toc;

%% intersection interp to Datapixx_eye_T

x=intersection_cxt(:,4);
y=Datapixx_eye_T.time;

%%


Z1_display_choice_event_picture

Z2_display_choice_event_video

