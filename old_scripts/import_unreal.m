cd(raw_folder_unreal);
filename_unreal= [animal_id '_' session_date '.csv'];

delimiter = ',';
formatSpec = '%s%f%f%f%f%[^\n\r]';
fileID = fopen(filename_unreal,'r');

dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN, 'ReturnOnError', false);

fclose(fileID);

EventName = dataArray{:, 1};
Time = dataArray{:, 2};
TimeStamp = dataArray{:, 2};
PositionX = dataArray{:, 3};
PositionY = dataArray{:, 4};
TType = dataArray{:, 5};

%remove non-time value from TimeStamp array

for iL=1:size(dataArray{1,1},1)
    data_type=dataArray{1}{iL,1};
    if strfind(data_type,'TrialType')
        TimeStamp(iL)=nan;
% % Log no longer contains nLap or Trial lines (5/17)
%     elseif strfind(data_type,'nLap')
%         TimeStamp(iL)=nan;
%     elseif strfind(data_type,'Trial')
%         TimeStamp(iL)=nan;
    end
end

LapStartEvent='LapStart';
LapEndEvent='LapEnd';
TrialStartEvent='TrialStart';
TrialEndEvent='TrialEnd';
TurnOnEvent = 'TurnStart';
TurnOffEvent = 'TurnEnd';
ObjOnEvent = 'ObjOn';
ObjOffEvent = 'ObjOff';
JoystickLeftEvent = 'JoystickLeft';
JoystickRightEvent = 'JoystickRight';
ChoiceLeftEvent = 'ChoiceLeft';
ChoiceRightEvent = 'ChoiceRight';
TrialType = 'TrialType';
RewardEvent = 'Reward';
% CorrectnessEvent = 'Decision'; % Obsolete (190517,BN)
CursorOnEvent= 'CursorOn';
CursorColorChangeEvent= 'CursorBlue';
CursorTimerResetEvent= 'CursorTimerReset';

% iCorrectnessEvent = find(strcmp(X, CorrectnessEvent));
% DecisionDuration= Position(iCorrectnessEvent);

iRecordingStart = find(strcmp(EventName, 'RecordingStart'), Session_num );
iRecordingEnd = find(strcmp(EventName, 'RecordingEnd'), Session_num );

tRecordingStart = Time(iRecordingStart(Session_num));
tRecordingEnd = Time(iRecordingEnd(Session_num));


%% 
clearvars delimiter formatSpec fileID ans;

PositionX(PositionX<0) = 0;

% Invalid trials are labeled VOID in first column in dataArray
iVoidOff = find(strcmp(EventName, 'VoidOff'), 1 );
iSessionEnd = find(strcmp(EventName, 'SessionEnd'), 1 );
ix = find(or(strncmp(EventName, 'Void',4), strcmp(EventName, "Calibration_On")));
tx = Time(ix);
px = PositionX(ix);
py = PositionY(ix);
Void_unreal = horzcat(ix, tx, px, py);
Void_unreal(Void_unreal(:,1)<iVoidOff,:) = [];
Void_unreal(Void_unreal(:,1)>iSessionEnd,:) = [];
clearvars ix tx px py


% Find Start index for each laps
iLapStart = find(strcmp(EventName, LapStartEvent));
iLapStart(length(iLapStart))=[];
Lap = PositionX(iLapStart);

pLapStart = PositionX(iLapStart+2);
tLapStart = Time(iLapStart);
nLap=length(Lap);
LapNum = size(iLapStart, 1);


% Remove Void laps from nLAP
for n=1:length(Void_unreal(:,1))
    for m=1:(nLap-1)
        if (Void_unreal(n,1)>iLapStart(m))&&(Void_unreal(n,1)<iLapStart(m+1))
            EventName((iLapStart(m)):(iLapStart(m+1)-1),2)={'Void_Lap'};
%             PositionX((iLapStart(m)):(iLapStart(m+1)-1))=-1;
        end
    end
end

