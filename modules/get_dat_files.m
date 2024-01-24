function [file_list,S0] = get_dat_files(root, date_id, file_id)
temp = dir(root); file_list = {};
for i=1:size(temp,1)
    x = find(temp(i).name=='_'); x0 = find(file_id=='_');
    if contains(temp(i).name,date_id) & contains(temp(i).name,file_id) & length(x)==length(x0)+1
        x = find(temp(i).name=='_',1,'last');
        n = str2double(temp(i).name(x+1:end-4));
        file_list{n,1} = temp(i).name;
    end
end

S0=[];
for n=1:size(file_list,1)
m1 = load([root '\' file_list{n}]); fields = fieldnames(m1);

if size(m1.([fields{1}]),1)>5
    S0 = [S0; m1.([fields{1}])];
else
S0 = [S0; m1.([fields{1}])'];
end

end




end