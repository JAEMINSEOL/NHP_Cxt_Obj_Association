function [Eye_sacc_XY_index_lp] = D_Saccade_detection(Eye_Acc_deg_inst_lp,Eye_Speed_deg_inst_lp,X_lp_deg, Y_lp_deg)

crit_deg_one = 60; crit_deg_three=20; 

crit_perc = 0.2; crit_min=30;

%%
Eye_Speed_deg_inst_X_lp = Eye_Speed_deg_inst_lp(:,1);
Eye_Speed_deg_inst_Y_lp = Eye_Speed_deg_inst_lp(:,2);

Eye_Acc_deg_inst_X_lp = Eye_Acc_deg_inst_lp(:,1);
Eye_Acc_deg_inst_Y_lp = Eye_Acc_deg_inst_lp(:,2);
%% Set saccade threshold


EyeAccT = 10^(4);
[EyeAccNxT, ChangeTx] = CalAccThreshold(Eye_Acc_deg_inst_X_lp, EyeAccT);
[EyeAccNyT, ChangeTy] = CalAccThreshold(Eye_Acc_deg_inst_Y_lp, EyeAccT);
 EyeAccNxT = 1000^(1); EyeAccNyT = 1000^(1);
%% make saccade pre-index table
Eye_sacc_X_index_lp = saccade_indexing(Eye_Acc_deg_inst_X_lp, EyeAccNxT);
Eye_sacc_Y_index_lp = saccade_indexing(Eye_Acc_deg_inst_Y_lp, EyeAccNyT);

Eye_sacc_XY_index_lp = or(Eye_sacc_X_index_lp(:,3),Eye_sacc_Y_index_lp(:,3));


%% Calculate 2D eye speed and acc

Eye_Speed_inst_X_lp = [0; diff(tand(X_lp_deg))*1000];
Eye_Speed_inst_Y_lp = [0; diff(tand(Y_lp_deg))*1000];
Eye_S2SDir = atand(Eye_Speed_inst_Y_lp./Eye_Speed_inst_X_lp);



Eye_Speed_inst_XY_lp = sqrt((Eye_Speed_inst_X_lp).^2+(Eye_Speed_inst_Y_lp).^2);
Eye_Direction_XY_lp = [Eye_Speed_inst_X_lp Eye_Speed_inst_Y_lp]./Eye_Speed_inst_XY_lp;
Eye_Speed_inst_deg_XY_lp = atand(Eye_Speed_inst_XY_lp);

%% Find Peak Velocity and Main Direction of each Saccades
clear Eye_PeakVelocity Eye_MainDir
f = find(Eye_sacc_XY_index_lp);
id= ischange(f,'linear');
id(1)=0; id(end)=1;
Eye_SaccOff = f(find(id)-1);
id(1)=1; id(end)=0;
Eye_SaccOn = f(find(id));

for i = 1:length(Eye_SaccOn)
   [M,I] = max(Eye_Speed_inst_XY_lp(Eye_SaccOn(i):Eye_SaccOff(i)));
   Eye_PeakVelocity(i,1) = Eye_SaccOn(i)+I-1;
   Eye_PeakVelocity(i,2) = M;
end
for i = 1: length(Eye_PeakVelocity)
Eye_MainDir(i,1) = (Eye_S2SDir(Eye_PeakVelocity(i,1)-1) + Eye_S2SDir(Eye_PeakVelocity(i,1)) + Eye_S2SDir(Eye_PeakVelocity(i,1)+1))*1/3;
end

%% Saccade detection


