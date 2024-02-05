Eye_AllRegion = zeros(54, 96);
Eye_LeftObj = NaN(54, 96);
Eye_RightObj = NaN(54, 96);
Eye_LeftDisc = NaN(54, 96);
Eye_RightDisc = NaN(54, 96);
Eye_InterDisc = NaN(54, 96);

for i = 1:96
    for j = 1:54
        if i>=32.5 && i <= 64.5 && j>=18 && j<=30
            Eye_AllRegion(j,i) = 0.5;
        end
        
        if (i-32.5)^2 + (j - 24)^2 <= 46
            Eye_AllRegion(j,i) = -0.8;
        end
        if (i-64.5)^2 + (j - 24)^2 <= 46
            Eye_AllRegion(j,i) = 0.8;
        end
        if (i-32.5)^2 + (j - 24)^2 <= 23
            Eye_AllRegion(j,i) = -2;
        end
        if (i-64.5)^2 + (j - 24)^2 <= 23
            Eye_AllRegion(j,i) = 2;
        end
        
        if Eye_AllRegion(j,i) >= 0.6
            Eye_LeftDisc(j,i) = 1;
        elseif Eye_AllRegion(j,i) <= -0.6
        Eye_RightDisc(j,i) = 1;
        elseif Eye_AllRegion(j,i) == 0.5
        Eye_InterDisc(j,i) = 1;
        end
        
    end
end
% imagesc(Eye_AllRegion)
% caxis([-2 2])
% colorbar('Limits', [-2 2])

Eye_FR_Forest_Left_LeftDisc = reshape(Eye_forest_left_skaggsrateMat .* Eye_LeftDisc,[],1);
Eye_FR_Forest_Left_RightDisc = reshape(Eye_forest_left_skaggsrateMat .* Eye_RightDisc,[],1);
Eye_FR_Forest_Left_InterDisc = reshape(Eye_forest_left_skaggsrateMat .* Eye_InterDisc,[],1);
Eye_FR_Forest_Right_LeftDisc = reshape(Eye_forest_right_skaggsrateMat .* Eye_LeftDisc,[],1);
Eye_FR_Forest_Right_RightDisc = reshape(Eye_forest_right_skaggsrateMat .* Eye_RightDisc,[],1);
Eye_FR_Forest_Right_InterDisc = reshape(Eye_forest_right_skaggsrateMat .* Eye_InterDisc,[],1);

Eye_FR_City_Left_LeftDisc = reshape(Eye_city_left_skaggsrateMat .* Eye_LeftDisc,[],1);
Eye_FR_City_Left_RightDisc = reshape(Eye_city_left_skaggsrateMat .* Eye_RightDisc,[],1);
Eye_FR_City_Left_InterDisc = reshape(Eye_city_left_skaggsrateMat .* Eye_InterDisc,[],1);
Eye_FR_City_Right_LeftDisc = reshape(Eye_city_right_skaggsrateMat .* Eye_LeftDisc,[],1);
Eye_FR_City_Right_RightDisc = reshape(Eye_city_right_skaggsrateMat .* Eye_RightDisc,[],1);
Eye_FR_City_Right_InterDisc = reshape(Eye_city_right_skaggsrateMat .* Eye_InterDisc,[],1);

Eye_FR_Overall_LeftDisc = reshape(Eye_skaggsrateMat .* Eye_LeftDisc,[],1);
Eye_FR_Overall_RightDisc = reshape(Eye_skaggsrateMat .* Eye_RightDisc,[],1);
Eye_FR_Overall_InterDisc = reshape(Eye_skaggsrateMat .* Eye_InterDisc,[],1);

max_graph = max(vertcat(nanmean(Eye_FR_Overall_LeftDisc), nanmean(Eye_FR_Overall_RightDisc), nanmean(Eye_FR_Overall_InterDisc), nanmean(Eye_FR_Forest_Left_LeftDisc), nanmean(Eye_FR_Forest_Left_RightDisc), nanmean(Eye_FR_Forest_Left_InterDisc), ...
    nanmean(Eye_FR_Forest_Right_LeftDisc), nanmean(Eye_FR_Forest_Right_RightDisc), nanmean(Eye_FR_Forest_Right_InterDisc), nanmean(Eye_FR_City_Left_LeftDisc), nanmean(Eye_FR_City_Left_RightDisc), nanmean(Eye_FR_City_Left_InterDisc), ...
    nanmean(Eye_FR_City_Right_LeftDisc), nanmean(Eye_FR_City_Right_RightDisc), nanmean(Eye_FR_City_Right_InterDisc)));


