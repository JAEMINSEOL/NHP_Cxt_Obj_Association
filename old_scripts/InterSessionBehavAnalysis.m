% Edited by JM (200309)
% Updated by JM (200312)
% Updated by JM (200313)

% DESCRIPTION: Inter-session analysis
% Prerequisite: Joystickcell, TrialInfo (from nhp_behavior_summary.m)

%% Load last updated Session Summary.mat
cd([mother_drive animal_id '\processed_data'])

if ~exist('SessionSummary.mat')
SessionSummary = [];
else
  load('SessionSummary.mat');  
end	% ~exist('SessionSummary.mat')


%% Add data to Session Summary
cd(result_folder)
idx = ~cellfun('isempty',Joystickcell);
void_trial_mat = nan(size(Joystickcell));
void_trial_mat(idx) = cellfun(@(v)v(5,1),Joystickcell(idx)); % valid = 1, void = 0

for n = 1:nLap
    for m = 1:8
        t = (n-1)*8+m;
        
        SessionSummary(t,1,day_num) = n;% lap number
        
        SessionSummary(t,2,day_num) = t;% trial number
        switch TrialInfo(n,3) % context
            case 1
                SessionSummary(t,3,day_num) = 1;
            case 2
                SessionSummary(t,3,day_num) = 2;
        end
        if m <= 4  % outbound/inbound
            SessionSummary(t,4,day_num) = 0;
        else
            SessionSummary(t,4,day_num) = 1;
        end
        SessionSummary(t,5,day_num) = TrialInfo(n,10*m+2);
        for c1 = 6:7
            if c1 ==6 % left object
                ObjectCode = fix(TrialInfo(n,10*m+3)/10);
            else % right object
                ObjectCode = mod(TrialInfo(n,10*m+3),10);
            end
            SessionSummary(t,c1,day_num) = ObjectCode;
        end
        switch TrialInfo(n,10*m+7) % monkey's response
            case -1
                SessionSummary(t,8,day_num) = 0;
            case 1
                SessionSummary(t,8,day_num) = 1;
        end
        switch TrialInfo(n,10*m+8) % correctness
            case 0
                SessionSummary(t,9,day_num) = 0;
            case 1
                SessionSummary(t,9,day_num) = 1;
        end
        switch void_trial_mat(n,m) % void trials
            case 0
                SessionSummary(t,10,day_num) = 1;
            case 1
                SessionSummary(t,10,day_num) = 0;
        end
        SessionSummary(t,11,day_num) = TrialInfo(n,10*m+6);
    end
end

SessionSummary_Today = SessionSummary(:,:,day_num);
%% Save Session Summary
for i = 1:size(SessionSummary,3)
    id = find(SessionSummary(:,1,i)==0);
    SessionSummary(id, :, i) = NaN;
end

cd([mother_drive animal_id '\processed_data'])
save('SessionSummary.mat','SessionSummary');
%% 
z = size(SessionSummary,3);

for c = 1:2
    for l = 1:8
        for ol = 0:5
            for or = 0:5
                if mod(ol,2) ~= mod(or,2)
                    
                    if c==1
                        cxt = "Forest";
                    else
                        cxt = "City";
                    end
                    ObjPair = [ol,or];
                    ot = ObjPair(find(mod([ol,or],2)==mod(c,2)));
                    olu = ObjPair(find(mod([ol,or],2)~=mod(c,2)));
                    
                    ObjLeft = Name_Obj(ol);
                    ObjRight = Name_Obj(or);
                    ObjTarget = Name_Obj(ot);
                    ObjLure = Name_Obj(olu);
                    if l>4
                        d=2;
                    else
                        d=1;
                    end
                    if l>4
                        l_abs = 9-l;
                    else
                        l_abs = l;
                    end
                    
                        i = (c-1)*144 + (l-1)*18 + (ol)*3 + fix(or/2) + 1;
                        idl = mod(SessionSummary(:,2,z),8); idl(idl==0)=8;
                        id = find(SessionSummary(:,3,z)==c & idl==l & SessionSummary(:,6,z)==ol & SessionSummary(:,7,z)==or);
                        
                    S_Animal(i,1) = string(animal_id);
                    S_Session(i,1) = "STD";
                    S_Day(i,1)  = z;
                    S_Context(i,1)  = string(cxt);
                    S_Direction(i,1)  = d; 
                    S_Location(i,1)  = l; 
                    S_Location_Abs(i,1)  = l_abs;
                    S_Object_Left(i,1)  = string(ObjLeft);
                    S_Object_Right(i,1)  = string(ObjRight);
                    S_Object_Target(i,1)  = string(ObjTarget);
                    S_Object_Lure(i,1)  = string(ObjLure);
                    
                    S_nTrial(i,1) = length(id);
                    S_AccMean(i,1) = nanmean(SessionSummary(id, 9, z),'all');
                    S_RTMedian(i,1) = median(SessionSummary(id, 11, z),'all','omitnan');
                    S_Void(i,1) = nanmean(SessionSummary(id, 10, z),'all');

                end
            end
        end
    end
end

clear z i l ol or ot olu d id cxt l_abs ObjLeft ObjRight ObjTarget ObjLure ObjPair
%% Add current session to BehaviorSummary.csv
cd([mother_drive animal_id '\processed_data'])
date_last=input('Last Update date(YYYYMMDD)? ::','s');
nameCSVFILE = strcat('BehaviorSummary_',date_last,'.csv');
 csvHEADER = ['Animal_ID, Session, Day, Context, Direction, Location, Location_Abs, Left Object, Right Object,Target Object, Lure Object, nTrial, Accuracy mean, Latency median, Void Property'];	

if ~exist(nameCSVFILE)
	hCSV = fopen(nameCSVFILE, 'W');
	fprintf(hCSV, csvHEADER);
	fclose(hCSV); clear hCSV;
end	%~exist(nameCSVFILE)


hCSV = fopen(nameCSVFILE, 'A');
for i = 1:288
    fprintf(hCSV, '%s,%s,%f,%s,%f,%f,%f,%s,%s,%s,%s,%f,%f,%f,%f\n', S_Animal(i),S_Session(i),S_Day(i),S_Context(i),S_Direction(i),S_Location(i),S_Location_Abs(i),...
        S_Object_Left(i),S_Object_Right(i),S_Object_Target(i),S_Object_Lure(i),S_nTrial(i),S_AccMean(i),S_RTMedian(i),S_Void(i));
end
    fclose(hCSV); clear hCSV;
%     
clear S_Animal S_Session S_Day S_Context S_Direction S_Location S_Location_Abs S_Object_Left S_Object_Right S_Object_Target S_Object_Lure S_nTrial S_AccMean S_RTMedian S_Void
%% Local functions
function Obj = Name_Obj(o)
switch o
    case 0
        Obj = 'Donut';
    case 1
        Obj = 'Pumpkin';
    case 2
        Obj = 'Turtle';
    case 3
        Obj = 'Jellyfish';
    case 4
        Obj = 'Octopus';
    case 5
        Obj = 'Pizza';
end
end
