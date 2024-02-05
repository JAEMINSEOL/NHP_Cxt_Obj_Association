function [Array, Firing_Rate] = Rasterplot_by_Choice(SpikeData_info, TickLog_sync_recording_info,TrialInfo_sync_recording,Cxt, LeftObj, RightObj)
Choice_Index = logical((SpikeData_info(:,4)==Cxt) .* (abs(SpikeData_info(:,6))~=0).* (SpikeData_info(:,7)==LeftObj).* (SpikeData_info(:,8)==RightObj).*(SpikeData_info(:,13)==0));
Choice_Indices = find(Choice_Index~=0);
Choice_SpikeInfo = horzcat(SpikeData_info(Choice_Indices,1), SpikeData_info(Choice_Indices,2), SpikeData_info(Choice_Indices,12), SpikeData_info(Choice_Indices,6));
ChoiceRaster = NaN(10000, 2);

Choice_BehaviorIndex = logical((TickLog_sync_recording_info(:,4)==Cxt) .* (abs(TickLog_sync_recording_info(:,6))~=0).* (TickLog_sync_recording_info(:,7)==LeftObj).* (TickLog_sync_recording_info(:,8)==RightObj).* (TickLog_sync_recording_info(:,13)==0));
Choice_BehaviorIndices = find(Choice_BehaviorIndex~=0);
Choice_BehaviorInfo = horzcat(TickLog_sync_recording_info(Choice_BehaviorIndices,1), TickLog_sync_recording_info(Choice_BehaviorIndices,2), TickLog_sync_recording_info(Choice_BehaviorIndices,6));
Choice_BehaviorInfo(:,9) = TickLog_sync_recording_info(Choice_BehaviorIndices,12);

if ~isempty(Choice_SpikeInfo)
    Choice_SpikeInfo(Choice_SpikeInfo(:,1) < Choice_BehaviorInfo(1,1),:) = [];
end
Array = zeros(1,20);
Firing_Rate = NaN(100,1);
if ~isnan(Choice_SpikeInfo)

for i = 1:size(Choice_SpikeInfo,1)
    switch (Choice_SpikeInfo(i,4))
        case -1
            Choice_SpikeInfo(i,5) = (Choice_SpikeInfo(i,1) - TrialInfo_sync_recording(Choice_SpikeInfo(i,3),1)+(0.5*10^6))/(0.5*10^6);
            case 1
            Choice_SpikeInfo(i,5) = (Choice_SpikeInfo(i,1) - TrialInfo_sync_recording(Choice_SpikeInfo(i,3),1))/(TrialInfo_sync_recording(Choice_SpikeInfo(i,3),2) - TrialInfo_sync_recording(Choice_SpikeInfo(i,3),1))+1;
            case 2
            Choice_SpikeInfo(i,5) = (Choice_SpikeInfo(i,1) - TrialInfo_sync_recording(Choice_SpikeInfo(i,3),2))/(TrialInfo_sync_recording(Choice_SpikeInfo(i,3),3) - TrialInfo_sync_recording(Choice_SpikeInfo(i,3),2))+2;
            case 3
            Choice_SpikeInfo(i,5) = (Choice_SpikeInfo(i,1) - TrialInfo_sync_recording(Choice_SpikeInfo(i,3),3))/(TrialInfo_sync_recording(Choice_SpikeInfo(i,3),4) - TrialInfo_sync_recording(Choice_SpikeInfo(i,3),3))+3;
    end
end

%%
Choice_Trial_FR= zeros(length(unique(Choice_BehaviorInfo(:,9))),21);
Choice_Trial_FR(:,end) = unique(Choice_BehaviorInfo(:,9));
    for j = 1: size(Choice_Trial_FR,1)
        Trial_Num = Choice_Trial_FR(j,21);
        arr = Choice_SpikeInfo(find(Choice_SpikeInfo(:,3)==Trial_Num),5);
        for h=1:20
            Choice_Trial_FR(j,h) = length(find((arr< 0.2*h) .* (arr > (0.2*(h-1)))));
        end