% Deviation from the main direciton
for i=1:length(Eye_MainDir)
    for k = Eye_PeakVelocity(i,1):Eye_SaccOff(i,1)
        if abs(Eye_S2SDir(k)-Eye_MainDir(i,1))>crit_deg_one
            Eye_SaccOff(i,2) = k;
            break
        elseif abs(Eye_S2SDir(k)-Eye_MainDir(i,1))>crit_deg_three && abs(Eye_S2SDir(k-1)-Eye_MainDir(i,1))>crit_deg_three && abs(Eye_S2SDir(k-2)-Eye_MainDir(i,1))>crit_deg_three
            Eye_SaccOff(i,2) = k;
            break
        elseif k==Eye_SaccOff(i)
            Eye_SaccOff(i,2) = k+1;
        end
    end
    for k = Eye_SaccOn(i,1):Eye_PeakVelocity(i,1)
        k2 = Eye_PeakVelocity(i,1)+Eye_SaccOn(i,1)-k;
        if abs(Eye_S2SDir(k2)-Eye_MainDir(i,1))>crit_deg_one
            Eye_SaccOn(i,2) = k2;
            break
        elseif abs(Eye_S2SDir(k2)-Eye_MainDir(i,1))>crit_deg_three && abs(Eye_S2SDir(k2+1)-Eye_MainDir(i,1))>crit_deg_three && abs(Eye_S2SDir(k2+2)-Eye_MainDir(i,1))>crit_deg_three
            Eye_SaccOn(i,2) = k2;
            break
        elseif k2==Eye_SaccOn(i)
            Eye_SaccOn(i,2) = k2-1;
        end
    end
end

% Insonsistent sample-to-sample direction
Eye_ChS2SDir = [0;diff(Eye_S2SDir)];
for i=1:length(Eye_MainDir)
    for k = Eye_PeakVelocity(i,1):Eye_SaccOff(i,1)
        k2 = Eye_PeakVelocity(i,1)+Eye_SaccOff(i,1)-k;
        if abs(Eye_ChS2SDir(k2))>crit_deg_one
            Eye_SaccOff(i,3) = k2;
            break
        elseif abs(Eye_ChS2SDir(k2))>crit_deg_three && abs(Eye_ChS2SDir(k2+1))>crit_deg_three && abs(Eye_ChS2SDir(k2+2))>crit_deg_three
            Eye_SaccOff(i,3) = k2;
            break
        elseif k2==Eye_PeakVelocity(i,1)
            Eye_SaccOff(i,3) = Eye_SaccOff(i,2);
        end
    end
    for k = Eye_SaccOn(i,1):Eye_PeakVelocity(i,1)
        if abs(Eye_ChS2SDir(k))>crit_deg_one
            Eye_SaccOn(i,3) = k;
            break
        elseif abs(Eye_ChS2SDir(k))>crit_deg_three && abs(Eye_ChS2SDir(k-1))>crit_deg_three && abs(Eye_ChS2SDir(k-2))>crit_deg_three
            Eye_SaccOn(i,3) = k;
            break
        elseif k==Eye_PeakVelocity(i,1)
            Eye_SaccOn(i,3) = Eye_SaccOn(i,2);
        end
    end
end

% Velocity at an onset/offset
for i=1:length(Eye_MainDir)
    for k = Eye_PeakVelocity(i,1):Eye_SaccOff(i,1)
        k2 = Eye_PeakVelocity(i,1)+Eye_SaccOff(i,1)-k;
        if abs(Eye_Speed_inst_deg_XY_lp(k2))<crit_min || abs(Eye_Speed_inst_deg_XY_lp(k2))<(Eye_PeakVelocity(i,2)*crit_perc)
            Eye_SaccOff(i,4) = max(k2,Eye_SaccOff(i,3));
            break
        elseif k2==Eye_PeakVelocity(i,1)
            Eye_SaccOff(i,4) = max(Eye_SaccOff(i,2),Eye_SaccOff(i,3));
        end
    end
    for k = Eye_SaccOn(i,1):Eye_PeakVelocity(i,1) 
        if abs(Eye_Speed_inst_deg_XY_lp(k))<crit_min || abs(Eye_Speed_inst_deg_XY_lp(k))<(Eye_PeakVelocity(i,2)*crit_perc)
            Eye_SaccOn(i,4) = min(k,Eye_SaccOn(i,3));
            break
        elseif k==Eye_PeakVelocity(i,1)
            Eye_SaccOn(i,3) = min(Eye_SaccOn(i,2),Eye_SaccOn(i,3));
        end
    end
