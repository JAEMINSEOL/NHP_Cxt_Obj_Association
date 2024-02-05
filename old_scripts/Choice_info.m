Choice_Index = logical((SpikeData_info(:,3)==Cxt) .* (SpikeData_info(:,5)>0).* (SpikeData_info(:,6)==LeftObj).* (SpikeData_info(:,7)==RightObj));
Choice_Indices = find(Choice_Index~=0);
Choice_SpikeInfo = horzcat(SpikeData_info(Choice_Indices,1), SpikeData_info(Choice_Indices,2), SpikeData_info(Choice_Indices,5));

Choice_BehaviorIndex = logical((TickLog_sync_recording_info(:,3)==Cxt) .* (TickLog_sync_recording_info(:,5)>0).* (TickLog_sync_recording_info(:,6)==LeftObj).* (TickLog_sync_recording_info(:,7)==RightObj));
Choice_BehaviorIndices = find(Choice_BehaviorIndex~=0);
Choice_BehaviorInfo = horzcat(TickLog_sync_recording_info(Choice_BehaviorIndices,1), TickLog_sync_recording_info(Choice_BehaviorIndices,2), TickLog_sync_recording_info(Choice_BehaviorIndices,5));

t=1;TrialDuration = [];
for c1 = 1:length(Choice_BehaviorInfo)
    Choice_BehaviorInfo(c1,7) = t;
    if c1 == 1
        Choice_BehaviorInfo(c1,4) = 0;
        TrialStartTime(t,1) = Choice_BehaviorInfo(c1,1);
    else
        if Choice_BehaviorInfo(c1,3) == 1
            if Choice_BehaviorInfo(c1-1,3) == 3
            Choice_BehaviorInfo(c1,4) = 0;
            TrialStartTime(t+1,1) = Choice_BehaviorInfo(c1,1);
            TrialDuration(t,3) = Choice_BehaviorInfo(c1-1,1) - TrialStartTime(t,3);
            t = t+1;
            else
                Choice_BehaviorInfo(c1,4) = Choice_BehaviorInfo(c1,1) - TrialStartTime(t,1);
            end
        elseif Choice_BehaviorInfo(c1,3) == 2
            Choice_BehaviorInfo(c1,4) = NaN;
            if Choice_BehaviorInfo(c1-1,3) == 1
                Choice_BehaviorInfo(c1,5) = 0;
                TrialStartTime(t,2) = Choice_BehaviorInfo(c1,1);
                TrialDuration(t,1) = Choice_BehaviorInfo(c1,1) - TrialStartTime(t,1);
            else
                Choice_BehaviorInfo(c1,5) = Choice_BehaviorInfo(c1,1) - TrialStartTime(t,2);
            end
        elseif Choice_BehaviorInfo(c1,3) == 3
            Choice_BehaviorInfo(c1,4) = NaN;
            Choice_BehaviorInfo(c1,5) = NaN;
            if Choice_BehaviorInfo(c1-1,3) == 2
                Choice_BehaviorInfo(c1,6) = 0;
                TrialStartTime(t,3) = Choice_BehaviorInfo(c1,1);
                TrialDuration(t,2) = Choice_BehaviorInfo(c1,1) - TrialStartTime(t,2);
            else
                Choice_BehaviorInfo(c1,6) = Choice_BehaviorInfo(c1,1) - TrialStartTime(t,3);
            end
        end
    end
end
TrialDuration(end,3) = Choice_BehaviorInfo(end,1)- TrialStartTime(end,3);
TrialDuration = TrialDuration/10^6;

Choice_SpikeInfo(:,4) = interp1(Choice_BehaviorInfo(:,1), Choice_BehaviorInfo(:,4), Choice_SpikeInfo(:,1), 'linear');
Choice_SpikeInfo(:,5) = interp1(Choice_BehaviorInfo(:,1), Choice_BehaviorInfo(:,5), Choice_SpikeInfo(:,1), 'linear');
Choice_SpikeInfo(:,6) = interp1(Choice_BehaviorInfo(:,1), Choice_BehaviorInfo(:,6), Choice_SpikeInfo(:,1), 'linear');
Choice_SpikeInfo(:,7) = interp1(Choice_BehaviorInfo(:,1), Choice_BehaviorInfo(:,7), Choice_SpikeInfo(:,1), 'nearest');