%         Choice_Trial_FR(j,1:5) = Choice_Trial_FR(j,1:5)/0.05;
%         Choice_Trial_FR(j,5:10) = Choice_Trial_FR(j,5:10)/((TrialInfo_sync_recording(Trial_Num,2) - TrialInfo_sync_recording(Trial_Num,1))*10^(-7));
%         Choice_Trial_FR(j,10:15) = Choice_Trial_FR(j,10:15)/((TrialInfo_sync_recording(Trial_Num,3) - TrialInfo_sync_recording(Trial_Num,2))*10^(-7));
%         Choice_Trial_FR(j,15:20) = Choice_Trial_FR(j,15:20)/((TrialInfo_sync_recording(Trial_Num,4) - TrialInfo_sync_recording(Trial_Num,3))*10^(-7));
        Choice_Trial_Time(j,1:5) = 0.05;
        Choice_Trial_Time(j,5:10) = ((TrialInfo_sync_recording(Trial_Num,2) - TrialInfo_sync_recording(Trial_Num,1))*10^(-7));
        Choice_Trial_Time(j,10:15) = ((TrialInfo_sync_recording(Trial_Num,3) - TrialInfo_sync_recording(Trial_Num,2))*10^(-7));
        Choice_Trial_Time(j,15:20) = ((TrialInfo_sync_recording(Trial_Num,4) - TrialInfo_sync_recording(Trial_Num,3))*10^(-7));
    end

 %% histogram


for h=1:20
    
    Array(1,h) = sum(Choice_Trial_FR(:,h))/sum(Choice_Trial_Time(:,h));
    
end
  
%%
% t=1;TrialDuration = [];
% for c1 = 1:length(Choice_BehaviorInfo)
%     Choice_BehaviorInfo(c1,8) = t;
%     if c1 == 1
%         Choice_BehaviorInfo(c1,4) = 0;
%         TrialStartTime(t,1) = Choice_BehaviorInfo(c1,1);
%     else
%         if Choice_BehaviorInfo(c1,3) == -1
%        
%             if Choice_BehaviorInfo(c1-1,3) == 3
%                 if Choice_BehaviorInfo(c1,3) == 1
%                     Choice_BehaviorInfo(c1,4) = 0;
%                 elseif Choice_BehaviorInfo(c1,3) == -1
%                     Choice_BehaviorInfo(c1,4) = 0;
%                 end
%                 TrialStartTime(t+1,1) = Choice_BehaviorInfo(c1,1);
%                 TrialDuration(t,4) = Choice_BehaviorInfo(c1-1,1) - TrialStartTime(t,4);
%                 t = t+1;
%             else
%                 Choice_BehaviorInfo(c1,4) = Choice_BehaviorInfo(c1,1) - TrialStartTime(t,1);
%             end
%             
%         elseif Choice_BehaviorInfo(c1,3) == 1
%                            Choice_BehaviorInfo(c1,4) = NaN;
% 
%             if Choice_BehaviorInfo(c1-1,3) ==-1
%                     Choice_BehaviorInfo(c1,5) = 0;
%                 TrialStartTime(t,2) = Choice_BehaviorInfo(c1,1);
%                 TrialDuration(t,1) = Choice_BehaviorInfo(c1-1,1) - TrialStartTime(t,1);
% 
%             else
%                 Choice_BehaviorInfo(c1,5) = Choice_BehaviorInfo(c1,1) - TrialStartTime(t,2);
%             end
%         elseif Choice_BehaviorInfo(c1,3) == 2
%             Choice_BehaviorInfo(c1,4) = NaN;
%             Choice_BehaviorInfo(c1,5) = NaN;
%             if Choice_BehaviorInfo(c1-1,3) == 1
%                 Choice_BehaviorInfo(c1,6) = 0;
%                 TrialStartTime(t,3) = Choice_BehaviorInfo(c1,1);
%                 TrialDuration(t,2) = Choice_BehaviorInfo(c1,1) - TrialStartTime(t,2);
%             else
%                 Choice_BehaviorInfo(c1,6) = Choice_BehaviorInfo(c1,1) - TrialStartTime(t,3);
%             end
%         elseif Choice_BehaviorInfo(c1,3) == 3
%             Choice_BehaviorInfo(c1,4) = NaN;
%             Choice_BehaviorInfo(c1,5) = NaN;
%             Choice_BehaviorInfo(c1,6) = NaN;
%             if Choice_BehaviorInfo(c1-1,3) == 2
%                 Choice_BehaviorInfo(c1,7) = 0;
%                 TrialStartTime(t,4) = Choice_BehaviorInfo(c1,1);
%                 TrialDuration(t,3) = Choice_BehaviorInfo(c1,1) - TrialStartTime(t,3);
%             else
%                 Choice_BehaviorInfo(c1,7) = Choice_BehaviorInfo(c1,1) - TrialStartTime(t,4);
%             end
%         end
%     end
% end
% TrialDuration(end,3) = Choice_BehaviorInfo(end,1)- TrialStartTime(end,3);
% TrialDuration = TrialDuration/10^6;
% 
% Choice_SpikeInfo(:,4) = interp1(Choice_BehaviorInfo(:,1), Choice_BehaviorInfo(:,4), Choice_SpikeInfo(:,1), 'linear','extrap');
% Choice_SpikeInfo(:,5) = interp1(Choice_BehaviorInfo(:,1), Choice_BehaviorInfo(:,5), Choice_SpikeInfo(:,1), 'linear','extrap');
% Choice_SpikeInfo(:,6) = interp1(Choice_BehaviorInfo(:,1), Choice_BehaviorInfo(:,6), Choice_SpikeInfo(:,1), 'linear','extrap');
% Choice_SpikeInfo(:,7) = interp1(Choice_BehaviorInfo(:,1), Choice_BehaviorInfo(:,7), Choice_SpikeInfo(:,1), 'linear','extrap');
% Choice_SpikeInfo(:,8) = interp1(Choice_BehaviorInfo(:,1), Choice_BehaviorInfo(:,8), Choice_SpikeInfo(:,1), 'nearest');
% Choice_SpikeInfo(:,9) = interp1(Choice_BehaviorInfo(:,1), Choice_BehaviorInfo(:,9), Choice_SpikeInfo(:,1), 'nearest');

