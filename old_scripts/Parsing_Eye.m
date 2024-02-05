% Eyelink data parsing
% Written by SJM (19/12/30)
% Updated by SJM (20/02/05)

% Input argument: Eye_Analog_datapixx, TickLog_datapixx_recording, TickLog_unreal_recording, TickLog_sync_recording
% Output argument: Eye_Analog_unreal, Eye_Analog_unreal_recording, Eye_Analog_sync_recording
% Eye_Analog_sync_recording_forest_left, Eye_Analog_sync_recording_forest_right, Eye_Analog_sync_recording_forest_Conly, Eye_Analog_sync_recording_city_left, Eye_Analog_sync_recording_city_right, Eye_Analog_sync_recording_city_Conly,


%% Initialize
clear Eye_Analog_unreal_recording Eye_Analog_sync_recording Eye_Analog_sync_recording_info 

%% Eyelink Data (Unreal timestamp)
Eye_Analog_unreal_recording(:,1) = interp1(TickLog_datapixx_recording(:,1), TickLog_unreal_recording(:,2), Eye_Analog_datapixx(:,4),'linear'); % Unreal TickLog의 timestamp에 맞춰 eyedata timestamp를 linear interpolation
Eye_Analog_unreal_recording(:,2) = Eye_Analog_datapixx(:,1); % Gaze position X data
Eye_Analog_unreal_recording(:,3) = Eye_Analog_datapixx(:,2); % Gaze position Y data
Eye_Analog_unreal_recording(:,4) = Eye_Analog_datapixx(:,3); % Pupil size data
Eye_Analog_unreal_recording(:,5) = interp1(TickLog_unreal(:,2), TickLog_unreal(:,3), Eye_Analog_unreal_recording(:,1), 'linear','extrap'); % TickLog의 position data(X좌표)를 linear interpolation
Eye_Analog_unreal_recording(find(isnan(Eye_Analog_unreal_recording(:,5))),:) =[];  % Position 좌표가 Nan으로 입력된, task 시작 전 및 종료 후 eye data를 제거

Eye_Analog_unreal_recording(Eye_Analog_unreal_recording(:,1)<tRecordingStart,:) = []; % Recording start 이전 timestamp 가진 eyedata 제거
Eye_Analog_unreal_recording(Eye_Analog_unreal_recording(:,1)>tRecordingEnd,:) = []; % Recording end 이후 timestamp 가진 eyedata 제거

%% Eyelink Data (Neuralynx timestamp)
Eye_Analog_sync_recording(:,1) = interp1(TickLog_unreal_recording(:,2), TickLog_sync_recording(:,1), Eye_Analog_unreal_recording(:,1), 'linear'); % Neuralynx TickLog의 timestamp에 맞춰 eyedata timestamp를 linear interpolation
Eye_Analog_sync_recording(:,2) = Eye_Analog_unreal_recording(:,2); % Gaze position X data
Eye_Analog_sync_recording(:,3) = Eye_Analog_unreal_recording(:,3); % Gaze position Y data
Eye_Analog_sync_recording(:,4) = Eye_Analog_unreal_recording(:,4); % Pupil size data

%% Add Information Column to Eyelink Data
Eye_Analog_sync_recording_info(:,1) = Eye_Analog_sync_recording(:,1); % Timestamp
Eye_Analog_sync_recording_info(:,2) = Eye_Analog_sync_recording(:,2); % Gaze position X data
Eye_Analog_sync_recording_info(:,3) = Eye_Analog_sync_recording(:,3); % Gaze position Y data

for i = 4:13
Eye_Analog_sync_recording_info(:,i) = interp1(TickLog_sync_recording_info(:,1),TickLog_sync_recording_info(:,i), Eye_Analog_sync_recording_info(:,1), 'nearest', 'extrap'); % TickLog_info의 information column을 eyelink data의 timestamp에 맞는 값으로 nearest interpolation
end

