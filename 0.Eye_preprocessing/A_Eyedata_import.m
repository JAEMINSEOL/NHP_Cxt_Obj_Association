
function [Datapixx_eye,Datapixx_ticks,Datapixx_events] = A_Eyedata_import(ROOTo,date)
fname=0;
File_id = 'Eye_Analog_adj';
fl = dir(ROOTo.Datapixx); 
for i=1:size(fl,1)
    if strncmp(fl(i).name,date,8)
        fname = fl(i).name; break; 
    end
end
if fname==0
    fname = fl(i).name;
end
ROOT= [ROOTo.Datapixx '\' fname];

[temp_list,Datapixx_eye] = get_dat_files(ROOT, fname, 'Eye_Analog');
% [temp_list,Datapixx_eye_adj] = get_dat_files(ROOT.Datapixx, fl, 'Eye_Analog_Adj');
[temp_list_2,Datapixx_ticks] = get_dat_files(ROOT, fname, 'TickLog');
[temp_list_3,Datapixx_events] = get_dat_files(ROOT, fname, 'EventLog');

% subplot(1,2,1)
% scatter(Datapixx_eye(:,1),Datapixx_eye(:,2))
% subplot(1,2,2)
% scatter(Datapixx_eye_adj(:,1),Datapixx_eye_adj(:,2))