% Raster_Choice_Normalized4 = max(TrialDuration(:,1)) * (Choice_SpikeInfo(:,5) - min(Choice_SpikeInfo(:,5)))/(max(Choice_SpikeInfo(:,5)) - min(Choice_SpikeInfo(:,5)));
% Raster_Choice_Normalized5 = max(TrialDuration(:,1)) + max(TrialDuration(:,2)) * (Choice_SpikeInfo(:,6) - min(Choice_SpikeInfo(:,6)))/(max(Choice_SpikeInfo(:,6)) - min(Choice_SpikeInfo(:,6)));
% Raster_Choice_Normalized6 = max(TrialDuration(:,1)) + max(TrialDuration(:,2)) + max(TrialDuration(:,3)) * (Choice_SpikeInfo(:,7) - min(Choice_SpikeInfo(:,7)))/(max(Choice_SpikeInfo(:,7)) - min(Choice_SpikeInfo(:,7)));
% Raster_Choice_Normalized_0 = (Choice_SpikeInfo(:,4) - min(Choice_SpikeInfo(:,4)))/(max(Choice_SpikeInfo(:,4)) - min(Choice_SpikeInfo(:,4)));
% Raster_Choice_Normalized_0(find(Choice_SpikeInfo(:,3)~=-1)) = NaN;
% Raster_Choice_Normalized_1 = (Choice_SpikeInfo(:,5) - min(Choice_SpikeInfo(:,5)))/(max(Choice_SpikeInfo(:,5)) - min(Choice_SpikeInfo(:,5)));
% Raster_Choice_Normalized_1(find(Choice_SpikeInfo(:,3) ~=1)) = NaN;
% Raster_Choice_Normalized_2 = (Choice_SpikeInfo(:,6) - min(Choice_SpikeInfo(:,6)))/(max(Choice_SpikeInfo(:,6)) - min(Choice_SpikeInfo(:,6)));
% Raster_Choice_Normalized_2(find(Choice_SpikeInfo(:,3)~=2)) = NaN;
% Raster_Choice_Normalized_3 = (Choice_SpikeInfo(:,7) - min(Choice_SpikeInfo(:,7)))/(max(Choice_SpikeInfo(:,7)) - min(Choice_SpikeInfo(:,7)));
% Raster_Choice_Normalized_3(find(Choice_SpikeInfo(:,3)~=3)) = NaN;
% Raster_Choice_Normalized_linear = vertcat(Raster_Choice_Normalized_0, Raster_Choice_Normalized_1+1, Raster_Choice_Normalized_2+2, Raster_Choice_Normalized_3+3);
% Raster_Choice_Normalized = horzcat(Raster_Choice_Normalized_0,Raster_Choice_Normalized_1+1, Raster_Choice_Normalized_2+2, Raster_Choice_Normalized_3+3);

