function y = MakeEventLog_recording(Time, PositionX, PositionY, EventName, x, LapStart_unreal_recording, LapEnd_unreal_recording,Session_num)
iRecordingStart = find(strcmp(EventName, 'RecordingStart'),Session_num );
iRecordingEnd = find(strcmp(EventName, 'RecordingEnd'),Session_num );
if size(EventName,2)==2
ix = find(strcmp(EventName, x) & ~strcmp(EventName(:,2), 'Void_Lap'));
 vx = strcmp(EventName(ix,2), 'Void');
else
    ix = find(strcmp(EventName, x));
     vx = zeros(length(ix),1);
end

tx = Time(ix);
px = PositionX(ix);
py =  PositionY(ix);
y = horzcat(ix, tx, px,py, vx);
y(y(:,1)<iRecordingStart(Session_num,1),:) = [];
y(y(:,1)>iRecordingEnd(Session_num,1),:) = [];

if LapStart_unreal_recording(1,1) ~= 0
y(y(:,1)<LapStart_unreal_recording(1,1),:) = [];
end
if LapEnd_unreal_recording(1,1) ~= 0
y(y(:,1)>LapEnd_unreal_recording(end,1),:) = [];
end
clearvars ix tx px py
end