% L = 0;
% FR_Context_mean = [];
% FR_Context_std = [];
% FR_Context_sem = [];
% 
% FR_Object_mean = [];
% FR_Object_std = [];
% FR_Object_sem = [];
% 
% FR_Response_mean = [];
% FR_Response_std = [];
% FR_Response_sem = [];

for c = 1:2
for i = 0:2
for j = 1:3
FR_mean(i+1,j,2*c-1) = nanmean(Firing_Rate(:,c,6*i+2*j-1));
FR_sem(i+1,j,2*c-1) = nanstd(Firing_Rate(:,c,6*i+2*j-1))/length(Firing_Rate(~isnan(Firing_Rate(:,c,6*i+2*j-1))));

FR_mean(i+1,j,2*c) = nanmean(Firing_Rate(:,c,6*i+2*j));
FR_sem(i+1,j,2*c) = nanstd(Firing_Rate(:,c,6*i+2*j))/length(Firing_Rate(~isnan(Firing_Rate(:,c,6*i+2*j))));
end
end
end
% 
% 
% for i = 1:2
% FR_Context_mean(1,i) = nanmean(Firing_Rate(:,i,1:18),'all');
% FR_Context_std(1,i) = nanstd(Firing_Rate(:,i,1:18),0,'all');
% 
% L=0;
% for l = 1:9
% L = L + length(Firing_Rate(~isnan(Firing_Rate(:,i,(i-1)*9+l))));
% end
% FR_Context_sem(1,i) = FR_Context_std(1,i) / sqrt(L);
% 
% FR_Response_mean(i,1) = nanmean(Firing_Rate(:,i,i:2:end),'all');
% FR_Response_std(i,1) = nanstd(Firing_Rate(:,i,i:2:end),0,'all');
% FR_Response_mean(i,2) = nanmean(Firing_Rate(:,i,i+1:2:end),'all');
% FR_Response_std(i,2) = nanstd(Firing_Rate(:,i,i+1:2:end),0,'all');
% 
% L1=0; L2=0;
% for l = 0:2:16
% L1 = L1 + length(Firing_Rate(~isnan(Firing_Rate(:,i,i+l))));
% L2 = L2 + length(Firing_Rate(~isnan(Firing_Rate(:,i,i+l))));
% end
% FR_Response_sem(i,1) = FR_Response_std(i,1) / sqrt(L1);
% FR_Response_sem(i,2) = FR_Response_std(i,2) / sqrt(L2);
% 
%       
% FR_Object_mean(i,1) = nanmean(horzcat(Firing_Rate(:,i,1),Firing_Rate(:,i,2), Firing_Rate(:,i,3), Firing_Rate(:,i,4), Firing_Rate(:,i,5), Firing_Rate(:,i,6)),'all');
% FR_Object_mean(i,3) = nanmean(horzcat(Firing_Rate(:,i,7),Firing_Rate(:,i,8), Firing_Rate(:,i,9), Firing_Rate(:,i,10), Firing_Rate(:,i,11), Firing_Rate(:,i,12)),'all');
% FR_Object_mean(i,5) = nanmean(horzcat(Firing_Rate(:,i,13),Firing_Rate(:,i,14), Firing_Rate(:,i,15), Firing_Rate(:,i,16), Firing_Rate(:,i,17), Firing_Rate(:,i,18)),'all');
% FR_Object_mean(i,2) = nanmean(horzcat(Firing_Rate(:,i,1),Firing_Rate(:,i,2), Firing_Rate(:,i,7), Firing_Rate(:,i,8), Firing_Rate(:,i,13), Firing_Rate(:,i,14)),'all');
% FR_Object_mean(i,4) = nanmean(horzcat(Firing_Rate(:,i,3),Firing_Rate(:,i,4), Firing_Rate(:,i,9), Firing_Rate(:,i,10), Firing_Rate(:,i,15), Firing_Rate(:,i,16)),'all');
% FR_Object_mean(i,6) = nanmean(horzcat(Firing_Rate(:,i,5),Firing_Rate(:,i,6), Firing_Rate(:,i,11), Firing_Rate(:,i,12), Firing_Rate(:,i,17), Firing_Rate(:,i,18)),'all');
% 
% FR_Object_std(i,1) = nanstd(horzcat(Firing_Rate(:,i,1),Firing_Rate(:,i,2), Firing_Rate(:,i,3), Firing_Rate(:,i,4), Firing_Rate(:,i,15), Firing_Rate(:,i,6)),0,'all');
% FR_Object_sem(i,1) = FR_Object_std(i,1)/sqrt(length(Firing_Rate(~isnan(Firing_Rate(:,i,1)))) + length(Firing_Rate(~isnan(Firing_Rate(:,i,2)))) + length(Firing_Rate(~isnan(Firing_Rate(:,i,3)))) +length(Firing_Rate(~isnan(Firing_Rate(:,i,4)))) + length(Firing_Rate(~isnan(Firing_Rate(:,i,5)))) + length(Firing_Rate(~isnan(Firing_Rate(:,i,6)))));
% 
% FR_Object_std(i,3) = nanstd(horzcat(Firing_Rate(:,i,7),Firing_Rate(:,i,8), Firing_Rate(:,i,9), Firing_Rate(:,i,10), Firing_Rate(:,i,11), Firing_Rate(:,i,12)),0,'all');
% FR_Object_sem(i,3) = FR_Object_std(i,3)/sqrt(length(Firing_Rate(~isnan(Firing_Rate(:,i,7)))) + length(Firing_Rate(~isnan(Firing_Rate(:,i,8)))) + length(Firing_Rate(~isnan(Firing_Rate(:,i,9)))) +length(Firing_Rate(~isnan(Firing_Rate(:,i,10)))) + length(Firing_Rate(~isnan(Firing_Rate(:,i,11)))) + length(Firing_Rate(~isnan(Firing_Rate(:,i,12)))));
% 
% FR_Object_std(i,5) = nanstd(horzcat(Firing_Rate(:,i,13),Firing_Rate(:,i,14), Firing_Rate(:,i,15), Firing_Rate(:,i,16), Firing_Rate(:,i,17), Firing_Rate(:,i,18)),0,'all');
% FR_Object_sem(i,5) = FR_Object_std(i,5)/sqrt(length(Firing_Rate(~isnan(Firing_Rate(:,i,13)))) + length(Firing_Rate(~isnan(Firing_Rate(:,i,14)))) + length(Firing_Rate(~isnan(Firing_Rate(:,i,15)))) +length(Firing_Rate(~isnan(Firing_Rate(:,i,16)))) + length(Firing_Rate(~isnan(Firing_Rate(:,i,17)))) + length(Firing_Rate(~isnan(Firing_Rate(:,i,18)))));
% 
% FR_Object_std(i,2) = nanstd(horzcat(Firing_Rate(:,i,1),Firing_Rate(:,i,2), Firing_Rate(:,i,7), Firing_Rate(:,i,8), Firing_Rate(:,i,13), Firing_Rate(:,i,14)),0,'all');
% FR_Object_sem(i,2) = FR_Object_std(i,2)/sqrt(length(Firing_Rate(~isnan(Firing_Rate(:,i,1)))) + length(Firing_Rate(~isnan(Firing_Rate(:,i,2)))) + length(Firing_Rate(~isnan(Firing_Rate(:,i,7)))) +length(Firing_Rate(~isnan(Firing_Rate(:,i,8)))) + length(Firing_Rate(~isnan(Firing_Rate(:,i,13)))) + length(Firing_Rate(~isnan(Firing_Rate(:,i,14)))));
% 
% FR_Object_std(i,4) = nanstd(horzcat(Firing_Rate(:,i,3),Firing_Rate(:,i,4), Firing_Rate(:,i,9), Firing_Rate(:,i,10), Firing_Rate(:,i,15), Firing_Rate(:,i,16)),0,'all');
% FR_Object_sem(i,4) = FR_Object_std(i,4)/sqrt(length(Firing_Rate(~isnan(Firing_Rate(:,i,3)))) + length(Firing_Rate(~isnan(Firing_Rate(:,i,4)))) + length(Firing_Rate(~isnan(Firing_Rate(:,i,9)))) +length(Firing_Rate(~isnan(Firing_Rate(:,i,10)))) + length(Firing_Rate(~isnan(Firing_Rate(:,i,15)))) + length(Firing_Rate(~isnan(Firing_Rate(:,i,16)))));
% 
% FR_Object_std(i,6) = nanstd(horzcat(Firing_Rate(:,i,5),Firing_Rate(:,i,6), Firing_Rate(:,i,11), Firing_Rate(:,i,12), Firing_Rate(:,i,17), Firing_Rate(:,i,18)),0,'all');
% FR_Object_sem(i,6) = FR_Object_std(i,6)/sqrt(length(Firing_Rate(~isnan(Firing_Rate(:,i,5)))) + length(Firing_Rate(~isnan(Firing_Rate(:,i,6)))) + length(Firing_Rate(~isnan(Firing_Rate(:,i,11)))) +length(Firing_Rate(~isnan(Firing_Rate(:,i,12)))) + length(Firing_Rate(~isnan(Firing_Rate(:,i,17)))) + length(Firing_Rate(~isnan(Firing_Rate(:,i,18)))));
% end
% %%
% FR_Trial_Location = [];
% for c = 1:2
%     for i = 1:size(TrialInfo_sync_recording,1)
%         for j = 1:4
%             FR_Trial_Location(i,j,c) = length(SpikeData_info(SpikeData_info(:,11)==i & SpikeData_info(:,4)==2*j& SpikeData_info(:,3)==c))/((TrialInfo_sync_recording(i,2)-TrialInfo_sync_recording(i,1))*10^-6);
%             FR_Trial_Location(i,4+j,c) = length(SpikeData_info(SpikeData_info(:,11)==i & SpikeData_info(:,4)==2*j+10& SpikeData_info(:,3)==c))/((TrialInfo_sync_recording(i,2)-TrialInfo_sync_recording(i,1))*10^-6);
%         end
%         for j=1:8
%             if mod(i,8)~=mod(j,8)
%                 FR_Trial_Location(i,j,c) = NaN;
%             end
%         end
%     end
% end