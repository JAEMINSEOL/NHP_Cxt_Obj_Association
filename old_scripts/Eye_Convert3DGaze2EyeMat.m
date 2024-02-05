        intersection_all = [];

for l=1:size(intersection,1)
    for d=1:2
        intersection_temp = squeeze(intersection(l,d,:,:));
        intersection_temp(isnan(intersection_temp(:,1)),:)=[];
        intersection_all = vertcat(intersection_all,intersection_temp);
    end
end
%%
id = knnsearch(Eye_mat.Timestamp,intersection_all(:,4));

Eye_mat.ContextX(id) = intersection_all(:,1);
Eye_mat.ContextY(id) = intersection_all(:,2);
Eye_mat.ContextZ(id) = intersection_all(:,3);
%%
for i=1:length(Eye_mat.Void)
    
    if Eye_mat.ContextX(i)+ Eye_mat.ContextY(i)+ Eye_mat.ContextZ(i)==0

        Eye_mat.ContextX(i) = Eye_mat.ContextX(i-1);
        Eye_mat.ContextY(i) = Eye_mat.ContextY(i-1);
        Eye_mat.ContextZ(i) = Eye_mat.ContextZ(i-1);

    end
    
end

%%
filename = 'Eye_Mat.xlsx';
writetable(Eye_mat,filename,'Sheet',1,'Range','A1')