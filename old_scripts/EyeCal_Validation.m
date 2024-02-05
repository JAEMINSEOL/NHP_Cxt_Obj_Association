id=[];
for l = 1:size(cali,1)
    idl = mink(find(abs(Eye_Analog_datapixx(:,4)-cali(l,1))<1),15);
id = vertcat(id,idl);
end

idc = find(Eye_Analog_datapixx(:,4)<LapStart_datapixx(1,1));

x = Eye_Analog_datapixx(id,1);
y = Eye_Analog_datapixx(id,2);
Eye_Analog_unreal_recording = Eye_Analog_datapixx(idc,1:4);
[X_lp,Y_lp,X_lp_deg, Y_lp_deg,Eye_sacc_XY_index_lp] = Eye_Classification_lowpassfilter(Eye_Analog_unreal_recording);
idf = find(Eye_sacc_XY_index_lp(:,1));

idx = intersect(idf,id);

figure;
x = Eye_Analog_datapixx(idx,1);
y = Eye_Analog_datapixx(idx,2);
scatter(x,y,'r','filled')
xlim([-5 5])
ylim([-5 5])
 
