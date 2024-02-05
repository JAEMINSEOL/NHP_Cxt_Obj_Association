
%%
spk_eye = [];
spk_eye(:,1) = SpikeData_info(:,1);
spk_eye(:,2) = interp1(Eye_Analog_sync_recording(:,1), Eye_Analog_sync_recording(:,2), spk_eye(:,1) , 'nearest');
spk_eye(:,3) = interp1(Eye_Analog_sync_recording(:,1), Eye_Analog_sync_recording(:,3), spk_eye(:,1) , 'nearest');


spk_eye(:,5) =(spk_eye(:,2)>0).*(spk_eye(:,2)<1920).*(spk_eye(:,3)>0).*(spk_eye(:,3)<1080);

%%

for i = 1:8
    if i < 5
        j = 2*i;
    else
        j = 2*i+2;
    end

spk_eye_left_id(:,:,i) = spk_eye(:,5).*(SpikeData_info(:,9)==1).*(SpikeData_info(:,4)==j);
spk_eye_left(1:length(find(spk_eye_left_id(:,:,i)==1)),:,i) = horzcat(spk_eye(find(spk_eye_left_id(:,:,i)==1),1), spk_eye(find(spk_eye_left_id(:,:,i)==1),2), spk_eye(find(spk_eye_left_id(:,:,i)==1),3));

spk_eye_forest_left_id(:,:,i) = logical(spk_eye(:,5) .* (SpikeData_info(:,3)==1).* (SpikeData_info(:,9)==1)).*(SpikeData_info(:,4)==j);
spk_eye_forest_left(1:length(find(spk_eye_forest_left_id(:,:,i)==1)),:,i) = horzcat(spk_eye(find(spk_eye_forest_left_id(:,:,i)==1),1), spk_eye(find(spk_eye_forest_left_id(:,:,i)==1),2), spk_eye(find(spk_eye_forest_left_id(:,:,i)==1),3));

spk_eye_forest_right_id(:,:,i) = spk_eye(:,5).*(SpikeData_info(:,3)==1).*(SpikeData_info(:,9)==2).*(SpikeData_info(:,4)==j);
spk_eye_forest_right(1:length(find(spk_eye_forest_right_id(:,:,i)==1)),:,i) = horzcat(spk_eye(find(spk_eye_forest_right_id(:,:,i)==1),1), spk_eye(find(spk_eye_forest_right_id(:,:,i)==1),2), spk_eye(find(spk_eye_forest_right_id(:,:,i)==1),3));

spk_eye_forest_COnly_id(:,:,i) = spk_eye(:,5).*(SpikeData_info(:,3)==1).*(abs(SpikeData_info(:,5))==1).*(SpikeData_info(:,4)==j);
spk_eye_forest_COnly(1:length(find(spk_eye_forest_COnly_id(:,:,i)==1)),:,i) = horzcat(spk_eye(find(spk_eye_forest_COnly_id(:,:,i)==1),1), spk_eye(find(spk_eye_forest_COnly_id(:,:,i)==1),2), spk_eye(find(spk_eye_forest_COnly_id(:,:,i)==1),3));

spk_eye_city_left_id(:,:,i) = spk_eye(:,5).*(SpikeData_info(:,3)==2).*(SpikeData_info(:,9)==1).*(SpikeData_info(:,4)==j);
spk_eye_city_left(1:length(find(spk_eye_city_left_id(:,:,i)==1)),:,i) = horzcat(spk_eye(find(spk_eye_city_left_id(:,:,i)==1),1), spk_eye(find(spk_eye_city_left_id(:,:,i)==1),2), spk_eye(find(spk_eye_city_left_id(:,:,i)==1),3));

spk_eye_city_right_id(:,:,i) = spk_eye(:,5).*(SpikeData_info(:,3)==2).*(SpikeData_info(:,9)==2).*(SpikeData_info(:,4)==j);
spk_eye_city_right(1:length(find(spk_eye_city_right_id(:,:,i)==1)),:,i) = horzcat(spk_eye(find(spk_eye_city_right_id(:,:,i)==1),1), spk_eye(find(spk_eye_city_right_id(:,:,i)==1),2), spk_eye(find(spk_eye_city_right_id(:,:,i)==1),3));

spk_eye_city_COnly_id(:,:,i) = spk_eye(:,5).*(SpikeData_info(:,3)==2).*(abs(SpikeData_info(:,5))==1).*(SpikeData_info(:,4)==j);
spk_eye_city_COnly(1:length(find(spk_eye_city_COnly_id(:,:,i)==1)),:,i) = horzcat(spk_eye(find(spk_eye_city_COnly_id(:,:,i)==1),1), spk_eye(find(spk_eye_city_COnly_id(:,:,i)==1),2), spk_eye(find(spk_eye_city_COnly_id(:,:,i)==1),3));
end

