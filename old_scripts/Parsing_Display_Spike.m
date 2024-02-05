
Dir_Data = processed_folder_neuralynx;
nttDirectory=[Dir_Data];

for ClusterNum = 1:MaxClusterNum
clear [nSPKS, withinREFRACPortion, SPKWIDTHAMP, SPKWIDTH, ttSPKWIDTH, MaximumChannel, thisCLAP,thisCLTS, maxAPMat, ISODIST, LRATIO, PEAKMat, VALLEYMat, ttSPKPEAK, ttSPKVALLEY]
clear SpikeIndex SpikeTime SpikePosition TTL1TimeT SpikeTimeT SpikeData Frequency 
clear SpikeData_info
clear spk_area spk_context spk_choice_phase spk_left_obj spk_right_obj spk_correct_side spk_Response
clear spk_area_forest spk_area_city spk_choice_phase_forest spk_choice_phase_city spk_area_occ spk_area_forest_occ spk_area_city_occ spk_choice_phase_occ spk_loc spk_run
clear spk_eye spk_eye_forest_left_id spk_eye_forest_left spk_eye_forest_right_id spk_eye_forest_right spk_eye_forest_COnly_id spk_eye_forest_COnly spk_eye_city_left_id spk_eye_city_left spk_eye_city_right_id spk_eye_city_right spk_eye_city_COnly_id spk_eye_city_COnly
    
    
ClusterName=['TT' num2str(TetrodeNumber) '-0' num2str(Session_num) '.xls'];
cd(nttDirectory);
[nSPKS, withinREFRACPortion, SPKWIDTHAMP, SPKWIDTH, ttSPKWIDTH, MaximumChannel, thisCLAP,thisCLTS, maxAPMat, ISODIST, LRATIO, PEAKMat, VALLEYMat, ttSPKPEAK, ttSPKVALLEY] = JKGetClusterQuals_SJM(Dir_Data, TetrodeNumber, ClusterNum, Session_num, [0 1 0 0], LapStart_sync_recording(1,1), LapEnd_sync_recording(end,1));

% TT1_Samples = thisCLTS(:,4:end);
% TT1_Timestamps = thisCLTS(:,2);
SpikeIndex = thisCLTS(:,1);
SpikeTime = thisCLTS(:,2);

SpikePositionX = interp1(TickLog_sync_recording(:,1), TickLog_sync_recording(:,2), SpikeTime, 'linear','extrap');
SpikePositionY = interp1(TickLog_sync_recording(:,1), TickLog_sync_recording(:,3), SpikeTime, 'linear','extrap');
TTL1TimeT = (((TickLog_sync_recording(:,1)-min(TickLog_sync_recording(:,1))))./1000000);
SpikeTimeT = (((SpikeTime-min(TickLog_sync_recording(:,1))))./1000000);
SpikeData = [SpikeTime, SpikePositionX SpikePositionY];

Frequency = length(SpikeTime)/max(TTL1TimeT);
% SpikeData = [SpikeTime, SpikePosition];
% SpikeData(find(isnan(SpikePosition)),:) = [];
% SpikeTime= SpikeData(:,1);  SpikePosition= SpikeData(:,2);

% SpikeData(SpikeData(:,1)<LapStart_neuralynx(1,1),:) = [];
% SpikeData(SpikeData(:,1)>LapStart_neuralynx(end,1),:) = [];

%% make SpikeData_info
SpikeData_info(:,1) = SpikeData(:,1);
SpikeData_info(:,2) = SpikeData(:,2);
SpikeData_info(:,3) = SpikeData(:,3);
for i = 4:13
SpikeData_info(:,i) = interp1(TickLog_sync_recording_info(:,1),TickLog_sync_recording_info(:,i), SpikeData_info(:,1), 'nearest');
end

for i = 1:length(SpikeData_info)
    if SpikeData_info(i,5) == 1 || SpikeData_info(i,5) == 19
        if SpikeData_info(i,2) >= 2800
            SpikeData_info(i,end) = 1;
        end
    end
end