LapStart_unreal_recording = MakeEventLog_recording(Time, PositionX, PositionY, EventName,LapStartEvent,0,0,Session_num);
LapEnd_unreal_recording = MakeEventLog_recording(Time, PositionX, PositionY, EventName,LapEndEvent,0,0,Session_num);
TrialStart_unreal_recording = MakeEventLog_recording(Time, PositionX, PositionY, EventName,TrialStartEvent,LapStart_unreal_recording,LapEnd_unreal_recording,Session_num);
TrialEnd_unreal_recording = MakeEventLog_recording(Time, PositionX, PositionY, EventName,TrialEndEvent,LapStart_unreal_recording,LapEnd_unreal_recording,Session_num);
CursorTimerReset_unreal_recording = MakeEventLog_recording(Time, PositionX, PositionY, EventName,CursorTimerResetEvent,LapStart_unreal_recording,LapEnd_unreal_recording,Session_num);
TrialType_unreal_recording = MakeEventLog_recording(TType, PositionX, PositionY, EventName,TrialType,LapStart_unreal_recording,LapEnd_unreal_recording,Session_num);

TrialInfo_recording = zeros(length(TrialStart_unreal_recording),5);
TrialInfo_recording(:,1) = TrialStart_unreal_recording(:,2);
TrialInfo_recording(:,2) = TrialEnd_unreal_recording(:,2);
TrialInfo_recording(:,3) = TrialEnd_unreal_recording(:,2)-TrialStart_unreal_recording(:,2);


ChoiceLeft_unreal_recording = MakeEventLog_recording(Time, PositionX, PositionY, EventName,ChoiceLeftEvent,LapStart_unreal_recording,LapEnd_unreal_recording,Session_num);
ChoiceRight_unreal_recording = MakeEventLog_recording(Time, PositionX, PositionY, EventName,ChoiceRightEvent,LapStart_unreal_recording,LapEnd_unreal_recording,Session_num);
Choice_unreal_recording=[horzcat(ChoiceLeft_unreal_recording,ones(size(ChoiceLeft_unreal_recording,1),1)); horzcat(ChoiceRight_unreal_recording,2*ones(size(ChoiceRight_unreal_recording,1),1))];% ChioceA + ChoiceB
Choice_unreal_recording=sortrows(Choice_unreal_recording,1);


%%
for i = 1:length(TrialInfo_recording)
    if str2double(extractBetween(num2str(TrialType_unreal_recording(i,2)),4,4))+1 ~= Choice_unreal_recording(i,end)
        TrialInfo_recording(i,4) = 1;
    end
        
    if TrialInfo_recording(i,3)>mean(TrialInfo_recording(:,3))+2*std(TrialInfo_recording(:,3))
        TrialInfo_recording(i,4) = 1;
    end
   
    for j = 1:length(CursorTimerReset_unreal_recording)
    if TrialInfo_recording(i,1)<CursorTimerReset_unreal_recording(j,2) && TrialInfo_recording(i,2)>CursorTimerReset_unreal_recording(j,2)
        TrialInfo_recording(i,4) = 1;
    end
    end
end

for i = 1:length(TrialInfo_recording)
    if TrialInfo_recording(i,4) == 1
    EventName(TrialStart_unreal_recording(i,1):TrialEnd_unreal_recording(i,1),2)={'Void'};
     EventName(TrialType_unreal_recording(i,1),2)={'Void'};
%     PositionX(TrialStart_unreal_recording(i,1):TrialEnd_unreal_recording(i,1))=-1;
%    PositionX(TrialType_unreal_recording(i,1),2)=-1;
    end
end


    


% Make matrix with only movement information
TickLog_unreal = MakeEventLog(Time, PositionX, PositionY, EventName,'Tick');
TickLog_unreal_recording = MakeEventLog_recording(Time, PositionX, PositionY, EventName,'Tick',0,0,Session_num);


% Make VoidLog
VoidLog_unreal_recording = find(strcmp(EventName(:,2),'Void'));
VoidLog_unreal_recording(find(VoidLog_unreal_recording<TickLog_unreal_recording(1,1))) = [];

