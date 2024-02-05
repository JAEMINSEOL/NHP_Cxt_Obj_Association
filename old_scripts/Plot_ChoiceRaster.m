figure;

YMax = max(max(ChoiceArray));
for c = 1:2
    if c==1
        Color = 'r';
    else
        Color = 'b';
    end
for i = 0:2
hold on
subplot(6,6,0+3*(c-1)+i+1)
DrawHistogramFromArray(ChoiceArray(c*18+i*6-17,:),ChoiceRaster(:,:,c*18+i*6-17),c, 2*i+1, 0, YMax)



hold on
subplot(6,6,6+3*(c-1)+i+1)
DrawHistogramFromArray(ChoiceArray(c*18+i*6-16,:),ChoiceRaster(:,:,c*18+i*6-16),c, 0, 2*i+1, YMax)

subplot(6,6,12+3*(c-1)+i+1)
DrawHistogramFromArray(ChoiceArray(c*18+i*6-15,:),ChoiceRaster(:,:,c*18+i*6-15),c, 2*i+1, 2, YMax)
subplot(6,6,18+3*(c-1)+i+1)
DrawHistogramFromArray(ChoiceArray(c*18+i*6-14,:),ChoiceRaster(:,:,c*18+i*6-14),c, 2, 2*i+1, YMax)

subplot(6,6,24+3*(c-1)+i+1)
DrawHistogramFromArray(ChoiceArray(c*18+i*6-13,:),ChoiceRaster(:,:,c*18+i*6-13),c, 2*i+1, 4, YMax)
subplot(6,6,30+3*(c-1)+i+1)
DrawHistogramFromArray(ChoiceArray(c*18+i*6-12,:),ChoiceRaster(:,:,c*18+i*6-12),c, 4, 2*i+1, YMax)

end

end










