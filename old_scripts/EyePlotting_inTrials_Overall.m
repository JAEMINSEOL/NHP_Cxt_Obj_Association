function EyePlotting_inTrials_Overall(cxt,loc,res,ol,or,FixPoint_Intrials,program_folder)

%%
FigName = ['Cxt' num2str(cxt) '_Loc' num2str(loc) 'N'];

if cxt==0
    FixPoint_Intrials(:,4)=0;
    Cxt = 'All';
else
    Cxt = Cxt_Name(cxt);
end

if loc==0
    FixPoint_Intrials(:,5)=0;
    Loc = 'All';
    FigName = ['Cxt_AllLoc'];
else
    Loc = num2str(loc);
end

if res==0
    FixPoint_Intrials(:,10)=0;
    Res = 'L/R';
else
    Res = Res_Name(res);
end

if ol==0
    FixPoint_Intrials(:,7)=0;
    ObjL = '';
else
    if mod(ol,2)==0
        on=ol-2;
    else
        on=ol;
    end
    ObjL = ['L' ObjName(on)];
end

if or==0
    FixPoint_Intrials(:,8)=0;
    ObjR = '';
else
    if mod(or,2)==0
        on=or-2;
    else
        on=or;
    end
    ObjR = ['R' ObjName(on)];
end


%%

%%
cd([program_folder '\Image'])
figure;
ax0=axes;
F_BG = imread([FigName '.png']);
F_BG_G = rgb2gray(F_BG);
F_BG_S = imresize(F_BG,[1125 2005]);
imshow(F_BG_S);

hold on
axis off
FigName_Obj=[];
if ol~=0
    FigName_Obj = ['ObjL' num2str(ol)];
elseif or~=0
    FigName_Obj = ['ObjR' num2str(or)];
end

    ax1=axes;
if ~isempty(FigName_Obj)

F_O = imread([FigName_Obj '.png']);
F_O_A = MakeTransLImage( F_O,FigName_Obj);
im = image(F_O);
im.AlphaData = F_O_A;
end
axis off
lw = 1;
sz = 80;



% [F,camp,trans] = imread('Frame.png','BackgroundColor','none');
% f = imshow(F,camp);
% % set(f,'AlphaData',trans)
hold on
id = find(and(and(and(and(and(and(and(FixPoint_Intrials(:,4)==cxt,FixPoint_Intrials(:,5)==loc),FixPoint_Intrials(:,10)==res), FixPoint_Intrials(:,11)==0), FixPoint_Intrials(:,6)==-1), FixPoint_Intrials(:,13)==0),FixPoint_Intrials(:,7)==ol),FixPoint_Intrials(:,8)==or));
scatter(ax0,FixPoint_Intrials(id,1),FixPoint_Intrials(id,2),sz,'c+','LineWidth',lw);
hold on
id = find(and(and(and(and(and(and(and(FixPoint_Intrials(:,4)==cxt,FixPoint_Intrials(:,5)==loc),FixPoint_Intrials(:,10)==res), FixPoint_Intrials(:,11)==0), FixPoint_Intrials(:,6)==1), FixPoint_Intrials(:,13)==0),FixPoint_Intrials(:,7)==ol),FixPoint_Intrials(:,8)==or));
scatter(ax0,FixPoint_Intrials(id,1),FixPoint_Intrials(id,2),sz,'m+','LineWidth',lw);
hold on
id = find(and(and(and(and(and(and(and(FixPoint_Intrials(:,4)==cxt,FixPoint_Intrials(:,5)==loc),FixPoint_Intrials(:,10)==res), FixPoint_Intrials(:,11)==0), FixPoint_Intrials(:,6)==2), FixPoint_Intrials(:,13)==0),FixPoint_Intrials(:,7)==ol),FixPoint_Intrials(:,8)==or));
scatter(ax0,FixPoint_Intrials(id,1),FixPoint_Intrials(id,2),sz,'r+','LineWidth',lw);
hold on
id = find(and(and(and(and(and(and(and(FixPoint_Intrials(:,4)==cxt,FixPoint_Intrials(:,5)==loc),FixPoint_Intrials(:,10)==res), FixPoint_Intrials(:,11)==0), FixPoint_Intrials(:,6)==3), FixPoint_Intrials(:,13)==0),FixPoint_Intrials(:,7)==ol),FixPoint_Intrials(:,8)==or));
scatter(ax0, FixPoint_Intrials(id,1),FixPoint_Intrials(id,2),sz,'g+','LineWidth',lw);
legend(ax0,{'Pre-Cursor','Pre-Sample','Sample','Choice'},'location','south','FontSize',20)
set([ax0,ax1],'Position',[.13 .13 .7 .7]);
title([Cxt '_Loc' Loc '_' ObjL ObjR '_' Res '_Wrong'],'FontSize', 20,'Color', 'k','Interpreter','none','FontWeight','b')

saveas(gcf,['Scatter_' Cxt '_Loc' Loc '_' ObjL ObjR '_' Res '_Wrong.png'])
close gcf
end