VoidLog_unreal_recording_Tick = find(strcmp(EventName, 'Tick') & strcmp(EventName(:,2), 'Void'));
VoidLog_unreal_recording_Tick(find(VoidLog_unreal_recording_Tick<TickLog_unreal_recording(1,1))) = [];
VoidLog_unreal_recording_Tick(:,2) = VoidLog_unreal_recording_Tick(:,1) - TickLog_unreal_recording(1,1);




%% Location position info

% Find Starting index for turn around period indices
TurnOn_unreal = MakeEventLog(Time, PositionX, PositionY, EventName,TurnOnEvent);
TurnOff_unreal = MakeEventLog(Time, PositionX, PositionY, EventName,TurnOffEvent);
TrialStart_unreal = MakeEventLog(Time, PositionX, PositionY, EventName,TrialStartEvent);
TrialEnd_unreal = MakeEventLog(Time, PositionX, PositionY, EventName,TrialEndEvent);
CursorOn_unreal = MakeEventLog(Time, PositionX, PositionY, EventName,CursorOnEvent);
CursorChange_unreal = MakeEventLog(Time, PositionX, PositionY, EventName,CursorColorChangeEvent);
LapStart_unreal = MakeEventLog(Time, PositionX, PositionY, EventName,LapStartEvent);
LapEnd_unreal = MakeEventLog(Time, PositionX, PositionY, EventName,LapEndEvent);
ObjOn_unreal = MakeEventLog(Time, PositionX, PositionY, EventName,ObjOnEvent);
ObjOff_unreal = MakeEventLog(Time, PositionX, PositionY, EventName,ObjOffEvent);
JoystickLeft_unreal = MakeEventLog(Time, PositionX, PositionY, EventName,JoystickLeftEvent);
JoystickRight_unreal = MakeEventLog(Time, PositionX, PositionY, EventName,JoystickRightEvent);
ChoiceLeft_unreal = MakeEventLog(Time, PositionX, PositionY, EventName,ChoiceLeftEvent);
ChoiceRight_unreal = MakeEventLog(Time, PositionX, PositionY, EventName,ChoiceRightEvent);
CursorTimerReset_unreal = MakeEventLog(Time, PositionX, PositionY, EventName,CursorTimerResetEvent);
TrialType_unreal = MakeEventLog(TType, PositionX, PositionY, EventName,TrialType);





LapStart_unreal_recording = MakeEventLog_recording(Time, PositionX, PositionY, EventName,LapStartEvent,0,0,Session_num);
LapEnd_unreal_recording = MakeEventLog_recording(Time, PositionX, PositionY, EventName,LapEndEvent,0,0,Session_num);
ObjOn_unreal_recording = MakeEventLog_recording(Time, PositionX, PositionY, EventName,ObjOnEvent,LapStart_unreal_recording,LapEnd_unreal_recording,Session_num);
ObjOff_unreal_recording = MakeEventLog_recording(Time, PositionX, PositionY, EventName,ObjOffEvent,LapStart_unreal_recording,LapEnd_unreal_recording,Session_num);
JoystickLeft_unreal_recording = MakeEventLog_recording(Time, PositionX, PositionY, EventName,JoystickLeftEvent,LapStart_unreal_recording,LapEnd_unreal_recording,Session_num);
JoystickRight_unreal_recording = MakeEventLog_recording(Time, PositionX, PositionY, EventName,JoystickRightEvent,LapStart_unreal_recording,LapEnd_unreal_recording,Session_num);
ChoiceLeft_unreal_recording = MakeEventLog_recording(Time, PositionX, PositionY, EventName,ChoiceLeftEvent,LapStart_unreal_recording,LapEnd_unreal_recording,Session_num);
ChoiceRight_unreal_recording = MakeEventLog_recording(Time, PositionX, PositionY, EventName,ChoiceRightEvent,LapStart_unreal_recording,LapEnd_unreal_recording,Session_num);
TrialType_unreal_recording = MakeEventLog_recording(TType, PositionX, PositionY, EventName,TrialType,LapStart_unreal_recording,LapEnd_unreal_recording,Session_num);
TurnOn_unreal_recording = MakeEventLog_recording(Time, PositionX, PositionY, EventName,TurnOnEvent,LapStart_unreal_recording,LapEnd_unreal_recording,Session_num);
TurnOff_unreal_recording = MakeEventLog_recording(Time, PositionX, PositionY, EventName,TurnOffEvent,LapStart_unreal_recording,LapEnd_unreal_recording,Session_num);
TrialStart_unreal_recording = MakeEventLog_recording(Time, PositionX, PositionY, EventName,TrialStartEvent,LapStart_unreal_recording,LapEnd_unreal_recording,Session_num);
TrialEnd_unreal_recording = MakeEventLog_recording(Time, PositionX, PositionY, EventName,TrialEndEvent,LapStart_unreal_recording,LapEnd_unreal_recording,Session_num);
CursorOn_unreal_recording = MakeEventLog_recording(Time, PositionX, PositionY, EventName,CursorOnEvent,LapStart_unreal_recording,LapEnd_unreal_recording,Session_num);
CursorChange_unreal_recording = MakeEventLog_recording(Time, PositionX, PositionY, EventName,CursorColorChangeEvent,LapStart_unreal_recording,LapEnd_unreal_recording,Session_num);
CursorTimerReset_unreal_recording = MakeEventLog_recording(Time, PositionX, PositionY, EventName,CursorTimerResetEvent,LapStart_unreal_recording,LapEnd_unreal_recording,Session_num);


