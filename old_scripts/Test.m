TickLog_unreal_recording_info(:,1) = TickLog_unreal_recording(:,1);
TickLog_unreal_recording_info(:,2) = TickLog_unreal_recording(:,2);
trial.spk = [];
l=1; t=1;
for i = 1:length(TickLog_unreal_recording_info)
    TickLog_unreal_recording_info(i,3:10) = 0;
    
    if TickLog_unreal_recording_info(i,1) < LapStart_unreal_recording(l,1)
        TickLog_unreal_recording_info(i,3) = 0;
        TickLog_unreal_recording_info(i,4) = 0;
        t=1;
    elseif TickLog_unreal_recording_info(i,1) >= LapStart_unreal_recording(l,1)
        if TickLog_unreal_recording_info(i,1) < LapEnd_unreal_recording(l,1)
            TickLog_unreal_recording_info(i,3) = LapType_unreal_recording(l,2);
            lt = 8*(l-1) + t;
            
            if TickLog_unreal_recording_info(i,1) < TrialStart_unreal_recording(lt,1)
                if t<=4
                    TickLog_unreal_recording_info(i,4) = 2*t-1;
                else
                    TickLog_unreal_recording_info(i,4) = 2*t+1;
                end
                if t~=1
                    TickLog_unreal_recording_info(i-1,4) = TickLog_unreal_recording_info(i,4);
                end
            elseif TickLog_unreal_recording_info(i,1) >= TrialStart_unreal_recording(lt,1)
                if TickLog_unreal_recording_info(i,1) < TrialEnd_unreal_recording(lt,1)
                    if t<=4
                        TickLog_unreal_recording_info(i,4) = 2*t;
                    else
                        TickLog_unreal_recording_info(i,4) = 2*(t+1);
                    end
                    
                    if TickLog_unreal_recording_info(i,1) >= CursorOn_unreal_recording(lt,1)
                        if TickLog_unreal_recording_info(i,1) < ObjOn_unreal_recording(lt,1)
                            TickLog_unreal_recording_info(i,5) = 1;
                                                        TickLog_unreal_recording_info(i,6) = TrialType_unreal_recording(lt,7);
                            TickLog_unreal_recording_info(i,7) = TrialType_unreal_recording(lt,8);
                        elseif TickLog_unreal_recording_info(i,1) >= ObjOn_unreal_recording(lt,1) && TickLog_unreal_recording_info(i,1) < ObjOff_unreal_recording(lt,1)
                            
                            TickLog_unreal_recording_info(i,6) = TrialType_unreal_recording(lt,7);
                            TickLog_unreal_recording_info(i,7) = TrialType_unreal_recording(lt,8);
                            TickLog_unreal_recording_info(i,8) = TrialType_unreal_recording(lt,6)+1;
                            TickLog_unreal_recording_info(i,9) = Choice_unreal_recording(lt,4);
                            TickLog_unreal_recording_info(i,10) = (TickLog_unreal_recording_info(i,8) == TickLog_unreal_recording_info(i,9))+1;
                            
                            if TickLog_unreal_recording_info(i,1) < CursorChange_unreal_recording(lt,1)
                                TickLog_unreal_recording_info(i,5) = 2;
                            elseif TickLog_unreal_recording_info(i,1) >= CursorChange_unreal_recording(lt,1)
                                if TickLog_unreal_recording_info(i,1) < ObjOff_unreal_recording(lt,1)
                                    TickLog_unreal_recording_info(i,5) = 3;
                                elseif TickLog_unreal_recording_info(i,1) >= ObjOff_unreal_recording(lt,1)
                                    TickLog_unreal_recording_info(i,5) = 0;
                               end
                           end
                       end
                       
                   end
                    
                elseif TickLog_unreal_recording_info(i,1) >= TrialEnd_unreal_recording(lt,1)
                    if t < 8 && t~=4
                        t=t+1;
                    elseif t == 8
                        TickLog_unreal_recording_info(i,4) = 19;
                    elseif t==4
                        if TickLog_unreal_recording_info(i,1) < TurnOn_unreal_recording(l,1)
                            TickLog_unreal_recording_info(i,4) = 9;
                        elseif TickLog_unreal_recording_info(i,1) < TurnOff_unreal_recording(l,1)
                            TickLog_unreal_recording_info(i,4) = 10;
                        elseif TickLog_unreal_recording_info(i,1) >= TurnOff_unreal_recording(l,1)
                            t=t+1;
                        end
                    end
                end
            end
        elseif TickLog_unreal_recording_info(i,1) >= LapEnd_unreal_recording(l,1)
            l = l+1;
            i = i-1;
        end
    end
    abstrial.spk(i,lt) = 1;
    TickLog_unreal_recording_info(i,11) = lt;
end

