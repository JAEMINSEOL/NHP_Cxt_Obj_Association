

%% Overall InTrial Fixation HeatMap
levels = 4096;
Resolution =1;

for cxt = 1:2
    for loc = 1:8
        for p = -1:3
            for res=1:2
                if p~=0
                    Cxt=Cxt_Name(cxt);
                    Phase = Phase_Name(p);
                    Res=Res_Name(res);
                    FigName = ['Cxt' num2str(cxt) '_Loc' num2str(loc)];
                    f = figure;
                    ax0 = axes;
                    F_BG = imread([FigName 'N.png']);
                    
                    
                    imshow(F_BG,'parent',ax0);
                    
                    axis off
                    hold on
                    xmax = 2005; xmin= 0;
                    ymax = 1125; ymin = 0;
                    
                    
                    id = find(and(and(and(and(FixPoint_Intrials(:,4)==cxt,FixPoint_Intrials(:,5)==loc),FixPoint_Intrials(:,6)==p),FixPoint_Intrials(:,10)==res),FixPoint_Intrials(:,11)==0));
                    X = vertcat(FixPoint_Intrials(id,1)+80,[xmin;xmax]); Y = vertcat(FixPoint_Intrials(id,2)+45,[ymin;ymax]);
                    ax1 = DataDensityPlot( X, Y, levels,1920,1080,Resolution,xmax,ymax);
                    colormap(ax1,jet(levels));
                    alpha(0.5)
                    
                    
                    axis off
                    
                    hold on
                    
                    
                    axis off
                    
                    c1 = colorbar(ax1,'location','southoutside','Ticks',[(levels+1)*0.25 (levels+1)*0.5 (levels+1)*0.75 levels+1],'TickLabels',{'0.25' '0.5' '0.75' '1'},'Fontsize',15);
                    c1.Label.String = 'Fixation Density (Normalized)';
                    
                    set([ax0,ax1],'Position',[.17 .173 .685 .689]);
                    
                    
                    
                    title([Cxt '_Loc' num2str(loc) '_' Res '_' Phase '_Wrong'],'FontSize', 20,'Color', 'k','Interpreter','none','FontWeight','b')
                    
                    saveas(f,[Cxt '_Loc' num2str(loc) '_' Res '_' Phase '_N_Wrong.png'])
                    close gcf
                end
            end
        end
    end
end
%% InTrial Fixation HeatMap_Loc
levels = 4096;
Resolution =1;
for cxt = 1:2
    for p = -1:3
        for res=1:2
            if p~=0
                Cxt=Cxt_Name(cxt);
                Phase = Phase_Name(p);
                Res=Res_Name(res);
                FigName = ['Cxt_AllLoc'];
                f = figure;
                ax0 = axes;
                F_BG = imread([FigName '.png']);
                
                
                imshow(F_BG,'parent',ax0);
                
                axis off
                hold on
                xmax = 2005; xmin= 0;
                ymax = 1125; ymin = 0;
                
                id = find(and(and(and(and(FixPoint_Intrials(:,4)==cxt,1),FixPoint_Intrials(:,6)==p),FixPoint_Intrials(:,10)==res),FixPoint_Intrials(:,11)==0));
                X = vertcat(FixPoint_Intrials(id,1)+80,[xmin;xmax]); Y = vertcat(FixPoint_Intrials(id,2)+45,[ymin;ymax]);
                ax1 = DataDensityPlot( X, Y, levels,1920,1080,Resolution,xmax,ymax);
                colormap(ax1,jet(levels));
                alpha(0.5)
                
                
                axis off
                
                hold on
                
                c1 = colorbar(ax1,'location','southoutside','Ticks',[(levels+1)*0.25 (levels+1)*0.5 (levels+1)*0.75 levels+1],'TickLabels',{'0.25' '0.5' '0.75' '1'},'Fontsize',15);
                c1.Label.String = 'Fixation Density (Normalized)';
                
                set([ax0,ax1],'Position',[.17 .173 .685 .689]);
                
                
                title([Cxt '_AllLoc'  '_' Res '_' Phase '_Wrong'],'FontSize', 20,'Color', 'k','Interpreter','none','FontWeight','b')
                
                saveas(f,[Cxt '_AllLoc' '_' Res '_' Phase '_N_Wrong.png'])
                close gcf
                
            end
        end
    end
end


