function [Datapixx_eye_T,Datapixx_events_T,UE_log] = B_Unreal_parsing(ROOT,Animal_id,date,Datapixx_events,Datapixx_eye)
UE_log=struct;
UE_log.raw = readtable([ROOT.Unreal '\' [Animal_id '_' date '.csv']]);
UE_log.ticks = UE_log.raw(strcmp(UE_log.raw.Var1,'Tick'),:);
if isempty(UE_log.ticks), UE_log.ticks = UE_log.raw(strcmp(UE_log.raw.Var1,'X'),:); end

rs = find(strcmp(UE_log.raw.Var1,'RecordingStart'));
 re = find(strcmp(UE_log.raw.Var1,'RecordingEnd'));
 UE_log.recording = [rs, re];

% UE_log.parsed = UE_log.raw(find(~strcmp(UE_log.raw.Var1,'Tick')),:);
UE_log.parsed = UE_log.raw(find(strcmp(UE_log.raw.Var1,'SessionStart')):find(strcmp(UE_log.raw.Var1,'SessionEnd')),:);


 UE_log.ts = UE_log.parsed(find(strcmp(UE_log.parsed.Var1,'CursorOn')),:);

  UE_log.tx = UE_log.parsed(find(~strcmp(UE_log.parsed.Var1,'Tick')),:);

  Datapixx_ts = Datapixx_events(find(strcmp(Datapixx_events,'CursorOn')),:);

     x = UE_log.ts.Var2;
     xv = UE_log.parsed.Var2;

  y = cell2mat(Datapixx_ts(:,2));

    if isempty(y)
        Datapixx_ts = Datapixx_events(find(strcmp(Datapixx_events.name,'CursorOn')),:);
        y=cell2mat(Datapixx_ts.time);
    end

yv = interp1(x,y,xv,'linear','extrap');

UE_log.parsed.Time_adjust = yv;

%%
UE_log.cali = UE_log.parsed(find(strncmp(UE_log.parsed.Var1,'Cali',4) | strcmp(UE_log.parsed.Var1,'Water')),:);
temp = {};
for u=1:size(UE_log.cali,1)
    temp{u,2} = UE_log.cali.Time_adjust(u);
    temp{u,3} = 0;
    if strncmp(UE_log.cali.Var1{u},'Cali',4)
        hyp = find(UE_log.cali.Var1{u}=='_');
        n = UE_log.cali.Var1{u}(hyp+1:end);

        if strcmp(n,'On')
            temp{u,1} = 'CaliStart';
        elseif strcmp(n,'Off')
            temp{u,1} = 'CaliEnd';
        else
            temp{u,1} = 'CaliNum';
            temp{u,3} = str2double(n);
        end
    else
        temp{u,1} = 'Water';
    end
end
Datapixx_events = [temp;Datapixx_events];

%%
if iscell(Datapixx_events)
Datapixx_events_T = cell2table(Datapixx_events,'VariableNames',["name","time","type"]);
else
    Datapixx_events_T=Datapixx_events;
end
trial_s = UE_log.parsed.Time_adjust(find(strcmp(UE_log.parsed.Var1,'TrialStart')));
trial_e = UE_log.parsed.Time_adjust(find(strcmp(UE_log.parsed.Var1,'TrialEnd')));
trial_1 = UE_log.parsed.Time_adjust(find(strcmp(UE_log.parsed.Var1,'CursorOn')));
trial_2 = UE_log.parsed.Time_adjust(find(strcmp(UE_log.parsed.Var1,'ObjOn')));
trial_3 = UE_log.parsed.Time_adjust(find(strcmp(UE_log.parsed.Var1,'CursorBlue')));
T=[trial_s trial_1 trial_2 trial_3 trial_e];
UE_log.trials = array2table(T,'VariableNames',["Start","CursorOn","ObjOn","CursorBlue","End"]);
%% trial type indexing
choice = UE_log.parsed.Var1(find(strncmp(UE_log.parsed.Var1,'Choice',6)));
type = UE_log.parsed.Var5(find(strcmp(UE_log.parsed.Var1,'TrialType')));
if ~iscell(type)
    type2={};
    for t=1:size(type,1)
        type2{t,1}=num2str(type(t));
    end
    type=type2;
end


type(end)=[];
for t=1:size(type,1)
    UE_log.trials.Trial(t) = t;
UE_log.trials.Context(t) = str2double(type{t}(1));
UE_log.trials.Direction(t) = str2double(type{t}(2));
UE_log.trials.Location(t) = str2double(type{t}(3));
if strcmp(choice{t},'ChoiceLeft'), UE_log.trials.Choice(t)=0; else, UE_log.trials.Choice(t)=1; end
    UE_log.trials.CorrectAnswer(t) = str2double(type{t}(4));

    UE_log.trials.ObjectLeft{t} = object_code(str2double(type{t}(5)));
    UE_log.trials.ObjectRight{t} = object_code(str2double(type{t}(6)));
end

%%
joystick_l = UE_log.parsed.Time_adjust(find(strcmp(UE_log.parsed.Var1,'JoystickLeft'))); 
joystick_r = UE_log.parsed.Time_adjust(find(strcmp(UE_log.parsed.Var1,'JoystickRight'))); 
joystick = [joystick_l -1*ones(size(joystick_l,1),1); joystick_r ones(size(joystick_r,1),1)];
UE_log.Joystick = sortrows(joystick,1);
%%
lap_s = UE_log.parsed.Time_adjust(find(strcmp(UE_log.parsed.Var1,'LapStart'))); lap_s(end)=[];
lap_e = UE_log.parsed.Time_adjust(find(strcmp(UE_log.parsed.Var1,'LapEnd')));
T=[lap_s lap_e];
UE_log.laps = array2table(T,'VariableNames',["Start","End"]);


turn_s = UE_log.parsed.Time_adjust(find(strcmp(UE_log.parsed.Var1,'TurnStart')));
turn_e = UE_log.parsed.Time_adjust(find(strcmp(UE_log.parsed.Var1,'TurnEnd')));
T=[turn_s turn_e];
UE_log.turns = array2table(T,'VariableNames',["Start","End"]);
%%
Datapixx_eye_T = array2table(Datapixx_eye,'VariableNames',["X","Y","pupil","time"]);

t0 = size(UE_log.trials,1);
times = Datapixx_eye_T.time;
trial=zeros(size(Datapixx_eye,1),1); state=zeros(size(Datapixx_eye,1),1); 
parfor d=1:size(Datapixx_eye_T,1)
    t1=t0+1;
    for t=1:t0-1
        if times(d)<=trial_e(1),t1=1; break; end
        if times(d)>trial_e(t) && times(d)<=trial_e(t+1) ,t1=t+1; break; end
    end
            trial(d) = t1; state(d)=0;
    if t1<=t0
        if times(d)>trial_s(t1)-0.5, state(d)=1; end
        if times(d)>trial_1(t1), state(d)=2; end
        if times(d)>trial_2(t1), state(d)=3; end
        if times(d)>trial_3(t1), state(d)=4; end
    end
end

Datapixx_eye_T.trial = trial; Datapixx_eye_T.on_trial = state;
%%
l0=size(UE_log.laps,1);
lap=zeros(size(Datapixx_eye,1),1); state=zeros(size(Datapixx_eye,1),1); turn=zeros(size(Datapixx_eye,1),1);
  parfor d=1:size(Datapixx_eye_T,1)
    l1=l0+1;
    for l=1:l0-1
        if times(d)<=lap_s(1),l1=0; break; end
        if times(d)>lap_s(l) && times(d)<=lap_s(l+1) ,l1=l; break; end
    end
            lap(d) = l1; 
    if l1<=l0 && l1~=0
        if times(d)>lap_s(l1), state(d)=1; end
        if times(d)>lap_e(l1), state(d)=0; end
                if times(d)>turn_s(l1) && times(d)<turn_e(l1), turn(d)=1; end
    end
  end

  Datapixx_eye_T.lap = lap; Datapixx_eye_T.on_lap = state; Datapixx_eye_T.on_turn = turn;

  %%
  x=UE_log.parsed.Time_adjust(find(strcmp(UE_log.parsed.Var1,'Tick'))); y=UE_log.parsed.Var3(find(strcmp(UE_log.parsed.Var1,'Tick'))); y2=UE_log.parsed.Var4(find(strcmp(UE_log.parsed.Var1,'Tick'))); 
  xv = Datapixx_eye_T.time;
  Datapixx_eye_T.Xpos = interp1(x,y,xv,'nearest','extrap');   Datapixx_eye_T.Ypos = interp1(x,y2,xv,'previous','extrap');


  %%

function obj = object_code(num)

switch num
    case 0
        obj = 'Donut';
    case 1
        obj = 'Pumpkin';
    case 2
        obj = 'Turtle';
    case 3
        obj = 'Jellyfish';
    case 4
        obj = 'Octopus';
    case 5
        obj = 'Pizza';
    otherwise
        obj = 'Unknown';
end

