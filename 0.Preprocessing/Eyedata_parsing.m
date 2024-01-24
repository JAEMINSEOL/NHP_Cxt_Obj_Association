% eye_data_preprocessing
ROOT.Mother = 'D:\NHP project';
ROOT.Program = [ROOT.Mother '\Program'];
addpath(genpath(ROOT.Program))


%% file import

date = '20200108';
Animal_id = 'Nabi';
Task_id = 'Cxt-Obj Association_6 Objects';
File_id = 'Eye_Analog_Adj';

ROOT.Datapixx = [ROOT.Mother '\Data\' Animal_id '\Behavior\' Task_id '\' date '\Datapixx'];
ROOT.Unreal = [ROOT.Mother '\Data\' Animal_id '\Behavior\' Task_id '\' date '\Unreal'];

fl = dir(ROOT.Datapixx); 
for i=1:size(fl,1), if strncmp(fl(i).name,date,8), fl = fl(i).name; break; end; end

ROOT.Datapixx = [ROOT.Datapixx '\' fl];

[temp_list,Datapixx_eye] = get_dat_files(ROOT.Datapixx, fl, File_id);
[temp_list_2,Datapixx_ticks] = get_dat_files(ROOT.Datapixx, fl, 'TickLog');
[temp_list_3,Datapixx_events] = get_dat_files(ROOT.Datapixx, fl, 'EventLog');
UE_raw = readtable([ROOT.Unreal '\' [Animal_id '_' date '.csv']]);
UE_ticks = UE_raw(strcmp(UE_raw.Var1,'Tick'),:);

rs = find(strcmp(UE_raw.Var1,'RecordingStart'));
 re = find(strcmp(UE_raw.Var1,'RecordingEnd'));
 UE_recording = [rs, re];


UE_parsed = UE_raw(find(strcmp(UE_raw.Var1,'SessionStart')):find(strcmp(UE_raw.Var1,'SessionEnd')),:);

 UE_ts = UE_parsed(find(strcmp(UE_parsed.Var1,'TrialStart')),:);

  Datapixx_events = Datapixx_events(find(strcmp(Datapixx_events,'SessionStart')),:);
 Datapixx_ts = Datapixx_events(find(strcmp(Datapixx_events,'TrialStart')),:);


 %%
  UE_recorded =[];
 for i=1:size(UE_recording,1)
 UE_recorded =  [UE_recorded; [UE_raw(UE_recording(i,1):UE_recording(i,2),:)]];
     end


%%