Eye_Analog_sync_recording(:,5) = (abs(Eye_Analog_sync_recording(:,2))<5).*(abs(Eye_Analog_sync_recording(:,3))<5); % VR monitor를 벗어난 gaze data를 void(0) 처리 (analog voltage 절대값이 5V 이상인 data)
Eye_Analog_sync_recording(:,2) = (Eye_Analog_sync_recording(:,2) + 5) * 192; % Analog voltage값으로 기록된 gaze X position data를 monitor 해상도에 맞게 변환 ([-5 5] -> [0 1920])
Eye_Analog_sync_recording(:,3) = (Eye_Analog_sync_recording(:,3) + 5) * 108; % Analog voltage값으로 기록된 gaze Y position data를 monitor 해상도에 맞게 변환 ([-5 5] -> [0 1080])

Eye_Analog_sync_recording_info(:,2) = (Eye_Analog_sync_recording_info(:,2) + 5) * 192; % Analog voltage값으로 기록된 gaze X position data를 monitor 해상도에 맞게 변환 ([-5 5] -> [0 1920])
Eye_Analog_sync_recording_info(:,3) = (Eye_Analog_sync_recording_info(:,3) + 5) * 108; % Analog voltage값으로 기록된 gaze Y position data를 monitor 해상도에 맞게 변환 ([-5 5] -> [0 1080])

%% Eye_SpeedTable

Eye_SpeedTable = [];  % 변수 초기화
Eye_SpeedTable(:,1) = Eye_Analog_sync_recording_info(:,1);  % 1열: Timestamp
Eye_SpeedTable(1,2) = 0; Eye_SpeedTable(1,3) = 0; % 1행의 이동 거리와 속도를 0으로 설정
for i = 2:length(Eye_SpeedTable(:,1))
Eye_SpeedTable(i,2) = sqrt((Eye_Analog_sync_recording_info(i,2)-Eye_Analog_sync_recording_info(i-1,2))^2 + (Eye_Analog_sync_recording_info(i,3)-Eye_Analog_sync_recording_info(i-1,3))^2); % 2열: 이동 거리(pixel)
Eye_SpeedTable(i,3) = Eye_SpeedTable(i,2)/(Eye_SpeedTable(i,1)-Eye_SpeedTable(i-1,1));  % 3열: 이동 속도
end

% figure;
% plot(Eye_SpeedTable(:,1), Eye_SpeedTable(:,3))

%% Eyelink Data Parsing by Context and Response Side
% Eye_Analog_sync_recording(:,5): 0인 경우 VR monitor 바깥의 gaze point이므로 배제
% Eye_Analog_sync_recording_info(:,4): Forest=1, City=2
% Eye_Analog_sync_recording_info(:,6): Pre-Cursor=-1, Pre-Sample=1, Sample=2, Choice=3
% Eye_Analog_sync_recording_info(:,10): Left=1, Right=2, ObjectOn~Choice 가 아닌 구간은 0
% Eye_Analog_sync_recording_info(:,5): Choice location별 분리 Outbound=2,4,6,8; Inbound=12,14,16,18
% Eye_Analog_sync_recording_info(:,13): 1인 경우 void 처리된 Trial 및 Lap이므로 배제

for i = 1:8
    if i < 5
        j = 2*i;
    else
        j = 2*i+2;
    end

Eye_id(:,:,i) = logical(Eye_Analog_sync_recording(:,5) .* (Eye_Analog_sync_recording_info(:,4)==1).* (Eye_Analog_sync_recording_info(:,10)==1)).*(Eye_Analog_sync_recording_info(:,5)==j).*(Eye_Analog_sync_recording_info(:,13)==0);
Eye_Analog_sync_recording_forest_left(1:length(find(Eye_id(:,:,i)==1)),:,i) = horzcat(Eye_Analog_sync_recording(find(Eye_id(:,:,i)==1),1), Eye_Analog_sync_recording(find(Eye_id(:,:,i)==1),2), Eye_Analog_sync_recording(find(Eye_id(:,:,i)==1),3)); clear Eye_id;