end

%%
Eye_sacc_XY_index_lp(:,2) = zeros(length(Eye_sacc_XY_index_lp(:,1)),1);
for i = 1:size(Eye_SaccOn,1)
    if Eye_SaccOn(i,4)~=0
    Eye_sacc_XY_index_lp(Eye_SaccOn(i,4):Eye_SaccOff(i,4),2)=1;
    end
end


Eye_Sacc_X = X_lp_deg .* Eye_sacc_XY_index_lp(:,2); 
Eye_Sacc_Y = Y_lp_deg .* Eye_sacc_XY_index_lp(:,2);

B = and(Eye_Sacc_Y==0,Eye_Sacc_X==0);
Eye_Sacc_X(B)=90; Eye_Sacc_Y(B)=90;

%%

% [pks,locs,w,p] = findpeaks(Eye_Speed_inst_deg_XY);
% 
% find(Eye_sacc_XY_index_lp)
%% plotting indexing



%%
% figure;
% plot(T(is:ie),Eye_Acc_deg_inst_X_lp(is:ie),'b')
% 
% hold on
% % plot(X_lp(is:ie),Y_lp(is:ie),'k')
% % plot(X_lp_deg(is:ie),Y_lp_deg(is:ie),'k')
% % scatter(Eye_Sacc_X(is:ie),Eye_Sacc_Y(is:ie),7,'r','filled')
% % xlim([-28 28]); ylim([-15 15]);
% % xlabel('X(degree)'); ylabel('Y(degree)');
% % plot(T(is:ie),tand(Y_lp_deg(is:ie))*distM/disty,'b')
% 
% % plot(T(is:ie),Eye_sacc_X_index_lp(is:ie,1)/10^7,'r')
% line([is/1000 ie/1000],[-EyeAccNxT -EyeAccNxT],'Color','k'); line([is/1000 ie/1000],[EyeAccNxT EyeAccNxT],'Color','k')
% % legend('Acceleration','Threshold','Threshold')
% xlabel('Time(s)'); ylabel('X(degree/s^2)');
% % axis ij


%%
%  Eye_sacc_XY_index_lp = double(Eye_sacc_XY_index_lp);
%  Eye_sacc_XY_index_lp(:,3) = Eye_Analog_sync_recording(:,1);

%% local functions
function index = saccade_indexing(AccData, AccTh)

    crit_duration = 40; crit_isi=10;
index = double(abs(AccData(:,1))>=AccTh);

j=2; id1(1)=1;
for i1 = 2:length(index)
    
    if index(i1,1) ~= index(i1-1,1)
        id1(j)=i1;
        j=j+1;
    end
end
index(:,2) = index(:,1);
index(:,3) = index(:,2);

for i1 = 2:length(id1)-1
        if index(id1(i1),1)==0 && id1(i1+1)-id1(i1)<crit_duration
            index(id1(i1):id1(i1+1),2) = 1;
        end
end


clear id1
j=2; id1(1)=1;
for i1 = 2:length(index)
    
    if index(i1,2) ~= index(i1-1,2)
        id1(j)=i1;
        j=j+1;
    end
end
index(:,3) = zeros(length(index(:,2)),1);
for i1 = 1:length(id1)
    if i1 == length(id1)
        if   index(id1(i1),2)==1 && length(index(:,2)) - id1(i1)>=crit_isi
            index(id1(i1):end,3) = 1;
        end
    else
        if index(id1(i1),2)==1 && id1(i1+1)-id1(i1)>=crit_isi
            index(id1(i1):id1(i1+1)-1,3) = 1;
        end

    end
end
end
end