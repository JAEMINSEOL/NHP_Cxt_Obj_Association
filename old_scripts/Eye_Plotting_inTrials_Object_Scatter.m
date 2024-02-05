function [Fix_InObj, FixPoint_All] = Eye_Plotting_inTrials_Object_Scatter(index,JoystickID_Eye,ol,x,y,SaccIndex,program_folder,F_O,F_O_A,ObjBoundary,CursorBoundary,c,o,cxtx,locx)

%%
cd([program_folder '\Image'])
cmap =jet(max(index(:,9)));
FigName = ['Cxt_Disc2.jpg'];


%%
X_deg_max = atand(700/1300);
Y_deg_max = atand(400/1300);
FigX = 1920;
FigY = 1120;
x2=(x+X_deg_max)*FigX/(2*X_deg_max);
y2 = (y+Y_deg_max)*FigY/(2*Y_deg_max);

NTrials = max(index(:,9));
Fix_InObj = NaN(NTrials,15,2);
FixPoint_All=[];
%%
figure;
ax0 = axes;
F=imread(FigName);
imshow(F);
axis on
axis ij
hold on
lw = 2;




if o==1
    % Left Obj Option
    on=ol;
else
    % Right Obj Option
    on=ol+6;
end

im = imshow(rgb2gray(squeeze(F_O(on,:,:,:))));
im.AlphaData = squeeze(F_O_A(on,:,:));


%%
for t=1:max(index(:,9))
    
    id = find(and((index(:,9)==t),(index(:,3)~=0)));
    % id = find((index(:,3)~=0));
    cxt = max(index(id,1));
    loc = mod(t,8); if loc==0 loc=8; end
    cor = max(index(id,8));
    void = max(index(id,10));
    res = max(index(id,6));
    
    if cxtx==0 cxtn=cxt; else cxtn=cxtx; end
    if locx==0 locn=loc; else locn=locx; end
    
    if c==1
        % Left Choice Option
        rl =  max(index(id,4)); rl2 =  max(index(id,4));
    elseif c==2
        % Right Choice Option
        rl = max(index(id,5)); rl2 = max(index(id,5));
    else
        rl = max(index(id,4)); rl2 = max(index(id,5));
    end
    FixPoint=[];
    if  or(rl==ol,rl2==ol) && cxtn==cxt && locn==loc && cor && ~void && res~=0
        is = id(1);
        ie = id(end);
        
        
        
        
        
        
        cxt = index(is,1);
        loc = mod(index(is,9),8); if loc==0 loc=8; end
        
        
        res = index(ie,6);
        cor = index(ie,8);
        
        
        
        
        
        
        
        FixPoint = vertcat(FindFixationPoint(SaccIndex,x2,y2,id,'mid'),[]);
        
        
        FixPoint(:,4:13) = index(FixPoint(:,3),1:10);
        FixPoint(:,14:15) = JoystickID_Eye(FixPoint(:,3),:);
        
        FixPoint(:,5) = loc;
        FixPoint(:,10) = res;
        FixPoint(:,11) = cor;
        
