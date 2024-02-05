obj=5;
levels = 4096;
Resolution =1;
%%
for obj = 1:6
    for r= 1:2
        for num=1:5
            Res = Res_Name(r);
            Obj= Obj_Name(obj);
            FigName = ['Cxt_AllLoc'];
            f = figure;
            ax0 = axes;
            F_BG = imread([FigName '.png']);
            
            
            imshow(F_BG,'parent',ax0);
            
            axis off
            hold on
            ax1 = axes;
            if r==1
            F_O = imread(['ObjL' num2str(obj) '.png']);
            elseif r==2
                F_O = imread(['ObjR' num2str(obj) '.png']);
            end
            F_O_A = MakeTransLImage( F_O,0.5);
            im = image(F_O);
            im.AlphaData = F_O_A;
            axis off
            xmax = 2005; xmin= 0;
            ymax = 1125; ymin = 0;
            
            
            
            Pool = sortrows(FixPoint_All(:,:),12);
            
            for t = 1:NTrials
                Pool_temp = find(and(Pool(:,12)==t,Pool(:,6)==2));
                for i=1:5
                    if size(Pool_temp,1)>=i
                        Pool(Pool_temp(i),18)=i;
                    end
                end
            end
            id = find(and(and(and(and(Pool(:,r+6)==obj,Pool(:,6)==2),Pool(:,11)==1),Pool(:,13)==0),Pool(:,18)==num));
            X = vertcat(Pool(id,1),[xmin;xmax]); Y = vertcat(Pool(id,2),[ymin;ymax]);
            ax2 = DataDensityPlot( X, Y, levels,1920,1080,Resolution,xmin,xmax,ymin,ymax);
            colormap(ax2,jet(levels));
            
            alpha(0.5)
            axis off
            hold on
            
            set([ax0,ax1,ax2],'Position',[.17 .173 .685 .689]);

            title([Obj '-' Res '-Sample(' num2str(num) ')'])
        end
    end
end