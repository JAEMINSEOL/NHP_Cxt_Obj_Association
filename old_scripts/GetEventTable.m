%% Title
% NHP VR Events Combining & Indexing Module
% Version : 20.03.04 12:30 by SJM (initial ver.)
%           20.03.04 15:20 by SJM

% Prerequisite: Parsing_EventAndPosition must be preceded
% Output: ParsedEventTable (Table with 6 columns),
% ParsedTrialTable(Table with 70 columns)

%% Combine Event Variables

Name = getVarName(LapStart_sync_recording); LapS = makeTable(LapStart_sync_recording,Name);
Name = getVarName(LapEnd_sync_recording); LapE = makeTable(LapEnd_sync_recording,Name);

Name = getVarName(TrialStart_sync_recording); TrialS = makeTable(TrialStart_sync_recording,Name);
Name = getVarName(TrialEnd_sync_recording); TrialE = makeTable(TrialEnd_sync_recording,Name);

Name = getVarName(CursorOn_sync_recording); CursON = makeTable(CursorOn_sync_recording,Name);
Name = getVarName(CursorChange_sync_recording); CursCh = makeTable(CursorChange_sync_recording,Name);

Name = getVarName(ObjOn_sync_recording); ObjON = makeTable(ObjOn_sync_recording,Name);
Name = getVarName(ObjOff_sync_recording); ObjOFF = makeTable(ObjOff_sync_recording,Name);

Name = getVarName(JoystickLeft_sync_recording); JoyL = makeTable(JoystickLeft_sync_recording,Name);
Name = getVarName(JoystickRight_sync_recording); JoyR = makeTable(JoystickRight_sync_recording,Name);

Name = getVarName(ChoiceLeft_sync_recording); ChoL = makeTable(ChoiceLeft_sync_recording,Name);
Name = getVarName(ChoiceRight_sync_recording); ChoR = makeTable(ChoiceRight_sync_recording,Name);

Name = getVarName(TurnOn_sync_recording); TurON = makeTable(TurnOn_sync_recording,Name);
Name = getVarName(TurnOff_sync_recording); TurOFF = makeTable(TurnOff_sync_recording,Name);

E_Table = [LapS;LapE;TrialS;TrialE;CursON;CursCh;ObjON;ObjOFF;JoyL;JoyR;ChoL;ChoR;TurON;TurOFF];
clear LapS LapE TrialS TrialE CursON CursCh ObjON ObjOFF JoyL JoyR ChoL ChoR TurON TurOFF Name
E_Table2 = sortrows(E_Table,2); clear E_Table
%% Index and Convert to Table

ParsedEvent(:,3:4) = E_Table2;

l=knnsearch(LapStart_unreal,LapStart_unreal_recording(1,:))-1;
t=0;

for i = 1:size(E_Table2,1)
    if strcmp(cell2mat(E_Table2(i,1)),'LapStart')
        l=l+1;
        t=0;
    end
    if strcmp(cell2mat(E_Table2(i,1)),'TrialStart')
        t=t+1;
    end
    ParsedEvent(i,1) = num2cell(l);
    ParsedEvent(i,5) = cellstr(secs2hms((cell2mat(ParsedEvent(i,4)) - cell2mat(ParsedEvent(1,4)))/(10^6)));
    ParsedEvent(i,6) = cellstr(secs2hms((cell2mat(ParsedEvent(i,4)) - cell2mat(ParsedEvent(1,4)))/(10^6)+LapStart_unreal_recording(1,2) - LapStart_unreal(1,2)));
    ParsedEvent(i,2) = num2cell(t);
end
ParsedEventTable = cell2table(ParsedEvent,'VariableNames',{'LapNum' 'TrialNum' 'EventName' 'Time_ms' 'Time_fromRecordingStart' 'Time_fromVRStart'});

%%
clear ParsedTrialTable

l=knnsearch(LapStart_unreal,LapStart_unreal_recording(1,:))-1;
Time_i = LapStart_sync_recording(1,1)/10^6;

clear ParsedTrial
for i = 1:size(LapStart_sync_recording,1)
    ParsedTrial(i,1) = {l+i};
    if LapType_unreal_recording(i,2)==1 c='Forest'; else c='City'; end
    ParsedTrial(i,2) = cellstr(c);
    ParsedTrial(i,3) = cellstr(secs2hms(LapStart_sync_recording(i,1)/10^6-Time_i));
    ParsedTrial(i,4) = cellstr(secs2hms(LapEnd_sync_recording(i,1)/10^6-Time_i));
    ParsedTrial(i,5) = cellstr(secs2hms(TurnOn_sync_recording(i,1)/10^6-Time_i));
    ParsedTrial(i,6) = cellstr(secs2hms(TurnOff_sync_recording(i,1)/10^6-Time_i));
end