%% InTrial Fixation HeatMap_Obj
levels = 4096;
Resolution =1;
WinSize=20;
for cxt = 1:1
    for p = 2:3
        for ol=1:6
            for res=1:2
                
                Res=Res_Name(res);
                Phase = Phase_Name(p);
                if mod(ol,2)==0
                    on=ol-2;
                else
                    on=ol;
                end
                OL=ObjName(on);
                
                FigName = ['Cxt_AllLoc'];
                f = figure;
                ax0 = axes;
                F_BG = imread([FigName '.png']);
                F_BG_G = rgb2gray(F_BG);
                
                imshow(F_BG,'parent',ax0);
                
                axis off
                hold on
                
                ax1 = axes;
                F_O = imread(['ObjL' num2str(ol) '.png']);
                F_O_A = MakeTransLImage( F_O,['ObjL' num2str(ol)]);
                im = image(F_O);
                im.AlphaData = F_O_A;
                axis off
                
                xmax = 2005; xmin= 0;
                ymax = 1125; ymin = 0;
                
                id = find(and(and(and(and(1,FixPoint_Intrials(:,10)==res),FixPoint_Intrials(:,6)==p),FixPoint_Intrials(:,7)==ol),FixPoint_Intrials(:,11)==0));
                X = vertcat(FixPoint_Intrials(id,1)+80,[xmin;xmax]); Y = vertcat(FixPoint_Intrials(id,2)+45,[ymin;ymax]);
                ax2 = DataDensityPlot( X, Y, levels,1920,1080,Resolution,xmax,ymax);
                colormap(ax2,jet(levels));
                alpha(0.5)
                
                hold on
                
                
                axis off
                
                c1 = colorbar(ax2,'location','southoutside','Ticks',[(levels+1)*0.25 (levels+1)*0.5 (levels+1)*0.75 levels+1],'TickLabels',{'0.25' '0.5' '0.75' '1'},'Fontsize',15);
                c1.Label.String = 'Fixation Density (Normalized)';
                
                
                
                
                set([ax0,ax1,ax2],'Position',[.13 .13 .7 .7]);
                title(['AllCxt_AllLoc_L' '_' OL '_Choice' Res '_'  Phase '_Wrong'],'FontSize', 20,'Color', 'k','Interpreter','none','FontWeight','b')
                
                saveas(f,['AllCxt_AllLoc_L' '_' OL '_Choice' Res '_'  Phase '_N_Wrong.png'])
                close gcf
            end
            
            for or=1:6
                
                Phase = Phase_Name(p);
                if mod(or,2)==0
                    on=or-2;
                else
                    on=or;
                end
                OR=ObjName(on);
                
                FigName = ['Cxt_AllLoc'];
                f = figure;
                ax0 = axes;
                F_BG = imread([FigName '.png']);
                F_BG_G = rgb2gray(F_BG);
                
                imshow(F_BG,'parent',ax0);
                
                axis off
                hold on
                
                ax1 = axes;
                F_O = imread(['ObjR' num2str(or) '.png']);
                F_O_A = MakeTransLImage( F_O,['ObjR' num2str(or)]);
                im = image(F_O);
                im.AlphaData = F_O_A;
                axis off
                
                xmax = 2005; xmin= 0;
                ymax = 1125; ymin = 0;
                
                id = find(and(and(and(and(1,FixPoint_Intrials(:,10)==res),FixPoint_Intrials(:,6)==p),FixPoint_Intrials(:,8)==or),FixPoint_Intrials(:,11)==0));
                X = vertcat(FixPoint_Intrials(id,1)+80,[xmin;xmax]); Y = vertcat(FixPoint_Intrials(id,2)+45,[ymin;ymax]);
                ax2 = DataDensityPlot( X, Y, levels,1920,1080,Resolution,xmax,ymax);
                colormap(ax2,jet(levels));
                alpha(0.5)
                hold on
                
                axis off
                
                c1 = colorbar(ax2,'location','southoutside','Ticks',[(levels+1)*0.25 (levels+1)*0.5 (levels+1)*0.75 levels+1],'TickLabels',{'0.25' '0.5' '0.75' '1'},'Fontsize',15);
                c1.Label.String = 'Fixation Density (Normalized)';
                
                
                
                set([ax0,ax1,ax2],'Position',[.13 .13 .7 .7]);
                title(['AllCxt_AllLoc_R' '_' OR '_Choice' Res '_'  Phase '_Wrong'],'FontSize', 20,'Color', 'k','Interpreter','none','FontWeight','b')
                
                saveas(f,['AllCxt_AllLoc_R' '_' OR '_Choice' Res '_' Phase '_N_Wrong.png'])
                close gcf
            end
        end
    end
end