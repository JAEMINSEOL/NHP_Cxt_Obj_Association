function JoystickID_Eye = CursorPosition(Eye_Analog_sync_recording_info,JoystickLeft_sync_recording,JoystickRight_sync_recording)

JoystickID_Eye = zeros(size(Eye_Analog_sync_recording_info,1),1);
JoystickID_Eye(knnsearch(Eye_Analog_sync_recording_info(:,1),JoystickLeft_sync_recording),1)=1;
JoystickID_Eye(knnsearch(Eye_Analog_sync_recording_info(:,1),JoystickRight_sync_recording),1)=2;

flag=0; c=0;
for i = 1:size(Eye_Analog_sync_recording_info,1)
    if Eye_Analog_sync_recording_info(i,6)==3
        flag=1;
    elseif Eye_Analog_sync_recording_info(i,6)==0
        flag=0;
    end
    
    if flag==1
        if JoystickID_Eye(i,1)==1
        c = max(-5,c-1);
    elseif JoystickID_Eye(i,1)==2
        c= min(5,c+1);
        end
    elseif flag==0
        c=0;
    end
    JoystickID_Eye(i,2)=c;
end
end