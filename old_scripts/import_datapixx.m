%% Import Datapixx Data
cd(raw_folder_datapixx);
filename_datapixx= [session_date matlab_num];

Eye_Analog_datapixx = [];
for i = 1:1000
    if ~exist([filename_datapixx ' Eye_Analog_' num2str(i) '.mat'])
        break;
    end
    load([filename_datapixx ' Eye_Analog_' num2str(i) '.mat']);
    DatA = DatA';
    Eye_Analog_datapixx = vertcat(Eye_Analog_datapixx, DatA);
end

EventLog_datapixx =[];
for i = 1:1000
    if ~exist([filename_datapixx ' EventLog_' num2str(i) '.mat'])
        break;
    end
    load([filename_datapixx ' EventLog_' num2str(i) '.mat']);
    EventLog_datapixx = vertcat(EventLog_datapixx, EventLog);
end

TickLog_datapixx =[];
for i = 1:1000
    if ~exist([filename_datapixx ' TickLog_' num2str(i) '.mat'])
        break;
    end
    load([filename_datapixx ' TickLog_' num2str(i) '.mat']);
    TickLog_datapixx = vertcat(TickLog_datapixx, TickLog);
end

clearvars DatA EventLog TickLog

if ~cell2mat(EventLog_datapixx(strcmp(EventLog_datapixx, 'VoidOff'),2))
tSessionStart = min(cell2mat(EventLog_datapixx(strcmp(EventLog_datapixx, 'VoidOff'),2)));
else
    tSessionStart = min(cell2mat(EventLog_datapixx(strcmp(EventLog_datapixx, 'LapStart'),2)));
end
tSessionEnd = cell2mat(EventLog_datapixx(strcmp(EventLog_datapixx, 'SessionEnd'),2));


% EventLog_datapixx(cell2mat(EventLog_datapixx(:,2))<tSessionStart,:) = [];
% EventLog_datapixx(cell2mat(EventLog_datapixx(:,2))>tSessionEnd,:) = [];
TickLog_datapixx(TickLog_datapixx(:,1)<tSessionStart,:) = [];
TickLog_datapixx(TickLog_datapixx(:,1)>tSessionEnd,:) = [];


LapStart_datapixx = cell2mat(EventLog_datapixx(find(strcmp(EventLog_datapixx,'LapStart')),2));
LapStart_datapixx_recording =  LapStart_datapixx(find(LapStart_unreal(:,1) == LapStart_unreal_recording(1,1)):find(LapStart_unreal(:,1) == LapStart_unreal_recording(end,1)),:);

TrialStart_datapixx = cell2mat(EventLog_datapixx(find(strcmp(EventLog_datapixx,'TrialStart')),2));

TickLog_datapixx_recording = TickLog_datapixx;
TickLog_datapixx_recording(TickLog_datapixx_recording(:,1)<LapStart_datapixx_recording(1,1),:) = [];

figure;
scatter(Eye_Analog_datapixx(:,1), Eye_Analog_datapixx(:,2))
set(gca,'YDir','reverse');
xlabel('Gaze X (V)','FontSize',10);
ylabel('Gaze Y (V)','FontSize',10);
title('Eyelink Raw Data');