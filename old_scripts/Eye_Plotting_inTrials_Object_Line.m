function Eye_Plotting_inTrials_Object_Line(index,cxtf,locf,ol,x,y,SaccIndex,program_folder,F_O,F_O_A,ch,o)
%%
cd([program_folder '\Image'])
cmap =jet(max(index(:,9)));



%%
X_deg_max = atand(700/1300);
Y_deg_max = atand(400/1300);
FigX = 1920;
FigY = 1120;
x=(x+X_deg_max)*FigX/(2*X_deg_max);
y = (y+Y_deg_max)*FigY/(2*Y_deg_max);
%%
figure;
ax0 = axes;

FigName = ['Cxt' num2str(cxtf) '_Loc' num2str(locf) 'C.png'];
F=imread(FigName);
imshow(rgb2gray(F));
axis on
axis ij
hold on
lw = 2;

if o~=0
if o==1
% Left Obj Option
on=ol;
else
% Right Obj Option
on=ol+6;
end

im = imshow(rgb2gray(squeeze(F_O(on,:,:,:))));
im.AlphaData = squeeze(F_O_A(on,:,:));
end

%%
for t=1:max(index(:,9))
ID = index;
id = find(and((ID(:,9)==t),(ID(:,3)~=0)));

if ch==1
% Left Choice Option
rl =  max(index(id,4));
elseif ch==2
% Right Choice Option
rl = max(index(id,5));
else
    rl=ol;
end


cl = max(index(id,1));
ll = max(index(id,2))/2;
if locf>4
    ll = ll-1;
end

void = max(index(id,10));

if  (rl==ol && cl==cxtf && ll==locf && ~void)
is = id(1);
ie = id(end);


 



cxt = index(is,1);
loc = mod(index(is,9),8);


res = index(ie,6);
cor = index(ie,8);







FixPoint = vertcat(FindFixationPoint(SaccIndex,x,y,id,'mid'),[]);


FixPoint(:,4:13) = index(FixPoint(:,3),1:10);

FixPoint(:,5) = loc;
FixPoint(:,10) = res;
FixPoint(:,11) = cor;

% if o==1
% % Left Obj Option
% FixPoint_f = FixPoint((FixPoint(:,1) > 520 & FixPoint(:,1) <805) & (FixPoint(:,2) > 330 & FixPoint(:,2) <615) & (FixPoint(:,6)>=2) ,:);   
% else
% % Right Obj Option
% FixPoint_f = FixPoint((FixPoint(:,1) > 1195 & FixPoint(:,1) <1480) & (FixPoint(:,2) > 330 & FixPoint(:,2) <615) & (FixPoint(:,6)>=2) ,:);
% end
% FixPoint_f= FixPoint(I,:);

FixPoint_f= FixPoint(FixPoint(:,6)>=2,:);
Q = QuiverFromFixation(FixPoint_f,x,y);

id_0 = find(and((ID(:,9)==t),(ID(:,3)==-1)));
id_1 = find(and((ID(:,9)==t),(ID(:,3)==1)));
id_2 = find(and((ID(:,9)==t),(ID(:,3)==2)));
id_3 = find(and((ID(:,9)==t),(ID(:,3)==3)));

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

plot(x(is_1:ie_1),y(is_1:ie_1),'Color','r','LineWidth',lw)
% hold on

% plot(x(is_0:ie_0),y(is_0:ie_0),'r--','LineWidth',lw)

% plot(x(is_1:ie_1),y(is_1:ie_1),'r','LineWidth',lw)
% plot(x(is_3:ie_3),y(is_3:ie_3),'Color',cmap(t,:),'LineWidth',lw)
% hold on
% scatter(x(is_0),y(is_0),60,'r','filled','LineWidth',1.5);
% scatter(x(ie_3),y(ie_3),60,'b','filled','LineWidth',1.5);
% if ~isempty(FixPoint_f)
%     scatter(ax0,FixPoint_f(1,1),FixPoint_f(1,2),60,'MarkerFaceColor','r','MarkerEdgeColor','k','LineWidth',1.5);
%     quiver(Q(1,1),Q(1,2),Q(1,3),Q(1,4),'Color','r','LineWidth',1.5,'MaxHeadSize',1)
% %     if size(FixPoint_f,1)>=2
% %         scatter(ax0,FixPoint_f(2,1),FixPoint_f(2,2),60,'MarkerFaceColor','b','MarkerEdgeColor','k','LineWidth',1.5);
% %         quiver(Q(2,1),Q(2,2),Q(2,3),Q(2,4),'Color','b','LineWidth',1.5,'MaxHeadSize',1)
% %     end
% end
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
end
% if o==1
% % Left Obj Option
% axis([ax0],[520 805 330 615])
% else
% % Right Obj Option
% axis([ax0],[1195 1480 330 615])
% end
end