%% Calc FR of each choice phases
% for c = 1:2
%     for i = 1:size(TrialInfo_sync_recording,1)
%         for j = 1:3
%             FR_Trial(i,j,c) = length(SpikeData_info(SpikeData_info(:,11)==i & SpikeData_info(:,5)==j& SpikeData_info(:,3)==c))/(TrialInfo_sync_recording(i,j+2)*10^-6);
%         end
%     end
% end
%% Track Parsing
for i = 1:length(SpikeData_info)
    for c1 = 0:19
        spk_area (i,c1+1) = (SpikeData_info(i,5) == c1);
    end
    for c2 = 1:2
        spk_context (i,c2) = (SpikeData_info(i,4) == c2);
    end
    for c3 = 1:3
        spk_choice_phase (i,c3) = (SpikeData_info(i,6) == c3);
    end
    for c4 = 1:6
        spk_left_obj (i,c4) = (SpikeData_info(i,7) == c4);
    end
    for c5 = 1:6
       spk_right_obj (i,c5) = (SpikeData_info(i,8) == c5);
    end
    for c6 = 1:2
        spk_correct_side (i,c6) = (SpikeData_info(i,9) == c6);
    end
    for c7 = 1:2
        spk_Response (i,c7) = (SpikeData_info(i,10) == c7);
    end
    for c8 = 1:2
        spk_correctness (i,c8) = (SpikeData_info(i,11) == c8);
    end
    spk_void(i,1) = (SpikeData_info(i,13) == 0);
end
spk_run(:,1) =  sum(spk_area(:,2:2:10),2);
spk_run(:,2) =  sum(spk_area(:,12:2:20),2);
spk_run(:,3) =  sum(spk_area(:,11),2);

%% spk_area_context
spk_area_forest = spk_area .* spk_context(:,1);
spk_area_city = spk_area .* spk_context(:,2);
spk_choice_phase_forest = spk_choice_phase.* spk_context(:,1);
spk_choice_phase_city = spk_choice_phase.* spk_context(:,2);

spk_area_occ = sum(spk_area);
spk_area_forest_occ = sum(spk_area_forest);
spk_area_city_occ = sum(spk_area_city);
spk_choice_phase_occ = sum(spk_choice_phase);
% 
% for c1 = 1:8
%     if c1 < 5
%         choice_phase_overall_Trial_spk(:,:,c1) = choice_phase_spk.* area_spk (:,2*c1+1);
%     else
%         choice_phase_overall_Trial_spk(:,:,c1)  = choice_phase_spk.* area_spk (:,2*c1+3);
%     end
%     choice_phase_overall_Trial_spk_acc(c1,:) = sum(choice_phase_overall_Trial_spk(:,:,c1));
% end
% 
% for c1 = 1:8
%     if c1 < 5
%         choice_phase_forest_Trial_spk(:,:,c1) = choice_phase_forest_spk.* area_spk (:,2*c1+1);
%     else
%         choice_phase_forest_Trial_spk(:,:,c1)  = choice_phase_forest_spk.* area_spk (:,2*c1+3);
%     end
%     choice_phase_forest_Trial_spk_acc(c1,:) = sum(choice_phase_forest_Trial_spk(:,:,c1));
% end
% 
% for c1 = 1:8
%     if c1 < 5
%         choice_phase_city_Trial_spk(:,:,c1) = choice_phase_city_spk.* area_spk (:,2*c1+1);
%     else
%         choice_phase_city_Trial_spk(:,:,c1)  = choice_phase_city_spk.* area_spk (:,2*c1+3);
%     end
%     choice_phase_city_Trial_spk_acc(c1,:) = sum(choice_phase_city_Trial_spk(:,:,c1));
% end


%% spk_loc
for i = 1:4
spk_loc(:,i) = spk_area(:,2*i);
spk_loc(:,i+4) = spk_area(:,10+2*i);
end
%% spk_eye
spk_eye = [];
spk_eye(:,1) = SpikeData_info(:,1);
spk_eye(:,2) = interp1(Eye_Analog_sync_recording(:,1), Eye_Analog_sync_recording(:,2), spk_eye(:,1) , 'nearest');
spk_eye(:,3) = interp1(Eye_Analog_sync_recording(:,1), Eye_Analog_sync_recording(:,3), spk_eye(:,1) , 'nearest');


spk_eye(:,5) =(spk_eye(:,2)>0).*(spk_eye(:,2)<1920).*(spk_eye(:,3)>0).*(spk_eye(:,3)<1080);

%% spk_eye, parsed by object location, context, and responses

for i = 1:8
    if i < 5
        j = 2*i;
    else
        j = 2*i+2;
    end
% 
% spk_eye_left_id(:,:,i) = spk_eye(:,5).*(SpikeData_info(:,9)==1).*(SpikeData_info(:,4)==j).*(SpikeData_info(:,12)==0);
% spk_eye_left(1:length(find(spk_eye_left_id(:,:,i)==1)),:,i) = horzcat(spk_eye(find(spk_eye_left_id(:,:,i)==1),1), spk_eye(find(spk_eye_left_id(:,:,i)==1),2), spk_eye(find(spk_eye_left_id(:,:,i)==1),3));

