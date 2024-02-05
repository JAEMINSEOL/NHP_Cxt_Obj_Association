function [ChLat,FixPoint] = Eye_Plotting_inTrials(index,t,x,y,SaccIndex)
%%
cd('F:\NHP project\실험 셋업 자료\Unreal Assets')

ID = index;
id = find(and((ID(:,9)==t),(ID(:,3)~=0)));
is = id(1);
ie = id(end);
X_deg_max = atand(700/1300);
Y_deg_max = atand(400/1300);
FigX = 1920;
FigY = 1120;

            

cxt = index(is,1);
loc = mod(index(is,9),8);
if loc==0 loc=8; end

res = index(ie,6);
cor = index(ie,8);
void = index(ie,10);
if void==1 Void=', Void'; else Void=''; end
if or(cor==0,void==1) FontC='r'; else FontC='k'; end

FigName = ['Cxt' num2str(cxt) '_Loc' num2str(loc) '.png'];
Cxt = Cxt_Name(cxt);
Res = Res_Name(res);
Cor = Cor_Name(cor);



x=(x+X_deg_max)*FigX/(2*X_deg_max);
y = (y+Y_deg_max)*FigY/(2*Y_deg_max);

FixPoint = vertcat(FindFixationPoint(SaccIndex,x,y,id,'first'),FindFixationPoint(SaccIndex,x,y,id,'last'));


FixPoint(:,4:13) = index(FixPoint(:,3),1:10);

FixPoint(:,5) = loc;
FixPoint(:,10) = res;
FixPoint(:,11) = cor;



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
figure;
imshow(FigName);
axis on
hold on;
lw = 2;

[F,camp,trans] = imread('Frame.png','BackgroundColor','none');
f = imshow(F,camp);
set(f,'AlphaData',trans)

text(1400, 900,['Choice Latency: ' num2str(ie_3-is_2) 'ms'],'FontSize',30,'FontWeight','b','Color',[.99 .99 .99])
text(1410, 940,['Trial ' num2str(t) ', ' Cxt ' Loc ' num2str(loc) ', ' Res ', '  Cor Void],'FontSize',20,'FontWeight','b','Color',FontC)
text(1530, 995,[num2str(ie_1-is_1) 'ms'],'FontSize',15,'Color','k')
text(1680, 995,[num2str(ie_2-is_2) 'ms'],'FontSize',15,'Color','k')
text(1815, 995,[num2str(ie_3-is_3) 'ms'],'FontSize',15,'Color','k')

% plot(X_lp(is:ie),Y_lp(is:ie),'k')
% hold on
plot(x(is_2:ie_2),y(is_2:ie_2),'y','LineWidth',lw)
hold on
plot(x(is_0:ie_0),y(is_0:ie_0),'r--','LineWidth',lw)

plot(x(is_1:ie_1),y(is_1:ie_1),'r','LineWidth',lw)
plot(x(is_3:ie_3),y(is_3:ie_3),'b','LineWidth',lw)
scatter(x(is_0),y(is_0),60,'r','filled','LineWidth',1.5);
scatter(x(ie_3),y(ie_3),60,'b','filled','LineWidth',1.5);
scatter(FixPoint(:,1),FixPoint(:,2),60,'g','LineWidth',1.5);



% scatter(Eye_Sacc_X(is:ie),Eye_Sacc_Y(is:ie),7,'r','filled')
xlim([0 FigX]); ylim([0 FigY]);
% xlabel('X(degree)'); ylabel('Y(degree)');
axis ij

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