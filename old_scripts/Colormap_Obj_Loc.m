%% Load last updated Session Summary.mat
clear all
close all
mother_drive = 'F:\NHP project\Data\';
animal_id=input('Nabi or Yoda?','s');
cd([mother_drive animal_id '\processed_data'])

if ~exist('SessionSummary.mat')
    SessionSummary = [];
else
    load('SessionSummary.mat');
end	% ~exist('SessionSummary.mat')

date_Analysis=input('Analysis date(YYYYMMDD)? ::','s');
cd([mother_drive animal_id '\processed_data\behavior'])
mkdir(date_Analysis)
cd([mother_drive animal_id '\processed_data\behavior\' date_Analysis])



program_folder= [mother_drive '\program'];
addpath(genpath(program_folder))

%% All conditions+Target side
z = size(SessionSummary,3);

for j = 1:z
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
                        
                        if ot==ol
                            TargetSide = 'Left';
                        else
                            TargetSide = 'Right';
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
                        v = VoidColumn(SessionSummary,j); v(isnan(v)) = 0;
                        i = (j-1)*288 + (c-1)*144 + (l-1)*18 + (ol)*3 + fix(or/2) + 1;
                        idl = mod(SessionSummary(:,2,j),8); idl(idl==0)=8;
                        id = find(SessionSummary(:,3,j)==c & idl==l & SessionSummary(:,6,j)==ol & SessionSummary(:,7,j)==or & v);
                        
                        S_Animal(i,1) = string(animal_id);
                        S_Session(i,1) = "STD";
                        S_Day(i,1)  = j;
                        S_Context(i,1)  = c;
                        S_Direction(i,1)  = d;
                        S_Location(i,1)  = l;
                        S_Location_Abs(i,1)  = l_abs;
                        S_Object_Left(i,1)  = ol;
                        S_Object_Right(i,1)  = or;
                        S_Object_Target(i,1)  = ot;
                        S_Object_Lure(i,1)  = olu;
                        S_Side(i,1) = string(TargetSide);
                        
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


% nameCSVFILE = strcat('BehaviorSummary_All_T_',date_last,'.csv');
% csvHEADER = ['Animal_ID,Session,Day,Context,Direction,Location,Location_Abs,Left Object,Right Object,Target Object,Lure Object,Target Side,nTrial,Accuracy mean,Latency median,Void Proportion'];
% 
% if ~exist(nameCSVFILE)
%     hCSV = fopen(nameCSVFILE, 'W');
%     fprintf(hCSV, csvHEADER);
%     fclose(hCSV); clear hCSV;
% end	%~exist(nameCSVFILE)
% 
% 
% hCSV = fopen(nameCSVFILE, 'A');
% for i = 1:length(S_Animal)
%     fprintf(hCSV, '\n%s,%s,%f,%s,%f,%f,%f,%s,%s,%s,%s,%s,%f,%f,%f,%f', S_Animal(i),S_Session(i),S_Day(i),S_Context(i),S_Direction(i),S_Location(i),S_Location_Abs(i),...
%         S_Object_Left(i),S_Object_Right(i),S_Object_Target(i),S_Object_Lure(i),S_Side(i),S_nTrial(i),S_AccMean(i),S_RTMedian(i),S_Void(i));
% end
% fclose(hCSV); clear hCSV;
% 



Sample = horzcat(S_Day,S_Context,S_Direction,S_Location,S_Location_Abs, S_Object_Left,S_Object_Right,S_Object_Target,S_Object_Lure,S_nTrial,S_AccMean,S_RTMedian);
%%
x = size(Sample,1);

Acc_Obj_Mean = nan(3,3,8);
Acc_Obj_Sem = nan(3,3,8);

for l = 1:8
for ot = 1:2:5
    for ol = 0:2:4
        id = find(Sample(:,4)==l & Sample(:,8)==ot & Sample(:,9) ==ol);
        Acc_Obj_Mean(fix(ot/2)+1,fix(ol/2)+1,l) = nanmean(Sample(id,11));
        Acc_Obj_Sem(fix(ot/2)+1,fix(ol/2)+1,l) = nanstd(Sample(id,11))/sqrt(x);
    end
end
end
        
Acc_Obj_Mean_F = nan(3,3,8);
Acc_Obj_Sem_F = nan(3,3,8);

for l = 1:8
for ot = 1:2:5
    for ol = 0:2:4
        id = find(Sample(:,2)==1 &Sample(:,4)==l & Sample(:,8)==ot & Sample(:,9) ==ol);
        Acc_Obj_Mean_F(fix(ol/2)+1,fix(ot/2)+1,l) = nanmean(Sample(id,11));
        Acc_Obj_Sem_F(fix(ol/2)+1,fix(ot/2)+1,l) = nanstd(Sample(id,11))/sqrt(x);
    end
end
end

Acc_Obj_Mean_C = nan(3,3,8);
Acc_Obj_Sem_C = nan(3,3,8);

for l = 1:8
for ot = 0:2:4
    for ol = 1:2:5
        id = find(Sample(:,2)==2 &Sample(:,4)==l & Sample(:,8)==ot & Sample(:,9) ==ol);
        Acc_Obj_Mean_C(fix(ot/2)+1,fix(ol/2)+1,l) = nanmean(Sample(id,11));
        Acc_Obj_Sem_C(fix(ot/2)+1,fix(ol/2)+1,l) = nanstd(Sample(id,11))/sqrt(x);
    end
end
end
%%

baseX = 0.35; baseY = 0.82; AxisXTick = 0.155; AxisYTick = 0.23; sizeX = 0.12; sizeY = 0.15;
f_title = 10; f_axis = 10;

Range_max = 1.1;
Range_min = 0.9;
% sheetTitle = subplot('Position', Coordinate_Title);
% set(sheetTitle, 'visible', 'off');
% text(0,0.5,[session_date ' - Mean Firing Rate, from Object On to Choice'],'Fontsize',TitleFontsize);


figure;
for i = 1:2
    for j = 1:4
        id = (i-1)*4+j;
subplot(2,4,id)
SetColorMap2(1,Acc_Obj_Mean(:,:,id),Acc_Obj_Sem(:,:,id),Range_max, 10)
title('Choice Accuracy, All Contexts','FontSize',20)
xlabel('Obj 1','FontSize',16)
ylabel('Obj 2','FontSize',16)

caxis([0.87 1])
colormap('jet')
    end
end

cd([mother_drive animal_id '\processed_data\behavior\' date_Analysis])
saveas(gcf,[animal_id '_All'])
%%
FontSize = 10;
figure;

for i = 1:2
    for j = 1:4
        id = (i-1)*4+j;
subplot(2,4,id)
SetColorMap2(1,Acc_Obj_Mean_F(:,:,id),Acc_Obj_Sem_F(:,:,id),Range_max,FontSize)
title(['Choice Accuracy, Forest, Loc ', num2str(id)],'FontSize',20)
xlabel('Obj 1','FontSize',16)
ylabel('Obj 2','FontSize',16)

caxis([0.87 1])
colormap('jet')
    end
end
cd([mother_drive animal_id '\processed_data\behavior\' date_Analysis])
saveas(gcf,[animal_id '_Forest'])


%%
FontSize = 10;
figure;

for i = 1:2
    for j = 1:4
        id = (i-1)*4+j;
subplot(2,4,id)
SetColorMap2(2,Acc_Obj_Mean_C(:,:,id),Acc_Obj_Sem_C(:,:,id),Range_max,FontSize)
title(['Choice Accuracy, City, Loc ', num2str(id)],'FontSize',20)
xlabel('Obj 1','FontSize',16)
ylabel('Obj 2','FontSize',16)

caxis([0.87 1])
colormap('jet')
    end
end
cd([mother_drive animal_id '\processed_data\behavior\' date_Analysis])
saveas(gcf,[animal_id '_City'])
%%
function v = VoidColumn(SessionSummary,j)
v = SessionSummary(:,14,j);
% v = SessionSummary(:,12,j).*SessionSummary(:,13,j).*SessionSummary(:,14,j);
end