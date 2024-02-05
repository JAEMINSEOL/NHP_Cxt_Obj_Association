x = []; y = [];
for i = 1:18
    x = vertcat(x,Firing_Rate(:,1,i));
    y = vertcat(y,Firing_Rate(:,2,i));
end
x(isnan(x))=[];
y(isnan(y)) = [];

[h_cxt,p_cxt] = ttest2(x,y,'Vartype','unequal');

%%
x = []; y = [];
for i = 1:9
    x = vertcat(x,Firing_Rate(:,1,-1+2*i));
    y = vertcat(y,Firing_Rate(:,1,0+2*i));
end
x(isnan(x))=[];
y(isnan(y)) = [];

[h_resp_f,p_resp_f] = ttest2(x,y,'Vartype','unequal');


x = []; y = [];
for i = 1:9
    x = vertcat(x,Firing_Rate(:,2,0+2*i));
    y = vertcat(y,Firing_Rate(:,2,-1+2*i));
end
x(isnan(x))=[];
y(isnan(y)) = [];

[h_resp_c,p_resp_c] = ttest2(x,y,'Vartype','unequal');



%%
y = [];

y(:,1) = vertcat(Firing_Rate(:,1,1),Firing_Rate(:,1,2), Firing_Rate(:,1,3), Firing_Rate(:,1,4), Firing_Rate(:,1,5), Firing_Rate(:,1,6));
y(:,3) = vertcat(Firing_Rate(:,1,7),Firing_Rate(:,1,8), Firing_Rate(:,1,9), Firing_Rate(:,1,10), Firing_Rate(:,1,11), Firing_Rate(:,1,12));
y(:,5) = vertcat(Firing_Rate(:,1,13),Firing_Rate(:,1,14), Firing_Rate(:,1,15), Firing_Rate(:,1,16), Firing_Rate(:,1,17), Firing_Rate(:,1,18));
y(:,2) = vertcat(Firing_Rate(:,1,1),Firing_Rate(:,1,2), Firing_Rate(:,1,7), Firing_Rate(:,1,8), Firing_Rate(:,1,13), Firing_Rate(:,1,14));
y(:,4) = vertcat(Firing_Rate(:,1,3),Firing_Rate(:,1,4), Firing_Rate(:,1,9), Firing_Rate(:,1,10), Firing_Rate(:,1,15), Firing_Rate(:,1,16));
y(:,6) = vertcat(Firing_Rate(:,1,5),Firing_Rate(:,1,6), Firing_Rate(:,1,11), Firing_Rate(:,1,12), Firing_Rate(:,1,17), Firing_Rate(:,1,18));

p_obj_f = anova1(y);


x = []; y = [];

y(:,1) = vertcat(Firing_Rate(:,2,1),Firing_Rate(:,2,2), Firing_Rate(:,2,3), Firing_Rate(:,2,4), Firing_Rate(:,2,5), Firing_Rate(:,2,6));
y(:,3) = vertcat(Firing_Rate(:,2,7),Firing_Rate(:,2,8), Firing_Rate(:,2,9), Firing_Rate(:,2,10), Firing_Rate(:,2,11), Firing_Rate(:,2,12));
y(:,5) = vertcat(Firing_Rate(:,2,13),Firing_Rate(:,2,14), Firing_Rate(:,2,15), Firing_Rate(:,2,16), Firing_Rate(:,2,17), Firing_Rate(:,2,18));
y(:,2) = vertcat(Firing_Rate(:,2,1),Firing_Rate(:,2,2), Firing_Rate(:,2,7), Firing_Rate(:,2,8), Firing_Rate(:,2,13), Firing_Rate(:,2,14));
y(:,4) = vertcat(Firing_Rate(:,2,3),Firing_Rate(:,2,4), Firing_Rate(:,2,9), Firing_Rate(:,2,10), Firing_Rate(:,2,15), Firing_Rate(:,2,16));
y(:,6) = vertcat(Firing_Rate(:,2,5),Firing_Rate(:,2,6), Firing_Rate(:,2,11), Firing_Rate(:,2,12), Firing_Rate(:,2,17), Firing_Rate(:,2,18));

p_obj_c = anova1(y);

%%
y = [];
y(:,1) = vertcat(Firing_Rate(:,2,1),Firing_Rate(:,2,2), Firing_Rate(:,2,3), Firing_Rate(:,2,4), Firing_Rate(:,2,5), Firing_Rate(:,2,6));
y(:,2) = vertcat(Firing_Rate(:,2,7),Firing_Rate(:,2,8), Firing_Rate(:,2,9), Firing_Rate(:,2,10), Firing_Rate(:,2,11), Firing_Rate(:,2,12));
y(:,3) = vertcat(Firing_Rate(:,2,13),Firing_Rate(:,2,14), Firing_Rate(:,2,15), Firing_Rate(:,2,16), Firing_Rate(:,2,17), Firing_Rate(:,2,18));
y(:,4) = vertcat(Firing_Rate(:,2,1),Firing_Rate(:,2,2), Firing_Rate(:,2,7), Firing_Rate(:,2,8), Firing_Rate(:,2,13), Firing_Rate(:,2,14));

p_obj_c = anova1(y);

%%
y = [];
y(:,1) = FR_Trial_Location(:,1,1);
y(:,2) = FR_Trial_Location(:,2,1);
y(:,3) = FR_Trial_Location(:,3,1);
y(:,4) = FR_Trial_Location(:,4,1);
y(:,5) = FR_Trial_Location(:,5,1);
y(:,6) = FR_Trial_Location(:,6,1);
y(:,7) = FR_Trial_Location(:,7,1);
y(:,8) = FR_Trial_Location(:,8,1);

p_loc_f = anova1(y);


y = [];
y(:,1) = FR_Trial_Location(:,1,2);
y(:,2) = FR_Trial_Location(:,2,2);
y(:,3) = FR_Trial_Location(:,3,2);
y(:,4) = FR_Trial_Location(:,4,2);
y(:,5) = FR_Trial_Location(:,5,2);
y(:,6) = FR_Trial_Location(:,6,2);
y(:,7) = FR_Trial_Location(:,7,2);
y(:,8) = FR_Trial_Location(:,8,2);

p_loc_c = anova1(y);


%%
y = horzcat(Eye_FR_Overall_LeftDisc, Eye_FR_Overall_RightDisc, Eye_FR_Overall_InterDisc);
p_eye_o = anova1(y);

y = horzcat(Eye_FR_Forest_Left_LeftDisc, Eye_FR_Forest_Left_RightDisc, Eye_FR_Forest_Left_InterDisc);
p_eye_f_l = anova1(y);

y = horzcat(Eye_FR_Forest_Right_LeftDisc, Eye_FR_Forest_Right_RightDisc, Eye_FR_Forest_Right_InterDisc);
p_eye_f_r = anova1(y);

y = horzcat(Eye_FR_City_Left_LeftDisc, Eye_FR_City_Left_RightDisc, Eye_FR_City_Left_InterDisc);
p_eye_c_l = anova1(y);

y = horzcat(Eye_FR_City_Right_LeftDisc, Eye_FR_City_Right_RightDisc, Eye_FR_City_Right_InterDisc);
p_eye_c_r = anova1(y);