for t = 1:size(TrialStart_sync_recording,1)
    i = fix((t-1)/8)+1; a=7; x=8;
    b = rem(t,8); if b ==0 b = 8; end
    ParsedTrial(i,a+x*(b-1)+0) = cellstr(secs2hms(TrialStart_sync_recording(t,1)/10^6-Time_i));
    ParsedTrial(i,a+x*(b-1)+1) = cellstr(secs2hms(TrialEnd_sync_recording(t,1)/10^6-Time_i));
    ParsedTrial(i,a+x*(b-1)+2) = cellstr(secs2hms(ObjOn_sync_recording(t,1)/10^6-Time_i));
    ParsedTrial(i,a+x*(b-1)+3) = cellstr(secs2hms(ObjOff_sync_recording(t,1)/10^6-Time_i));
    ParsedTrial(i,a+x*(b-1)+4) = cellstr(NameObj(TrialType_unreal_recording(t,7)));
    ParsedTrial(i,a+x*(b-1)+5) = cellstr(NameObj(TrialType_unreal_recording(t,8)));
    if Choice_unreal_recording(t,6)==1
        c='Left';
        if rem(LapType_unreal_recording(i,2),2)==rem(TrialType_unreal_recording(t,7)-1,2)
            d='Correct';
        else
            d='Wrong';
        end     
    else
        c='Right';
        if rem(LapType_unreal_recording(i,2),2)==rem(TrialType_unreal_recording(t,8)-1,2)
            d='Correct';
        else
            d='Wrong';
        end  
    end
    ParsedTrial(i,a+x*(b-1)+6) = cellstr(c);
    ParsedTrial(i,a+x*(b-1)+7) = cellstr(d);
end

ParsedTrialTable = cell2table(ParsedTrial,...
    'VariableNames',{'LapNum' 'Context' 'LapStart' 'LapEnd' 'TurnStart' 'TurnEnd' ...
    'Trial1Start' 'Trial1End' 'Trial1ObjOn' 'Trial1ObjOff' 'Trial1LeftObj' 'Trial1RightObj' 'Trial1Response' 'Trial1Correctness'...
    'Trial2Start' 'Trial2End' 'Trial12ObjOn' 'Trial2ObjOff' 'Trial2LeftObj' 'Trial2RightObj' 'Trial12Response' 'Trial2Correctness'...
    'Trial3Start' 'Trial3End' 'Trial3ObjOn' 'Trial3ObjOff' 'Trial3LeftObj' 'Trial3RightObj' 'Trial3Response' 'Trial3Correctness'...
    'Trial4Start' 'Trial4End' 'Trial4ObjOn' 'Trial4ObjOff' 'Trial4LeftObj' 'Trial4RightObj' 'Trial4Response' 'Trial4Correctness'...
    'Trial5Start' 'Trial5End' 'Trial5ObjOn' 'Trial5ObjOff' 'Trial5LeftObj' 'Trial5RightObj' 'Trial5Response' 'Trial5Correctness'...
    'Trial6Start' 'Trial6End' 'Trial6ObjOn' 'Trial6ObjOff' 'Trial6LeftObj' 'Trial6RightObj' 'Trial6Response' 'Trial6Correctness'...
    'Trial7Start' 'Trial7End' 'Trial7ObjOn' 'Trial7ObjOff' 'Trial7LeftObj' 'Trial7RightObj' 'Trial7Response' 'Trial7Correctness'...
    'Trial8Start' 'Trial8End' 'Trial8ObjOn' 'Trial8ObjOff' 'Trial8LeftObj' 'Trial8RightObj' 'Trial8Response' 'Trial8Correctness'...
    });
%% Clear Unnecessary Variables
clear ParsedEvent E_Table2 l t i a b c d Time_i ParsedTrial
%% Local functions
function T = makeTable(EventName,Name)
Event = cellstr((repmat(extractBefore(Name,'_sync'),size(EventName,1),1)));
Time = num2cell(EventName(:,1));
T = [Event,Time];
end

function out = getVarName(var)
out = inputname(1);
end

function time_string=secs2hms(time_in_secs)
time_string='';
nhours = 0;
nmins = 0;
if time_in_secs >= 3600
    nhours = floor(time_in_secs/3600);
    if nhours > 1
        hour_string = 'h:';
    else
        hour_string = 'h:';
    end
    time_string = [num2str(nhours) hour_string];
end
if time_in_secs >= 60
    nmins = floor((time_in_secs - 3600*nhours)/60);
    if nmins > 1
        minute_string = 'm:';
    else
        minute_string = 'm:';
    end
    time_string = [time_string num2str(nmins) minute_string];
end
nsecs = time_in_secs - 3600*nhours - 60*nmins;
time_string = [time_string sprintf('%2.1f', nsecs) 's'];
end

function n = NameObj(o)
switch o
    case 1
        n = 'Donut';
    case 2
        n = 'Pumpkin';
    case 3
        n = 'Turtle';
    case 4
        n = 'Jellyfish';
    case 5
        n = 'Octopus';
    case 6
        n = 'Pizza';
end
end
