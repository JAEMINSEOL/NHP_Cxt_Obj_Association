cd(raw_folder_neuralynx);
filename_neuralynx= ['Events.csv'];

delimiter = ',';
formatSpec = '%*s%*s%*s%f%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%s%[^\n\r]';
fileID = fopen(filename_neuralynx,'r');

dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN, 'ReturnOnError', false);
fclose(fileID);

Timestamp_neuralynx = dataArray{:, 1};
Event_neuralynx = dataArray{:, 2};


TickEvent_neuralynx = 'TTL Input on AcqSystem1_0 board 0 port 0 value (0x0001).';
LapStartEvent_neuralynx = 'TTL Input on AcqSystem1_0 board 0 port 0 value (0x0002).';
TrialStartEvent_neuralynx = 'TTL Input on AcqSystem1_0 board 0 port 0 value (0x0004).';
RecordingEvent_neuralynx = 'TTL Input on AcqSystem1_0 board 0 port 0 value (0x0008).';


RecordingLog_neuralynx = Timestamp_neuralynx(find(strcmp(Event_neuralynx, RecordingEvent_neuralynx)));
% RecordingStartLog_neuralynx = RecordingLog_neuralynx(1:2:end,:);
% RecordingEndLog_neuralynx = RecordingLog_neuralynx(2:2:end,:);
RecordingStartLog_neuralynx = Timestamp_neuralynx(find(strcmp(Event_neuralynx, 'Starting Recording')));
RecordingEndLog_neuralynx = Timestamp_neuralynx(find(strcmp(Event_neuralynx, 'Stopping Recording')));



TickLog_neuralynx = Timestamp_neuralynx(find(strcmp(Event_neuralynx, TickEvent_neuralynx)));
LapStart_neuralynx = Timestamp_neuralynx(find(strcmp(Event_neuralynx, LapStartEvent_neuralynx)));
TrialStart_neuralynx = Timestamp_neuralynx(find(strcmp(Event_neuralynx, TrialStartEvent_neuralynx)));


LapStart_neuralynx(LapStart_neuralynx(:,1)<RecordingLog_neuralynx(1,:),:) = [];
LapStart_neuralynx(LapStart_neuralynx(:,1)>RecordingLog_neuralynx(end,:),:) = [];
LapStart_neuralynx(end,:) = [];

TrialStart_neuralynx(TrialStart_neuralynx(:,1)<RecordingStartLog_neuralynx(1,:),:) = [];
TrialStart_neuralynx(TrialStart_neuralynx(:,1)>RecordingEndLog_neuralynx(1,:),:) = [];
% TrialStart_neuralynx(end,:) = [];

TickLog_neuralynx(TickLog_neuralynx(:,1)<LapStart_neuralynx(1,1),:) = [];
TickLog_neuralynx(TickLog_neuralynx(:,1)>RecordingLog_neuralynx(end,1),:) = [];

clear Timestamp_neuralynx Event_neuralynx

% LapStart_neuralynx(end,:) = [];






