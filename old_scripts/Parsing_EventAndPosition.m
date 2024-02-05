%%
% TickLog_neuralynx(VoidLog_unreal_recording_Tick(:,2)) = [];
TickLog_neuralynx(length(TickLog_unreal_recording)+1:end,:) = [];
TickLog_datapixx_recording(length(TickLog_unreal_recording)+1:end,:) = [];

for i=1:length(TickLog_neuralynx)-1
 latency(i,1) = TickLog_neuralynx(i+1)-TickLog_neuralynx(i);
end
LapStart_neuralynx(length(LapStart_unreal_recording)+1:end,:) = [];
TrialStart_neuralynx(length(TrialStart_unreal_recording)+1:end,:) = [];

LapStart_datapixx(length(LapStart_unreal)+1:end,:) = [];
TrialStart_datapixx(length(TrialStart_unreal)+1:end,:) = [];

TimeInterval_neuralynx_unreal = LapStart_neuralynx(:,1)/1000000-LapStart_unreal_recording(:,2);
TimeInterval_datapixx_unreal = LapStart_datapixx(:,1)-LapStart_unreal(:,2);


%%
clear TickLog_sync_recording
TickLog_sync_recording(:,1) = TickLog_neuralynx(:,1);
TickLog_sync_recording(:,2) = TickLog_unreal_recording(:,3);
TickLog_sync_recording(:,3) = TickLog_unreal_recording(:,4);
LapStart_sync_recording(:,1) = LapStart_neuralynx(:,1);
LapStart_sync_recording(:,2) = LapStart_unreal_recording(:,3);


LapEnd_sync_recording = interp1(TickLog_unreal_recording(:,2),TickLog_neuralynx,LapEnd_unreal_recording(:,2),'linear','extrap');
TrialStart_sync_recording = interp1_RemoveNaN(TickLog_unreal_recording(:,2),TickLog_neuralynx,TrialStart_unreal_recording(:,2));
TrialEnd_sync_recording = interp1_RemoveNaN(TickLog_unreal_recording(:,2),TickLog_neuralynx,TrialEnd_unreal_recording(:,2)); 
CursorOn_sync_recording = interp1_RemoveNaN(TickLog_unreal_recording(:,2),TickLog_neuralynx,CursorOn_unreal_recording(:,2));
CursorChange_sync_recording = interp1_RemoveNaN(TickLog_unreal_recording(:,2),TickLog_neuralynx,CursorChange_unreal_recording(:,2));
ObjOn_sync_recording = interp1_RemoveNaN(TickLog_unreal_recording(:,2),TickLog_neuralynx,ObjOn_unreal_recording(:,2));
ObjOff_sync_recording = interp1_RemoveNaN(TickLog_unreal_recording(:,2),TickLog_neuralynx,ObjOff_unreal_recording(:,2));
JoystickLeft_sync_recording = interp1_RemoveNaN(TickLog_unreal_recording(:,2),TickLog_neuralynx,JoystickLeft_unreal_recording(:,2));
JoystickRight_sync_recording = interp1(TickLog_unreal_recording(:,2),TickLog_neuralynx,JoystickRight_unreal_recording(:,2));
ChoiceLeft_sync_recording = interp1_RemoveNaN(TickLog_unreal_recording(:,2),TickLog_neuralynx,ChoiceLeft_unreal_recording(:,2));
ChoiceRight_sync_recording = interp1_RemoveNaN(TickLog_unreal_recording(:,2),TickLog_neuralynx,ChoiceRight_unreal_recording(:,2));
Choice_sync_recording = sort(vertcat(ChoiceLeft_sync_recording, ChoiceRight_sync_recording));
TurnOn_sync_recording = interp1_RemoveNaN(TickLog_unreal_recording(:,2),TickLog_neuralynx,TurnOn_unreal_recording(:,2));
TurnOff_sync_recording = interp1_RemoveNaN(TickLog_unreal_recording(:,2),TickLog_neuralynx,TurnOff_unreal_recording(:,2));
TrialInfo_sync_recording = horzcat(TrialStart_sync_recording, ObjOn_sync_recording, CursorChange_sync_recording, ObjOff_sync_recording, TrialEnd_sync_recording, TrialType_unreal_recording(:,3:8));

