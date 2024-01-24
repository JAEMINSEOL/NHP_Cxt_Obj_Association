function [X_lp,Y_lp,X_lp_deg, Y_lp_deg,Eye_Speed_deg_inst_lp,Eye_Acc_deg_inst_lp] = C_Angular_NoiseFiltering_SpeedCalc(EyeData)

%%
T = EyeData(:,1)-EyeData(1,1); % Eye gaze timestamp; recording start = 0
X = round(EyeData(:,2),4); % Eye gaze x coordinate
Y = round(EyeData(:,3),4); % Eye gaze y coordinate
P = EyeData(:,4); % Pupil size
remark = ones(length(X),1); % Eye data classification
%% Angular xy calculate
distx = 700/5;
disty = 400/5;
distM= 1300;

X(X>5) = 5; X(X<-5)=-5; Y(Y>5) = 5; Y(Y<-5)=-5;

X_deg = atand(X*distx/distM);  % max 28.3008 deg
Y_deg = atand(Y*disty/distM);  % max 17.1027 deg


%% Lowpass filtering
% tic
X_lp = lowpassfilter(X,1000,25,2,'but','twopass');
Y_lp = lowpassfilter(Y,1000,25,2,'but','twopass');
% toc

% X_lp = X;
% Y_lp = Y;

X_lp_deg = atand(X_lp*distx/distM);
Y_lp_deg = atand(Y_lp*disty/distM);
%% Speed and Acc calculation

Eye_Speed_deg_inst_X_lp = [0; diff(X_lp_deg)*1000];
Eye_Speed_deg_inst_Y_lp = [0; diff(Y_lp_deg)*1000];
Eye_Speed_deg_inst_lp = [Eye_Speed_deg_inst_X_lp,Eye_Speed_deg_inst_Y_lp];

Eye_Acc_deg_inst_X_lp = [0; diff(Eye_Speed_deg_inst_X_lp)*1000];
Eye_Acc_deg_inst_Y_lp = [0; diff(Eye_Speed_deg_inst_Y_lp)*1000];
Eye_Acc_deg_inst_lp = [Eye_Acc_deg_inst_X_lp,Eye_Acc_deg_inst_Y_lp];