%%
    XsizeOfVideo = 1920;
    YsizeOfVideo = 1080;
    samplingRate = 1000;
    scaleForRateMap = 20;
    
    binXForRateMap = XsizeOfVideo / scaleForRateMap ;
    binYForRateMap = YsizeOfVideo / scaleForRateMap ;
    
    
        [Eye_occMat, spkMat, rawMat, Eye_skaggsrateMat] = abmFiringRateMap( ...
            [spk_eye(:,1), spk_eye(:,2), spk_eye(:,3)],...
            [Eye_Analog_sync_recording(:,1), Eye_Analog_sync_recording(:,2), Eye_Analog_sync_recording(:,3)],...
        binYForRateMap, binXForRateMap, scaleForRateMap, samplingRate);

    
    
        [Eye_forest_left_occMat, spkMat, rawMat, Eye_forest_left_skaggsrateMat] = abmFiringRateMap( ...
            [spk_eye_forest_left(:,1), spk_eye_forest_left(:,2), spk_eye_forest_left(:,3)],...
            [Eye_Analog_sync_recording_forest_left(:,1), Eye_Analog_sync_recording_forest_left(:,2), Eye_Analog_sync_recording_forest_left(:,3)],...
        binYForRateMap, binXForRateMap, scaleForRateMap, samplingRate);
    Eye_ForestMaxFR(1,1) = nanmax(nanmax(Eye_forest_left_skaggsrateMat));


        [Eye_forest_right_occMat, spkMat, rawMat, Eye_forest_right_skaggsrateMat] = abmFiringRateMap( ...
            [spk_eye_forest_right(:,1), spk_eye_forest_right(:,2), spk_eye_forest_right(:,3)],...
            [Eye_Analog_sync_recording_forest_right(:,1), Eye_Analog_sync_recording_forest_right(:,2), Eye_Analog_sync_recording_forest_right(:,3)],...
        binYForRateMap, binXForRateMap, scaleForRateMap, samplingRate);
    Eye_ForestMaxFR(1,2) = nanmax(nanmax(Eye_forest_right_skaggsrateMat));

        [Eye_forest_COnly_occMat, spkMat, rawMat, Eye_forest_COnly_skaggsrateMat] = abmFiringRateMap( ...
            [spk_eye_forest_COnly(:,1), spk_eye_forest_COnly(:,2), spk_eye_forest_COnly(:,3)],...
            [Eye_Analog_sync_recording_forest_COnly(:,1), Eye_Analog_sync_recording_forest_COnly(:,2), Eye_Analog_sync_recording_forest_COnly(:,3)],...
        binYForRateMap, binXForRateMap, scaleForRateMap, samplingRate);
    Eye_ForestMaxFR(1,3) = nanmax(nanmax(Eye_forest_COnly_skaggsrateMat));

        [Eye_city_left_occMat, spkMat, rawMat, Eye_city_left_skaggsrateMat] = abmFiringRateMap( ...
            [spk_eye_city_left(:,1), spk_eye_city_left(:,2), spk_eye_city_left(:,3)],...
            [Eye_Analog_sync_recording_city_left(:,1), Eye_Analog_sync_recording_city_left(:,2), Eye_Analog_sync_recording_city_left(:,3)],...
        binYForRateMap, binXForRateMap, scaleForRateMap, samplingRate);
    Eye_CityMaxFR(1,1) = nanmax(nanmax(Eye_city_left_skaggsrateMat));


        [Eye_city_right_occMat, spkMat, rawMat, Eye_city_right_skaggsrateMat] = abmFiringRateMap( ...
            [spk_eye_city_right(:,1), spk_eye_city_right(:,2), spk_eye_city_right(:,3)],...
            [Eye_Analog_sync_recording_city_right(:,1), Eye_Analog_sync_recording_city_right(:,2), Eye_Analog_sync_recording_city_right(:,3)],...
        binYForRateMap, binXForRateMap, scaleForRateMap, samplingRate);
    Eye_CityMaxFR(1,12) = nanmax(nanmax(Eye_city_right_skaggsrateMat));

        [Eye_city_COnly_occMat, spkMat, rawMat, Eye_city_COnly_skaggsrateMat] = abmFiringRateMap( ...
            [spk_eye_city_COnly(:,1), spk_eye_city_COnly(:,2), spk_eye_city_COnly(:,3)],...
            [Eye_Analog_sync_recording_city_COnly(:,1), Eye_Analog_sync_recording_city_COnly(:,2), Eye_Analog_sync_recording_city_COnly(:,3)],...
        binYForRateMap, binXForRateMap, scaleForRateMap, samplingRate);
    Eye_CityMaxFR(1,3) = nanmax(nanmax(Eye_city_COnly_skaggsrateMat));