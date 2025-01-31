% Z3_display_lap_video
%% set maps
close all
%%
ROOT.Mother = 'Z:\NHP\Data';
ROOT.Program = ['D:\NHP_project\Analysis\Program'];
ROOT.Save = 'X:\E-Phys Analysis\NHP project';
addpath(genpath(ROOT.Program))
addpath(genpath('D:\Modules'))


Animal_id = 'Nabi';
date='20200108';
load([ROOT.Save '\Eye_parsed\' Animal_id '_' date '.mat'],'Datapixx_eye_T','UE_log','Datapixx_events','NonSacc')
%%
newdir = 'D:\NHP_project\실험 셋업 자료\Unreal Assets\run';
dinfo = dir( fullfile(newdir, '*.png') );
oldnames = {dinfo.name};
FigList=table;
for o=1:length(oldnames)
    findHyp = find(oldnames{o}=='_');
    FigList.cxt(o) = str2double(oldnames{o}(4));
    FigList.dir(o) = str2double(oldnames{o}(9));
    FigList.pos(o) = str2double(oldnames{o}(11:end-4));
end

L1_1 = load('D:\NHP_project\Analysis\Figures\Property sheet\3DRecon_Nabi_20200108.mat');
L1_2 = load('D:\NHP_project\Analysis\Figures\Property sheet\3DRecon_Nabi_20200108_2.mat');



%% draw gif
for thisLap=1:50
    close all
    is=find(Datapixx_eye_T.lap==thisLap,1,'first'); ie=find(Datapixx_eye_T.lap==thisLap,1,'last');
    h=[]; h1=[]; h2=[]; h3=[]; h4=[]; h_trial=[]; hp=[];
    s0=[];s1=[];s2=[];s3=[];sc=[]; s30=[];s31=[]; s32=[]; s33=[]; s_ori=[]; line_gaz=[]; s50=[];s51=[]; s52=[]; s53=[]; s_ori2=[]; line_gaz3=[];
    sz=300;
    idx0 = Datapixx_eye_T.saccade(is:ie,1); idt = Datapixx_eye_T.trial(is:ie); ids0 = Datapixx_eye_T.on_trial(is:ie); times = Datapixx_eye_T.time(is:ie);
    %
    X_lp = Datapixx_eye_T.X; Y_lp = Datapixx_eye_T.Y;
    x = X_lp(is:ie); y= Y_lp(is:ie);
    x=(x+5)*2000/10; y=(y+5)*1125/10;

    xpos=Datapixx_eye_T.Xpos(is:ie,1);
    ypos=Datapixx_eye_T.Ypos(is:ie,1);

    cxt = UE_log.trials.Context(min(idt(1:20)));   if cxt==1, cxt_s = 'Forest'; else, cxt_s='City'; end
    cxt_dir=zeros(size(xpos,1),2);
    cxt_dir(1,2)=1;
    for i=2:size(xpos,1)
        if ypos(i)==9250 || abs(xpos(i)-xpos(i-1))>5000
            cxt_dir(i,2) =0;
        else
            if (xpos(i-1)<xpos(i)-1)
                cxt_dir(i,2)=1;
            elseif (xpos(i-1)>xpos(i))
                cxt_dir(i,2)=2;
            else
                cxt_dir(i,2) = cxt_dir(i-1,2);
            end
        end
    end

    cxt_dir(:,1)=cxt;
    cxt_dir(cxt_dir(:,2)==0,1)=0;

    intersection_sky = [L1_1.intersection_sky(1:find(cxt_dir(:,2)==1,1,'last'),:); L1_2.intersection_sky(find(cxt_dir(:,2)==1,1,'last')+1:end,:)];
    intersection_cxt = [L1_1.intersection_cxt(1:find(cxt_dir(:,2)==1,1,'last'),:); L1_2.intersection_cxt(find(cxt_dir(:,2)==1,1,'last')+1:end,:)];
    origins = L1_1.origin_cxt;

    intersection_sky(:,5)=0;intersection_cxt(:,5)=1;
    intersections = sortrows([intersection_cxt;intersection_sky],4);
    intersections(intersections(:,4)==0,:)=[];

    id3x0 = interp1(origins(:,4),intersections(:,1),times,'linear','extrap'); id3x0(intersections(:,4)==0)=nan;
    id3y0 = interp1(origins(:,4),intersections(:,2),times,'linear','extrap'); id3y0(intersections(:,4)==0)=nan;
    id3z0 = interp1(origins(:,4),intersections(:,3),times,'linear','extrap'); id3z0(intersections(:,4)==0)=nan;

    id2x0 = interp1(origins(:,4),origins(:,1),times,'linear','extrap'); id2x0(origins(:,4)==0)=nan;
    id2y0 = interp1(origins(:,4),origins(:,2),times,'linear','extrap'); id2y0(origins(:,4)==0)=nan;
end
    %% draw gif for each lap


    figure('Position',[-1005,150,2500,828])

    filename = ['color_moving_dot_lap' num2str(thisLap)  '_500ms_verification.gif'];
    n=1; l=20;
    num_moves = size(x,1)-l;
    f2=1;

    for k =1:num_moves
%%
        subplot('position',[.22 .05 .64 .9])
        t=min(idt(n:n+l));

        tr =  rem(t,8);

        direction = UE_log.trials.Direction(t); if direction==1, dir_s='Outbound'; else, dir_s='Inbound'; end
        cho = UE_log.trials.CorrectAnswer(t); if cho==0, cho_s='Left'; else, cho_s='Right'; end
        if UE_log.trials.Choice(t)==UE_log.trials.CorrectAnswer(t), cor_s='Correct'; else, cor_s='Wrong'; end
        obj_l = UE_log.trials.ObjectLeft{t}; obj_r = UE_log.trials.ObjectRight{t};
        loc = tr; if tr==0, loc=8; end
        FigList = sortrows(FigList,{'cxt','dir','pos'});

        x1=x(n:n+l); y1=y(n:n+l); idx = idx0(n:n+l); ids = ids0(n:n+l); idtime = times(n:n+l);

        id3x=id3x0(n:n+l); id3y=id3y0(n:n+l); id3z=id3z0(n:n+l);
        id3xt=2000-(id3x)/10.675; id3yt=-(id3y+20010)/10+500;

        id2x=id2x0(n:n+l); id2y=id2y0(n:n+l);
        id2xt=2000-(id2x)/10.675; id2yt=-(id2y+20010)/10+500;
        % if max(ids)>=2
        %         n=n+20;
        %     continue;
        % end


        pos = find(cxt_dir(n+round(l/2),1)==FigList.cxt & cxt_dir(n+round(l/2),2)==FigList.dir & xpos(n+round(l/2)) >= FigList.pos,1,'last');
        if isempty(pos), pos= find(cxt_dir(n+round(l/2),1)==FigList.cxt & cxt_dir(n+round(l/2),2)==FigList.dir & xpos(n+round(l/2)) >= FigList.pos,1,'first');end
        if isempty(pos), pos= find(cxt_dir(n+round(l/2),1)==FigList.cxt & cxt_dir(n+round(l/2),2)==FigList.dir & xpos(n+round(l/2)) <= FigList.pos,1,'first');end

        if max(ids)<2
            delete(h_trial)
            img = imread([newdir '\Cxt' num2str(cxt_dir(n+round(l/2),1)) '_Dir' num2str(cxt_dir(n+round(l/2),2)) '_' num2str(FigList.pos(pos)) '.png']);
            img = imresize(img,[1127 2002]);
            flag=1; flagb=1; jm=0;
            imgx=rgb2gray((img));
            imshow(img, 'Border', 'tight')
        else
            if flagb==1
                jm=0;
                %         img = imread(['D:\NHP project\실험 셋업 자료\Unreal Assets\wo disc\Cxt' num2str(cxt) '_Loc' num2str(loc) '.png']);
                img = imread([newdir '\Cxt' num2str(cxt_dir(n+round(l/2),1)) '_Dir' num2str(cxt_dir(n+round(l/2),2)) '_' num2str(FigList.pos(pos)) '.png']);
                imgx=rgb2gray((img));
                imshow(img, 'Border', 'tight')

                flagb=0;
            end
            delete(h_trial)
            h_trial = text(10,80,['Trial ' num2str(t) ', ' obj_l '-' obj_r '(' cho_s '), ' cor_s],'FontSize',15,'color','w','FontWeight','b');
        end

        if max(ids)>0
            imgl = imread(['D:\NHP_project\실험 셋업 자료\Unreal Assets\' obj_l '_Left.png']);
            imglx=rgb2gray((imgl));
            imgr = imread(['D:\NHP_project\실험 셋업 자료\Unreal Assets\' obj_r '_Right.png']);
            imgrx=rgb2gray((imgr));

            for i=1:size(x1,1)
                sq2=50; sq1=20;
                p1 = round(x1(i)); p2= round(y1(i));

                if p1<=0 || p1>size(imglx,2) || p2<=0 || p2>size(imglx,1), objl(i,1)=0; objr(i,1)=0;
                else
                    if imglx(p2,p1)>0, objl(i,1)=1; else, objl(i,1)=0; end
                    if imgrx(p2,p1)>0, objr(i,1)=1; else, objr(i,1)=0; end
                end


                if p2>470-sq2 && p2<470+jm && p1>1000+jm-sq2 && p1<1000+jm+sq2
                    cur(i,1)=1;
                else
                    cur(i,1)=0;
                end

            end
            if max(cur(idx>0))==1, overlap_obj = 'Cursor'; elseif max(objr(idx>0))==1, overlap_obj = 'Right Obj'; elseif  max(objl(idx>0))==1, overlap_obj = 'Left Obj'; else, overlap_obj=''; end

        end

        if n+20<size(x,1), delete(h); end
        h_lap = text(10,20,['Lap ' num2str(thisLap) ', ' cxt_s],'FontSize',15,'color','w','FontWeight','b');
        h = text(1800,20,[num2str(n-1) 'ms'],'FontSize',15,'color','w','FontWeight','b');

        if max(idx)>0
             delete(hp);
                        gaz = [id3y(idx>=1) id3x(idx>=1) id3z(idx>=1)];
                hp = text(1500,130,['x=' jjnum2str(gaz(end,1)+20500,0) ', y=' jjnum2str(gaz(end,2),0) ', z=' jjnum2str(gaz(end,3),0)],'FontSize',15,'color','w','FontWeight','b');
        end

        hold on
        if max(ids)==2
            delete(h1);
            h1 = text(1800,80,overlap_obj,'FontSize',15,'color','w','FontWeight','b');
            delete(sc)

            is1=find(Datapixx_eye_T.trial==t & Datapixx_eye_T.on_trial>0,1,'first'); ie1=find(Datapixx_eye_T.trial==t & Datapixx_eye_T.on_trial>0,1,'last');
            ids1 = Datapixx_eye_T.on_trial(is1:ie1); times1 = Datapixx_eye_T.time(is1:ie1);

            t4 = times1(ids1==4);
            joystick = UE_log.Joystick(UE_log.Joystick(:,1)>t4(1) & UE_log.Joystick(:,1)<t4(end),:);
            joystick(1,3)=joystick(1,2); for j=2:size(joystick,1), joystick(j,3) = joystick(j-1,3)+joystick(j,2); end
            joystick(joystick(:,3)>5,3) = 5; joystick(joystick(:,3)<-5,3) = -5;

            sc = scatter(1000,470,2000,'r','LineWidth',3);
        end
        if max(ids)==3
            delete(h1);

            h1 = text(1800,80,overlap_obj,'FontSize',15,'color','w','FontWeight','b');
            if flag

                alphaData=ones(1127,2002); alphaData(imglx==0)=0;
                imagesc(imgl, 'AlphaData', alphaData)

                alphaData=ones(1127,2002); alphaData(imgrx==0)=0;
                imagesc(imgr, 'AlphaData', alphaData)

                x2=x(1:n); y2=y(1:n); idx2 = idx0(1:n);

                flag=0;
            end
        end
        if max(ids)==4
            delete(h1);
            h1 = text(1800,80,overlap_obj,'FontSize',15,'color','w','FontWeight','b');
            delete(sc)
            ij = find(idtime(end)>joystick(:,1),1,'last');
            if isempty(ij), jm=0; else, jm = joystick(ij,3)*150/4; end
            if joystick(ij,3)==5, jm=340; elseif joystick(ij,3)==-5, jm=-340; end
            sc = scatter(1000+jm,470,2000,'r','LineWidth',3);
        end


        delete(s0); delete(s1); delete(s2); delete(s3);
        s0= scatter(x1(idx==0),y1(idx==0),40,'w','filled');
        %     s1=scatter(x1(idx==3),y1(idx==3),sz,[0.4940 0.1840 0.5560],'filled');
        s1=scatter(x1(idx==3),y1(idx==3),sz,[1 0 1],'filled');
        s2=scatter(x1(idx==1),y1(idx==1),sz,'r','filled');
        s3=scatter(x1(idx==2),y1(idx==2),sz,'c','filled');

%%

        subplot('position',[.86 .01 .12 .98]); hold on

        if f2==1
            imgc2 = imread(['D:\NHP_project\실험 셋업 자료\Unreal Assets\context_' cxt_s '.png']);
            imgc2 = (imresize(imgc2,[2500 1000]));
            imshow(imgc2)
        end

        delete(s30);   delete(s31);   delete(s32);   delete(s33); delete(s_ori);
        %         s30 = scatter(id3y(idx==0)+20050,id3x(idx==0),40,'k','filled');
        s31 = scatter(id3yt(idx==3),id3xt(idx==3),40,[1 0 1],'filled');
        s32 = scatter(id3yt(idx==1),id3xt(idx==1),40,'r','filled');
        s33 = scatter(id3yt(idx==2),id3xt(idx==2),40,'c','filled');

        if cxt_dir(n+round(l/2),2)==1,scat_dir='^'; else, scat_dir='v'; end
        s_ori = scatter(id2yt(end),id2xt(end),40,'k',scat_dir,'filled');

        if ~isempty(id3yt(idx>=1))
            delete(line_gaz)
            gaz = [id3yt(idx>=1) id3xt(idx>=1)];
            line_gaz = plot([id2yt(end) gaz(end,1)], [id2xt(end) gaz(end,2)],'color','g');
        else
                        delete(line_gaz)
            gaz = [id3yt(end) id3xt(end)];
            line_gaz = plot([id2yt(end) gaz(end,1)], [id2xt(end) gaz(end,2)],'color','g');
        end

        if exist('objl')
            if max([objl(idx>0);objr(idx>0)]) & max(ids)>0
                delete(s30);   delete(s31);   delete(s32);   delete(s33); delete(line_gaz);
             
            end
        end
        xlim([0 1000]); ylim([0 2500]);



        hold off

        %%
        ax1 = subplot('position',[.01 .01 .21 .98]); hold on

        if cxt==1
            F = STL_Forest;
            G = STL_Forest_Sky;
        else
            F = STL_City;
            G = STL_City_Sky;
        end
        if f2==1
            patch(ax1,F,'FaceColor',       [0.8 0.8 0.8], ...
                'EdgeColor',       'none',        ...
                'FaceLighting',    'gouraud',     ...
                'AmbientStrength', 0.15);
            hold on
            % patch(G,'FaceColor',       [0.8 0.8 0.8], ...
            %     'EdgeColor',       'none',        ...
            %     'FaceLighting',    'gouraud',     ...
            %     'AmbientStrength', 0.15);
            material('dull');
            camlight('headlight');
            axis('image');

            f2=0;
        end

        if direction==1
            view([-90 30]);
        else
            view([90 30]);
        end
        alpha(0.5)

        xlim([-5000 20000])
        ylim([-25000 -15000])
        zlim([0 5000])

        delete(s50);   delete(s51);   delete(s52);   delete(s53); delete(s_ori2);
        %         s30 = scatter(id3y(idx==0)+20050,id3x(idx==0),40,'k','filled');
        s51 = scatter3(id3x(idx==3),id3y(idx==3),id3z(idx==3),40,[1 0 1],'filled');
        s52 = scatter3(id3x(idx==1),id3y(idx==1),id3z(idx==1),40,'r','filled');
        s53 = scatter3(id3x(idx==2),id3y(idx==2),id3z(idx==2),40,'c','filled');

        if cxt_dir(n+round(l/2),2)==1,scat_dir='^'; else, scat_dir='v'; end
        s_ori2 = scatter3(id2x(end),id2y(end),0,60,'r',scat_dir,'filled','MarkerEdgeColor','k');

        if ~isempty(id3y(idx>=1))
            delete(line_gaz3)
            gaz3 = [id3x(idx>=1) id3y(idx>=1) id3z(idx>=1)];
            line_gaz3 = plot3([id2x(end) gaz3(end,1)], [id2y(end) gaz3(end,2)],[0 gaz3(end,3)],'color','g');
        else
                        delete(line_gaz3)
            gaz3 = [id3x(end) id3y(end) id3z(end)];
            line_gaz3 = line([id2x(end) gaz3(end,1)], [id2y(end) gaz3(end,2)],[0 gaz3(end,3)],'color','g','linewidth',2);
%                         line_gaz3 = plot3(ax1,[0 1000], [-10000 1000],[0 1000],'color','g','linewidth',2);
        end

        if exist('objl')
            if max([objl(idx>0);objr(idx>0)]) & max(ids)>0
                delete(s50);   delete(s51);   delete(s52);   delete(s53); delete(line_gaz3);
             
            end
        end

        hold off
        %% 프레임 캡처 및 GIF 파일에 추가
        cd([ROOT.Save '\Eye_parsed'])
        frame = getframe(gcf);
        im = frame2im(frame);
        [imind, cm] = rgb2ind(im, 256);
        if k == 1
            imwrite(imind, cm, filename, 'gif', 'Loopcount', inf, 'DelayTime', 0.05);
        else
            imwrite(imind, cm, filename, 'gif', 'WriteMode', 'append', 'DelayTime', 0.05);
        end

        % 점 위치 업데이트
        n=n+20;
        if n+20>num_moves, break; end
%         if n+20>500, break; end
        %     x = x + 10;
        %     y = y + 10;

    end

%%
%%