%         if o==1
%         % Left Obj Option
%         FixPoint_f = FixPoint((FixPoint(:,1) > 520 & FixPoint(:,1) <805) & (FixPoint(:,2) > 330 & FixPoint(:,2) <615) & (FixPoint(:,6)>=2) ,:);
%         else
%         % Right Obj Option
%         FixPoint_f = FixPoint((FixPoint(:,1) > 1195 & FixPoint(:,1) <1480) & (FixPoint(:,2) > 330 & FixPoint(:,2) <615) & (FixPoint(:,6)>=2) ,:);
%         end
%         FixPoint_f= FixPoint(I,:);
%         
        FixPoint_f_Sample= FixPoint(FixPoint(:,6)==2,:);
        FixPoint_f_Choice= FixPoint(FixPoint(:,6)==3,:);
        Q = QuiverFromFixation(FixPoint_f_Sample,x2,y2);
        
        id_0 = find(and((index(:,9)==t),(index(:,3)==-1)));
        id_1 = find(and((index(:,9)==t),(index(:,3)==1)));
        id_2 = find(and((index(:,9)==t),(index(:,3)==2)));
        id_3 = find(and((index(:,9)==t),(index(:,3)==3)));
        
        is_1 = id_1(1); is_2 = id_2(1); is_3 = id_3(1); is_0 = id_0(1);
        ie_1 = id_1(end); ie_2 = id_2(end); ie_3 = id_3(end); ie_0 = id_0(end);
        
        ChLat(1) = ie_1-is_1;
        ChLat(2) = ie_2-is_2;
        ChLat(3) = ie_3-is_3;
        
        %%
        
        
        
        % [F,camp,trans] = imread('Frame.png','BackgroundColor','none');
        % f = imshow(F,camp);
        % set(f,'AlphaData',trans)
        
        % text(1400, 900,['Choice Latency: ' num2str(ie_3-is_2) 'ms'],'FontSize',30,'FontWeight','b','Color',[.99 .99 .99])
        % text(1410, 940,['Trial ' num2str(t) ', ' Cxt ' Loc ' num2str(loc) ', ' Res ', '  Cor Void],'FontSize',20,'FontWeight','b','Color',FontC)
        % text(1530, 995,[num2str(ie_1-is_1) 'ms'],'FontSize',15,'Color','k')
        % text(1680, 995,[num2str(ie_2-is_2) 'ms'],'FontSize',15,'Color','k')
        % text(1815, 995,[num2str(ie_3-is_3) 'ms'],'FontSize',15,'Color','k')
        
        % plot(X_lp(is:ie),Y_lp(is:ie),'k')
        % hold on
        
        % plot(x(is_2:ie_3),y(is_2:ie_3),'Color','r','LineWidth',lw)
        % hold on
        
        % plot(x(is_0:ie_0),y(is_0:ie_0),'r--','LineWidth',lw)
        
        % plot(x(is_1:ie_1),y(is_1:ie_1),'r','LineWidth',lw)
        % plot(x(is_3:ie_3),y(is_3:ie_3),'Color',cmap(t,:),'LineWidth',lw)
        % hold on
        % scatter(x(is_0),y(is_0),60,'r','filled','LineWidth',1.5);
        % scatter(x(ie_3),y(ie_3),60,'b','filled','LineWidth',1.5);
        
        % if ~isempty(FixPoint_f)
        %
        %
        %
        %     scatter(ax0,FixPoint_f(1,1),FixPoint_f(1,2),150,[249 192 12]/255,'filled');
        %     %     quiver(Q(1,1),Q(1,2),Q(1,3),Q(1,4),'Color','r','LineWidth',1.5,'MaxHeadSize',1)
        %     Fix_InObj(t,1:2) = FixPoint_f(1,1:2);
        % %     in = InObj(ObjBoundary,FixPoint_f(1,:),ol);
        % %     Fix_InObj(t,3) = in;
        % end
