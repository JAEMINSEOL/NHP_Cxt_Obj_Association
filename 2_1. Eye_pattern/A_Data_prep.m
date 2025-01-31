clear all; close all;
% eye_data_preprocessing

ROOT.Mother = 'Z:\NHP\Data';
ROOT.Program = ['D:\NHP_project\Analysis\Program'];
ROOT.Save = 'X:\E-Phys Analysis\NHP project';
addpath(genpath(ROOT.Program))
addpath(genpath('D:\Modules'))

Animals = {'Nabi','Yoda'};

phase=4; % -500ms=1, CursorOn=2, ObjOn=3, GoCue=4
dur = 1000;

s=1;

whole_set=struct;
for aid = 1:2
Animal_id = Animals{aid};
Task_id = 'Cxt-Obj Association_6 Objects';

ROOT.Raw.Mother = [ROOT.Mother '\' Animal_id '\Behavior\' Task_id];
fd = dir(ROOT.Raw.Mother);

Eye_Yoda = readtable([ROOT.Save '\Yoda_Valid_Sessions.xlsx']);
Eye_Nabi = readtable([ROOT.Save '\Nabi_Valid_Sessions.xlsx']);

Session_summary = table;    
%%


for f=1:size(fd,1)
    try
% for f=1:size(fd,1)
    if length(fd(f).name)<8, continue; end

date = fd(f).name;

% ROOT.fig_lap = [ROOT.Save '\Property sheet\Preprocessing\lap\' Animal_id '_' date]; if ~exist(ROOT.fig_lap), mkdir(ROOT.fig_lap); end
% ROOT.fig_trial = [ROOT.Save '\Property sheet\Preprocessing\trial\' Animal_id '_' date]; if ~exist(ROOT.fig_trial), mkdir(ROOT.fig_trial); end

ROOT.Datapixx = [ROOT.Mother '\' Animal_id '\Behavior\' Task_id '\' date '\Datapixx'];
ROOT.Unreal = [ROOT.Mother '\' Animal_id '\Behavior\' Task_id '\' date '\Unreal'];

eye_data_temp = load([ROOT.Save '\Eye_parsed\' Animal_id '_' date '.mat']);
eye_temp_session = eye_data_temp.Datapixx_eye_T;
%% for trial
% for t=1:max(eye_temp_session.trial)
%     eye_temp_trial =   eye_temp_session(eye_temp_session.trial>=t & eye_temp_session.on_trial>=phase,:);
%     if isempty(eye_temp_trial), continue; end
%     eye_temp_trial = eye_temp_trial(1:dur,:);
%     whole_set(s).data = eye_temp_trial(:,["X","Y"]);
%     whole_set(s).data.time = [1:dur]';
%     id = find(eye_temp_trial.trial(1)==eye_data_temp.UE_log.trials.Trial);
%     whole_set(s).trial_info = eye_data_temp.UE_log.trials(id,{'Trial','Context','Direction','Location','Choice','CorrectAnswer','ObjectLeft','ObjectRight'});
%     whole_set(s).trial_info.Animal = aid;
%    whole_set(s).data.joystick = interp1(eye_data_temp.UE_log.Joystick(:,1),eye_data_temp.UE_log.Joystick(:,2),eye_temp_trial.time,'nearest');
%     s=s+1;
% end

%% for lap
for l=1:max(eye_temp_session.lap)
    eye_temp_lap =   eye_temp_session(eye_temp_session.lap>=l & eye_temp_session.on_lap>=1,:);
    if isempty(eye_temp_lap), continue; end
    eye_temp_lap = eye_temp_lap(1:dur,:);
    whole_set(s).data = eye_temp_lap(:,["X","Y","Xpos",'Ypos']);
    whole_set(s).data.time = [1:dur]';
    id = find(eye_temp_lap.trial(1)==eye_data_temp.UE_log.trials.Trial);
    whole_set(s).trial_info = eye_data_temp.UE_log.trials(id,{'Trial','Context','Direction','Location','Choice','CorrectAnswer','ObjectLeft','ObjectRight'});
    whole_set(s).trial_info.Animal = aid;
   whole_set(s).data.joystick = interp1(eye_data_temp.UE_log.Joystick(:,1),eye_data_temp.UE_log.Joystick(:,2),eye_temp_lap.time,'nearest');
    s=s+1;
end
%%

disp(['Success : ' Animal_id '_' date ])
    catch
        disp(['cannot load ' Animal_id '_' date '.mat'])
    end
end
end
%%
save(['X:\E-Phys Analysis\NHP project\Eye_parsed\LapStart_' num2str(dur) 'ms.mat'],'whole_set')
%%
% data = part_set;
% s=1;
% figure('Position',[680,266,758,712])
% d = data(s).data;
% plot3(d.X,d.Y,d.time,'LineWidth',2,'color','k'); hold on
% scatter3(d.X,d.Y,d.time,20,d.time,'filled')
% xlabel('X'); ylabel('Y'); zlabel('time (ms)')
% xlim([-5 5]); ylim([-5 5])
% title(['trial ' num2str(s) ', 500ms from trial start'])
% set(gca,'ZDir','normal','CameraPosition',[-5.16605259614629,-42.198985209164164,-3522.451970499622]); grid on