addpath([program_folder '\fieldtrip-20200302']);
ft_defaults
%%
T = Eye_Analog_unreal_recording(:,1)-Eye_Analog_unreal_recording(1,1); % Eye gaze timestamp; recording start = 0
X = round(Eye_Analog_unreal_recording(:,2),4); % Eye gaze x coordinate
Y = round(Eye_Analog_unreal_recording(:,3),4); % Eye gaze y coordinate
P = Eye_Analog_unreal_recording(:,4); % Pupil size
remark = ones(length(X),1); % Eye data classification

%%
is = 100001;
ie = 150000;

%% Angular xy calculate
distx = 130/14;
disty = 130/8;

X_d = atand(X/distx);
Y_d = atand(X/disty);

%% one-sample noise spike detection
% X_f1 = one_sample_noise_spike_detection(X_d);
% Y_f1 = one_sample_noise_spike_detection(Y_d);

%% two-sample noise detection
% X_f2 = two_sample_noise_detection(X_f1);
% Y_f2 = two_sample_noise_detection(Y_f1);


%% N-sample noise detection
tic
X_f50 = N_sample_noise_detection(X_d,50);
Y_f50 = N_sample_noise_detection(Y_d,50);
toc
%% calculate speed ans acc
EyeFilter = [-1 -1 -1 -1 -1 -1 -1 -1 0 1 1 1 1 1 1 1 1]*(1/40);

clear EyeSpeedTableX EyeSpeedTableY EyeAccTableX EyeAccTableY
EyeSpeedTableX = conv(X_f50,EyeFilter,'same');
EyeSpeedTableY = conv(Y_f50,EyeFilter,'same');

EyeSpeedTableX_inst = diff(X_f50)/1000;
EyeSpeedTableY_inst = diff(Y_f50)/1000;
% % 
% Eye_AccTable(:,1) = diff(Eye_SpeedTable(:,1))/(10^(-3));
% Eye_AccTable(:,2) = diff(Eye_SpeedTable(:,2))/(10^(-3));

EyeAccTableX = conv(EyeSpeedTableX,EyeFilter,'same');
EyeAccTableY = conv(EyeSpeedTableY,EyeFilter,'same');

EyeAccT = 10^(4);
[EyeAccNxT, ChangeTx] = CalAccThreshold(EyeAccTableX, EyeAccT);
[EyeAccNyT, ChangeTy] = CalAccThreshold(EyeAccTableY, EyeAccT);

%%
EyeSpeedTableX_inst(:,2) = zeros(length(EyeSpeedTableX_inst(:,1)),1);
for i = 1:length(EyeSpeedTableX_inst)-2
    if abs(EyeSpeedTableX_inst(i,1)) > 60
        EyeSpeedTableX_inst(i,2) = 1;
    elseif abs(EyeSpeedTableX_inst(i,1)) > 30 && abs(EyeSpeedTableX_inst(i+1,1)) > 20 && abs(EyeSpeedTableX_inst(i+2,1)) > 20
        EyeSpeedTableX_inst(i,2) = 1;
    end
end


EyeSpeedTableX_inst(:,3) = EyeSpeedTableX_inst(:,2) .* ischange(EyeSpeedTableX_inst(:,2));
EyeSpeedTableX_inst(:,4) = circshift(~EyeSpeedTableX_inst(:,2) .* ischange(EyeSpeedTableX_inst(:,2)),-1); EyeSpeedTableX_inst(end,4)=0;

EyeSpeedTableX_on = find(EyeSpeedTableX_inst(:,3));
EyeSpeedTableX_off = find(EyeSpeedTableX_inst(:,4));


% figure;
% plot(T(is:ie),EyeSpeedTableX_inst(is:ie,1))
% hold on
% plot(T(is:ie),EyeSpeedTableX_inst(is:ie,3)*5000)
% plot(T(is:ie),EyeSpeedTableX_inst(is:ie,4)*5000)

% make saccade index table
EyeAccTableX_index = double(abs(EyeAccTableX(:,1))>=EyeAccNxT);
EyeAccTableY_index = double(abs(EyeAccTableY(:,1))>=EyeAccNyT);




%%


if EyeAccTableX_index(1) ~=EyeAccTableX_index(2)
    str = [1;2];
else
    str = 1;
end
id = [str;find(ischange(EyeAccTableX_index(:,1),'linear'))];
EyeAccTableX_index(:,2) = EyeAccTableX_index(:,1);
EyeAccTableX_index(:,3) = EyeAccTableX_index(:,2);

for i = 2:length(id)-1
        if EyeAccTableX_index(id(i))==0 && id(i+1)-id(i)<40
            EyeAccTableX_index(id(i):id(i+1)-1,2) = 1;
        end
