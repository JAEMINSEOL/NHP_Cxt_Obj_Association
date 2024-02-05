% Analyze across session trends

session_column=1;
session_today=2;
session_accuracy=3;
session_latency=7;
session_bias=5;
session_void=6;

cd([result_folder '/across_session']);
load('across_session_performance.mat');

range_start=input('Range (Start) ::');
range_end=input('Range (End) ::');
range_num=range_end-range_start+1;

analyze_session_mat=across_session_mean_mat(:,[range_start:range_end])'; %switching dimensions for GLM table

% currently there is only one explanatory variable (session_num), but
% additional data such as date (Mon~Fri) could be added.
% Analyze trend of number of laps
mdl_laps=fitglm(analyze_session_mat(:,session_column),analyze_session_mat(:,session_today),'y ~ x1')

% Analyze trend of correctness
mdl_acc=fitglm(analyze_session_mat(:,session_column),analyze_session_mat(:,session_accuracy),'y ~ x1')

% Analyze trend of number of valid trials
mdl_valid=fitglm(analyze_session_mat(:,session_column),analyze_session_mat(:,session_void),'y ~ x1')

% Analyze trend of latency
mdl_latency=fitglm(analyze_session_mat(:,session_column),analyze_session_mat(:,session_latency),'y ~ x1')

save('across_session_trends.mat','range_num','range_start','range_end','mdl_laps','mdl_acc','mdl_valid','mdl_latency')