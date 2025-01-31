% Z2_display_choice_event_video
%% draw gif
s0=[];s1=[];s2=[];s3=[];sc=[]; sz=100;
for t=1:100
    flag=1;
tr =  rem(t,8);
cxt = UE_log.trials.Context(t); if cxt==1, cxt_s = 'Forest'; else, cxt_s='City'; end
dir = UE_log.trials.Direction(t); if dir==1, dir_s='Outbound'; else, dir_s='Inbound'; end
cho = UE_log.trials.CorrectAnswer(t); if cho==0, cho_s='Left'; else, cho_s='Right'; end
if UE_log.trials.Choice(t)==UE_log.trials.CorrectAnswer(t), cor_s='Correct'; else, cor_s='Wrong'; end
obj_l = UE_log.trials.ObjectLeft{t}; obj_r = UE_log.trials.ObjectRight{t};
 loc = tr; if tr==0, loc=8; end


figure
img = imread(['D:\NHP project\실험 셋업 자료\Unreal Assets\wo disc\Cxt' num2str(cxt) '_Loc' num2str(loc) '.png']); 
imgx=rgb2gray((img));
imshow(img, 'Border', 'tight')
hold on

filename = ['color_moving_dot_trial' num2str(t)  '.gif'];
num_moves = 200;

is=find(Datapixx_eye_T.trial==t & Datapixx_eye_T.on_trial>0,1,'first'); ie=find(Datapixx_eye_T.trial==t & Datapixx_eye_T.on_trial>0,1,'last');

% x = X_lp_deg(is:ie); y= Y_lp_deg(is:ie);  
% x=(x+29)*2000/54.73; y=(y+17)*1125/36.5685;
x = X_lp(is:ie); y= Y_lp(is:ie); 
x1=(x+5)*2000/10; y1=(y+5)*1125/10;

idx0 = Datapixx_eye_T.saccade(is:ie,1); idt = Datapixx_eye_T.trial(is:ie); ids0 = Datapixx_eye_T.on_trial(is:ie); times = Datapixx_eye_T.time(is:ie);
t4 = times(ids0==4);
joystick = UE_log.Joystick(UE_log.Joystick(:,1)>t4(1) & UE_log.Joystick(:,1)<t4(end),:);
joystick(1,3)=joystick(1,2); for j=2:size(joystick,1), joystick(j,3) = joystick(j-1,3)+joystick(j,2); end
joystick(joystick(:,3)>5,3) = 5; joystick(joystick(:,3)<-5,3) = -5;


n=1; l=20;
num_moves = size(x,1)-l;
h = text(1800,100,num2str(n-501),'FontSize',20,'color','w'); h1=[]; h2=[]; h3=[];
for k = 1:num_moves


    % 점 그리기
    hold on
    x1=x(n:n+l); y1=y(n:n+l); idx = idx0(n:n+l); ids = ids0(n:n+l); idtime = times(n:n+l);


    if n+20<size(x,1), delete(h); end
    h = text(1800,100,[num2str(n-501) 'ms'],'FontSize',20,'color','w','FontWeight','b');

    if max(ids)==2
        delete(h1); 
        h1 = text(1800,150,'Cursor On','FontSize',20,'color','r','FontWeight','b'); 
        delete(sc)
    sc = scatter(1000,470,2000,'r','LineWidth',3);
    end
    if max(ids)==3
        delete(h1); delete(h2);
        
        h2 = text(1800,150,'Object On','FontSize',20,'color','y','FontWeight','b');
        if flag
        img = imread(['D:\NHP project\실험 셋업 자료\Unreal Assets\' obj_l '_Left.png']); 
        imgx=rgb2gray((img)); 
        alphaData=ones(1127,2002); alphaData(imgx==0)=0;
        imagesc(img, 'AlphaData', alphaData)
        img2 = imread(['D:\NHP project\실험 셋업 자료\Unreal Assets\' obj_r '_Right.png']);
        img2x=rgb2gray((img2));
        alphaData=ones(1127,2002); alphaData(img2x==0)=0;
        imagesc(img2, 'AlphaData', alphaData)

        x2=x(1:n); y2=y(1:n); idx2 = idx0(1:n);
        delete(s0); delete(s1); delete(s2); delete(s3);
     s0 = scatter(x2(idx2==0),y2(idx2==0),sz*0.2,'k','filled');
%     s1 = scatter(x2(idx2==3),y2(idx2==3),sz,[0.4940 0.1840 0.5560],'filled');
    s1 = scatter(x2(idx2==3),y2(idx2==3),sz,[1 0 1],'filled');
   s2 =  scatter(x2(idx2==1),y2(idx2==1),sz,'r','filled');
    s3 = scatter(x2(idx2==2),y2(idx2==2),sz,'b','filled');


        flag=0;
        end
    end
    if max(ids)==4
        delete(h1); delete(h2); delete(h3);
        h3 = text(1650,150,'Choice Available','FontSize',20,'color',[0 1 1],'FontWeight','b');
        delete(sc)
         ij = find(idtime(end)>joystick(:,1),1,'last'); 
         if isempty(ij), jm=0; else, jm = joystick(ij,3)*150/4; end
         if joystick(ij,3)==5, jm=340; elseif joystick(ij,3)==-5, jm=-340; end
        sc = scatter(1000+jm,470,2000,'b','LineWidth',3);
    end
delete(s0); delete(s1); delete(s2); delete(s3);
     s0= scatter(x1(idx==0),y1(idx==0),sz*0.2,'k','filled');
%     s1=scatter(x1(idx==3),y1(idx==3),sz,[0.4940 0.1840 0.5560],'filled');
 s1=scatter(x1(idx==3),y1(idx==3),sz,[1 0 1],'filled');
    s2=scatter(x1(idx==1),y1(idx==1),sz,'r','filled');
    s3=scatter(x1(idx==2),y1(idx==2),sz,'b','filled');
    hold off

    % 프레임 캡처 및 GIF 파일에 추가
    cd(ROOT.fig_trial)
    frame = getframe(gcf);
    im = frame2im(frame);
    [imind, cm] = rgb2ind(im, 256);
    if k == 1
        imwrite(imind, cm, filename, 'gif', 'Loopcount', inf, 'DelayTime', 0.1);
    else
        imwrite(imind, cm, filename, 'gif', 'WriteMode', 'append', 'DelayTime', 0.1);
    end

    % 점 위치 업데이트
    n=n+20;
    if n+20>size(x,1), break; end
    %     x = x + 10;
    %     y = y + 10;
end
close all
end
%%
%%

