
function Display_EyeGaze(Eye_Analog)
moveX = 0;
moveY = 9;
EyeGaze_Overall = zeros(108,192);

for j = 1:size(Eye_Analog,1)
   x = round((Eye_Analog(j,2))/10)+moveY;
   y = round((Eye_Analog(j,3))/10)+moveX;
   if 1<x && 1<y && 192>=x && 108>=y
   EyeGaze_Overall(y,x) = EyeGaze_Overall(y,x)+1;
   end
end
   EyeGaze_Overall = EyeGaze_Overall(1:108,1:192);
h = imagesc(EyeGaze_Overall);
        colormap(jet);
    thisAlphaZ = EyeGaze_Overall;
    thisAlphaZ(isnan(EyeGaze_Overall)) = 0;
    thisAlphaZ(~isnan(EyeGaze_Overall)) = 1;
    hold on
    
       alpha(thisAlphaZ);axis off;
      j=1;
    minmaxColor = get(gca, 'CLim');
    if minmaxColor(1) == -1 && minmaxColor(2) == 1
        minmaxColor(2)=0.1;
    end
    
    maxColor(j) = minmaxColor(2);
    j=j+1;  
    hold on
MAXcolor=max(maxColor);
if MAXcolor<1
    MAXcolor=1;
end
set(gca,'CLim', [0 maxColor(1)]);
