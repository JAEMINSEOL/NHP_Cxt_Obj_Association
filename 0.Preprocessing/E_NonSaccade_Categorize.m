function [Eye_sacc_XY_index_lp_new,NonSacc] = E_NonSaccade_Categorize(Eye_sacc_XY_index_lp,Eye_Acc_deg_inst_lp,Eye_Speed_deg_inst_lp,X_lp_deg, Y_lp_deg)

nd=0.45; ncd=0.5; npd=0.3; nMaxFix=1.5; nMinSmp=1;

Amin=0.15; rth=0.89; R=0.15;

Eye_sacc_XY_index_lp=~Eye_sacc_XY_index_lp(:,2);

%% get NonSacc period
NonSacc=[]; s=1;
if Eye_sacc_XY_index_lp(1)==1, NonSacc(s,1)=1; end
for i=2:size(Eye_sacc_XY_index_lp,1)
    if Eye_sacc_XY_index_lp(i-1)==0 && Eye_sacc_XY_index_lp(i)==1
        NonSacc(s,1)=i;
    elseif Eye_sacc_XY_index_lp(i-1)==1 && Eye_sacc_XY_index_lp(i)==0
        NonSacc(s,2)=i;
        s=s+1;
    end
end
if Eye_sacc_XY_index_lp(end)==1, NonSacc(s,2)=i; end


%%
Eye_sacc_XY_index_lp_new = Eye_sacc_XY_index_lp;

%%
for s=1:size(NonSacc,1)
    x = X_lp_deg(NonSacc(s,1):NonSacc(s,2));
    y = Y_lp_deg(NonSacc(s,1):NonSacc(s,2));

    speed = Eye_Speed_deg_inst_lp(NonSacc(s,1):NonSacc(s,2),:);
    [speed_r,~] = cart2pol(speed(:,1),speed(:,2));

    [mu] = circ_mean(speed_r);
    deg = rad2deg(mu); if deg<0, deg = deg+360; end
    NonSacc(s,3) = deg;
end

%% first categorization
% temps = zeros(size(Eye_Acc_deg_inst_lp,1),1);
% parfor s=1:size(NonSacc,1)
%     x = X_lp_deg(NonSacc(s,1):NonSacc(s,2));
%     y = Y_lp_deg(NonSacc(s,1):NonSacc(s,2));
% 
%     speed = Eye_Speed_deg_inst_lp(NonSacc(s,1):NonSacc(s,2),:);
%     [speed_r,~] = cart2pol(speed(:,1),speed(:,2));
% 
%     [mu] = circ_mean(speed_r);
%     deg = rad2deg(mu); if deg<0, deg = deg+360; end
%     [pval, ~] = circ_rtest(speed_r);
% 
%     if size(speed,1)>=40 && pval<0.01
% 
%         [coeff,score,latent] = pca([x,y]);
%         pc1=score(:,1); pc2=score(:,2);
% 
% 
%         d_x = max(pc1)-min(pc1); d_y = max(pc2)-min(pc2);
%         d_pc1 = max([d_x,d_y]); d_pc2 = min([d_x,d_y]);
%         d_ed = pdist([x(1) y(1); x(end) y(end)]);
% 
%         d_tl=0;
%         for i=1:size(x,1)-1
%             d = pdist([x(i:i+1) y(i:i+1)]);
%             d_tl = d_tl+d;
%         end
% 
%         pd = d_pc2/d_pc1;
%         pcd=d_ed/d_pc1;
%         ppd = d_ed/d_tl;
%         pr = sqrt((max(x)-min(x))^2+(max(y)-min(y))^2);
% 
%         if pd>nd && pcd>ncd && ppd>npd && pr>nMaxFix
%             idx=2;
%         else
%             if ppd>npd
%                 idx=0;
% %                 if pr>nMinSmp
% %                     idx=2;
% %                 else
% %                     idx=1;
% %                 end
%             elseif pr>nMaxFix
%                 idx=2;
%             else
%                 idx=1;
%             end
% 
%         end
% 
%     else
%         idx=1;
% 
%     end
% NonSac(s,4) = idx;
% % temps(NonSacc(s,1):NonSacc(s,2),1) = idx;
% end
% NonSacc(:,4) = NonSac(:,4);

