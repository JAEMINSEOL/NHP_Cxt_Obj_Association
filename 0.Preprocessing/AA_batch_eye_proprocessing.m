clear all; close all;
% eye_data_preprocessing

ROOT.Mother = 'Z:\NHP';
ROOT.Program = ['D:\NHP project\Program'];
addpath(genpath(ROOT.Program))
addpath(genpath('D:\Modules'))

date = '20200108';
Animal_id = 'Nabi';
Task_id = 'Cxt-Obj Association_6 Objects';

ROOT.fig_lap = ['D:\NHP project\분석 관련\Property sheet\Preprocessing\lap\' Animal_id '_' date]; if ~exist(ROOT.fig_lap), mkdir(ROOT.fig_lap); end
ROOT.fig_trial = ['D:\NHP project\분석 관련\Property sheet\Preprocessing\trial\' Animal_id '_' date]; if ~exist(ROOT.fig_trial), mkdir(ROOT.fig_trial); end


ROOT.Datapixx = [ROOT.Mother '\Data\' Animal_id '\Behavior\' Task_id '\' date '\Datapixx'];
ROOT.Unreal = [ROOT.Mother '\Data\' Animal_id '\Behavior\' Task_id '\' date '\Unreal'];


[Datapixx_eye,Datapixx_ticks,Datapixx_events] = A_Eyedata_import(ROOT,date);

[Datapixx_eye_T,Datapixx_events,UE_log] = B_Unreal_parsing(ROOT,Animal_id,date,Datapixx_events,Datapixx_eye);

Eye_Raw = [Datapixx_eye(:,4) Datapixx_eye(:,1) Datapixx_eye(:,2) Datapixx_eye(:,3)];
[X_lp,Y_lp,X_lp_deg, Y_lp_deg,Eye_Speed_deg_inst_lp,Eye_Acc_deg_inst_lp] = C_Angular_NoiseFiltering_SpeedCalc(Eye_Raw);

[Eye_sacc_XY_index_lp] = D_Saccade_detection(Eye_Acc_deg_inst_lp,Eye_Speed_deg_inst_lp,X_lp_deg, Y_lp_deg);
Datapixx_eye_T.saccade = Eye_sacc_XY_index_lp(:,2);

[Eye_sacc_XY_index_lp_new,NonSacc] = E_NonSaccade_Categorize(Eye_sacc_XY_index_lp,Eye_Acc_deg_inst_lp,Eye_Speed_deg_inst_lp,X_lp_deg, Y_lp_deg);
Datapixx_eye_T.saccade = Eye_sacc_XY_index_lp_new;
% Calibration_Check(Datapixx_eye,Datapixx_events)

Z3_display_lap_video
%% Load Context .stl Image
load([ROOT.Program '\Image\STLImportedContexts.mat'])

% cd([program_folder '\Image'])
% 
% STL_Forest_Landscape = stlread_NHP('Forest_context_b.stl');
% STL_Forest_Foliage = stlread_NHP('Forest_Foliage2_Poly.stl');
% STL_City = stlread_NHP('City_context_b.stl');
% 
% STL_Forest_Sky = stlread_NHP('Forest_Sky.stl');
% STL_City_Sky = stlread_NHP('City_Sky.stl');
% %%
% STL_City_Sky.vertices(:,2) = STL_City_Sky.vertices(:,2)+200.8;
% STL_City_Sky.vertices(:,1) = STL_City_Sky.vertices(:,1)-81.7;
% STL_City_Sky.vertices = STL_City_Sky.vertices*50000;
% % STL_City_Sky.vertices(STL_City_Sky.vertices(:,3)<-2000,:) = NaN;
% 
% STL_Forest_Sky.vertices(:,2) = STL_Forest_Sky.vertices(:,2)-8.9;
% STL_Forest_Sky.vertices(:,1) = STL_Forest_Sky.vertices(:,1)-81.2;
% STL_Forest_Sky.vertices = STL_Forest_Sky.vertices*50000;
% STL_Forest_Sky.vertices(STL_Forest_Sky.vertices(:,3)<-2000,:) = NaN;
% 
% 
% STL_Forest.faces = []; 
% for f = 1:length(STL_Forest.vertices)/3-1
%         STL_Forest.faces(f,1:3) = [3*(f-1)+1,3*(f-1)+2,3*(f-1)+3];
% end


%    
% STL_City_o = stlread_NHP('City_context_o.stl');
% STL_City_All.vertices = vertcat(STL_City_o.vertices,STL_City.vertices);
% STL_City_All.faces = []; 
% for f = 1:length(STL_City_All.vertices)/3-1
%         STL_City_All.faces(f,1:3) = [3*(f-1)+1,3*(f-1)+2,3*(f-1)+3];
% end
%%
% clear origin direction intersection FixPoint
% origin = NaN(nLap,8,20000,5); intersection = NaN(nLap,8,20000,4); direction = NaN(nLap,8,20000,4); FixPoint_InterTrial = NaN(nLap,8,20000,5);
%% Inter Trial Interval 3D Eyegaze Map
tic;
l=1; d=1;
[origin(l,d,:,:), direction(l,d,:,:), intersection(l,d,:,:),FixPoint_InterTrial(l,d,:,:),FigTitle,fig,ax1] = Eye_Plotting_InterTrial(STL_Forest,STL_City,STL_Forest_Sky,STL_City_Sky,...
    2,l,d,Datapixx_eye_T,Eye_sacc_XY_index_lp(:,1),X_lp,Y_lp);
cd([ROOT.Program '\EyeData'])
% savefig(fig,[FigTitle '.fig']);
% saveas(fig,[FigTitle '.jpg']);
close gcf
toc;

save('Eye_InterTrial.mat','FixPoint_InterTrial')
toc;

%%


Z1_display_choice_event_picture

Z2_display_choice_event_video