%         Fix_InObj(t,3:3:15) = -1;
        
        for n = 1:5
            if size(FixPoint_f_Sample,1)>=n
                %         scatter(ax0,FixPoint_f(n,1),FixPoint_f(n,2),150,[0 185 241]/255,'filled');
                
                Fix_InObj(t,3*(n-1)+1:3*(n-1)+2,1) = FixPoint_f_Sample(n,1:2);
                in = InObj(ObjBoundary,FixPoint_f_Sample(n,:),on);
                
                Fix_InObj(t,3*n,1) = in;
                if (o==1) && ((FixPoint_f_Sample(n,1) > 520 && FixPoint_f_Sample(n,1) <805) && (FixPoint_f_Sample(n,2) > 330 && FixPoint_f_Sample(n,2) <615) && (FixPoint_f_Sample(n,6)>=2))
                    if in==1
                    Fix_InObj(t,3*n,1) = 2;
                    else
                       Fix_InObj(t,3*n,1) = 1; 
                    end
                elseif (o==2) && (FixPoint_f_Sample(n,1) > 1195 && FixPoint_f_Sample(n,1) <1480) && (FixPoint_f_Sample(n,2) > 330 && FixPoint_f_Sample(n,2) <615) && (FixPoint_f_Sample(n,6)>=2)
                     if in==1
                    Fix_InObj(t,3*n,1) = 2;
                    else
                       Fix_InObj(t,3*n,1) = 1; 
                    end
                end
                
                %         line(ax0,FixPoint_f(1:2,1),FixPoint_f(1:2,2),'Color','k','LineStyle','--','LineWidth',lw/2)
                %         quiver(Q(2,1),Q(2,2),Q(2,3),Q(2,4),'Color','b','LineWidth',1.5,'MaxHeadSize',1)
            end
        end
        
        for n = 1:5
            if size(FixPoint_f_Choice,1)>=n
                %         scatter(ax0,FixPoint_f(n,1),FixPoint_f(n,2),150,[0 185 241]/255,'filled');
                
                Fix_InObj(t,3*(n-1)+1:3*(n-1)+2,2) = FixPoint_f_Choice(n,1:2);
                in = InObj(ObjBoundary,FixPoint_f_Choice(n,:),on);
                
                Fix_InObj(t,3*n,2) = in;
                if (o==1) && ((FixPoint_f_Choice(n,1) > 520 && FixPoint_f_Choice(n,1) <805) && (FixPoint_f_Choice(n,2) > 330 && FixPoint_f_Choice(n,2) <615) && (FixPoint_f_Choice(n,6)>=2))
                    if in==1
                    Fix_InObj(t,3*n,2) = 2;
                    else
                       Fix_InObj(t,3*n,2) = 1; 
                    end
                elseif (o==2) && (FixPoint_f_Choice(n,1) > 1195 && FixPoint_f_Choice(n,1) <1480) && (FixPoint_f_Choice(n,2) > 330 && FixPoint_f_Choice(n,2) <615) && (FixPoint_f_Choice(n,6)>=2)
                     if in==1
                    Fix_InObj(t,3*n,2) = 2;
                    else
                       Fix_InObj(t,3*n,2) = 1; 
                    end
                end
                
                %         line(ax0,FixPoint_f(1:2,1),FixPoint_f(1:2,2),'Color','k','LineStyle','--','LineWidth',lw/2)
                %         quiver(Q(2,1),Q(2,2),Q(2,3),Q(2,4),'Color','b','LineWidth',1.5,'MaxHeadSize',1)
            end
        end
        
        FixPoint(:,16:17)=0;
        
        for n = 1:size(FixPoint,1)
            x = FixPoint(n,1); y = FixPoint(n,2); obl = FixPoint(end,7); obr = FixPoint(end,7); cb = FixPoint(n,15);
            FixPoint(n,16) = InObjIndex(x,y,obl,obr,cb,CursorBoundary,ObjBoundary);
        end
        
        if size(FixPoint_f_Sample,1)>=2
            x = mean(FixPoint_f_Sample(1:2,1));
            y = mean(FixPoint_f_Sample(1:2,2));
            obl = FixPoint(end,7); obr = FixPoint(end,7); cb = 0;
            id = find(FixPoint(:,3)==FixPoint_f_Sample(2,3));
            FixPoint(id,17) = InObjIndex(x,y,obl,obr,cb,CursorBoundary,ObjBoundary);
        end
        
        if size(FixPoint_f_Sample,1)>=3
            x = mean(FixPoint_f_Sample(1:3,1));
            y = mean(FixPoint_f_Sample(1:3,2));
            obl = FixPoint(end,7); obr = FixPoint(end,7); cb = 0;
            id = find(FixPoint(:,3)==FixPoint_f_Sample(3,3));
            FixPoint(id,17) = InObjIndex(x,y,obl,obr,cb,CursorBoundary,ObjBoundary);
        end

                
        
        
        %
        %         scatter(ax0,(FixPoint_f(1,1)+FixPoint_f(2,1))/2,(FixPoint_f(1,2)+FixPoint_f(2,2))/2,150,[124 188 126]/255,'filled');
        
        %         if size(FixPoint_f,1)>=3
        %             scatter(ax0,FixPoint_f(3,1),FixPoint_f(3,2),150,[114 0 218]/255,'filled');
        %             Fix_InObj(t,7:8) = FixPoint_f(3,1:2);
        %             in = InObj(ObjBoundary,FixPoint_f(3,:),ol);
        %             Fix_InObj(t,9) = in;
        %             %             line(ax0,FixPoint_f(2:3,1),FixPoint_f(2:3,2),'Color','k','LineStyle','--','LineWidth',lw/2)
        %             %             %         quiver(Q(2,1),Q(2,2),Q(2,3),Q(2,4),'Color','b','LineWidth',1.5,'MaxHeadSize',1)
        %     end
        
        
        hold on
        
        
        % scatter(Eye_Sacc_X(is:ie),Eye_Sacc_Y(is:ie),7,'r','filled')
        % xlabel('X(degree)'); ylabel('Y(degree)');
        % set([ax0],'Position',[.13 .13 .7 .7]);
        
        
        
        %%
        % z= [1:length(x(is:ie))]*0.001;
        % figure;
        % surf([x(is:ie) x(is:ie)], [y(is:ie) y(is:ie)], [z(:) z(:)], ...  % Reshape and replicate data
        %      'FaceColor', 'none', ...    % Don't bother filling faces with color
        %      'EdgeColor', 'interp', ...  % Use interpolated color for edges
        %      'LineWidth', 2);            % Make a thicker line
        % view(2);   % Default 2-D view
        % colormap('jet')
        % colorbar;  % Add a colorbar
        % xlim([-30 30]); ylim([-20 20]);
        % xlabel('X(degree)'); ylabel('Y(degree)');
        % axis ij
    end
    FixPoint_All = vertcat(FixPoint_All,FixPoint);