% Choice_SpikeInfo2 (i,4) = Choice_SpikeInfo (i,Choice_SpikeInfo(i,3)+)



% if size(Raster_Choice_Normalized_linear,1) > size(Raster_Choice_Normalized_linear,2)
%     Raster_Choice_Normalized_linear=Raster_Choice_Normalized_linear';
% end
% 
% %%
% for i = 1:max(Choice_BehaviorInfo(:,8))
%     ChoiceRaster(i,3) = i;
% for j = 4:6
% ChoiceRaster(i,j) = max(Choice_BehaviorInfo(Choice_BehaviorInfo(:,8)==i,j))/10^6;
% end
% end
% 
% for i = 1:size(Choice_SpikeInfo,1)
%     if ~isnan(Choice_SpikeInfo(i,8))
%     if ChoiceRaster(Choice_SpikeInfo(i,8),6)/10^6 < 2 && ChoiceRaster(Choice_SpikeInfo(i,8),5)/10^6 < 2
% if i~=1 && Choice_SpikeInfo(i,8) > Choice_SpikeInfo(i-1,8)
% end
% ChoiceRaster(i,1) = Choice_SpikeInfo(i,Choice_SpikeInfo(i,3)+3)/10^6;
% 
% if Choice_SpikeInfo(i,3) == 2
%     ChoiceRaster(i,1) = ChoiceRaster(i,1) + ChoiceRaster(Choice_SpikeInfo(i,8),4);
% elseif Choice_SpikeInfo(i,3) == 3
%     ChoiceRaster(i,1) = ChoiceRaster(i,1) + ChoiceRaster(Choice_SpikeInfo(i,8),4)+ ChoiceRaster(Choice_SpikeInfo(i,8),5);
% end
% ChoiceRaster(i,2) = Choice_SpikeInfo(i,8);
%     end
%     end
% end
%% Raster plot
% axis([0 max(Raster_Choice_Normalized)+1 -1 1])
% plot([Raster_Choice_Normalized;Raster_Choice_Normalized],[ones(size(Raster_Choice_Normalized));zeros(size(Raster_Choice_Normalized))],'k-')
% set(gca,'TickDir','out') % draw the tick marks on the outside
% set(gca,'YTick', []) % don't draw y-axis ticks
% set(gca,'PlotBoxAspectRatio',[1 0.05 1]) % short and wide
% set(gca,'Color',get(gcf,'Color')) % match figure background
% set(gca,'YColor',get(gcf,'Color')) % hide the y axis
% ylim([0 1.5])
% LeftObjName = NameObj (LeftObj);
% RightObjName = NameObj (RightObj);
% % set(gca,'XColor','none','YColor','none');
% if mod(LeftObj,2) == mod(Cxt,2)
%     CorrChoice = 'Left';
% else
%     CorrChoice = 'Right';
% end
% 
% if Cxt==1
%     CxtName = 'Forest';
% else
%     CxtName = 'City';
% end
% 
% title([CxtName ',' LeftObjName ',' RightObjName ',' CorrChoice],'Fontsize', 12)
% % xlabel('Normalized Time')
% xticks([0 1 2 3])
% xticklabels({'Cursor On', 'Obj On', 'Cursor Blue', 'Choice'})
% pbaspect([3 0.6 1])
% % set(gca, 'XAxisLocation', 'origin');
% hold off
% box off
% 
% line([0 0], [0 1.5],'color','k')
% line([1 1], [0 1.5],'color','r')
% line([2 2], [0 1.5],'color','b')
% line([3 3], [0 1.5],'color','k')

%% histogram
% Bin = cell(1,40);
% 
% for h=1:20
%     
%     Bin{1,h} = length(find((Raster_Choice_Normalized_linear< 0.2*h) .* (Raster_Choice_Normalized_linear > (0.2*(h-1)))));
%     
% end
% 
% Array = cell2mat(Bin);


%%

for i = 1:size(Choice_Trial_FR,1)
    Trial_Num = Choice_Trial_FR(i,21);
Firing_Rate(i,1) = length(find(Choice_SpikeInfo(:,3)==Trial_Num & Choice_SpikeInfo(:,4)>1))/((TrialInfo_sync_recording(Trial_Num,4)-TrialInfo_sync_recording(Trial_Num,2))*10^(-6));
end
end
end