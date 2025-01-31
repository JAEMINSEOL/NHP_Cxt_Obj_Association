% Z2_display_choice_event_video
phase_s = 'TrialStart';
%%
% load(['X:\E-Phys Analysis\NHP project\Eye_parsed\' phase_s '_600ms.mat'])
% % sample_num = randperm(size(whole_set,2),10000);
% part_set = whole_set(sample_num);
% clear whole_set
% save(['X:\E-Phys Analysis\NHP project\Eye_parsed\' phase_s '_600ms_part.mat'],'part_set','sample_num')
% save(['X:\E-Phys Analysis\NHP project\Eye_parsed\sample_num.mat'],'sample_num')
%%
ROOT.raw.data = 'X:\E-Phys Analysis\NHP project\Eye_parsed';
% ROOT.raw.fig = 'D:\NHP project\Unreal Assets';
ROOT.raw.fig = 'D:\NHP_project\실험 셋업 자료\Unreal Assets';

%% draw gif
load([ROOT.raw.data '\' phase_s '_600ms_part.mat'])
% sample_num = sort(sample_num);
s0=[];s1=[];s2=[];s3=[];sc=[]; sz=100; lens = 300; adds = 0; st = 2; fsz=12;
for t=1:1000
    samp = sample_num(t);
    TInfo = part_set(t).trial_info;
    flag=1;
tr =  rem(TInfo.Trial(1),8);
cxt = TInfo.Context(1); if cxt==1, cxt_s = 'Forest'; else, cxt_s='City'; end
dir = TInfo.Direction(1); if dir==1, dir_s='Outbound'; else, dir_s='Inbound'; end
cho = TInfo.CorrectAnswer(1); if cho==0, cho_s='Left'; else, cho_s='Right'; end
animal = TInfo.Animal(1); if animal==1, animal_s = 'Nabi'; else, animal_s='Yoda'; end
if TInfo.Choice(1)==TInfo.CorrectAnswer(1), cor_s='Correct'; else, cor_s='Wrong'; end
obj_l = TInfo.ObjectLeft{1}; obj_r = TInfo.ObjectRight{1};
 loc = tr; if tr==0, loc=8; end
cmap = jet(lens+adds);

% ROOT.save.fig = ['D:\NHP project\Sample_imgs\' phase_s '\' animal_s '\' dir_s];
ROOT.save.fig = ['D:\NHP_project\Analysis\Figures\sample_imgs\' phase_s '\' animal_s '\' dir_s];
if ~exist(ROOT.save.fig), mkdir(ROOT.save.fig); end
filename = [animal_s '_loc' num2str(loc) '_' phase_s '_sample ' num2str(t) '(' num2str(samp) ')_' num2str(lens) 'ms.gif'];

figure('position',[119,173,1768,805])
subplot('Position',[.05 .15 .3 .7])
d = part_set(t).data(1:lens+adds,:);
colors = jet(numel(d.time));
plot3(d.X,d.Y,d.time,'LineWidth',1,'color','k'); hold on
scatter3(d.X,d.Y,d.time,20,cmap(1:lens+adds,:),'filled')
    plot3([-5 5],[0 0],[lens lens],'r--')
        plot3([0 0],[-5 5],[lens lens],'r--')
 plot3([-5 5],[-5 -5],[lens lens],'k')
        plot3([5 5],[-5 5],[lens lens],'k')
         plot3([5 5],[-5 -5],[0 lens],'k')
% line3(d.X,d.Y,'LineWidth',2,'color',d.time); 
xlabel('X'); ylabel('Y'); zlabel('time (ms)')
xlim([-5 5]); ylim([-5 5]); zlim([0 lens])
title(['sample ' num2str(samp) ', ' num2str(lens) 'ms from ' phase_s],'fontsize',fsz,'FontWeight','b')
set(gca,'ZDir','reverse','YDir','reverse','XDir','normal','view',[-11,71],'cameraposition',[-5,28,-4600]); grid on
colormap jet

subplot('Position',[.4 .15 .55 .7])
img = imread([ROOT.raw. fig '\wo disc\Cxt' num2str(cxt) '_Loc' num2str(loc) '.png']); 
imgx=rgb2gray((img));
imshow(img, 'Border', 'tight')
hold on

title([animal_s ', trial ' num2str(TInfo.Trial(1)) ', ' cxt_s ', ' dir_s '(loc ' num2str(loc) '), ' cho_s ', ' cor_s ', ' obj_l '-' obj_r],'fontsize',fsz,'FontWeight','b')


is=1; ie=lens+adds;

% x = X_lp_deg(is:ie); y= Y_lp_deg(is:ie);  
% x=(x+29)*2000/54.73; y=(y+17)*1125/36.5685;
x = d.X(is:ie); y= d.Y(is:ie); 
x=(x+5)*2000/10; y=(y+5)*1125/10;

idx0 = ones(ie,1); idt = idx0*TInfo.Trial(1); ids0 = ones(ie,1)*st; times = d.time(is:ie);
t4 = times(ids0==4);
Exist_Column = max(strcmp('joystick',d.Properties.VariableNames));
if ~Exist_Column, d.joystick=zeros(size(d,1),1); end
joystick = d.joystick;
joystick(1,2)=joystick(1,1);
joystick(:,3) = 1:lens;
k=2;
for j=2:size(joystick,1)
    if k+33<=j || joystick(j,1)~=joystick(j-1,1)
    joystick(j,2) = joystick(j-1,2)+joystick(j,1);
    k=j;
    else
      joystick(j,2) = joystick(j-1,2);
    end
end
joystick(joystick(:,2)>6,2) = 6; joystick(joystick(:,2)<-5,2) = -6;


n=1; l=5;
num_moves = size(x,1)-l;
h=[]; h1=[]; h2=[]; h3=[];
check_flag=0;
for frame_num = 1:num_moves


    % 점 그리기
    hold on
    x1=x(n:n+l); y1=y(n:n+l); idx = idx0(n:n+l); ids = ids0(n:n+l); idtime = times(n:n+l);


    if n+l<size(x,1), delete(h); end
    h = text(1800,100,[num2str(n) 'ms'],'FontSize',fsz,'color','w','FontWeight','b');

    if max(ids)==2
        delete(h1); 
        h1 = text(1800,150,'Cursor On','FontSize',fsz,'color','r','FontWeight','b'); 
        delete(sc)
    sc = scatter(1000,470,2000,'r','LineWidth',3);
    end
    if max(ids)>=3
        delete(h1); delete(h2);
        
        h2 = text(1800,150,'Object On','FontSize',fsz,'color','y','FontWeight','b');
        if flag
            sc = scatter(1000,470,2000,'r','LineWidth',3);
        img = imread([ROOT.raw.fig '\' obj_l '_Left.png']); 
        imgx=rgb2gray((img)); 
        alphaData=ones(1127,2002); alphaData(imgx==0)=0;
        imagesc(img, 'AlphaData', alphaData)
        img2 = imread([ROOT.raw.fig '\' obj_r '_Right.png']);
        img2x=rgb2gray((img2));
        alphaData=ones(1127,2002); alphaData(img2x==0)=0;
        imagesc(img2, 'AlphaData', alphaData)

        x2=x(1:n); y2=y(1:n); idx2 = idx0(1:n);
%         delete(s0); delete(s1); delete(s2); delete(s3);

   s2=scatter(x1,y1,sz,cmap(idtime,:),'filled','MarkerEdgeColor','w');


        flag=0;
        end
    end
    if max(ids)==4
        delete(h1); delete(h2); delete(h3);
        h3 = text(1650,150,'Choice Available','FontSize',fsz,'color',[0 1 1],'FontWeight','b');
        delete(sc)
        jm=0;
         ij = find(idtime(end)>joystick(:,3),1,'last'); 
         if isempty(ij), jm=0; else, jm = joystick(ij,2)*150/4; end
         if joystick(ij,2)==6, jm=340; elseif joystick(ij,2)==-6, jm=-340; end
        sc = scatter(1000+jm,470,2000,'b','LineWidth',3);
    end
% delete(s0); delete(s1); delete(s2); delete(s3);
    s2=scatter(x1,y1,sz,cmap(idtime,:),'filled','MarkerEdgeColor','w');

    % 프레임 캡처 및 GIF 파일에 추가
    cd(ROOT.save.fig)
   
    frame = getframe(gcf);
    im = frame2im(frame);
    [imind, cm] = rgb2ind(im, 256);
    if check_flag == 0
        imwrite(imind, cm, filename, 'gif', 'Loopcount', inf, 'DelayTime', 0.1);
        check_flag=1;
    else
        imwrite(imind, cm, filename, 'gif', 'WriteMode', 'append', 'DelayTime', 0.1);
    end

    % 점 위치 업데이트
    n=n+l;
    if n+l>size(x,1), break; end
    %     x = x + 10;
    %     y = y + 10;
end
close all
end
%%
%%