end

if o==1
    % Left Obj Option
    axis([ax0],[520 805 330 615])
else
    % Right Obj Option
    axis([ax0],[1195 1480 330 615])
end
function Idx = InObjIndex(x,y,ol,or,c,CursorBoundary,ObjBoundary)
                        inol = InObj(ObjBoundary,[x,y],ol);
            indl = ((x > 520 && x <805) && (y > 330 && y <615));
            inl = inol+indl;
            inor = InObj(ObjBoundary,[x,y],or+6);
            indr = ((x > 1195 && x <1480) && (y > 330 && y <615));
            inr=inor+indr;
            inc = InCursor(CursorBoundary,[x,y],c+6);
            if inr~=0 inr=inr+2; end
            if and(inl,inr)
                Idx=0;
            else
                Idx = inl+inr;
            end
            if inc
                Idx = 5;
            end
end

    function in = InObj(ObjBoundary,FixPoint_f,ol)
        xv = ObjBoundary(ol,:,1)'; xv(isnan(xv))=[];
        yv = ObjBoundary(ol,:,2)'; yv(isnan(yv))=[];
        
        xq = FixPoint_f(1,1);
        yq = FixPoint_f(1,2);
        [in,oxn] = inpolygon(xq,yq,xv,yv);
    end

    function in = InCursor(CursorBoundary,FixPoint_f,c)
        xc = floor(FixPoint_f(:,1)); if xc<=0 xc=1; end
        yc = floor(FixPoint_f(:,2)); if yc<=0 yc=1; end
        if CursorBoundary(c,yc,xc) ~=0
            in=1;
        else
            in=0;
        end
    end

end