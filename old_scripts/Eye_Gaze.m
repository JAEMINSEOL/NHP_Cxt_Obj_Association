
%% Import Eye & Event Data
Eye_Analog_unreal_recording = [];
for i = 1:112
    load(['19102920 Eye_Analog_' num2str(i)]);
    DatA = DatA';
    Eye_Analog_unreal_recording = vertcat(Eye_Analog_unreal_recording, DatA);
end
EventLog2 =[];
for i = 1:4

    load(['19102920 EventLog_' num2str(i)]);
    EventLog2 = vertcat(EventLog2, EventLog);
end
EventLog = EventLog2;
%% Overall Eye Data Heatmap
EyeGaze_Overall = zeros(200);

for j = 1:size(Eye_Analog_unreal_recording,1)
   x = round((Eye_Analog_unreal_recording(j,2)+5)*20);
   y = round((Eye_Analog_unreal_recording(j,3)+5)*20);
   if 1<x && 1<y && 199>=x && 199>=y
   EyeGaze_Overall(201-y,x) = EyeGaze_Overall(201-y,x)+1;
   end
end
h = heatmap(EyeGaze_Overall,'Colormap',parula);
%% Event Parsing

    t=1;
    for j = 1:size(EventLog,1)
        if EventLog{j,1} == "ObjOn"
            Event.ObjOn(t,1) = EventLog{j,2};
            t=t+1;
        end
    end
    t=1;
    for j = 1:size(EventLog,1)
        if EventLog{j,1} == "ObjOff"
            Event.ObjOff(t,1) = EventLog{j,2};
            t=t+1;
        end
    end
    
    
    t=1;
    for j = 1:size(EventLog,1)
        if EventLog{j,1} == "TurnStart"
            Event.TurnStart(t,1) = EventLog{j,2};
            t=t+1;
        end
    end
    t=1;
    for j = 1:size(EventLog,1)
        if EventLog{j,1} == "TurnEnd"
            Event.TurnEnd(t,1) = EventLog{j,2};
            t=t+1;
        end
    end



 t=1;
    for j = 1:size(EventLog,1)
        if EventLog{j,1} == "CursorOn"
            Event.CursorOn(t,1) = EventLog{j,2};
            t=t+1;
        end
    end
    t=1;
    for j = 1:size(EventLog,1)
        if EventLog{j,1} == "CursorBlue"
            Event.CursorBlue(t,1) = EventLog{j,2};
            t=t+1;
        end
    end
   
t=1;
    for j = 1:size(EventLog,1)
        if EventLog{j,1} == "ButtonA"
            Event.ButtonA(t,1) = EventLog{j,2};
            t=t+1;
        end
    end
    
  t=1;
    for j = 1:size(EventLog,1)
        if EventLog{j,1} == "ButtonB"
            Event.ButtonB(t,1) = EventLog{j,2};
            t=t+1;
        end
    end
    t=1;
    for j = 1:size(EventLog,1)
        if EventLog{j,1} == "ButtonA" || EventLog{j,1} == "ButtonB"
            Event.Button(t,1) = EventLog{j,2};

            if EventLog{j,1} == "ButtonA"
                Event.Button(t,2) = 1;
            end
            
            if EventLog{j,1} == "ButtonB"
                Event.Button(t,2) = 2;
            end
                        t=t+1;
        end
    end
    t=1;
    for j = 1:size(EventLog,1)
        if EventLog{j,1} == "ChoiceA"
            Event.ChoiceA(t,1) = EventLog{j,2};
            t=t+1;
        end
    end
    t=1;
    for j = 1:size(EventLog,1)
        if EventLog{j,1} == "ChoiceB"
            Event.ChoiceB(t,1) = EventLog{j,2};
            t=t+1;
        end
    end
    t=1;
    for j = 1:size(EventLog,1)
        if EventLog{j,1} == "ChoiceA" || EventLog{j,1} == "ChoiceB"
            Event.Choice(t,1) = EventLog{j,2};
        
            if EventLog{j,1} == "ChoiceA"
                Event.Choice(t,2) = 1;
            end
            
            if EventLog{j,1} == "ChoiceB"
                Event.Choice(t,2) = 2;
            end
                        t=t+1;
        end
        
    end

    for j = 1:size(Event.ObjOff,1)
            Event.ChoiceLatency(j,1) = Event.ObjOff(j,1)- Event.ObjOn(j,1);
    end
%%
t=1;
BinSize = 200;
EyeGaze_Overall = zeros(BinSize);

for j = 1:size(Eye_Analog_unreal_recording,1)
    x = round((Eye_Analog_unreal_recording(j,2)+5)*(BinSize/10));
    y = round((Eye_Analog_unreal_recording(j,3)+5)*(BinSize/10));  % -5 ~ +5V analog data를 bin size에 맞게 변환하는 과정
    if 1<x && 1<y && (BinSize-1)>=x && (BinSize-1)>=y
        if Eye_Analog_unreal_recording(j,1) > Event.ObjOff(t,1) && t<size(Event.ObjOn,1)-1 % EndEvent와 다음 StartEvent 사이에 있다면, t값을 1 증가시킴(다음 StartEvent로 진행)
            t=t+1;
        end
        if Eye_Analog_unreal_recording(j,1) > Event.ObjOn(t,1) && Eye_Analog_unreal_recording(j,1) < Event.ObjOff(t,1) % StartEvent와 EndEvent 사이에 gaze position의 timestamp가 있다면, 해당하는 position bin의 빈도값을 1 증가시킴
            if Event.ChoiceLatency(t,1)<3  &&Event.Choice(t,2) == 2 % 오래 멈춰 있던 trial을 제외함
                EyeGaze_Overall((BinSize+1)-y,x) = EyeGaze_Overall((BinSize+1)-y,x)+1;
            end
        end
    end
end
figure;
h = heatmap(EyeGaze_Overall,'Colormap',jet);
