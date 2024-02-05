function EyeGazeMovie(index,t,xf,yf,SaccIndex,program_folder,F_O,F_O_A,JoystickID_Eye)

%%
cd([program_folder '\Image'])


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
ol = max(index(is:ie,4));
or = max(index(is:ie,5));

if void==1 Void=', Void'; else Void=''; end
if or(cor==0,void==1) FontC='r'; else FontC='k'; end

Cxt = Cxt_Name(cxt);
Res = Res_Name(res);
Cor = Cor_Name(cor);



x=(xf+X_deg_max)*FigX/(2*X_deg_max);
y = (yf+Y_deg_max)*FigY/(2*Y_deg_max);

FixPoint = FindFixationPoint(SaccIndex,x,y,id,'mid');


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

% ChLat(1) = ie_1-is_1;
% ChLat(2) = ie_2-is_2;
% ChLat(3) = ie_3-is_3;
%%


CxtFig=imread(['Cxt' num2str(cxt) '_Loc' num2str(loc) 'C2.png']); % Load context contour image of current location
CxtFig_G = rgb2gray(CxtFig);
I1 = (squeeze(F_O(ol,:,:,:))); % Load left object image
I2 = (squeeze(F_O(or+6,:,:,:))); % Load right object image

DownS = 10;
lw=3;
is_temp = is_0;
ie_temp = ie_3;

loops = ie_temp-is_temp; % 3번째 phase(choice)의 end부터 1번째 phase(pre-sample)의 start까지
clear M
M(fix(loops/DownS)) = struct('cdata',[],'colormap',[]); % video frame을 저장할 struct 변수 생성

for i = 1:fix(loops/DownS)
    
    j=is_temp+i*DownS; % 1000Hz의 eye data를 100Hz로 downsampling
        imc = imshow(CxtFig_G); % Context image plotting
        imc.AlphaData = 0.5;
    hold on
rectangle('Position',[0 0 250 80],'FaceColor',[1 1 1]) % 왼쪽 위 HUD 가리기

    c='r';
    if j<is_1 % Pre-cursor 구간만 빨간색 점선으로 표시
        plot(x(is_0:j),y(is_0:j),'r--','LineWidth',lw)
    else
        plot(x(is_0:is_1),y(is_0:is_1),'r--','LineWidth',lw)
    end
    
    
    if j>=is_1 % Pre-sample 구간만 빨간색 실선으로 표시
        c='r';
        if j<is_2
            plot(x(is_1:j),y(is_1:j),'Color',c,'LineWidth',lw)
        else
            plot(x(is_1:is_2),y(is_1:is_2),'Color',c,'LineWidth',lw)
        end
    end
    
    if j>=is_2
        c='y'; % Sample 구간은 노란색
        im = imshow(I1); % Left object image plotting
        im.AlphaData = squeeze(F_O_A(ol,:,:)); % Left object image의 background를 투명하게
        im2 = imshow(I2);  % Right object image plotting
        im2.AlphaData = squeeze(F_O_A(or+6,:,:));  % Right object image의 background를 투명하게

        if j<is_3 % Sample 구간만 노란색 실선으로 표시
            plot(x(is_2:j),y(is_2:j),'Color',c,'LineWidth',lw)
        else
            plot(x(is_2:is_3),y(is_2:is_3),'Color',c,'LineWidth',lw)
        end
    end
    
    if j >=is_3
        c='b'; % Choice 구간만 파란색 실선으로 표시
        plot(x(is_3:j),y(is_3:j),'Color',c,'LineWidth',lw)
    end
    
    % Joystick 조작 표시
    if max(JoystickID_Eye(j:j+DownS))==1
        quiver(100,100,-50,0,'Color','r','LineWidth',5,'MaxHeadSize',1)
    elseif max(JoystickID_Eye(j:j+DownS))==2
        quiver(100,100,50,0,'Color','b','LineWidth',5,'MaxHeadSize',1)
    end
    
    scatter(x(j),y(j),'MarkerFaceColor',c,'MarkerEdgeColor','k','LineWidth',1.5)  % 현재 eye gaze plotting
    scatter(FixPoint(and(FixPoint(:,3)<=j,FixPoint(:,3)>=is_temp),1),FixPoint(and(FixPoint(:,3)<=j,FixPoint(:,3)>=is_temp),2),60,'g','LineWidth',1.5); % Fixation point plotting
    
    % Trial 및 time 정보 표시
    text(5,10,['Trial' num2str(t) ',' Cxt ',Loc' num2str(loc) ',' Res Void], 'FontSize',12,'FontWeight','b','Color',FontC)
    text(5,50,['Time: ' num2str(j-is_1) 'ms'], 'FontSize',20,'FontWeight','b')
    
    
    axis([0 2000 0 1125])
    M(i) = getframe(gcf); % 현재 그림을 변수 M에 i번째 frame으로 저장
    hold off
end
%%
close gcf

v = VideoWriter(['Trial' num2str(t) '-' Cxt '-Loc' num2str(loc) Res '_' num2str(round(1000/DownS)) 'Hz_ObjOnly.avi']);
open(v)
writeVideo(v,M)
close(v)

%%


% movie(M,3)  
end
