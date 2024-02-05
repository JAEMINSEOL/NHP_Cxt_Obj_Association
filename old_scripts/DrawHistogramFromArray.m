function DrawHistogramFromArray(Array, Cxt, LeftObj, RightObj, YMax)
if Cxt == 1
    Color = [1 0 0];
else
    Color = [0 0 1];
end

% plot(Raster(:,1), Raster(:,2),'MarkerSize',10,'Marker','.','LineWidth',2,'LineStyle','none',...
%     'Color','b');
% ylim([0 max(Raster(:,3))])
% % yticks(0:1:max(Raster(:,3)))
% 
% for i = 2: max(Raster(:,3))
%     line([Raster(i-1,4) Raster(i,4)], [i-1 i],'Color','r','LineWidth',1.5)
%     line([Raster(i-1,4)+Raster(i-1,5) Raster(i,4)+Raster(i,5)], [i-1 i],'Color',[0 191 225]/225,'LineWidth',1.5)
% end
% R = rmmissing(Raster,1,'MinNumMissing',2);
% plot((R(:,1)*10),R(:,2), 'MarkerSize',5,'Marker','.','LineWidth',2,'LineStyle','none','Color','k');

% ylim([0 max(Raster(:,3))])
% yticks([0 max(Raster(:,3))])
% xlabel('Time (s)')
% ylabel('Trial')
bar(Array(1:5),'FaceColor', 'w','EdgeColor','k');
hold on
bar(horzcat(zeros(1,5),Array(6:10)),'FaceColor', [0.5 0.5 0.5]);
hold on
bar(horzcat(zeros(1,10),Array(11:15)),'FaceColor', 'w','EdgeColor','k');
hold on
bar(horzcat(zeros(1,15),Array(16:20)),'FaceColor', 'k');





LeftObjName = NameObj (LeftObj);
RightObjName = NameObj (RightObj);
if mod(LeftObj,2) == mod(Cxt,2)
    CorrChoice = 'Left';
else
    CorrChoice = 'Right';
end

ax= gca;
if Cxt==1
    CxtName = 'Forest';
%     ax.XColor = 'r';
%     ax.YColor = 'r';
else
    CxtName = 'City';
%     ax.XColor = 'b';
%     ax.YColor = 'b';
end


pbaspect([2 1 1])
ylim([0 YMax+1])

xticks([2.5 7.5 12.5 17.5])
xticklabels({'PreCr', 'PreSp', 'Sp', 'Ch'})
title([CxtName ',' LeftObjName ',' RightObjName ',' CorrChoice],'Fontsize', 8)
if Cxt == 1
    if LeftObj==1 || RightObj==1
ylabel('FR(Hz)','FontSize',7)
    end
end

set(gca,'XTickLabel',get(gca,'XTickLabel'),'fontsize',8,'FontWeight','bold')

line([5.5 5.5], [0 YMax+1],'color','k')
line([10.5 10.5], [0 YMax+1],'color','k')
line([15.5 15.5], [0 YMax+1],'color','k')

    function ObjName = NameObj (ObjNum)
        switch ObjNum
            case 0
                ObjName = 'Donut';
            case 1
                ObjName = 'Pumpkin';
            case 2
                ObjName = 'Turtle';
            case 3
                ObjName = 'Jellyfish';
            case 4
                ObjName = 'Octopus';
            case 5
                ObjName = 'Pizza';
        end
    end
end