%% Calculate FR of each Object Composition
AxisXTick = 0.08;
AxisCxtTick = -0.1;
cxt = 0.04;
Firing_Rate = NaN(100,2,18);
ChoiceRaster = NaN(10000, 6, 36);
for c = 1:2
for i = 0:2
[ChoiceArray(c*18+i*6-17,:), Firing_Rate(:,c,i*6+1),ChoiceRaster(:,:,c*18+i*6-17)] = Rasterplot_by_Choice(SpikeData_info, TickLog_sync_recording_info,c, 2*i+1, 0);
[ChoiceArray(c*18+i*6-16,:), Firing_Rate(:,c,i*6+2),ChoiceRaster(:,:,c*18+i*6-16)] = Rasterplot_by_Choice(SpikeData_info, TickLog_sync_recording_info,c, 0, 2*i+1);
[ChoiceArray(c*18+i*6-15,:), Firing_Rate(:,c,i*6+3),ChoiceRaster(:,:,c*18+i*6-15)] = Rasterplot_by_Choice(SpikeData_info, TickLog_sync_recording_info,c, 2*i+1, 2);
[ChoiceArray(c*18+i*6-14,:), Firing_Rate(:,c,i*6+4),ChoiceRaster(:,:,c*18+i*6-14)] = Rasterplot_by_Choice(SpikeData_info, TickLog_sync_recording_info,c, 2, 2*i+1);
[ChoiceArray(c*18+i*6-13,:), Firing_Rate(:,c,i*6+5),ChoiceRaster(:,:,c*18+i*6-13)] = Rasterplot_by_Choice(SpikeData_info, TickLog_sync_recording_info,c, 2*i+1, 4);
[ChoiceArray(c*18+i*6-12,:), Firing_Rate(:,c,i*6+6),ChoiceRaster(:,:,c*18+i*6-12)] = Rasterplot_by_Choice(SpikeData_info, TickLog_sync_recording_info,c, 4, 2*i+1);
end
end
%%
Parsing_FR;
Eye_FR;
TTest_fast;