spk_eye_forest_left_id(:,:,i) = logical(spk_eye(:,5) .* (SpikeData_info(:,4)==1).* (SpikeData_info(:,10)==1)).*(SpikeData_info(:,5)==j).*(SpikeData_info(:,13)==0);
spk_eye_forest_left(1:length(find(spk_eye_forest_left_id(:,:,i)==1)),:,i) = horzcat(spk_eye(find(spk_eye_forest_left_id(:,:,i)==1),1), spk_eye(find(spk_eye_forest_left_id(:,:,i)==1),2), spk_eye(find(spk_eye_forest_left_id(:,:,i)==1),3));

spk_eye_forest_right_id(:,:,i) = spk_eye(:,5).*(SpikeData_info(:,4)==1).*(SpikeData_info(:,10)==2).*(SpikeData_info(:,5)==j).*(SpikeData_info(:,13)==0);
spk_eye_forest_right(1:length(find(spk_eye_forest_right_id(:,:,i)==1)),:,i) = horzcat(spk_eye(find(spk_eye_forest_right_id(:,:,i)==1),1), spk_eye(find(spk_eye_forest_right_id(:,:,i)==1),2), spk_eye(find(spk_eye_forest_right_id(:,:,i)==1),3));

spk_eye_forest_COnly_id(:,:,i) = spk_eye(:,5).*(SpikeData_info(:,4)==1).*((SpikeData_info(:,6))==1).*(SpikeData_info(:,5)==j).*(SpikeData_info(:,13)==0);
spk_eye_forest_COnly(1:length(find(spk_eye_forest_COnly_id(:,:,i)==1)),:,i) = horzcat(spk_eye(find(spk_eye_forest_COnly_id(:,:,i)==1),1), spk_eye(find(spk_eye_forest_COnly_id(:,:,i)==1),2), spk_eye(find(spk_eye_forest_COnly_id(:,:,i)==1),3));

spk_eye_city_left_id(:,:,i) = spk_eye(:,5).*(SpikeData_info(:,4)==2).*(SpikeData_info(:,10)==1).*(SpikeData_info(:,5)==j).*(SpikeData_info(:,13)==0);
spk_eye_city_left(1:length(find(spk_eye_city_left_id(:,:,i)==1)),:,i) = horzcat(spk_eye(find(spk_eye_city_left_id(:,:,i)==1),1), spk_eye(find(spk_eye_city_left_id(:,:,i)==1),2), spk_eye(find(spk_eye_city_left_id(:,:,i)==1),3));

spk_eye_city_right_id(:,:,i) = spk_eye(:,5).*(SpikeData_info(:,4)==2).*(SpikeData_info(:,10)==2).*(SpikeData_info(:,5)==j).*(SpikeData_info(:,13)==0);
spk_eye_city_right(1:length(find(spk_eye_city_right_id(:,:,i)==1)),:,i) = horzcat(spk_eye(find(spk_eye_city_right_id(:,:,i)==1),1), spk_eye(find(spk_eye_city_right_id(:,:,i)==1),2), spk_eye(find(spk_eye_city_right_id(:,:,i)==1),3));

spk_eye_city_COnly_id(:,:,i) = spk_eye(:,5).*(SpikeData_info(:,4)==2).*((SpikeData_info(:,6))==1).*(SpikeData_info(:,5)==j).*(SpikeData_info(:,13)==0);
spk_eye_city_COnly(1:length(find(spk_eye_city_COnly_id(:,:,i)==1)),:,i) = horzcat(spk_eye(find(spk_eye_city_COnly_id(:,:,i)==1),1), spk_eye(find(spk_eye_city_COnly_id(:,:,i)==1),2), spk_eye(find(spk_eye_city_COnly_id(:,:,i)==1),3));
end