Eye_id(:,:,i) = Eye_Analog_sync_recording(:,5).*(Eye_Analog_sync_recording_info(:,4)==1).*(Eye_Analog_sync_recording_info(:,10)==2).*(Eye_Analog_sync_recording_info(:,5)==j).*(Eye_Analog_sync_recording_info(:,13)==0);
Eye_Analog_sync_recording_forest_right(1:length(find(Eye_id(:,:,i)==1)),:,i) = horzcat(Eye_Analog_sync_recording(find(Eye_id(:,:,i)==1),1), Eye_Analog_sync_recording(find(Eye_id(:,:,i)==1),2), Eye_Analog_sync_recording(find(Eye_id(:,:,i)==1),3)); clear Eye_id;

Eye_id(:,:,i) = Eye_Analog_sync_recording(:,5).*(Eye_Analog_sync_recording_info(:,4)==1).*(abs(Eye_Analog_sync_recording_info(:,6))==1).*(Eye_Analog_sync_recording_info(:,5)==j).*(Eye_Analog_sync_recording_info(:,13)==0);
Eye_Analog_sync_recording_forest_COnly(1:length(find(Eye_id(:,:,i)==1)),:,i) = horzcat(Eye_Analog_sync_recording(find(Eye_id(:,:,i)==1),1), Eye_Analog_sync_recording(find(Eye_id(:,:,i)==1),2), Eye_Analog_sync_recording(find(Eye_id(:,:,i)==1),3)); clear Eye_id;

Eye_id(:,:,i) = Eye_Analog_sync_recording(:,5).*(Eye_Analog_sync_recording_info(:,4)==2).*(Eye_Analog_sync_recording_info(:,10)==1).*(Eye_Analog_sync_recording_info(:,5)==j).*(Eye_Analog_sync_recording_info(:,13)==0);
Eye_Analog_sync_recording_city_left(1:length(find(Eye_id(:,:,i)==1)),:,i) = horzcat(Eye_Analog_sync_recording(find(Eye_id(:,:,i)==1),1), Eye_Analog_sync_recording(find(Eye_id(:,:,i)==1),2), Eye_Analog_sync_recording(find(Eye_id(:,:,i)==1),3)); clear Eye_id;

Eye_id(:,:,i) = Eye_Analog_sync_recording(:,5).*(Eye_Analog_sync_recording_info(:,4)==2).*(Eye_Analog_sync_recording_info(:,10)==2).*(Eye_Analog_sync_recording_info(:,5)==j).*(Eye_Analog_sync_recording_info(:,13)==0);
Eye_Analog_sync_recording_city_right(1:length(find(Eye_id(:,:,i)==1)),:,i) = horzcat(Eye_Analog_sync_recording(find(Eye_id(:,:,i)==1),1), Eye_Analog_sync_recording(find(Eye_id(:,:,i)==1),2), Eye_Analog_sync_recording(find(Eye_id(:,:,i)==1),3)); clear Eye_id;

Eye_id(:,:,i) = Eye_Analog_sync_recording(:,5).*(Eye_Analog_sync_recording_info(:,4)==2).*(abs(Eye_Analog_sync_recording_info(:,6))==1).*(Eye_Analog_sync_recording_info(:,5)==j).*(Eye_Analog_sync_recording_info(:,13)==0);
Eye_Analog_sync_recording_city_COnly(1:length(find(Eye_id(:,:,i)==1)),:,i) = horzcat(Eye_Analog_sync_recording(find(Eye_id(:,:,i)==1),1), Eye_Analog_sync_recording(find(Eye_id(:,:,i)==1),2), Eye_Analog_sync_recording(find(Eye_id(:,:,i)==1),3)); clear Eye_id;
end