% %% grouping
% NonSacc_2=NonSacc;
% s0=1;
% while s0<size(NonSacc,1)
% s=s0;
% flag=1;
% while flag
%     a = NonSacc(s,3); b = NonSacc(s+1,3);
%     normDeg = mod(a-b,360);
%     absDiffDeg = min(360-normDeg, normDeg);
%     if NonSacc(s,4)==0 && absDiffDeg<45
%         flag=1;
%         s=s+1;
%     else
%         flag=0;
%     end
% end
% NonSacc_2(s0:s,1) = NonSacc_2(s0,1);
% NonSacc_2(s0:s,2) = NonSacc_2(s,2);
% 
% s0=s+1;
% end
%% second categorization
NonSacc_2=NonSacc;
parfor s=1:size(NonSacc_2,1)
    x = X_lp_deg(NonSacc_2(s,1):NonSacc_2(s,2));
    y = Y_lp_deg(NonSacc_2(s,1):NonSacc_2(s,2));

    speed = Eye_Speed_deg_inst_lp(NonSacc_2(s,1):NonSacc_2(s,2),:);
    [speed_r,~] = cart2pol(speed(:,1),speed(:,2));

    [mu] = circ_mean(speed_r);
    deg = rad2deg(mu); if deg<0, deg = deg+360; end
    [pval, ~] = circ_rtest(speed_r);

    if size(speed,1)>=40 && pval<0.01

        [coeff,score,latent] = pca([x,y]);
        pc1=score(:,1); pc2=score(:,2);


        d_x = max(pc1)-min(pc1); d_y = max(pc2)-min(pc2);
        d_pc1 = max([d_x,d_y]); d_pc2 = min([d_x,d_y]);
        d_ed = pdist([x(1) y(1); x(end) y(end)]);

        d_tl=0;
        for i=1:size(x,1)-1
            d = pdist([x(i:i+1) y(i:i+1)]);
            d_tl = d_tl+d;
        end

        pd = d_pc2/d_pc1;
        pcd=d_ed/d_pc1;
        ppd = d_ed/d_tl;
        pr = sqrt((max(x)-min(x))^2+(max(y)-min(y))^2);

        if pd>nd && pcd>ncd && ppd>npd && pr>nMaxFix
            idx=2;
        else
            if ppd>npd
                if pr>nMinSmp
                    idx=2;
                else
                    idx=1;
                end
            elseif pr>nMaxFix
                idx=2;
            else
                idx=1;
            end

        end

    else
        idx=1;

    end
NonSac(s,4) = idx;
% temps(NonSacc(s,1):NonSacc(s,2),1) = idx;
end
NonSacc(:,4) = NonSac(:,4);



%% get PSO
parfor s=1:size(NonSacc,1)
per = [NonSacc(s,1):min(NonSacc(s,1)+40,size(X_lp_deg,1))];

    x = X_lp_deg(per);
    y = Y_lp_deg(per);

    speed = Eye_Speed_deg_inst_lp(per,:); sx=speed(:,1); sy=speed(:,2);
    
    a = sqrt(sx.^2); A = max(a); rmax = max(x);
    if A>Amin && rmax<rth && A/0.04, X=1; else, X=0; end

        a = sqrt(sy.^2); A = max(a); rmax = max(y);
    if A>Amin && rmax<rth && A/0.04, Y=1; else, Y=0; end

    if X && Y, idx=3; else, idx=1;end
    
NonSac(s,5) = idx;
end

NonSacc(:,5) = NonSac(:,5);
NonSacc((NonSacc(:,4)==2 & NonSacc(:,5)==1),5) = 2;

%%
Eye_sacc_XY_index_lp_new = double(Eye_sacc_XY_index_lp_new);
for s=1:size(NonSacc,1)
Eye_sacc_XY_index_lp_new(NonSacc(s,1):NonSacc(s,2),1) = NonSacc(s,4);
Eye_sacc_XY_index_lp_new(NonSacc(s,1):min([NonSacc(s,1)+40,NonSacc(s,2)]),1) = NonSacc(s,5);
end



end