end

if EyeAccTableX_index(1,2) ~=EyeAccTableX_index(2,2)
    str = [1;2];
else
    str = 1;
end
id = [str;find(ischange(EyeAccTableX_index(:,2),'linear'))];
EyeAccTableX_index(:,3) = zeros(length(EyeAccTableX_index(:,2)),1);
for i = 1:length(id)
    if i == length(id)
        if   EyeAccTableX_index(id(i),2)==1 && length(EyeAccTableX_index(:,2)) - id(i)>=10
            EyeAccTableX_index(id(i):end,3) = 1;
        end
    else
        if EyeAccTableX_index(id(i),2)==1 && id(i+1)-id(i)>=10
            EyeAccTableX_index(id(i):id(i+1)-1,3) = 1;
        end

    end
end


if EyeAccTableY_index(1) ~=EyeAccTableY_index(2)
    str = [1;2];
else
    str = 1;
end
id = [str;find(ischange(EyeAccTableY_index(:,1),'linear'))];
EyeAccTableY_index(:,2) = EyeAccTableY_index(:,1);
EyeAccTableY_index(:,3) = EyeAccTableY_index(:,2);

for i = 2:length(id)-1
        if EyeAccTableY_index(id(i))==0 && id(i+1)-id(i)<40
            EyeAccTableY_index(id(i):id(i+1)-1,2) = 1;
        end
end

if EyeAccTableY_index(1,2) ~=EyeAccTableY_index(2,2)
    str = [1;2];
else
    str = 1;
end
id = [str;find(ischange(EyeAccTableY_index(:,2),'linear'))];
EyeAccTableY_index(:,3) = zeros(length(EyeAccTableY_index(:,2)),1);
for i = 1:length(id)
    if i == length(id)
        if   EyeAccTableY_index(id(i),2)==1 && length(EyeAccTableY_index(:,2)) - id(i)>=10
            EyeAccTableY_index(id(i):end,3) = 1;
        end
    else
        if EyeAccTableY_index(id(i),2)==1 && id(i+1)-id(i)>=10
            EyeAccTableY_index(id(i):id(i+1)-1,3) = 1;
        end

    end
end

% EyeAccTableY(:,2) = abs(EyeAccTableY(:,1))>EyeAccNyT;
%% Saccade detection


EyeAccTable_index = double((EyeAccTableX_index(:,3) + EyeAccTableY_index(:,3))>0);

Eye_Speed_inst_X = diff(tand(X_f50));
Eye_Speed_inst_Y = diff(tand(Y_f50));

Eye_Speed_inst = sqrt((Eye_Speed_inst_X).^2+(Eye_Speed_inst_Y).^2);
Eye_Direction = [Eye_Speed_inst_X Eye_Speed_inst_Y]./Eye_Speed_inst;
Eye_Speed_inst_degree = atand(Eye_Speed_inst);

[pks,locs,w,p] = findpeaks(Eye_Speed_inst_degree);
%%

figure;
% plot(T(is:ie),EyeAccTableX(is:ie))
hold on
plot(T(is:ie),EyeSpeedTableX(is:ie))
plot(T(is:ie),EyeAccTableX(is:ie,1))
legend('Speed','ACC')
% plot(T(is:ie),EyeAccTableX_index(is:ie,2)*5)
% plot(T(is:ie),EyeAccTableX_index(is:ie,3)*2)
%  plot(T(is:ie),X_f50(is:ie))
%  plot(T(is:ie),X(is:ie),'--')
% line([is/1000 ie/1000],[-EyeAccNxT -EyeAccNxT],'Color','r'); line([is/1000 ie/1000],[EyeAccNxT EyeAccNxT],'Color','r')

% idm = min(find(T(id)>30));
% 
% x1 = T(id(1:2:idm))'; x2 = T(id(2:2:idm+1))';
% x3 = [x1;x2;x2;x1];
% y1 = ones(1,length(T(id(1:2:idm))));
% y2 = [-10*y1;-10*y1;10*y1;10*y1];
% 
% patch(x3,y2,'r','EdgeColor','none')
% alpha(0.3)

%%
cd('F:\NHP project\Data\Yoda\processed_data\20200204')
savefilename=[animal_id '_' num2str(session_date) '_EyeData.mat']; 
save(savefilename)
%%
figure;
plot(T(is:ie),X_f50(is:ie))

hold on
plot(T(is:ie),X_lp(is:ie),'r')
plot(T(is:ie),X_d(is:ie),'k--')
xlabel('Time(s)')
ylabel('X(degree)')
legend('M-T f50','lowpass','Raw')


