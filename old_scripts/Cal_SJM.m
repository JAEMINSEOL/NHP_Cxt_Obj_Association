%% Calculate FR of each Object Composition
AxisXTick = 0.08;
AxisCxtTick = -0.1;
cxt = 0.04;
clear ChoiceArray Firing_Rate
Firing_Rate = NaN(100,2,18);
ChoiceRaster = NaN(10000, 6, 36);

for c = 1:2
for i = 0:2
[ChoiceArray(c*18+i*6-17,:), Firing_Rate(:,c,i*6+1)] = Rasterplot_by_Choice(SpikeData_info, TickLog_sync_recording_info,TrialInfo_sync_recording,c, 2*i+2, 1);
[ChoiceArray(c*18+i*6-16,:), Firing_Rate(:,c,i*6+2)] = Rasterplot_by_Choice(SpikeData_info, TickLog_sync_recording_info,TrialInfo_sync_recording,c, 1, 2*i+2);
[ChoiceArray(c*18+i*6-15,:), Firing_Rate(:,c,i*6+3)] = Rasterplot_by_Choice(SpikeData_info, TickLog_sync_recording_info,TrialInfo_sync_recording,c, 2*i+2, 3);
[ChoiceArray(c*18+i*6-14,:), Firing_Rate(:,c,i*6+4)] = Rasterplot_by_Choice(SpikeData_info, TickLog_sync_recording_info,TrialInfo_sync_recording,c, 3, 2*i+2);
[ChoiceArray(c*18+i*6-13,:), Firing_Rate(:,c,i*6+5)] = Rasterplot_by_Choice(SpikeData_info, TickLog_sync_recording_info,TrialInfo_sync_recording,c, 2*i+2, 5);
[ChoiceArray(c*18+i*6-12,:), Firing_Rate(:,c,i*6+6)] = Rasterplot_by_Choice(SpikeData_info, TickLog_sync_recording_info,TrialInfo_sync_recording,c, 5, 2*i+2);
end
end
%%
Parsing_FR;
% Eye_FR;
% TTest_fast;
