function EyeGazeMovie_Obj(index,cxtx,locx,objx,resx,xf,yf,SaccIndex,program_folder,F_O,F_O_A,JoystickID_Eye)

%%
cd([program_folder '\Image'])

DownS = 50;
lw=3;
loops_prev = 0; is_prev=0; ie_prev=0;
clear M

M(10) = struct('cdata',[],'colormap',[]); % video frame을 저장할 struct 변수 생성

%%

        %%
for t = 1:max(index(:,9))
    
    
    id = find(and((index(:,9)==t),(index(:,3)~=0)));
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
    
    if cxtx==0 cxtn=cxt; else cxtn=cxtx; end
    if locx==0 locn=loc; else locn=locx; end
    if resx==0 resn=cxt; else resn=resx; end
    if mod(objx,2)==0 oln=objx-2; else oln=objx; end
    
    if ol==objx && ~void && res==resn && loc==locn && cxt==cxtn && cor
        
        if void==1 Void=', Void'; else Void=''; end
        if or(cor==0,void==1) FontC='r'; else FontC='k'; end
        
        Cxt = Cxt_Name(cxt);
        Res = Res_Name(res);
        Cor = Cor_Name(cor);
        Obj = ObjName(oln);
        Loc = Loc_Name(loc);
        
        
        x=(xf+X_deg_max)*FigX/(2*X_deg_max);
        y = (yf+Y_deg_max)*FigY/(2*Y_deg_max);
        
        FixPoint = FindFixationPoint(SaccIndex,x,y,id,'mid');
        
        
        FixPoint(:,4:13) = index(FixPoint(:,3),1:10);
        
        FixPoint(:,5) = loc;
        FixPoint(:,10) = res;
        FixPoint(:,11) = cor;
        
        id_0 = find(and((index(:,9)==t),(index(:,3)==-1)));
        id_1 = find(and((index(:,9)==t),(index(:,3)==1)));
        id_2 = find(and((index(:,9)==t),(index(:,3)==2)));
        id_3 = find(and((index(:,9)==t),(index(:,3)==3)));
        
        is_1 = id_1(1); is_2 = id_2(1); is_3 = id_3(1); is_0 = id_0(1);
        ie_1 = id_1(end); ie_2 = id_2(end); ie_3 = id_3(end); ie_0 = id_0(end);
        
        % ChLat(1) = ie_1-is_1;
        % ChLat(2) = ie_2-is_2;
        % ChLat(3) = ie_3-is_3;
        %%
        
        
        CxtFig=imread(['Cxt_Disc2.jpg']); % Load context contour image of current location
        CxtFig_G = rgb2gray(CxtFig);
        I1 = (squeeze(F_O(ol,:,:,:))); % Load left object image
        I2 = (squeeze(F_O(or+6,:,:,:))); % Load right object image

        is_temp = is_2;
        ie_temp = ie_3;
        
        loops = ie_temp-is_temp; % 3번째 phase(choice)의 end부터 1번째 phase(pre-sample)의 start까지

        for i = 1:fix(loops/DownS)
            
            j=is_temp+i*DownS; % 1000Hz의 eye data를 100Hz로 downsampling
            imc = imshow(CxtFig_G); % Context image plotting
            
            hold on
            rectangle('Position',[0 0 250 80],'FaceColor',[1 1 1])
            c='k';
            if ie_prev ~=0
                plot(x(is_prev:ie_prev),y(is_prev:ie_prev),'Color',c,'LineWidth',lw)
                alpha(.5)
                scatter(FixPoint(and(FixPoint(:,3)<=ie_prev,FixPoint(:,3)>=is_prev),1),FixPoint(and(FixPoint(:,3)<=ie_prev,FixPoint(:,3)>=is_prev),2),60,'k','LineWidth',1.5);
                alpha(.5)
            end
            
            if j>=is_2
                c='y'; % Sample 구간은 노란색
                im = imshow(I1); % Left object image plotting
                im.AlphaData = squeeze(F_O_A(ol,:,:)); % Left object image의 background를 투명하게
%                 im2 = imshow(I2);  % Right object image plotting
%                 im2.AlphaData = squeeze(F_O_A(or+6,:,:));  % Right object image의 background를 투명하게
                if j<is_3
                    plot(x(is_2:j),y(is_2:j),'Color',c,'LineWidth',lw)
                else
                    plot(x(is_2:is_3),y(is_2:is_3),'Color',c,'LineWidth',lw)
                end
            end
            if j >=is_3
                c='b'; % Choice 구간은 파란색
                plot(x(is_3:j),y(is_3:j),'Color',c,'LineWidth',lw)
            end
            
            if max(JoystickID_Eye(j:j+DownS))==1
                
                quiver(100,100,-50,0,'Color','r','LineWidth',5,'MaxHeadSize',1)
            elseif max(JoystickID_Eye(j:j+DownS))==2
                quiver(100,100,50,0,'Color','b','LineWidth',5,'MaxHeadSize',1)
            end
            
            scatter(x(j),y(j),'MarkerFaceColor',c,'MarkerEdgeColor','k','LineWidth',1.5)  % 현재 eye gaze plotting
            scatter(FixPoint(and(FixPoint(:,3)<=j,FixPoint(:,3)>=is_temp),1),FixPoint(and(FixPoint(:,3)<=j,FixPoint(:,3)>=is_temp),2),60,'g','LineWidth',1.5);
            
            title(['Trial ' num2str(t) ',' Cxt ',Loc' num2str(loc) ',' Res Void], 'FontSize',12,'FontWeight','b','Color',FontC)
            text(5,50,['Time: ' num2str(j-is_1) 'ms'], 'FontSize',20,'FontWeight','b')
            %
            %     if j-100>0  % 이전 100개 eyegaze를 tail로 plotting
            %         plot(x(j-100:j),y(j-100:j),'Color',c,'LineWidth',2)
            %     else
            %         plot(x(1:j),y(1:j),'Color',c,'LineWidth',2)
            %     end
            if 1
                % Left Obj Option
                axis([520 805 330 615])
            else
                % Right Obj Option
                axis([1195 1480 330 615])
            end
            %     axis([0 2000 0 1125])
            M(i+loops_prev) = getframe(gcf); % 현재 그림을 변수 M에 i번째 frame으로 저장
            hold off
        end
        loops_prev = loops_prev + fix(loops/DownS);
                is_prev = is_2;
        ie_prev = ie_3;
    end
end
%%
close gcf
% fig = figure('Position',[10 50 2200 1300]);
% title(['Trial' num2str(t) '-' Cxt '-Loc' num2str(loc) Res])


Cxt = Cxt_Name(cxtx);
        Res = Res_Name(resx);
        Obj = ObjName(oln);
        Loc = Loc_Name(locx);

 if ~isempty(M(1).cdata)       
v = VideoWriter([Cxt '_' Loc '_' Res '_' Obj '_' num2str(round(1000/DownS)) 'Hz_ObjOnly.avi']);
open(v)
writeVideo(v,M)
close(v)
 end
%%


% movie(M,3)
end