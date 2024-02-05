% record_across_session_performance

session_column=1;
session_today=2;
session_accuracy=3;
session_latency=4;
session_bias=5;
session_void=6;

session_forestACC=7;
session_cityACC=8;

session_pumpkin_donutACC=9;
session_jellyfish_turtleACC=10;

session_pumpkin_turtleACC=11;
session_jellyfish_donutACC=12;



session_pumpkin_donutLAT=13;
session_jellyfish_turtleLAT=14;

session_pumpkin_turtleLAT=15;
session_jellyfish_donutLAT=16;


%% move to parsed result folder
cd(result_folder)
if ~exist('across_session','dir')
    mkdir('across_session');
end
cd([result_folder '/across_session'])

if ~exist('across_session_performance.mat','file') % create matrix or cell or struct for across session tracking
   across_session_mat=cell(8,100);
   across_session_mean_mat=nan(8,100);
else
    load('across_session_performance.mat')
end

% get date information for session_id
across_session_mat{session_column,day_num}=day_num;
across_session_mean_mat(session_column,day_num)=day_num;

across_session_mat{session_today,day_num}=LapNum;
across_session_mean_mat(session_today,day_num)=LapNum;

%% get session correctness
% Context forest city


across_session_mean_mat(session_forestACC,day_num)=mean(nanmean(lap_ACC_forest),2);

across_session_mean_mat(session_cityACC,day_num)=mean(nanmean(lap_ACC_city),2);



across_session_mean_mat(session_pumpkin_donutACC,day_num)=mean(nanmean(trial_Pumpkin_Donut),2);
across_session_mean_mat(session_jellyfish_turtleACC,day_num)=mean(nanmean(trial_Jellyfish_Turtle),2);

across_session_mean_mat(session_pumpkin_turtleACC,day_num)=mean(nanmean(trial_Pumpkin_Turtle),2);
across_session_mean_mat(session_jellyfish_donutACC,day_num)=mean(nanmean(trial_Jellyfish_Donut),2);



across_session_mean_mat(session_pumpkin_donutLAT,day_num)= median(LAT_trial_Pumpkin_Donut);
across_session_mean_mat(session_jellyfish_turtleLAT,day_num)= median(LAT_trial_Jellyfish_Turtle);

across_session_mean_mat(session_pumpkin_turtleLAT,day_num)= median(LAT_trial_Pumpkin_Turtle);
across_session_mean_mat(session_jellyfish_donutLAT,day_num)= median(LAT_trial_Jellyfish_Donut);






%get session correctness
% across_session_mat{session_accuracy,day_num}=Correctness;
across_session_mean_mat(session_accuracy,day_num)=mean(nanmean(correctness_mat),2);
% 
% %plot moving window average of correctness and its threshold
% M= movmean(Correctness,24).*24; % M is number of correct trials, rather than proportions 
% crop_M=M(13:24:end);
% threshold_95=binoinv(0.95,24,0.5)./24; %binomial threshold of 0.05
% threshold_99=binoinv(0.99,24,0.5)./24; %binomial threshold of 0.05
% 
% % Plot this sessions average performance with threshold
% figure;
% plot([1:size(crop_M,1)],crop_M./24,'-ob');
% set(gca,'XLim',[1 size(crop_M,1)],'YLim',[0 1]);xlabel('Blocks (24 trials)'),ylabel('Block Accuracy');hold on;
% line([1 size(crop_M,1)],[threshold_95,threshold_95],'color','k');
% line([1 size(crop_M,1)],[threshold_99,threshold_99],'color','cyan');
% legend('Block Accuracy','Significance threshold (95%)','Significance threshold (99%)');
% filename_block_acc_test=[session_date '_' animal_id '_Block_ACC_test.tif'];
% saveas(gcf,filename_block_acc_test);

%get session response side
session_bias_mat=reshape(response_mat',[numel(response_mat) 1]);
across_session_mat{session_bias,day_num}=session_bias_mat;
across_session_mean_mat(session_bias,day_num)=nansum(session_bias_mat)./numel(session_bias_mat);

% %get session void
% session_void_mat=reshape(void_trial_mat',[numel(void_trial_mat) 1]);
% across_session_mat{session_void,day_num}=session_void_mat;
% across_session_mean_mat(session_void,day_num)=nansum(session_void_mat)./numel(session_void_mat);

save('across_session_performance.mat','across_session_mat','across_session_mean_mat');