%%
clear TickLog_sync_recording_info
TickLog_sync_recording_info(:,1) = TickLog_sync_recording(:,1);
TickLog_sync_recording_info(:,2) = TickLog_sync_recording(:,2);
TickLog_sync_recording_info(:,3) = TickLog_sync_recording(:,3);
TickLog_sync_recording_info(:,13) = TickLog_unreal_recording(:,5);
trial.spk = [];
l=1; t=1;
for i = 1:length(TickLog_sync_recording_info)
    TickLog_sync_recording_info(i,4:11) = 0;
    
    if TickLog_sync_recording_info(i,1) < LapStart_sync_recording(l,1)
        TickLog_sync_recording_info(i,4) = 0;
        TickLog_sync_recording_info(i,5) = 0;
        t=1;
    elseif TickLog_sync_recording_info(i,1) >= LapStart_sync_recording(l,1)
        if TickLog_sync_recording_info(i,1) < LapEnd_sync_recording(l,1)
            TickLog_sync_recording_info(i,4) = LapType_unreal_recording(l,2);
            lt = 8*(l-1) + t;
            
            if TickLog_sync_recording_info(i,1) < TrialStart_sync_recording(lt,1)
                if TickLog_sync_recording_info(i,1) >= CursorOn_sync_recording(lt,1)-500*10^3
                    TickLog_sync_recording_info(i,6) = -1;
                    TickLog_sync_recording_info(i,7) = TrialType_unreal_recording(lt,7);
                    TickLog_sync_recording_info(i,8) = TrialType_unreal_recording(lt,8);
                end
                if t<=4
                    TickLog_sync_recording_info(i,5) = 2*t-1;
                else
                    TickLog_sync_recording_info(i,5) = 2*t+1;
                end
                if t~=1
                    TickLog_sync_recording_info(i-1,5) = TickLog_sync_recording_info(i,5);
                end
            elseif TickLog_sync_recording_info(i,1) >= TrialStart_sync_recording(lt,1)
                if TickLog_sync_recording_info(i,1) < TrialEnd_sync_recording(lt,1)
                    if t<=4
                        TickLog_sync_recording_info(i,5) = 2*t;
                    else
                        TickLog_sync_recording_info(i,5) = 2*(t+1);
                    end
                    
                    if TickLog_sync_recording_info(i,1) >= CursorOn_sync_recording(lt,1)
                        if TickLog_sync_recording_info(i,1) < ObjOn_sync_recording(lt,1)
                            TickLog_sync_recording_info(i,6) = 1;
                            TickLog_sync_recording_info(i,7) = TrialType_unreal_recording(lt,7);
                            TickLog_sync_recording_info(i,8) = TrialType_unreal_recording(lt,8);
                        elseif TickLog_sync_recording_info(i,1) >= ObjOn_sync_recording(lt,1) && TickLog_sync_recording_info(i,1) < ObjOff_sync_recording(lt,1)
                            
                            TickLog_sync_recording_info(i,7) = TrialType_unreal_recording(lt,7);
                            TickLog_sync_recording_info(i,8) = TrialType_unreal_recording(lt,8);
                            TickLog_sync_recording_info(i,9) = TrialType_unreal_recording(lt,6)+1;
                            TickLog_sync_recording_info(i,10) = Choice_unreal_recording(lt,end);
                            TickLog_sync_recording_info(i,11) = (TickLog_sync_recording_info(i,9) == TickLog_sync_recording_info(i,10));
                            
                            if TickLog_sync_recording_info(i,1) < CursorChange_sync_recording(lt,1)
                                TickLog_sync_recording_info(i,6) = 2;
                            elseif TickLog_sync_recording_info(i,1) >= CursorChange_sync_recording(lt,1)
                                if TickLog_sync_recording_info(i,1) < ObjOff_sync_recording(lt,1)
                                    TickLog_sync_recording_info(i,6) = 3;
                                elseif TickLog_sync_recording_info(i,1) >= ObjOff_sync_recording(lt,1)
                                    TickLog_sync_recording_info(i,5) = 0;
                               end
                           end
                        end

                   end
                    
                elseif TickLog_sync_recording_info(i,1) >= TrialEnd_sync_recording(lt,1)
                    if t < 8 && t~=4
                        t=t+1;
                    elseif t == 8
                        TickLog_sync_recording_info(i,5) = 19;
                    elseif t==4
                        if TickLog_sync_recording_info(i,1) < TurnOn_sync_recording(l,1)
                            TickLog_sync_recording_info(i,5) = 9;
                        elseif TickLog_sync_recording_info(i,1) < TurnOff_sync_recording(l,1)
                            TickLog_sync_recording_info(i,5) = 10;
                        elseif TickLog_sync_recording_info(i,1) >= TurnOff_sync_recording(l,1)
                            t=t+1;
                        end
                    end
                end
            end
        elseif TickLog_sync_recording_info(i,1) >= LapEnd_sync_recording(l,1)
            l = l+1;
                    TickLog_sync_recording_info(i,4) = 0;
        TickLog_sync_recording_info(i,5) = 0;
        end
    end
    abstrial.spk(i,lt) = 1;
    TickLog_sync_recording_info(i,12) = lt;
end

%% SpeedMap Module
clear SpeedMap StopIndex
SpeedMap(:,2) = (TickLog_unreal_recording (2:end,2) - TickLog_unreal_recording  (1:end-1,2))*10^3;
SpeedMap(:,3) = TickLog_unreal_recording  (2:end,3) - TickLog_unreal_recording  (1:end-1,3);
SpeedMap(:,4) = SpeedMap(:,3) ./ SpeedMap(:,2);
SpeedMap(:,5) = TickLog_sync_recording_info(1:end-1,5);
SpeedMap(:,6) = ~TickLog_sync_recording_info (1:end-1,13) .* mod(TickLog_sync_recording_info (1:end-1,5),2);
for i = 1:length(SpeedMap)-1
    SpeedMap(i,1) = i;
    if SpeedMap(i,5)>SpeedMap(i+1,5)
        SpeedMap(i,6) = 0;
    end
end
SpeedMap(find(SpeedMap(:,6)==0),:) = [];
StopIndex = SpeedMap(find(SpeedMap(:,4)==0),1);
TickLog_sync_recording_info (StopIndex,13) = 1;