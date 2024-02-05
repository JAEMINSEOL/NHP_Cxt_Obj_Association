%%
SpikePosition = interp1(TickLog_sync_recording(:,1), TickLog_sync_recording(:,2), SpikeTime, 'linear','extrap');
TTL1TimeT = (((TickLog_sync_recording(:,1)-min(TickLog_sync_recording(:,1))))./1000000);
SpikeTimeT = (((SpikeTime-min(TickLog_sync_recording(:,1))))./1000000);

Frequency = length(SpikeTime)/max(TTL1TimeT);
SpikeData = [SpikeTime, SpikePosition];
SpikeData(find(isnan(SpikePosition)),:) = [];
SpikeTime= SpikeData(:,1);  SpikePosition= SpikeData(:,2);

%%
SpikeData(SpikeData(:,1)<LapStart_neuralynx(1,1),:) = [];
SpikeData(SpikeData(:,1)>LapStart_neuralynx(end,1),:) = [];

SpikeData_info(:,1) = SpikeData(:,1);
SpikeData_info(:,2) = SpikeData(:,2);
for i = 3:11
SpikeData_info(:,i) = interp1(TickLog_sync_recording_info(:,1),TickLog_sync_recording_info(:,i), SpikeData_info(:,1), 'nearest');
end

%%
for c = 1:2
    for i = 1:size(TrialInfo_sync_recording,1)
        for j = 1:3
            FR_Trial(i,j,c) = length(SpikeData_info(SpikeData_info(:,11)==i & SpikeData_info(:,5)==j& SpikeData_info(:,3)==c))/(TrialInfo_sync_recording(i,j+2)*10^-6);
        end
    end
end


%% Track Parsing

for i = 1:length(SpikeData_info)
    for c1 = 0:19
        spk_area (i,c1+1) = (SpikeData_info(i,4) == c1);
    end
    for c2 = 1:2
        spk_context (i,c2) = (SpikeData_info(i,3) == c2);
    end
    for c3 = 1:3
        spk_choice_phase (i,c3) = (SpikeData_info(i,5) == c3);
    end
    for c4 = 1:6
        spk_left_obj (i,c4) = (SpikeData_info(i,6) == c4);
    end
    for c5 = 1:6
       spk_right_obj (i,c5) = (SpikeData_info(i,7) == c5);
    end
    for c6 = 1:2
        spk_correct_side (i,c6) = (SpikeData_info(i,8) == c6);
    end
    for c7 = 1:2
        spk_Response (i,c7) = (SpikeData_info(i,9) == c7);
    end
    for c8 = 1:2
        spk_correct_side (i,c8) = (SpikeData_info(i,10) == c8);
    end
end

%%
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


%%
for i = 1:4
spk_loc(:,i) = spk_area(:,2*i);
spk_loc(:,i+4) = spk_area(:,10+2*i);
end
