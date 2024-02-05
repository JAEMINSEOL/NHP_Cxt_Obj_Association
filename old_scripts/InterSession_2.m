% Edited by JM (200317)

% DESCRIPTION: Inter-session analysis, Column reducing
% Prerequisite: SessionSummary

clear all

%% Load last updated Session Summary.mat
mother_drive = 'F:\NHP project\Data\';
animal_id=input('Nabi or Yoda?','s');
cd([mother_drive animal_id '\processed_data'])

if ~exist('SessionSummary.mat')
    SessionSummary = [];
else
    load('SessionSummary.mat');
end	% ~exist('SessionSummary.mat')

cd([mother_drive animal_id '\processed_data\behavior'])

date_last=input('Analysis date(YYYYMMDD)? ::','s');
cd([mother_drive animal_id '\processed_data\behavior'])
mkdir(date_last)
cd([mother_drive animal_id '\processed_data\behavior\' date_last])

%% All conditions
z = size(SessionSummary,3);

for j = 1:z
    if ~isnan(SessionSummary(1,1,j))
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
                            if ~isnan(SessionSummary(1,1,j))
                                v = VoidColumn(SessionSummary,j);
                                i = (j-1)*288 + (c-1)*144 + (l-1)*18 + (ol)*3 + fix(or/2) + 1;
                                idl = mod(SessionSummary(:,2,j),8); idl(idl==0)=8;
                                id = find(SessionSummary(:,3,j)==c & idl==l & SessionSummary(:,6,j)==ol & SessionSummary(:,7,j)==or & v);
                                
                                S_Animal(i,1) = string(animal_id);
                                S_Session(i,1) = "STD";
                                S_Day(i,1)  = j;
                                S_Context(i,1)  = string(cxt);
                                S_Direction(i,1)  = d;
                                S_Location(i,1)  = l;
                                S_Location_Abs(i,1)  = l_abs;
                                S_Object_Left(i,1)  = string(ObjLeft);
                                S_Object_Right(i,1)  = string(ObjRight);
                                S_Object_Target(i,1)  = string(ObjTarget);
                                S_Object_Lure(i,1)  = string(ObjLure);
                                
                                S_nTrial(i,1) = length(id);
                                S_AccMean(i,1) = nanmean(SessionSummary(id, 9, j),'all');
                                S_RTMedian(i,1) = median(SessionSummary(id, 11, j),'all','omitnan');
                                S_Void(i,1) = nanmean(SessionSummary(id, 10, j),'all');
                                
                            end
                        end
                    end
                end
            end
        end
    end
end


nameCSVFILE = strcat('BehaviorSummary_All_',date_last,'.csv');
csvHEADER = ['Animal_ID,Session,Day,Context,Direction,Location,Location_Abs,Left Object,Right Object,Target Object,Lure Object,nTrial,Accuracy mean,Latency median,Void Proportion'];

if ~exist(nameCSVFILE)
    hCSV = fopen(nameCSVFILE, 'W');
    fprintf(hCSV, csvHEADER);
    fclose(hCSV); clear hCSV;
end	%~exist(nameCSVFILE)


hCSV = fopen(nameCSVFILE, 'A');
for i = 1:length(S_Animal)
    fprintf(hCSV, '\n%s,%s,%f,%s,%f,%f,%f,%s,%s,%s,%s,%f,%f,%f,%f', S_Animal(i),S_Session(i),S_Day(i),S_Context(i),S_Direction(i),S_Location(i),S_Location_Abs(i),...
        S_Object_Left(i),S_Object_Right(i),S_Object_Target(i),S_Object_Lure(i),S_nTrial(i),S_AccMean(i),S_RTMedian(i),S_Void(i));
end
fclose(hCSV); clear hCSV;

clear z i l ol or ot olu d id cxt l_abs ObjLeft ObjRight ObjTarget ObjLure ObjPair
clear S_Animal S_Session S_Day S_Context S_Direction S_Location S_Location_Abs S_Object_Left S_Object_Right S_Object_Target S_Object_Lure S_nTrial S_AccMean S_RTMedian S_Void

%% Object_side Only
z = size(SessionSummary,3);
for j = 1:z
    for ol = 0:5
        for or = 0:5
            if mod(ol,2) ~= mod(or,2)
                if ~isnan(SessionSummary(1,1,j))
                    
                    ObjLeft = Name_Obj(ol);
                    ObjRight = Name_Obj(or);
                    
                    v = VoidColumn(SessionSummary,j);
                    i = (j-1)*18 + (ol)*3 + fix(or/2) + 1;
                    
                    id = find(SessionSummary(:,6,j)==ol & SessionSummary(:,7,j)==or & v);
                    
                    S_Animal(i,1) = string(animal_id);
                    S_Session(i,1) = "STD";
                    S_Day(i,1)  = j;
                    S_Object_Left(i,1)  = string(ObjLeft);
                    S_Object_Right(i,1)  = string(ObjRight);
                    
                    S_nTrial(i,1) = length(id);
                    S_AccMean(i,1) = nanmean(SessionSummary(id, 9, j),'all');
                    S_RTMedian(i,1) = median(SessionSummary(id, 11, j),'all','omitnan');
                    S_Void(i,1) = nanmean(SessionSummary(id, 10, j),'all');
                end
            end
        end
    end
end


clear z i l ol or ot olu d id cxt l_abs ObjLeft ObjRight ObjTarget ObjLure ObjPair

% date_last=input('Last Update date(YYYYMMDD)? ::','s');
nameCSVFILE = strcat('BehaviorSummary_Obj_Side_',date_last,'.csv');
csvHEADER = ['Animal_ID,Session,Day,Left Object,Right Object,nTrial,Accuracy mean,Latency median,Void Proportion'];

if ~exist(nameCSVFILE)
    hCSV = fopen(nameCSVFILE, 'W');
    fprintf(hCSV, csvHEADER);
    fclose(hCSV); clear hCSV;
end	%~exist(nameCSVFILE)


hCSV = fopen(nameCSVFILE, 'A');
for i = 1:length(S_Animal)
    fprintf(hCSV, '\n%s,%s,%f,%s,%s,%f,%f,%f,%f', S_Animal(i),S_Session(i),S_Day(i),...
        S_Object_Left(i),S_Object_Right(i),S_nTrial(i),S_AccMean(i),S_RTMedian(i),S_Void(i));
end
fclose(hCSV); clear hCSV;
%
clear S_Animal S_Session S_Day S_Context S_Direction S_Location S_Location_Abs S_Object_Left S_Object_Right S_Object_Target S_Object_Lure S_nTrial S_AccMean S_RTMedian S_Void



%% Object only
z = size(SessionSummary,3);
for j = 1:z
    for ol = 1:2:5
        for or = 0:2:4
            if mod(ol,2) ~= mod(or,2)
                if ~isnan(SessionSummary(1,1,j))
                    Obj1 = Name_Obj(ol);
                    Obj2 = Name_Obj(or);
                    
                    v = VoidColumn(SessionSummary,j);
                    i = (j-1)*9 + fix(ol/2)*3 + fix(or/2) + 1;
                    
                    id = find((SessionSummary(:,6,j)==ol | SessionSummary(:,7,j)==ol) & (SessionSummary(:,6,j)==or | SessionSummary(:,7,j)==or) & v);
                    
                    S_Animal(i,1) = string(animal_id);
                    S_Session(i,1) = "STD";
                    S_Day(i,1)  = j;
                    S_Object_1(i,1)  = string(Obj1);
                    S_Object_2(i,1)  = string(Obj2);
                    
                    S_nTrial(i,1) = length(id);
                    S_AccMean(i,1) = nanmean(SessionSummary(id, 9, j),'all');
                    S_RTMedian(i,1) = median(SessionSummary(id, 11, j),'all','omitnan');
                    S_Void(i,1) = nanmean(SessionSummary(id, 10, j),'all');
                    
                end
            end
        end
    end
end

% date_last=input('Last Update date(YYYYMMDD)? ::','s');
nameCSVFILE = strcat('BehaviorSummary_Obj_',date_last,'.csv');
csvHEADER = ['Animal_ID,Session,Day,Object 1,Object 2,nTrial,Accuracy mean,Latency median,Void Proportion'];

if ~exist(nameCSVFILE)
    hCSV = fopen(nameCSVFILE, 'W');
    fprintf(hCSV, csvHEADER);
    fclose(hCSV); clear hCSV;
end	%~exist(nameCSVFILE)


hCSV = fopen(nameCSVFILE, 'A');
for i = 1:length(S_Animal)
    fprintf(hCSV, '\n%s,%s,%f,%s,%s,%f,%f,%f,%f', S_Animal(i),S_Session(i),S_Day(i),...
        S_Object_1(i),S_Object_2(i),S_nTrial(i),S_AccMean(i),S_RTMedian(i),S_Void(i));
end
fclose(hCSV); clear hCSV;
%
clear z i l ol or ot olu d id cxt l_abs Obj1 Obj2 ObjTarget ObjLure ObjPair
clear S_Animal S_Session S_Day S_Context S_Direction S_Location S_Location_Abs S_Object_1 S_Object_2 S_Object_Target S_Object_Lure S_nTrial S_AccMean S_RTMedian S_Void
%% Object_one only
z = size(SessionSummary,3);
for j = 1:z
    if ~isnan(SessionSummary(1,1,j))
        for o = 0:5
            Obj = Name_Obj(o);
            
            v = VoidColumn(SessionSummary,j);
            i = (j-1)*6 + (o) + 1;
            
            id = find((SessionSummary(:,6,j)==o | SessionSummary(:,7,j)==o) & v);
            
            S_Animal(i,1) = string(animal_id);
            S_Session(i,1) = "STD";
            S_Day(i,1)  = j;
            S_Object(i,1)  = string(Obj);
            
            S_nTrial(i,1) = length(id);
            S_AccMean(i,1) = nanmean(SessionSummary(id, 9, j),'all');
            S_RTMedian(i,1) = median(SessionSummary(id, 11, j),'all','omitnan');
            S_Void(i,1) = nanmean(SessionSummary(id, 10, j),'all');
            
        end
    end
end

% date_last=input('Last Update date(YYYYMMDD)? ::','s');
nameCSVFILE = strcat('BehaviorSummary_Obj_one_',date_last,'.csv');
csvHEADER = ['Animal_ID,Session,Day,Object,nTrial,Accuracy mean,Latency median,Void Proportion'];

if ~exist(nameCSVFILE)
    hCSV = fopen(nameCSVFILE, 'W');
    fprintf(hCSV, csvHEADER);
    fclose(hCSV); clear hCSV;
end	%~exist(nameCSVFILE)


hCSV = fopen(nameCSVFILE, 'A');
for i = 1:length(S_Animal)
    fprintf(hCSV, '\n%s,%s,%f,%s,%f,%f,%f,%f', S_Animal(i),S_Session(i),S_Day(i),...
        S_Object(i),S_nTrial(i),S_AccMean(i),S_RTMedian(i),S_Void(i));
end
fclose(hCSV); clear hCSV;
%
clear z i l ol or ot olu d id cxt l_abs Obj
clear S_Animal S_Session S_Day S_Context S_Direction S_Location S_Location_Abs S_Object S_nTrial S_AccMean S_RTMedian S_Void
%% Context only
z = size(SessionSummary,3);
for j = 1:z
    if ~isnan(SessionSummary(1,1,j))
        for c = 1:2
            if c==1
                cxt = "Forest";
            else
                cxt = "City";
            end
            
            v = VoidColumn(SessionSummary,j);
            i = (j-1)*2 + (c-1) + 1;
            id = find(SessionSummary(:,3,j)==c & v);
            
            S_Animal(i,1) = string(animal_id);
            S_Session(i,1) = "STD";
            S_Day(i,1)  = j;
            S_Context(i,1)  = string(cxt);
            
            S_nTrial(i,1) = length(id);
            S_AccMean(i,1) = nanmean(SessionSummary(id, 9, j),'all');
            S_RTMedian(i,1) = median(SessionSummary(id, 11, j),'all','omitnan');
            S_Void(i,1) = nanmean(SessionSummary(id, 10, j),'all');
        end
    end
end

% date_last=input('Last Update date(YYYYMMDD)? ::','s');
nameCSVFILE = strcat('BehaviorSummary_Cxt_',date_last,'.csv');
csvHEADER = ['Animal_ID,Session,Day,Context,nTrial,Accuracy mean,Latency median,Void Proportion'];

if ~exist(nameCSVFILE)
    hCSV = fopen(nameCSVFILE, 'W');
    fprintf(hCSV, csvHEADER);
    fclose(hCSV); clear hCSV;
end	%~exist(nameCSVFILE)


hCSV = fopen(nameCSVFILE, 'A');
for i = 1:length(S_Animal)
    fprintf(hCSV, '\n%s,%s,%f,%s,%f,%f,%f,%f', S_Animal(i),S_Session(i),S_Day(i),...
        S_Context(i),S_nTrial(i),S_AccMean(i),S_RTMedian(i),S_Void(i));
end
fclose(hCSV); clear hCSV;
%
clear z i l ol or ot olu d id cxt l_abs Obj1 Obj2 ObjTarget ObjLure ObjPair
clear S_Animal S_Session S_Day S_Context S_Direction S_Location S_Location_Abs S_Object_1 S_Object_2 S_Object_Target S_Object_Lure S_nTrial S_AccMean S_RTMedian S_Void
%% Direction Only
z = size(SessionSummary,3);

for j = 1:z
    if ~isnan(SessionSummary(1,1,j))
        for d = 1:2
            
            v = VoidColumn(SessionSummary,j);
            i = (j-1)*2 + (d-1) + 1;
            id = find(SessionSummary(:,4,j)==d-1 & v);
            
            S_Animal(i,1) = string(animal_id);
            S_Session(i,1) = "STD";
            S_Day(i,1)  = j;
            S_Direction(i,1)  = d;
            
            S_nTrial(i,1) = length(id);
            S_AccMean(i,1) = nanmean(SessionSummary(id, 9, j),'all');
            S_RTMedian(i,1) = median(SessionSummary(id, 11, j),'all','omitnan');
            S_Void(i,1) = nanmean(SessionSummary(id, 10, j),'all');
            
        end
    end
end

clear z i l ol or ot olu d id cxt l_abs ObjLeft ObjRight ObjTarget ObjLure ObjPair

nameCSVFILE = strcat('BehaviorSummary_Dir_',date_last,'.csv');
csvHEADER = ['Animal_ID,Session,Day,Direction,nTrial,Accuracy mean,Latency median,Void Proportion'];

if ~exist(nameCSVFILE)
    hCSV = fopen(nameCSVFILE, 'W');
    fprintf(hCSV, csvHEADER);
    fclose(hCSV); clear hCSV;
end	%~exist(nameCSVFILE)


hCSV = fopen(nameCSVFILE, 'A');
for i = 1:length(S_Animal)
    fprintf(hCSV, '\n%s,%s,%f,%f,%f,%f,%f,%f', S_Animal(i),S_Session(i),S_Day(i),S_Direction(i),...
        S_nTrial(i),S_AccMean(i),S_RTMedian(i),S_Void(i));
end
fclose(hCSV); clear hCSV;
%
clear S_Animal S_Session S_Day S_Context S_Direction S_Location S_Location_Abs S_Object_Left S_Object_Right S_Object_Target S_Object_Lure S_nTrial S_AccMean S_RTMedian S_Void

%% Location Only
z = size(SessionSummary,3);

for j = 1:z
    if ~isnan(SessionSummary(1,1,j))
        for l = 1:8
            
            
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
            
            v = VoidColumn(SessionSummary,j);
            i = (j-1)*8 + (l-1) + 1;
            idl = mod(SessionSummary(:,2,j),8); idl(idl==0)=8;
            id = find(idl==l & v);
            
            S_Animal(i,1) = string(animal_id);
            S_Session(i,1) = "STD";
            S_Day(i,1)  = j;
            S_Direction(i,1)  = d;
            S_Location(i,1)  = l;
            S_Location_Abs(i,1)  = l_abs;
            
            S_nTrial(i,1) = length(id);
            S_AccMean(i,1) = nanmean(SessionSummary(id, 9, j),'all');
            S_RTMedian(i,1) = median(SessionSummary(id, 11, j),'all','omitnan');
            S_Void(i,1) = nanmean(SessionSummary(id, 10, j),'all');
            
        end
    end
end

clear z i l ol or ot olu d id cxt l_abs ObjLeft ObjRight ObjTarget ObjLure ObjPair

nameCSVFILE = strcat('BehaviorSummary_Loc_',date_last,'.csv');
csvHEADER = ['Animal_ID,Session,Day,Direction,Location,Location_Abs,nTrial,Accuracy mean,Latency median,Void Proportion'];

if ~exist(nameCSVFILE)
    hCSV = fopen(nameCSVFILE, 'W');
    fprintf(hCSV, csvHEADER);
    fclose(hCSV); clear hCSV;
end	%~exist(nameCSVFILE)


hCSV = fopen(nameCSVFILE, 'A');
for i = 1:length(S_Animal)
    fprintf(hCSV, '\n%s,%s,%f,%f,%f,%f,%f,%f,%f,%f', S_Animal(i),S_Session(i),S_Day(i),S_Direction(i),S_Location(i),S_Location_Abs(i),...
        S_nTrial(i),S_AccMean(i),S_RTMedian(i),S_Void(i));
end
fclose(hCSV); clear hCSV;
%
clear S_Animal S_Session S_Day S_Context S_Direction S_Location S_Location_Abs S_Object_Left S_Object_Right S_Object_Target S_Object_Lure S_nTrial S_AccMean S_RTMedian S_Void

%% Location Only_abs
z = size(SessionSummary,3);

for j = 1:z
    if ~isnan(SessionSummary(1,1,j))
        for l = 1:4
            
            v = VoidColumn(SessionSummary,j);
            i = (j-1)*4 + (l-1) + 1;
            
            id = find(SessionSummary(:,5,j)==l & v);
            
            S_Animal(i,1) = string(animal_id);
            S_Session(i,1) = "STD";
            S_Day(i,1)  = j;
            S_Location_Abs(i,1)  = l;
            
            S_nTrial(i,1) = length(id);
            S_AccMean(i,1) = nanmean(SessionSummary(id, 9, j),'all');
            S_RTMedian(i,1) = median(SessionSummary(id, 11, j),'all','omitnan');
            S_Void(i,1) = nanmean(SessionSummary(id, 10, j),'all');
        end
    end
end

clear z i l ol or ot olu d id cxt l_abs ObjLeft ObjRight ObjTarget ObjLure ObjPair

nameCSVFILE = strcat('BehaviorSummary_Loc_abs_',date_last,'.csv');
csvHEADER = ['Animal_ID,Session,Day,Location_Abs,nTrial,Accuracy mean,Latency median,Void Proportion'];

if ~exist(nameCSVFILE)
    hCSV = fopen(nameCSVFILE, 'W');
    fprintf(hCSV, csvHEADER);
    fclose(hCSV); clear hCSV;
end	%~exist(nameCSVFILE)


hCSV = fopen(nameCSVFILE, 'A');
for i = 1:length(S_Animal)
    fprintf(hCSV, '\n%s,%s,%f,%f,%f,%f,%f,%f', S_Animal(i),S_Session(i),S_Day(i),S_Location_Abs(i),...
        S_nTrial(i),S_AccMean(i),S_RTMedian(i),S_Void(i));
end
fclose(hCSV); clear hCSV;
%
clear S_Animal S_Session S_Day S_Context S_Direction S_Location S_Location_Abs S_Object_Left S_Object_Right S_Object_Target S_Object_Lure S_nTrial S_AccMean S_RTMedian S_Void

%% Context+Location
z = size(SessionSummary,3);

for j = 1:z
    if ~isnan(SessionSummary(1,1,j))
        for c = 1:2
            for l = 1:8
                
                if c==1
                    cxt = "Forest";
                else
                    cxt = "City";
                end
                
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
                
                v = VoidColumn(SessionSummary,j);
                i = (j-1)*16 + (c-1)*8 + (l-1) + 1;
                idl = mod(SessionSummary(:,2,j),8); idl(idl==0)=8;
                id = find(SessionSummary(:,3,j)==c & idl==l & v);
                
                S_Animal(i,1) = string(animal_id);
                S_Session(i,1) = "STD";
                S_Day(i,1)  = j;
                S_Context(i,1)  = string(cxt);
                S_Direction(i,1)  = d;
                S_Location(i,1)  = l;
                S_Location_Abs(i,1)  = l_abs;
                
                
                S_nTrial(i,1) = length(id);
                S_AccMean(i,1) = nanmean(SessionSummary(id, 9, j),'all');
                S_RTMedian(i,1) = median(SessionSummary(id, 11, j),'all','omitnan');
                S_Void(i,1) = nanmean(SessionSummary(id, 10, j),'all');
                
            end
        end
    end
end

clear z i l ol or ot olu d id cxt l_abs ObjLeft ObjRight ObjTarget ObjLure ObjPair



nameCSVFILE = strcat('BehaviorSummary_Cxt_Loc_',date_last,'.csv');
csvHEADER = ['Animal_ID,Session,Day,Context,Direction,Location,Location_Abs,nTrial,Accuracy mean,Latency median,Void Proportion'];

if ~exist(nameCSVFILE)
    hCSV = fopen(nameCSVFILE, 'W');
    fprintf(hCSV, csvHEADER);
    fclose(hCSV); clear hCSV;
end	%~exist(nameCSVFILE)


hCSV = fopen(nameCSVFILE, 'A');
for i = 1:length(S_Animal)
    fprintf(hCSV, '\n%s,%s,%f,%s,%f,%f,%f,%f,%f,%f,%f', S_Animal(i),S_Session(i),S_Day(i),S_Context(i),S_Direction(i),S_Location(i),S_Location_Abs(i),...
        S_nTrial(i),S_AccMean(i),S_RTMedian(i),S_Void(i));
end
fclose(hCSV); clear hCSV;
%
clear S_Animal S_Session S_Day S_Context S_Direction S_Location S_Location_Abs S_Object_Left S_Object_Right S_Object_Target S_Object_Lure S_nTrial S_AccMean S_RTMedian S_Void

%% Context+Location_abs
z = size(SessionSummary,3);

for j = 1:z
    if ~isnan(SessionSummary(1,1,j))
        for c = 1:2
            for l = 1:4
                
                if c==1
                    cxt = "Forest";
                else
                    cxt = "City";
                end
                
                v = VoidColumn(SessionSummary,j);
                i = (j-1)*8 + (c-1)*4 + (l-1) + 1;
                id = find(SessionSummary(:,3,j)==c & SessionSummary(:,5,j)==l & v);
                
                S_Animal(i,1) = string(animal_id);
                S_Session(i,1) = "STD";
                S_Day(i,1)  = j;
                S_Context(i,1)  = string(cxt);
                S_Location_Abs(i,1)  = l;
                
                
                S_nTrial(i,1) = length(id);
                S_AccMean(i,1) = nanmean(SessionSummary(id, 9, j),'all');
                S_RTMedian(i,1) = median(SessionSummary(id, 11, j),'all','omitnan');
                S_Void(i,1) = nanmean(SessionSummary(id, 10, j),'all');
                
            end
        end
    end
end

clear z i l ol or ot olu d id cxt l_abs ObjLeft ObjRight ObjTarget ObjLure ObjPair

nameCSVFILE = strcat('BehaviorSummary_Cxt_Loc_abs_',date_last,'.csv');
csvHEADER = ['Animal_ID,Session,Day,Context,Location_Abs,nTrial,Accuracy mean,Latency median,Void Proportion'];

if ~exist(nameCSVFILE)
    hCSV = fopen(nameCSVFILE, 'W');
    fprintf(hCSV, csvHEADER);
    fclose(hCSV); clear hCSV;
end	%~exist(nameCSVFILE)


hCSV = fopen(nameCSVFILE, 'A');
for i = 1:length(S_Animal)
    fprintf(hCSV, '\n%s,%s,%f,%s,%f,%f,%f,%f,%f', S_Animal(i),S_Session(i),S_Day(i),S_Context(i),S_Location_Abs(i),...
        S_nTrial(i),S_AccMean(i),S_RTMedian(i),S_Void(i));
end
fclose(hCSV); clear hCSV;
%
clear S_Animal S_Session S_Day S_Context S_Direction S_Location S_Location_Abs S_Object_Left S_Object_Right S_Object_Target S_Object_Lure S_nTrial S_AccMean S_RTMedian S_Void

%% Context+Object
z = size(SessionSummary,3);

for j = 1:z
    if ~isnan(SessionSummary(1,1,j))
        for c = 1:2
            for ol = 1:2:5
                for or = 0:2:4
                    if mod(ol,2) ~= mod(or,2)
                        
                        
                        
                        if c==1
                            cxt = "Forest";
                        else
                            cxt = "City";
                        end
                        ObjPair = [ol,or];
                        ot = ObjPair(find(mod([ol,or],2)==mod(c,2)));
                        olu = ObjPair(find(mod([ol,or],2)~=mod(c,2)));
                        
                        Obj1 = Name_Obj(ol);
                        Obj2 = Name_Obj(or);
                        ObjTarget = Name_Obj(ot);
                        ObjLure = Name_Obj(olu);
                        
                        v = VoidColumn(SessionSummary,j);
                        i = (j-1)*18 + (c-1)*9 + fix(ol/2)*3 + fix(or/2) + 1;
                        id = find(SessionSummary(:,3,j)==c &(SessionSummary(:,6,j)==ol | SessionSummary(:,7,j)==ol) & (SessionSummary(:,6,j)==or | SessionSummary(:,7,j)==or) & v);
                        
                        S_Animal(i,1) = string(animal_id);
                        S_Session(i,1) = "STD";
                        S_Day(i,1)  = j;
                        S_Context(i,1) = cxt;
                        S_Object_1(i,1)  = string(Obj1);
                        S_Object_2(i,1)  = string(Obj2);
                        S_Object_Target(i,1)  = string(ObjTarget);
                        S_Object_Lure(i,1)  = string(ObjLure);
                        
                        S_nTrial(i,1) = length(id);
                        S_AccMean(i,1) = nanmean(SessionSummary(id, 9, j),'all');
                        S_RTMedian(i,1) = median(SessionSummary(id, 11, j),'all','omitnan');
                        S_Void(i,1) = nanmean(SessionSummary(id, 10, j),'all');
                    end
                end
            end
        end
    end
end



nameCSVFILE = strcat('BehaviorSummary_Cxt_Obj_',date_last,'.csv');
csvHEADER = ['Animal_ID,Session,Day,Context,Object 1,Object 2,Target Object,Lure Object,nTrial,Accuracy mean,Latency median,Void Proportion'];

if ~exist(nameCSVFILE)
    hCSV = fopen(nameCSVFILE, 'W');
    fprintf(hCSV, csvHEADER);
    fclose(hCSV); clear hCSV;
end	%~exist(nameCSVFILE)


hCSV = fopen(nameCSVFILE, 'A');
for i = 1:length(S_Animal)
    fprintf(hCSV, '\n%s,%s,%f,%s,%s,%s,%s,%s,%f,%f,%f,%f', S_Animal(i),S_Session(i),S_Day(i),S_Context(i),...
        S_Object_1(i),S_Object_2(i),S_Object_Target(i),S_Object_Lure(i),S_nTrial(i),S_AccMean(i),S_RTMedian(i),S_Void(i));
end
fclose(hCSV); clear hCSV;

clear z i l ol or ot olu d id cxt l_abs Obj1 Obj2 ObjTarget ObjLure ObjPair
clear S_Animal S_Session S_Day S_Context S_Direction S_Location S_Location_Abs S_Object_1 S_Object_2 S_Object_Target S_Object_Lure S_nTrial S_AccMean S_RTMedian S_Void
%% Context_Object_side
z = size(SessionSummary,3);

for j = 1:z
    if ~isnan(SessionSummary(1,1,j))
        for c = 1:2
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
                        
                        v = VoidColumn(SessionSummary,j);
                        i = (j-1)*36 + (c-1)*18 + (ol)*3 + fix(or/2) + 1;
                        id = find(SessionSummary(:,3,j)==c & SessionSummary(:,6,j)==ol & SessionSummary(:,7,j)==or & v);
                        
                        S_Animal(i,1) = string(animal_id);
                        S_Session(i,1) = "STD";
                        S_Day(i,1)  = j;
                        S_Context(i,1)  = string(cxt);
                        
                        S_Object_Left(i,1)  = string(ObjLeft);
                        S_Object_Right(i,1)  = string(ObjRight);
                        S_Object_Target(i,1)  = string(ObjTarget);
                        S_Object_Lure(i,1)  = string(ObjLure);
                        
                        S_nTrial(i,1) = length(id);
                        S_AccMean(i,1) = nanmean(SessionSummary(id, 9, j),'all');
                        S_RTMedian(i,1) = median(SessionSummary(id, 11, j),'all','omitnan');
                        S_Void(i,1) = nanmean(SessionSummary(id, 10, j),'all');
                        
                        
                    end
                end
            end
        end
    end
end


nameCSVFILE = strcat('BehaviorSummary_Cxt_Obj_side_',date_last,'.csv');
csvHEADER = ['Animal_ID,Session,Day,Context,Left Object,Right Object,Target Object,Lure Object,nTrial,Accuracy mean,Latency median,Void Proportion'];

if ~exist(nameCSVFILE)
    hCSV = fopen(nameCSVFILE, 'W');
    fprintf(hCSV, csvHEADER);
    fclose(hCSV); clear hCSV;
end	%~exist(nameCSVFILE)


hCSV = fopen(nameCSVFILE, 'A');
for i = 1:length(S_Animal)
    fprintf(hCSV, '\n%s,%s,%f,%s,%s,%s,%s,%s,%f,%f,%f,%f', S_Animal(i),S_Session(i),S_Day(i),S_Context(i),...
        S_Object_Left(i),S_Object_Right(i),S_Object_Target(i),S_Object_Lure(i),S_nTrial(i),S_AccMean(i),S_RTMedian(i),S_Void(i));
end
fclose(hCSV); clear hCSV;

clear z i l ol or ot olu d id cxt l_abs ObjLeft ObjRight ObjTarget ObjLure ObjPair
clear S_Animal S_Session S_Day S_Context S_Direction S_Location S_Location_Abs S_Object_Left S_Object_Right S_Object_Target S_Object_Lure S_nTrial S_AccMean S_RTMedian S_Void
%% Context + Location_abs + Object
z = size(SessionSummary,3);

for j = 1:z
    if ~isnan(SessionSummary(1,1,j))
        for c = 1:2
            for l = 1:4
                for ol = 1:2:5
                    for or = 0:2:4
                        if mod(ol,2) ~= mod(or,2)
                            
                            
                            
                            if c==1
                                cxt = "Forest";
                            else
                                cxt = "City";
                            end
                            ObjPair = [ol,or];
                            ot = ObjPair(find(mod([ol,or],2)==mod(c,2)));
                            olu = ObjPair(find(mod([ol,or],2)~=mod(c,2)));
                            
                            Obj1 = Name_Obj(ol);
                            Obj2 = Name_Obj(or);
                            ObjTarget = Name_Obj(ot);
                            ObjLure = Name_Obj(olu);
                            
                            v = VoidColumn(SessionSummary,j);
                            i = (j-1)*72 + (c-1)*36 + (l-1)*9 + fix(ol/2)*3 + fix(or/2) + 1;
                            id = find(SessionSummary(:,3,j)==c &SessionSummary(:,5,j)==l &(SessionSummary(:,6,j)==ol | SessionSummary(:,7,j)==ol) & (SessionSummary(:,6,j)==or | SessionSummary(:,7,j)==or) & v);
                            
                            S_Animal(i,1) = string(animal_id);
                            S_Session(i,1) = "STD";
                            S_Day(i,1)  = j;
                            S_Context(i,1) = cxt;
                            S_Location_Abs(i,1)  = l;
                            
                            S_Object_1(i,1)  = string(Obj1);
                            S_Object_2(i,1)  = string(Obj2);
                            S_Object_Target(i,1)  = string(ObjTarget);
                            S_Object_Lure(i,1)  = string(ObjLure);
                            
                            S_nTrial(i,1) = length(id);
                            S_AccMean(i,1) = nanmean(SessionSummary(id, 9, j),'all');
                            S_RTMedian(i,1) = median(SessionSummary(id, 11, j),'all','omitnan');
                            S_Void(i,1) = nanmean(SessionSummary(id, 10, j),'all');
                        end
                    end
                end
            end
        end
    end
end



nameCSVFILE = strcat('BehaviorSummary_Cxt_Loc_abs_Obj_',date_last,'.csv');
csvHEADER = ['Animal_ID,Session,Day,Context,Location_Abs,Object 1,Object 2,Target Object,Lure Object,nTrial,Accuracy mean,Latency median,Void Proportion'];

if ~exist(nameCSVFILE)
    hCSV = fopen(nameCSVFILE, 'W');
    fprintf(hCSV, csvHEADER);
    fclose(hCSV); clear hCSV;
end	%~exist(nameCSVFILE)


hCSV = fopen(nameCSVFILE, 'A');
for i = 1:length(S_Animal)
    fprintf(hCSV, '\n%s,%s,%f,%s,%f,%s,%s,%s,%s,%f,%f,%f,%f', S_Animal(i),S_Session(i),S_Day(i),S_Context(i),S_Location_Abs(i),...
        S_Object_1(i),S_Object_2(i),S_Object_Target(i),S_Object_Lure(i),S_nTrial(i),S_AccMean(i),S_RTMedian(i),S_Void(i));
end
fclose(hCSV); clear hCSV;

clear z i l ol or ot olu d id cxt l_abs Obj1 Obj2 ObjTarget ObjLure ObjPair
clear S_Animal S_Session S_Day S_Context S_Direction S_Location S_Location_Abs S_Object_1 S_Object_2 S_Object_Target S_Object_Lure S_nTrial S_AccMean S_RTMedian S_Void
%% Context+Location_abs+Object_side
z = size(SessionSummary,3);

for j = 1:z
    if ~isnan(SessionSummary(1,1,j))
        for c = 1:2
            for l = 1:4
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
                            
                            v = VoidColumn(SessionSummary,j);
                            i = (j-1)*144 + (c-1)*72 + (l-1)*18 + (ol)*3 + fix(or/2) + 1;
                            id = find(SessionSummary(:,3,j)==c & SessionSummary(:,5,j)==l & SessionSummary(:,6,j)==ol & SessionSummary(:,7,j)==or & v);
                            
                            S_Animal(i,1) = string(animal_id);
                            S_Session(i,1) = "STD";
                            S_Day(i,1)  = j;
                            S_Context(i,1)  = string(cxt);
                            S_Location_Abs(i,1)  = l;
                            S_Object_Left(i,1)  = string(ObjLeft);
                            S_Object_Right(i,1)  = string(ObjRight);
                            S_Object_Target(i,1)  = string(ObjTarget);
                            S_Object_Lure(i,1)  = string(ObjLure);
                            
                            S_nTrial(i,1) = length(id);
                            S_AccMean(i,1) = nanmean(SessionSummary(id, 9, j),'all');
                            S_RTMedian(i,1) = median(SessionSummary(id, 11, j),'all','omitnan');
                            S_Void(i,1) = nanmean(SessionSummary(id, 10, j),'all');
                            
                        end
                    end
                end
            end
        end
    end
end


nameCSVFILE = strcat('BehaviorSummary_Cxt_Loc_abs_Obj_Side_',date_last,'.csv');
csvHEADER = ['Animal_ID,Session,Day,Context,Location_Abs,Left Object,Right Object,Target Object,Lure Object,nTrial,Accuracy mean,Latency median,Void Proportion'];

if ~exist(nameCSVFILE)
    hCSV = fopen(nameCSVFILE, 'W');
    fprintf(hCSV, csvHEADER);
    fclose(hCSV); clear hCSV;
end	%~exist(nameCSVFILE)


hCSV = fopen(nameCSVFILE, 'A');
for i = 1:length(S_Animal)
    fprintf(hCSV, '\n%s,%s,%f,%s,%f,%s,%s,%s,%s,%f,%f,%f,%f', S_Animal(i),S_Session(i),S_Day(i),S_Context(i),S_Location_Abs(i),...
        S_Object_Left(i),S_Object_Right(i),S_Object_Target(i),S_Object_Lure(i),S_nTrial(i),S_AccMean(i),S_RTMedian(i),S_Void(i));
end
fclose(hCSV); clear hCSV;

clear z i l ol or ot olu d id cxt l_abs ObjLeft ObjRight ObjTarget ObjLure ObjPair
clear S_Animal S_Session S_Day S_Context S_Direction S_Location S_Location_Abs S_Object_Left S_Object_Right S_Object_Target S_Object_Lure S_nTrial S_AccMean S_RTMedian S_Void
%% Context+Location+Object
z = size(SessionSummary,3);

for j = 1:z
    if ~isnan(SessionSummary(1,1,j))
        for c = 1:2
            for l = 1:8
                for ol = 1:2:5
                    for or = 0:2:4
                        if mod(ol,2) ~= mod(or,2)
                            
                            if c==1
                                cxt = "Forest";
                            else
                                cxt = "City";
                            end
                            ObjPair = [ol,or];
                            ot = ObjPair(find(mod([ol,or],2)==mod(c,2)));
                            olu = ObjPair(find(mod([ol,or],2)~=mod(c,2)));
                            
                            Obj1 = Name_Obj(ol);
                            Obj2 = Name_Obj(or);
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
                            
                            v = VoidColumn(SessionSummary,j);
                            i = (j-1)*144 + (c-1)*72 + (l-1)*9 + fix(ol/2)*3 + fix(or/2) + 1;
                            idl = mod(SessionSummary(:,2,j),8); idl(idl==0)=8;
                            id = find(SessionSummary(:,3,j)==c & idl==l &(SessionSummary(:,6,j)==ol | SessionSummary(:,7,j)==ol) & (SessionSummary(:,6,j)==or | SessionSummary(:,7,j)==or) & v);
                            
                            S_Animal(i,1) = string(animal_id);
                            S_Session(i,1) = "STD";
                            S_Day(i,1)  = j;
                            S_Context(i,1)  = string(cxt);
                            S_Direction(i,1)  = d;
                            S_Location(i,1)  = l;
                            S_Location_Abs(i,1)  = l_abs;
                            
                            S_Object_1(i,1)  = string(Obj1);
                            S_Object_2(i,1)  = string(Obj2);
                            S_Object_Target(i,1)  = string(ObjTarget);
                            S_Object_Lure(i,1)  = string(ObjLure);
                            
                            S_nTrial(i,1) = length(id);
                            S_AccMean(i,1) = nanmean(SessionSummary(id, 9, j),'all');
                            S_RTMedian(i,1) = median(SessionSummary(id, 11, j),'all','omitnan');
                            S_Void(i,1) = nanmean(SessionSummary(id, 10, j),'all');
                            
                        end
                    end
                end
            end
        end
    end
end


nameCSVFILE = strcat('BehaviorSummary_Cxt_Loc_Obj_',date_last,'.csv');
csvHEADER = ['Animal_ID,Session,Day,Context,Direction,Location,Location_Abs,Object 1,Object 2,Target Object,Lure Object,nTrial,Accuracy mean,Latency median,Void Proportion'];

if ~exist(nameCSVFILE)
    hCSV = fopen(nameCSVFILE, 'W');
    fprintf(hCSV, csvHEADER);
    fclose(hCSV); clear hCSV;
end	%~exist(nameCSVFILE)


hCSV = fopen(nameCSVFILE, 'A');
for i = 1:length(S_Animal)
    fprintf(hCSV, '\n%s,%s,%f,%s,%f,%f,%f,%s,%s,%s,%s,%f,%f,%f,%f', S_Animal(i),S_Session(i),S_Day(i),S_Context(i),S_Direction(i),S_Location(i),S_Location_Abs(i),...
        S_Object_1(i),S_Object_2(i),S_Object_Target(i),S_Object_Lure(i),S_nTrial(i),S_AccMean(i),S_RTMedian(i),S_Void(i));
end
fclose(hCSV); clear hCSV;

clear z i l ol or ot olu d id cxt l_abs Obj1 Obj2 ObjTarget ObjLure ObjPair
clear S_Animal S_Session S_Day S_Context S_Direction S_Location S_Location_Abs S_Object_1 S_Object_2 S_Object_Target S_Object_Lure S_nTrial S_AccMean S_RTMedian S_Void



%% Context+Direction
z = size(SessionSummary,3);

for j = 1:z
    if ~isnan(SessionSummary(1,1,j))
        for c = 1:2
            for d = 1:2
                
                
                if c==1
                    cxt = "Forest";
                else
                    cxt = "City";
                end
                
                v = VoidColumn(SessionSummary,j);
                i = (j-1)*4 + (c-1)*2 + (d-1) + 1;
                
                id = find(SessionSummary(:,3,j)==c & SessionSummary(:,4,j)==d-1 & v);
                
                S_Animal(i,1) = string(animal_id);
                S_Session(i,1) = "STD";
                S_Day(i,1)  = j;
                S_Context(i,1)  = string(cxt);
                S_Direction(i,1)  = d;
                
                S_nTrial(i,1) = length(id);
                S_AccMean(i,1) = nanmean(SessionSummary(id, 9, j),'all');
                S_RTMedian(i,1) = median(SessionSummary(id, 11, j),'all','omitnan');
                S_Void(i,1) = nanmean(SessionSummary(id, 10, j),'all');
                
                
            end
        end
    end
end


nameCSVFILE = strcat('BehaviorSummary_Cxt_Dir_',date_last,'.csv');
csvHEADER = ['Animal_ID,Session,Day,Context,Direction,nTrial,Accuracy mean,Latency median,Void Proportion'];

if ~exist(nameCSVFILE)
    hCSV = fopen(nameCSVFILE, 'W');
    fprintf(hCSV, csvHEADER);
    fclose(hCSV); clear hCSV;
end	%~exist(nameCSVFILE)


hCSV = fopen(nameCSVFILE, 'A');
for i = 1:length(S_Animal)
    fprintf(hCSV, '\n%s,%s,%f,%s,%f,%f,%f,%f,%f', S_Animal(i),S_Session(i),S_Day(i),S_Context(i),S_Direction(i),...
        S_nTrial(i),S_AccMean(i),S_RTMedian(i),S_Void(i));
end
fclose(hCSV); clear hCSV;

clear z i l ol or ot olu d id cxt l_abs ObjLeft ObjRight ObjTarget ObjLure ObjPair
clear S_Animal S_Session S_Day S_Context S_Direction S_Location S_Location_Abs S_Object_Left S_Object_Right S_Object_Target S_Object_Lure S_nTrial S_AccMean S_RTMedian S_Void
%% Context+Direction+Object
z = size(SessionSummary,3);

for j = 1:z
    if ~isnan(SessionSummary(1,1,j))
        for c = 1:2
            for d = 1:2
                for ol = 1:2:5
                    for or = 0:2:4
                        if mod(ol,2) ~= mod(or,2)
                            
                            if c==1
                                cxt = "Forest";
                            else
                                cxt = "City";
                            end
                            ObjPair = [ol,or];
                            ot = ObjPair(find(mod([ol,or],2)==mod(c,2)));
                            olu = ObjPair(find(mod([ol,or],2)~=mod(c,2)));
                            
                            Obj1 = Name_Obj(ol);
                            Obj2 = Name_Obj(or);
                            ObjTarget = Name_Obj(ot);
                            ObjLure = Name_Obj(olu);
                            
                            v = VoidColumn(SessionSummary,j);
                            i = (j-1)*36 + (c-1)*18 + (d-1)*9 + fix(ol/2)*3 + fix(or/2) + 1;
                            
                            id = find(SessionSummary(:,3,j)==c & SessionSummary(:,4,j)==d-1 &(SessionSummary(:,6,j)==ol | SessionSummary(:,7,j)==ol) & (SessionSummary(:,6,j)==or | SessionSummary(:,7,j)==or) & v);
                            
                            S_Animal(i,1) = string(animal_id);
                            S_Session(i,1) = "STD";
                            S_Day(i,1)  = j;
                            S_Context(i,1)  = string(cxt);
                            S_Direction(i,1)  = d;
                            
                            S_Object_1(i,1)  = string(Obj1);
                            S_Object_2(i,1)  = string(Obj2);
                            S_Object_Target(i,1)  = string(ObjTarget);
                            S_Object_Lure(i,1)  = string(ObjLure);
                            
                            S_nTrial(i,1) = length(id);
                            S_AccMean(i,1) = nanmean(SessionSummary(id, 9, j),'all');
                            S_RTMedian(i,1) = median(SessionSummary(id, 11, j),'all','omitnan');
                            S_Void(i,1) = nanmean(SessionSummary(id, 10, j),'all');
                            
                            
                        end
                    end
                end
            end
        end
    end
end


nameCSVFILE = strcat('BehaviorSummary_Cxt_Dir_Obj_',date_last,'.csv');
csvHEADER = ['Animal_ID,Session,Day,Context,Direction,Object 1,Object 2,Target Object,Lure Object,nTrial,Accuracy mean,Latency median,Void Proportion'];

if ~exist(nameCSVFILE)
    hCSV = fopen(nameCSVFILE, 'W');
    fprintf(hCSV, csvHEADER);
    fclose(hCSV); clear hCSV;
end	%~exist(nameCSVFILE)


hCSV = fopen(nameCSVFILE, 'A');
for i = 1:length(S_Animal)
    fprintf(hCSV, '\n%s,%s,%f,%s,%f,%s,%s,%s,%s,%f,%f,%f,%f', S_Animal(i),S_Session(i),S_Day(i),S_Context(i),S_Direction(i),...
        S_Object_1(i),S_Object_2(i),S_Object_Target(i),S_Object_Lure(i),S_nTrial(i),S_AccMean(i),S_RTMedian(i),S_Void(i));
end
fclose(hCSV); clear hCSV;

clear z i l ol or ot olu d id cxt l_abs Obj1 Obj2 ObjTarget ObjLure ObjPair
clear S_Animal S_Session S_Day S_Context S_Direction S_Location S_Location_Abs S_Object_1 S_Object_2 S_Object_Target S_Object_Lure S_nTrial S_AccMean S_RTMedian S_Void

%% Context+Direction+Object_side
z = size(SessionSummary,3);

for j = 1:z
    if ~isnan(SessionSummary(1,1,j))
        for c = 1:2
            for d = 1:2
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
                            
                            v = VoidColumn(SessionSummary,j);
                            i = (j-1)*72 + (c-1)*36 + (d-1)*18 + (ol)*3 + fix(or/2) + 1;
                            id = find(SessionSummary(:,3,j)==c & SessionSummary(:,4,j)==d-1 & SessionSummary(:,6,j)==ol & SessionSummary(:,7,j)==or & v);
                            
                            S_Animal(i,1) = string(animal_id);
                            S_Session(i,1) = "STD";
                            S_Day(i,1)  = j;
                            S_Context(i,1)  = string(cxt);
                            S_Direction(i,1)  = d;
                            
                            S_Object_Left(i,1)  = string(ObjLeft);
                            S_Object_Right(i,1)  = string(ObjRight);
                            S_Object_Target(i,1)  = string(ObjTarget);
                            S_Object_Lure(i,1)  = string(ObjLure);
                            
                            S_nTrial(i,1) = length(id);
                            S_AccMean(i,1) = nanmean(SessionSummary(id, 9, j),'all');
                            S_RTMedian(i,1) = median(SessionSummary(id, 11, j),'all','omitnan');
                            S_Void(i,1) = nanmean(SessionSummary(id, 10, j),'all');
                            
                            
                        end
                    end
                end
            end
        end
    end
end


nameCSVFILE = strcat('BehaviorSummary_Cxt_Dir_Obj_side_',date_last,'.csv');
csvHEADER = ['Animal_ID,Session,Day,Context,Direction,Left Object,Right Object,Target Object,Lure Object,nTrial,Accuracy mean,Latency median,Void Proportion'];

if ~exist(nameCSVFILE)
    hCSV = fopen(nameCSVFILE, 'W');
    fprintf(hCSV, csvHEADER);
    fclose(hCSV); clear hCSV;
end	%~exist(nameCSVFILE)


hCSV = fopen(nameCSVFILE, 'A');
for i = 1:length(S_Animal)
    fprintf(hCSV, '\n%s,%s,%f,%s,%f,%s,%s,%s,%s,%f,%f,%f,%f', S_Animal(i),S_Session(i),S_Day(i),S_Context(i),S_Direction(i),...
        S_Object_Left(i),S_Object_Right(i),S_Object_Target(i),S_Object_Lure(i),S_nTrial(i),S_AccMean(i),S_RTMedian(i),S_Void(i));
end
fclose(hCSV); clear hCSV;

clear z i l ol or ot olu d id cxt l_abs ObjLeft ObjRight ObjTarget ObjLure ObjPair
clear S_Animal S_Session S_Day S_Context S_Direction S_Location S_Location_Abs S_Object_Left S_Object_Right S_Object_Target S_Object_Lure S_nTrial S_AccMean S_RTMedian S_Void

%% Location+Object
z = size(SessionSummary,3);

for j = 1:z
    if ~isnan(SessionSummary(1,1,j))
        for l = 1:8
            for ol = 1:2:5
                for or = 0:2:4
                    if mod(ol,2) ~= mod(or,2)
                        
                        
                        Obj1 = Name_Obj(ol);
                        Obj2 = Name_Obj(or);
                        
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
                        
                        v = VoidColumn(SessionSummary,j);
                        i = (j-1)*72 + (l-1)*9 + fix(ol/2)*3 + fix(or/2) + 1;
                        idl = mod(SessionSummary(:,2,j),8); idl(idl==0)=8;
                        id = find(idl==l &(SessionSummary(:,6,j)==ol | SessionSummary(:,7,j)==ol) & (SessionSummary(:,6,j)==or | SessionSummary(:,7,j)==or) & v);
                        
                        S_Animal(i,1) = string(animal_id);
                        S_Session(i,1) = "STD";
                        S_Day(i,1)  = j;
                        S_Direction(i,1)  = d;
                        S_Location(i,1)  = l;
                        S_Location_Abs(i,1)  = l_abs;
                        
                        S_Object_1(i,1)  = string(Obj1);
                        S_Object_2(i,1)  = string(Obj2);
                        
                        
                        S_nTrial(i,1) = length(id);
                        S_AccMean(i,1) = nanmean(SessionSummary(id, 9, j),'all');
                        S_RTMedian(i,1) = median(SessionSummary(id, 11, j),'all','omitnan');
                        S_Void(i,1) = nanmean(SessionSummary(id, 10, j),'all');
                        
                    end
                end
            end
        end
    end
end


nameCSVFILE = strcat('BehaviorSummary_Loc_Obj_',date_last,'.csv');
csvHEADER = ['Animal_ID,Session,Day,Direction,Location,Location_Abs,Object 1,Object 2,nTrial,Accuracy mean,Latency median,Void Proportion'];

if ~exist(nameCSVFILE)
    hCSV = fopen(nameCSVFILE, 'W');
    fprintf(hCSV, csvHEADER);
    fclose(hCSV); clear hCSV;
end	%~exist(nameCSVFILE)


hCSV = fopen(nameCSVFILE, 'A');
for i = 1:length(S_Animal)
    fprintf(hCSV, '\n%s,%s,%f,%f,%f,%f,%s,%s,%f,%f,%f,%f', S_Animal(i),S_Session(i),S_Day(i),S_Direction(i),S_Location(i),S_Location_Abs(i),...
        S_Object_1(i),S_Object_2(i),S_nTrial(i),S_AccMean(i),S_RTMedian(i),S_Void(i));
end
fclose(hCSV); clear hCSV;

clear z i l ol or ot olu d id cxt l_abs Obj1 Obj2 ObjTarget ObjLure ObjPair
clear S_Animal S_Session S_Day S_Context S_Direction S_Location S_Location_Abs S_Object_1 S_Object_2 S_Object_Target S_Object_Lure S_nTrial S_AccMean S_RTMedian S_Void
%% Location_abs + Object
z = size(SessionSummary,3);

for j = 1:z
    if ~isnan(SessionSummary(1,1,j))
        for l = 1:4
            for ol = 1:2:5
                for or = 0:2:4
                    if mod(ol,2) ~= mod(or,2)
                        
                        Obj1 = Name_Obj(ol);
                        Obj2 = Name_Obj(or);
                        
                        v = VoidColumn(SessionSummary,j);
                        i = (j-1)*36 + (l-1)*9 + fix(ol/2)*3 + fix(or/2) + 1;
                        id = find(SessionSummary(:,5,j)==l &(SessionSummary(:,6,j)==ol | SessionSummary(:,7,j)==ol) & (SessionSummary(:,6,j)==or | SessionSummary(:,7,j)==or) & v);
                        
                        S_Animal(i,1) = string(animal_id);
                        S_Session(i,1) = "STD";
                        S_Day(i,1)  = j;
                        S_Location_Abs(i,1)  = l;
                        
                        S_Object_1(i,1)  = string(Obj1);
                        S_Object_2(i,1)  = string(Obj2);
                        
                        S_nTrial(i,1) = length(id);
                        S_AccMean(i,1) = nanmean(SessionSummary(id, 9, j),'all');
                        S_RTMedian(i,1) = median(SessionSummary(id, 11, j),'all','omitnan');
                        S_Void(i,1) = nanmean(SessionSummary(id, 10, j),'all');
                    end
                end
            end
        end
    end
    
end



nameCSVFILE = strcat('BehaviorSummary_Loc_abs_Obj_',date_last,'.csv');
csvHEADER = ['Animal_ID,Session,Day,Location_Abs,Object 1,Object 2,nTrial,Accuracy mean,Latency median,Void Proportion'];

if ~exist(nameCSVFILE)
    hCSV = fopen(nameCSVFILE, 'W');
    fprintf(hCSV, csvHEADER);
    fclose(hCSV); clear hCSV;
end	%~exist(nameCSVFILE)


hCSV = fopen(nameCSVFILE, 'A');
for i = 1:length(S_Animal)
    fprintf(hCSV, '\n%s,%s,%f,%f,%s,%s,%f,%f,%f,%f', S_Animal(i),S_Session(i),S_Day(i),S_Location_Abs(i),...
        S_Object_1(i),S_Object_2(i),S_nTrial(i),S_AccMean(i),S_RTMedian(i),S_Void(i));
end
fclose(hCSV); clear hCSV;

clear z i l ol or ot olu d id cxt l_abs Obj1 Obj2 ObjTarget ObjLure ObjPair
clear S_Animal S_Session S_Day S_Context S_Direction S_Location S_Location_Abs S_Object_1 S_Object_2 S_Object_Target S_Object_Lure S_nTrial S_AccMean S_RTMedian S_Void

%% Location + Object_side
z = size(SessionSummary,3);

for j = 1:z
    if ~isnan(SessionSummary(1,1,j))
        for l = 1:8
            for ol = 0:5
                for or = 0:5
                    if mod(ol,2) ~= mod(or,2)
                        
                        
                        ObjLeft = Name_Obj(ol);
                        ObjRight = Name_Obj(or);
                        
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
                        
                        v = VoidColumn(SessionSummary,j);
                        i = (j-1)*144 + (l-1)*18 + (ol)*3 + fix(or/2) + 1;
                        idl = mod(SessionSummary(:,2,j),8); idl(idl==0)=8;
                        id = find(idl==l & SessionSummary(:,6,j)==ol & SessionSummary(:,7,j)==or & v);
                        
                        S_Animal(i,1) = string(animal_id);
                        S_Session(i,1) = "STD";
                        S_Day(i,1)  = j;
                        S_Direction(i,1)  = d;
                        S_Location(i,1)  = l;
                        S_Location_Abs(i,1)  = l_abs;
                        
                        S_Object_Left(i,1)  = string(ObjLeft);
                        S_Object_Right(i,1)  = string(ObjRight);
                        
                        S_nTrial(i,1) = length(id);
                        S_AccMean(i,1) = nanmean(SessionSummary(id, 9, j),'all');
                        S_RTMedian(i,1) = median(SessionSummary(id, 11, j),'all','omitnan');
                        S_Void(i,1) = nanmean(SessionSummary(id, 10, j),'all');
                        
                    end
                end
            end
        end
    end
end


nameCSVFILE = strcat('BehaviorSummary_Loc_Obj_side_',date_last,'.csv');
csvHEADER = ['Animal_ID,Session,Day,Direction,Location,Location_Abs,Left Object,Right Object,nTrial,Accuracy mean,Latency median,Void Proportion'];

if ~exist(nameCSVFILE)
    hCSV = fopen(nameCSVFILE, 'W');
    fprintf(hCSV, csvHEADER);
    fclose(hCSV); clear hCSV;
end	%~exist(nameCSVFILE)


hCSV = fopen(nameCSVFILE, 'A');
for i = 1:length(S_Animal)
    fprintf(hCSV, '\n%s,%s,%f,%f,%f,%f,%s,%s,%f,%f,%f,%f', S_Animal(i),S_Session(i),S_Day(i),S_Direction(i),S_Location(i),S_Location_Abs(i),...
        S_Object_Left(i),S_Object_Right(i),S_nTrial(i),S_AccMean(i),S_RTMedian(i),S_Void(i));
end
fclose(hCSV); clear hCSV;

clear z i l ol or ot olu d id cxt l_abs ObjLeft ObjRight ObjTarget ObjLure ObjPair
clear S_Animal S_Session S_Day S_Context S_Direction S_Location S_Location_Abs S_Object_Left S_Object_Right S_Object_Target S_Object_Lure S_nTrial S_AccMean S_RTMedian S_Void
%% Location_abs+Object_side
z = size(SessionSummary,3);

for j = 1:z
    if ~isnan(SessionSummary(1,1,j))
        for l = 1:4
            for ol = 0:5
                for or = 0:5
                    if mod(ol,2) ~= mod(or,2)
                        
                        
                        ObjLeft = Name_Obj(ol);
                        ObjRight = Name_Obj(or);
                        
                        v = VoidColumn(SessionSummary,j);
                        i = (j-1)*72 + (l-1)*18 + (ol)*3 + fix(or/2) + 1;
                        id = find(SessionSummary(:,5,j)==l & SessionSummary(:,6,j)==ol & SessionSummary(:,7,j)==or & v);
                        
                        S_Animal(i,1) = string(animal_id);
                        S_Session(i,1) = "STD";
                        S_Day(i,1)  = j;
                        
                        S_Location_Abs(i,1)  = l;
                        S_Object_Left(i,1)  = string(ObjLeft);
                        S_Object_Right(i,1)  = string(ObjRight);
                        
                        S_nTrial(i,1) = length(id);
                        S_AccMean(i,1) = nanmean(SessionSummary(id, 9, j),'all');
                        S_RTMedian(i,1) = median(SessionSummary(id, 11, j),'all','omitnan');
                        S_Void(i,1) = nanmean(SessionSummary(id, 10, j),'all');
                        
                    end
                end
            end
        end
    end
    
end


nameCSVFILE = strcat('BehaviorSummary_Loc_abs_Obj_Side_',date_last,'.csv');
csvHEADER = ['Animal_ID,Session,Day,Location_Abs,Left Object,Right Object,nTrial,Accuracy mean,Latency median,Void Proportion'];

if ~exist(nameCSVFILE)
    hCSV = fopen(nameCSVFILE, 'W');
    fprintf(hCSV, csvHEADER);
    fclose(hCSV); clear hCSV;
end	%~exist(nameCSVFILE)


hCSV = fopen(nameCSVFILE, 'A');
for i = 1:length(S_Animal)
    fprintf(hCSV, '\n%s,%s,%f,%f,%s,%s,%f,%f,%f,%f', S_Animal(i),S_Session(i),S_Day(i),S_Location_Abs(i),...
        S_Object_Left(i),S_Object_Right(i),S_nTrial(i),S_AccMean(i),S_RTMedian(i),S_Void(i));
end
fclose(hCSV); clear hCSV;

clear z i l ol or ot olu d id cxt l_abs ObjLeft ObjRight ObjTarget ObjLure ObjPair
clear S_Animal S_Session S_Day S_Context S_Direction S_Location S_Location_Abs S_Object_Left S_Object_Right S_Object_Target S_Object_Lure S_nTrial S_AccMean S_RTMedian S_Void

%% Direction+Object
z = size(SessionSummary,3);

for j = 1:z
    if ~isnan(SessionSummary(1,1,j))
        for d = 1:2
            for ol = 1:2:5
                for or = 0:2:4
                    if mod(ol,2) ~= mod(or,2)
                        
                        ObjPair = [ol,or];
                        ot = ObjPair(find(mod([ol,or],2)==mod(c,2)));
                        olu = ObjPair(find(mod([ol,or],2)~=mod(c,2)));
                        
                        Obj1 = Name_Obj(ol);
                        Obj2 = Name_Obj(or);
                        ObjTarget = Name_Obj(ot);
                        ObjLure = Name_Obj(olu);
                        
                        v = VoidColumn(SessionSummary,j);
                        i = (j-1)*18 + (d-1)*9 + fix(ol/2)*3 + fix(or/2) + 1;
                        
                        id = find(SessionSummary(:,4,j)==d-1 &(SessionSummary(:,6,j)==ol | SessionSummary(:,7,j)==ol) & (SessionSummary(:,6,j)==or | SessionSummary(:,7,j)==or) & v);
                        
                        S_Animal(i,1) = string(animal_id);
                        S_Session(i,1) = "STD";
                        S_Day(i,1)  = j;
                        
                        S_Direction(i,1)  = d;
                        
                        S_Object_1(i,1)  = string(Obj1);
                        S_Object_2(i,1)  = string(Obj2);
                        S_Object_Target(i,1)  = string(ObjTarget);
                        S_Object_Lure(i,1)  = string(ObjLure);
                        
                        S_nTrial(i,1) = length(id);
                        S_AccMean(i,1) = nanmean(SessionSummary(id, 9, j),'all');
                        S_RTMedian(i,1) = median(SessionSummary(id, 11, j),'all','omitnan');
                        S_Void(i,1) = nanmean(SessionSummary(id, 10, j),'all');
                        
                    end
                end
            end
        end
    end
    
end


nameCSVFILE = strcat('BehaviorSummary_Dir_Obj_',date_last,'.csv');
csvHEADER = ['Animal_ID,Session,Day,Direction,Object 1,Object 2,Target Object,Lure Object,nTrial,Accuracy mean,Latency median,Void Proportion'];

if ~exist(nameCSVFILE)
    hCSV = fopen(nameCSVFILE, 'W');
    fprintf(hCSV, csvHEADER);
    fclose(hCSV); clear hCSV;
end	%~exist(nameCSVFILE)


hCSV = fopen(nameCSVFILE, 'A');
for i = 1:length(S_Animal)
    fprintf(hCSV, '\n%s,%s,%f,%f,%s,%s,%s,%s,%f,%f,%f,%f', S_Animal(i),S_Session(i),S_Day(i),S_Direction(i),...
        S_Object_1(i),S_Object_2(i),S_Object_Target(i),S_Object_Lure(i),S_nTrial(i),S_AccMean(i),S_RTMedian(i),S_Void(i));
end
fclose(hCSV); clear hCSV;

clear z i l ol or ot olu d id cxt l_abs Obj1 Obj2 ObjTarget ObjLure ObjPair
clear S_Animal S_Session S_Day S_Context S_Direction S_Location S_Location_Abs S_Object_1 S_Object_2 S_Object_Target S_Object_Lure S_nTrial S_AccMean S_RTMedian S_Void

%% Direction+Object_side
z = size(SessionSummary,3);

for j = 1:z
    if ~isnan(SessionSummary(1,1,j))
        for d = 1:2
            for ol = 0:5
                for or = 0:5
                    if mod(ol,2) ~= mod(or,2)
                        
                        
                        ObjLeft = Name_Obj(ol);
                        ObjRight = Name_Obj(or);
                        
                        v = VoidColumn(SessionSummary,j);
                        i = (j-1)*36 + (d-1)*18 + (ol)*3 + fix(or/2) + 1;
                        id = find(SessionSummary(:,4,j)==d-1 & SessionSummary(:,6,j)==ol & SessionSummary(:,7,j)==or & v);
                        
                        S_Animal(i,1) = string(animal_id);
                        S_Session(i,1) = "STD";
                        S_Day(i,1)  = j;
                        
                        S_Direction(i,1)  = d;
                        
                        S_Object_Left(i,1)  = string(ObjLeft);
                        S_Object_Right(i,1)  = string(ObjRight);
                        
                        S_nTrial(i,1) = length(id);
                        S_AccMean(i,1) = nanmean(SessionSummary(id, 9, j),'all');
                        S_RTMedian(i,1) = median(SessionSummary(id, 11, j),'all','omitnan');
                        S_Void(i,1) = nanmean(SessionSummary(id, 10, j),'all');
                        
                    end
                end
            end
        end
    end
end


nameCSVFILE = strcat('BehaviorSummary_Dir_Obj_side_',date_last,'.csv');
csvHEADER = ['Animal_ID,Session,Day,Direction,Left Object,Right Object,nTrial,Accuracy mean,Latency median,Void Proportion'];

if ~exist(nameCSVFILE)
    hCSV = fopen(nameCSVFILE, 'W');
    fprintf(hCSV, csvHEADER);
    fclose(hCSV); clear hCSV;
end	%~exist(nameCSVFILE)


hCSV = fopen(nameCSVFILE, 'A');
for i = 1:length(S_Animal)
    fprintf(hCSV, '\n%s,%s,%f,%f,%s,%s,%f,%f,%f,%f', S_Animal(i),S_Session(i),S_Day(i),S_Direction(i),...
        S_Object_Left(i),S_Object_Right(i),S_nTrial(i),S_AccMean(i),S_RTMedian(i),S_Void(i));
end
fclose(hCSV); clear hCSV;

clear z i l ol or ot olu d id cxt l_abs ObjLeft ObjRight ObjTarget ObjLure ObjPair
clear S_Animal S_Session S_Day S_Context S_Direction S_Location S_Location_Abs S_Object_Left S_Object_Right S_Object_Target S_Object_Lure S_nTrial S_AccMean S_RTMedian S_Void

%% Location_abs + Object_one
z = size(SessionSummary,3);

for j = 1:z
    if ~isnan(SessionSummary(1,1,j))
        for l = 1:4
            for o = 0:5
                Obj = Name_Obj(o);
                v = VoidColumn(SessionSummary,j);
                i = (j-1)*24 + (l-1)*6 + (o) + 1;
                id = find(SessionSummary(:,5,j)==l & (SessionSummary(:,6,j)==o | SessionSummary(:,7,j)==o) & v);
                
                
                
                S_Animal(i,1) = string(animal_id);
                S_Session(i,1) = "STD";
                S_Day(i,1)  = j;
                S_Location_Abs(i,1)  = l;
                
                S_Object(i,1)  = string(Obj);
                
                
                S_nTrial(i,1) = length(id);
                S_AccMean(i,1) = nanmean(SessionSummary(id, 9, j),'all');
                S_RTMedian(i,1) = median(SessionSummary(id, 11, j),'all','omitnan');
                S_Void(i,1) = nanmean(SessionSummary(id, 10, j),'all');
            end
        end
    end
end


nameCSVFILE = strcat('BehaviorSummary_Loc_abs_Obj_one_',date_last,'.csv');
csvHEADER = ['Animal_ID,Session,Day,Location_Abs,Object,nTrial,Accuracy mean,Latency median,Void Proportion'];

if ~exist(nameCSVFILE)
    hCSV = fopen(nameCSVFILE, 'W');
    fprintf(hCSV, csvHEADER);
    fclose(hCSV); clear hCSV;
end	%~exist(nameCSVFILE)


hCSV = fopen(nameCSVFILE, 'A');
for i = 1:length(S_Animal)
    fprintf(hCSV, '\n%s,%s,%f,%f,%s,%f,%f,%f,%f', S_Animal(i),S_Session(i),S_Day(i),S_Location_Abs(i),...
        S_Object(i),S_nTrial(i),S_AccMean(i),S_RTMedian(i),S_Void(i));
end
fclose(hCSV); clear hCSV;

clear z i l ol or ot olu d id cxt l_abs Obj
clear S_Animal S_Session S_Day S_Context S_Direction S_Location S_Location_Abs S_Object S_nTrial S_AccMean S_RTMedian S_Void

%% Location + Object_one
z = size(SessionSummary,3);

for j = 1:z
    if ~isnan(SessionSummary(1,1,j))
        for l = 1:8
            for o = 0:5
                
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
                Obj = Name_Obj(o);
                
                v = VoidColumn(SessionSummary,j);
                i = (j-1)*48 + (l-1)*6 + (o) + 1;
                idl = mod(SessionSummary(:,2,j),8); idl(idl==0)=8;
                id = find(idl==l & (SessionSummary(:,6,j)==o | SessionSummary(:,7,j)==o) & v);
                
                S_Animal(i,1) = string(animal_id);
                S_Session(i,1) = "STD";
                S_Day(i,1)  = j;
                S_Direction(i,1)  = d;
                S_Location(i,1)  = l;
                S_Location_Abs(i,1)  = l_abs;
                
                S_Object(i,1)  = string(Obj);
                
                S_nTrial(i,1) = length(id);
                S_AccMean(i,1) = nanmean(SessionSummary(id, 9, j),'all');
                S_RTMedian(i,1) = median(SessionSummary(id, 11, j),'all','omitnan');
                S_Void(i,1) = nanmean(SessionSummary(id, 10, j),'all');
                
            end
        end
    end
end



nameCSVFILE = strcat('BehaviorSummary_Loc_Obj_one_',date_last,'.csv');
csvHEADER = ['Animal_ID,Session,Day,Direction,Location,Location_Abs,Object,nTrial,Accuracy mean,Latency median,Void Proportion'];

if ~exist(nameCSVFILE)
    hCSV = fopen(nameCSVFILE, 'W');
    fprintf(hCSV, csvHEADER);
    fclose(hCSV); clear hCSV;
end	%~exist(nameCSVFILE)


hCSV = fopen(nameCSVFILE, 'A');
for i = 1:length(S_Animal)
    fprintf(hCSV, '\n%s,%s,%f,%f,%f,%f,%s,%f,%f,%f,%f', S_Animal(i),S_Session(i),S_Day(i),S_Direction(i),S_Location(i),S_Location_Abs(i),...
        S_Object(i),S_nTrial(i),S_AccMean(i),S_RTMedian(i),S_Void(i));
end
fclose(hCSV); clear hCSV;

clear z i l ol or ot olu d id cxt l_abs Obj
clear S_Animal S_Session S_Day S_Context S_Direction S_Location S_Location_Abs S_Object S_nTrial S_AccMean S_RTMedian S_Void


%% Direction+Object_one
z = size(SessionSummary,3);

for j = 1:z
    if ~isnan(SessionSummary(1,1,j))
        for d = 1:2
            for o = 0:5
                
                Obj = Name_Obj(o);
                
                v = VoidColumn(SessionSummary,j);
                i = (j-1)*12 + (d-1)*6 + (o) + 1;
                
                id = find(SessionSummary(:,4,j)==d-1 & (SessionSummary(:,6,j)==o | SessionSummary(:,7,j)==o)& v);
                
                S_Animal(i,1) = string(animal_id);
                S_Session(i,1) = "STD";
                S_Day(i,1)  = j;
                
                S_Direction(i,1)  = d;
                
                S_Object(i,1)  = string(Obj);
                
                S_nTrial(i,1) = length(id);
                S_AccMean(i,1) = nanmean(SessionSummary(id, 9, j),'all');
                S_RTMedian(i,1) = median(SessionSummary(id, 11, j),'all','omitnan');
                S_Void(i,1) = nanmean(SessionSummary(id, 10, j),'all');
                
            end
        end
    end
end


nameCSVFILE = strcat('BehaviorSummary_Dir_Obj_one_',date_last,'.csv');
csvHEADER = ['Animal_ID,Session,Day,Direction,Object,nTrial,Accuracy mean,Latency median,Void Proportion'];

if ~exist(nameCSVFILE)
    hCSV = fopen(nameCSVFILE, 'W');
    fprintf(hCSV, csvHEADER);
    fclose(hCSV); clear hCSV;
end	%~exist(nameCSVFILE)


hCSV = fopen(nameCSVFILE, 'A');
for i = 1:length(S_Animal)
    fprintf(hCSV, '\n%s,%s,%f,%f,%s,%f,%f,%f,%f', S_Animal(i),S_Session(i),S_Day(i),S_Direction(i),...
        S_Object(i),S_nTrial(i),S_AccMean(i),S_RTMedian(i),S_Void(i));
end
fclose(hCSV); clear hCSV;

clear z i l ol or ot olu d id cxt l_abs Obj
clear S_Animal S_Session S_Day S_Context S_Direction S_Location S_Location_Abs S_Object S_nTrial S_AccMean S_RTMedian S_Void
%% Context+Object_one
z = size(SessionSummary,3);

for j = 1:z
    if ~isnan(SessionSummary(1,1,j))
        for c = 1:2
            for o = 0:5
                
                if c==1
                    cxt = "Forest";
                else
                    cxt = "City";
                end
                
                Obj = Name_Obj(o);
                
                v = VoidColumn(SessionSummary,j);
                i = (j-1)*12 + (c-1)*6 + (o) + 1;
                id = find(SessionSummary(:,3,j)==c & (SessionSummary(:,6,j)==o | SessionSummary(:,7,j)==o) & v);
                
                S_Animal(i,1) = string(animal_id);
                S_Session(i,1) = "STD";
                S_Day(i,1)  = j;
                S_Context(i,1) = cxt;
                S_Object(i,1)  = string(Obj);
                
                S_nTrial(i,1) = length(id);
                S_AccMean(i,1) = nanmean(SessionSummary(id, 9, j),'all');
                S_RTMedian(i,1) = median(SessionSummary(id, 11, j),'all','omitnan');
                S_Void(i,1) = nanmean(SessionSummary(id, 10, j),'all');
            end
        end
    end
end



nameCSVFILE = strcat('BehaviorSummary_Cxt_Obj_one_',date_last,'.csv');
csvHEADER = ['Animal_ID,Session,Day,Context,Object,nTrial,Accuracy mean,Latency median,Void Proportion'];

if ~exist(nameCSVFILE)
    hCSV = fopen(nameCSVFILE, 'W');
    fprintf(hCSV, csvHEADER);
    fclose(hCSV); clear hCSV;
end	%~exist(nameCSVFILE)


hCSV = fopen(nameCSVFILE, 'A');
for i = 1:length(S_Animal)
    fprintf(hCSV, '\n%s,%s,%f,%s,%s,%f,%f,%f,%f', S_Animal(i),S_Session(i),S_Day(i),S_Context(i),...
        S_Object(i),S_nTrial(i),S_AccMean(i),S_RTMedian(i),S_Void(i));
end
fclose(hCSV); clear hCSV;

clear z i l ol or ot olu d id cxt l_abs Obj
clear S_Animal S_Session S_Day S_Context S_Direction S_Location S_Location_Abs S_Object S_nTrial S_AccMean S_RTMedian S_Void
%% Context+Location+Object_one
z = size(SessionSummary,3);

for j = 1:z
    if ~isnan(SessionSummary(1,1,j))
        for c = 1:2
            for l = 1:8
                for o = 0:5
                    
                    if c==1
                        cxt = "Forest";
                    else
                        cxt = "City";
                    end
                    
                    Obj = Name_Obj(o);
                    
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
                    
                    v = VoidColumn(SessionSummary,j);
                    i = (j-1)*96 + (c-1)*48 + (l-1)*6 + (o) + 1;
                    idl = mod(SessionSummary(:,2,j),8); idl(idl==0)=8;
                    id = find(SessionSummary(:,3,j)==c & idl==l &(SessionSummary(:,6,j)==o | SessionSummary(:,7,j)==o) & v);
                    
                    S_Animal(i,1) = string(animal_id);
                    S_Session(i,1) = "STD";
                    S_Day(i,1)  = j;
                    S_Context(i,1)  = string(cxt);
                    S_Direction(i,1)  = d;
                    S_Location(i,1)  = l;
                    S_Location_Abs(i,1)  = l_abs;
                    
                    S_Object(i,1)  = string(Obj);
                    
                    S_nTrial(i,1) = length(id);
                    S_AccMean(i,1) = nanmean(SessionSummary(id, 9, j),'all');
                    S_RTMedian(i,1) = median(SessionSummary(id, 11, j),'all','omitnan');
                    S_Void(i,1) = nanmean(SessionSummary(id, 10, j),'all');
                    
                end
            end
        end
    end
end



nameCSVFILE = strcat('BehaviorSummary_Cxt_Loc_Obj_one_',date_last,'.csv');
csvHEADER = ['Animal_ID,Session,Day,Context,Direction,Location,Location_Abs,Object,nTrial,Accuracy mean,Latency median,Void Proportion'];

if ~exist(nameCSVFILE)
    hCSV = fopen(nameCSVFILE, 'W');
    fprintf(hCSV, csvHEADER);
    fclose(hCSV); clear hCSV;
end	%~exist(nameCSVFILE)


hCSV = fopen(nameCSVFILE, 'A');
for i = 1:length(S_Animal)
    fprintf(hCSV, '\n%s,%s,%f,%s,%f,%f,%f,%s,%f,%f,%f,%f', S_Animal(i),S_Session(i),S_Day(i),S_Context(i),S_Direction(i),S_Location(i),S_Location_Abs(i),...
        S_Object(i),S_nTrial(i),S_AccMean(i),S_RTMedian(i),S_Void(i));
end
fclose(hCSV); clear hCSV;

clear z i l ol or ot olu d id cxt l_abs Obj
clear S_Animal S_Session S_Day S_Context S_Direction S_Location S_Location_Abs S_Object S_nTrial S_AccMean S_RTMedian S_Void
%% Context + Location_abs + Object_one
z = size(SessionSummary,3);

for j = 1:z
    if ~isnan(SessionSummary(1,1,j))
        for c = 1:2
            for l = 1:4
                for o = 0:5
                    if c==1
                        cxt = "Forest";
                    else
                        cxt = "City";
                    end
                    
                    Obj = Name_Obj(o);
                    
                    v = VoidColumn(SessionSummary,j);
                    i = (j-1)*48 + (c-1)*24 + (l-1)*6 + (o) + 1;
                    id = find(SessionSummary(:,3,j)==c &SessionSummary(:,5,j)==l &(SessionSummary(:,6,j)==o | SessionSummary(:,7,j)==o) & v);
                    
                    S_Animal(i,1) = string(animal_id);
                    S_Session(i,1) = "STD";
                    S_Day(i,1)  = j;
                    S_Context(i,1) = cxt;
                    S_Location_Abs(i,1)  = l;
                    
                    S_Object(i,1)  = string(Obj);
                    
                    S_nTrial(i,1) = length(id);
                    S_AccMean(i,1) = nanmean(SessionSummary(id, 9, j),'all');
                    S_RTMedian(i,1) = median(SessionSummary(id, 11, j),'all','omitnan');
                    S_Void(i,1) = nanmean(SessionSummary(id, 10, j),'all');
                end
            end
        end
    end
end




nameCSVFILE = strcat('BehaviorSummary_Cxt_Loc_abs_Obj_one_',date_last,'.csv');
csvHEADER = ['Animal_ID,Session,Day,Context,Location_Abs,Object,nTrial,Accuracy mean,Latency median,Void Proportion'];

if ~exist(nameCSVFILE)
    hCSV = fopen(nameCSVFILE, 'W');
    fprintf(hCSV, csvHEADER);
    fclose(hCSV); clear hCSV;
end	%~exist(nameCSVFILE)


hCSV = fopen(nameCSVFILE, 'A');
for i = 1:length(S_Animal)
    fprintf(hCSV, '\n%s,%s,%f,%s,%f,%s,%f,%f,%f,%f', S_Animal(i),S_Session(i),S_Day(i),S_Context(i),S_Location_Abs(i),...
        S_Object(i),S_nTrial(i),S_AccMean(i),S_RTMedian(i),S_Void(i));
end
fclose(hCSV); clear hCSV;

clear z i l ol or ot olu d id cxt l_abs Obj
clear S_Animal S_Session S_Day S_Context S_Direction S_Location S_Location_Abs S_Object S_nTrial S_AccMean S_RTMedian S_Void
%% Context+Direction+Object_one
z = size(SessionSummary,3);

for j = 1:z
    if ~isnan(SessionSummary(1,1,j))
        for c = 1:2
            for d = 1:2
                for o = 0:5
                    
                    if c==1
                        cxt = "Forest";
                    else
                        cxt = "City";
                    end
                    
                    
                    Obj = Name_Obj(o);
                    
                    v = VoidColumn(SessionSummary,j);
                    i = (j-1)*24 + (c-1)*12 + (d-1)*6 + (o) + 1;
                    id = find(SessionSummary(:,3,j)==c & SessionSummary(:,4,j)==d-1 & (SessionSummary(:,6,j)==o | SessionSummary(:,7,j)==o) & v);
                    
                    S_Animal(i,1) = string(animal_id);
                    S_Session(i,1) = "STD";
                    S_Day(i,1)  = j;
                    S_Context(i,1)  = string(cxt);
                    S_Direction(i,1)  = d;
                    
                    S_Object(i,1)  = string(Obj);
                    
                    S_nTrial(i,1) = length(id);
                    S_AccMean(i,1) = nanmean(SessionSummary(id, 9, j),'all');
                    S_RTMedian(i,1) = median(SessionSummary(id, 11, j),'all','omitnan');
                    S_Void(i,1) = nanmean(SessionSummary(id, 10, j),'all');
                    
                end
            end
        end
    end
end



nameCSVFILE = strcat('BehaviorSummary_Cxt_Dir_Obj_one_',date_last,'.csv');
csvHEADER = ['Animal_ID,Session,Day,Context,Direction,Object,nTrial,Accuracy mean,Latency median,Void Proportion'];

if ~exist(nameCSVFILE)
    hCSV = fopen(nameCSVFILE, 'W');
    fprintf(hCSV, csvHEADER);
    fclose(hCSV); clear hCSV;
end	%~exist(nameCSVFILE)


hCSV = fopen(nameCSVFILE, 'A');
for i = 1:length(S_Animal)
    fprintf(hCSV, '\n%s,%s,%f,%s,%f,%s,%f,%f,%f,%f', S_Animal(i),S_Session(i),S_Day(i),S_Context(i),S_Direction(i),...
        S_Object(i),S_nTrial(i),S_AccMean(i),S_RTMedian(i),S_Void(i));
end
fclose(hCSV); clear hCSV;

clear z i l ol or ot olu d id cxt l_abs Obj
clear S_Animal S_Session S_Day S_Context S_Direction S_Location S_Location_Abs S_Object S_nTrial S_AccMean S_RTMedian S_Void


% clear z i l ol or ot olu d id cxt l_abs ObjLeft ObjRight ObjTarget ObjLure ObjPair TargetSide
% clear S_Animal S_Session S_Day S_Context S_Direction S_Location S_Location_Abs S_Object_Left S_Object_Right S_Object_Target S_Object_Lure S_nTrial S_AccMean S_RTMedian S_Void S_Side

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

function v = VoidColumn(SessionSummary,j)
v = SessionSummary(:,14,j)==1;
% v = SessionSummary(:,12,j).*SessionSummary(:,13,j).*SessionSummary(:,14,j);
end