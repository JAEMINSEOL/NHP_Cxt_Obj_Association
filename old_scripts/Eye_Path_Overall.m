% Eye_Plotting_inTrials(Eye_Analog_sync_recording_info(:,4:13),t,X_lp_deg,Y_lp_deg,Eye_sacc_XY_index_lp(:,1));
function Eye_Path_Overall(index,t,x,y,SaccIndex)
%%
index = Eye_Analog_sync_recording_info(:,4:13);
x= X_lp;
y = Y_lp;

for ol=4:4
or=0;
res=1;
ID = index;
figure;

ax0=axes;
imshow('Cxt1_Loc1C.png');
set([ax0],'Position',[.17 .173 .685 .689]);
axis off

if ol~=0
    FigName_Obj = ['ObjL' num2str(ol)];
elseif or~=0
    FigName_Obj = ['ObjR' num2str(or)];
end

    ax1=axes;
    set([ax1],'Position',[.17 .173 .685 .689]);
if ~isempty(FigName_Obj)

F_O = imread([FigName_Obj '.png']);
F_O_A = MakeTransLImage( F_O,FigName_Obj);
im = image(F_O);
im.AlphaData = F_O_A;
end

axis off


ax2=axes;
c=jet(max(ID(:,9)));
for t=1:max(ID(:,9))

id = find(and(and(and(and(and((ID(:,9)==t),(ID(:,3)==3)),ID(:,10)==0),ID(:,4)==ol),1),ID(:,7)==res));
if ~isempty(id)
is = id(1);
ie = id(end);
X_deg_max = atand(700/1300);
Y_deg_max = atand(400/1300);
FigX = 1920;
FigY = 1120;

% 
% x=(x+X_deg_max)*FigX/(2*X_deg_max);
% y = (y+Y_deg_max)*FigY/(2*Y_deg_max);

z= [1:length(x(is:ie))]*0.001;
line(ax2,[x(is:ie) x(is:ie)], [y(is:ie) y(is:ie)],'Color',c(t,:),'LineWidth', 1);            % Make a thicker line
view(2);   % Default 2-D view

 hold on
 
end

end
set([ax2],'Position',[.17 .173 .685 .689]);
axis off
axis ij
   xlim([-5 5]); ylim([-5 5])


xlabel('X(degree)'); ylabel('Y(degree)');
end