%% Eye gaze position Skagg's map
%     XsizeOfVideo = 1920;
%     YsizeOfVideo = 1080;
%     samplingRate = 1000;
%     scaleForRateMap = 20;
%     
%     binXForRateMap = XsizeOfVideo / scaleForRateMap ;
%     binYForRateMap = YsizeOfVideo / scaleForRateMap ;
%     
%     
%         [Eye_occMat, spkMat, rawMat, Eye_skaggsrateMat] = abmFiringRateMap( ...
%             [spk_eye(:,1), spk_eye(:,2), spk_eye(:,3)],...
%             [Eye_Analog_sync_recording(:,1), Eye_Analog_sync_recording(:,2), Eye_Analog_sync_recording(:,3)],...
%         binYForRateMap, binXForRateMap, scaleForRateMap, samplingRate);
% 
%     
%     
%         [Eye_forest_left_occMat, spkMat, rawMat, Eye_forest_left_skaggsrateMat] = abmFiringRateMap( ...
%             [spk_eye_forest_left(:,1), spk_eye_forest_left(:,2), spk_eye_forest_left(:,3)],...
%             [Eye_Analog_sync_recording_forest_left(:,1), Eye_Analog_sync_recording_forest_left(:,2), Eye_Analog_sync_recording_forest_left(:,3)],...
%         binYForRateMap, binXForRateMap, scaleForRateMap, samplingRate);
%     Eye_ForestMaxFR(1,1) = nanmax(nanmax(Eye_forest_left_skaggsrateMat));
% 
% 
%         [Eye_forest_right_occMat, spkMat, rawMat, Eye_forest_right_skaggsrateMat] = abmFiringRateMap( ...
%             [spk_eye_forest_right(:,1), spk_eye_forest_right(:,2), spk_eye_forest_right(:,3)],...
%             [Eye_Analog_sync_recording_forest_right(:,1), Eye_Analog_sync_recording_forest_right(:,2), Eye_Analog_sync_recording_forest_right(:,3)],...
%         binYForRateMap, binXForRateMap, scaleForRateMap, samplingRate);
%     Eye_ForestMaxFR(1,2) = nanmax(nanmax(Eye_forest_right_skaggsrateMat));
% 
%         [Eye_forest_COnly_occMat, spkMat, rawMat, Eye_forest_COnly_skaggsrateMat] = abmFiringRateMap( ...
%             [spk_eye_forest_COnly(:,1), spk_eye_forest_COnly(:,2), spk_eye_forest_COnly(:,3)],...
%             [Eye_Analog_sync_recording_forest_COnly(:,1), Eye_Analog_sync_recording_forest_COnly(:,2), Eye_Analog_sync_recording_forest_COnly(:,3)],...
%         binYForRateMap, binXForRateMap, scaleForRateMap, samplingRate);
%     Eye_ForestMaxFR(1,3) = nanmax(nanmax(Eye_forest_COnly_skaggsrateMat));
% 
%         [Eye_city_left_occMat, spkMat, rawMat, Eye_city_left_skaggsrateMat] = abmFiringRateMap( ...
%             [spk_eye_city_left(:,1), spk_eye_city_left(:,2), spk_eye_city_left(:,3)],...
%             [Eye_Analog_sync_recording_city_left(:,1), Eye_Analog_sync_recording_city_left(:,2), Eye_Analog_sync_recording_city_left(:,3)],...
%         binYForRateMap, binXForRateMap, scaleForRateMap, samplingRate);
%     Eye_CityMaxFR(1,1) = nanmax(nanmax(Eye_city_left_skaggsrateMat));
% 
% 
%         [Eye_city_right_occMat, spkMat, rawMat, Eye_city_right_skaggsrateMat] = abmFiringRateMap( ...
%             [spk_eye_city_right(:,1), spk_eye_city_right(:,2), spk_eye_city_right(:,3)],...
%             [Eye_Analog_sync_recording_city_right(:,1), Eye_Analog_sync_recording_city_right(:,2), Eye_Analog_sync_recording_city_right(:,3)],...
%         binYForRateMap, binXForRateMap, scaleForRateMap, samplingRate);
%     Eye_CityMaxFR(1,12) = nanmax(nanmax(Eye_city_right_skaggsrateMat));
% 
%         [Eye_city_COnly_occMat, spkMat, rawMat, Eye_city_COnly_skaggsrateMat] = abmFiringRateMap( ...
%             [spk_eye_city_COnly(:,1), spk_eye_city_COnly(:,2), spk_eye_city_COnly(:,3)],...
%             [Eye_Analog_sync_recording_city_COnly(:,1), Eye_Analog_sync_recording_city_COnly(:,2), Eye_Analog_sync_recording_city_COnly(:,3)],...
%         binYForRateMap, binXForRateMap, scaleForRateMap, samplingRate);
%     Eye_CityMaxFR(1,3) = nanmax(nanmax(Eye_city_COnly_skaggsrateMat));


%%
Cal_SJM
Display_Sheet
end