TickLog_unreal_recording(TickLog_unreal_recording(:,1)<LapStart_unreal_recording(1,1),:) = [];
TickLog_unreal_recording(TickLog_unreal_recording(:,1)>LapEnd_unreal_recording(end,1),:) = [];
LapEnd_unreal_recording(LapEnd_unreal_recording(:,1)<LapStart_unreal_recording(1,1),:) = [];
LapStart_unreal_recording(LapStart_unreal_recording(:,1)>LapEnd_unreal_recording(end,1),:) = [];










Choice_unreal=[horzcat(ChoiceLeft_unreal,ones(size(ChoiceLeft_unreal,1),1)); horzcat(ChoiceRight_unreal,2*ones(size(ChoiceRight_unreal,1),1))];% ChioceA + ChoiceB
Choice_unreal=sortrows(Choice_unreal,1);


Choice_unreal_recording=[horzcat(ChoiceLeft_unreal_recording,ones(size(ChoiceLeft_unreal_recording,1),1)); horzcat(ChoiceRight_unreal_recording,2*ones(size(ChoiceRight_unreal_recording,1),1))];% ChioceA + ChoiceB
Choice_unreal_recording=sortrows(Choice_unreal_recording,1);

if LapEnd_unreal_recording(1,1) < LapStart_unreal_recording(1,1)
    LapEnd_unreal_recording(1,:) = [];
end
if LapEnd_unreal_recording(end,1) < LapStart_unreal_recording(end,1)
    LapStart_unreal_recording(end,:) = [];
end

l=0;
for i = 1:length(TrialType_unreal_recording)
    TrialType_unreal_recording(i,9) = TrialType_unreal_recording(i,5);
    if l>size(LapStart_unreal_recording,1)
        break
    end
    for j = 1:6
        TrialType_unreal_recording(i,j+2) = str2double(extractBetween(num2str(TrialType_unreal_recording(i,2)),j,j));
        if j>4
            TrialType_unreal_recording(i,j+2) = TrialType_unreal_recording(i,j+2)+1;
        end
    end
   if TrialType_unreal_recording(i,4) == 1 && TrialType_unreal_recording(i,5) == 1
       LapType_unreal_recording (l+1,1) = LapStart_unreal_recording(l+1,3);
       LapType_unreal_recording (l+1,2) = TrialType_unreal_recording(i,3);

       l=l+1;

   end
end
 TrialType_unreal_recording(find(TrialType_unreal_recording(:,1)>LapEnd_unreal_recording(end,1)),:) = [];


LapStart_unreal(end,:) = [];
TrialType_unreal(end,:) = [];
