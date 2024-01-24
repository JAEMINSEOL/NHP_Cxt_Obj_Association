clear all; close all;
% eye_data_preprocessing

ROOT.Mother = 'Z:\NHP';
ROOT.Program = ['D:\NHP project\Program'];
addpath(genpath(ROOT.Program))
addpath(genpath('D:\Modules'))

date = '20200108';
Animal_id = 'Nabi';
Task_id = 'Cxt-Obj Association_6 Objects';

ROOT.fig_lap = ['D:\NHP project\분석 관련\Property sheet\Preprocessing\lap\' Animal_id '_' date]; if ~exist(ROOT.fig_lap), mkdir(ROOT.fig_lap); end
ROOT.fig_trial = ['D:\NHP project\분석 관련\Property sheet\Preprocessing\trial\' Animal_id '_' date]; if ~exist(ROOT.fig_trial), mkdir(ROOT.fig_trial); end


ROOT.Datapixx = [ROOT.Mother '\Data\' Animal_id '\Behavior\' Task_id '\' date '\Datapixx'];
ROOT.Unreal = [ROOT.Mother '\Data\' Animal_id '\Behavior\' Task_id '\' date '\Unreal'];


[Datapixx_eye,Datapixx_ticks,Datapixx_events] = A_Eyedata_import(ROOT,date);

[Datapixx_eye_T,Datapixx_events,UE_log] = B_Unreal_parsing(ROOT,Animal_id,date,Datapixx_events,Datapixx_eye);

Eye_Raw = [Datapixx_eye(:,4) Datapixx_eye(:,1) Datapixx_eye(:,2) Datapixx_eye(:,3)];
[X_lp,Y_lp,X_lp_deg, Y_lp_deg,Eye_Speed_deg_inst_lp,Eye_Acc_deg_inst_lp] = C_Angular_NoiseFiltering_SpeedCalc(Eye_Raw);

[Eye_sacc_XY_index_lp] = D_Saccade_detection(Eye_Acc_deg_inst_lp,Eye_Speed_deg_inst_lp,X_lp_deg, Y_lp_deg);
Datapixx_eye_T.saccade = Eye_sacc_XY_index_lp(:,2);

[Eye_sacc_XY_index_lp_new,NonSacc] = E_NonSaccade_Categorize(Eye_sacc_XY_index_lp,Eye_Acc_deg_inst_lp,Eye_Speed_deg_inst_lp,X_lp_deg, Y_lp_deg);
Datapixx_eye_T.saccade = Eye_sacc_XY_index_lp_new;
% Calibration_Check(Datapixx_eye,Datapixx_events)

%%
for lap=1:round(size(UE_log.trials,1)/8)
    %%
    t1=(lap-1)*8+1; t2=(lap-1)*8+8;
    is=find(Datapixx_eye_T.lap==lap,1,'first'); ie=find(Datapixx_eye_T.lap==lap,1,'last');
    if ~isempty(ie)
        x = X_lp_deg(is:ie); y= Y_lp_deg(is:ie);  idx = Datapixx_eye_T.saccade(is:ie,1); idt = Datapixx_eye_T.trial(is:ie); ids = Datapixx_eye_T.on_trial(is:ie);
        idturn=Datapixx_eye_T.on_turn(is:ie); ids2 = Datapixx_eye_T.on_lap(is:ie);
        turn_s=find(idturn,1,'first'); turn_e=find(idturn,1,'last');

        ticklabs={};
        for i=0:round((ie-is)/1000), ticklabs{i+1} = num2str(i); end

        figure('Position',[-2419,219,2477,641]);
        subplot(2,1,1); hold on


        plot(x,'color','k')
        scatter(find(idx==0),x(idx==0),10,'g','filled')
        scatter(find(idx==1),x(idx==1),20,'r','filled')
        scatter(find(idx==2),x(idx==2),20,'b','filled')
        scatter(find(idx==3),x(idx==3),20,[0.4940 0.1840 0.5560],'filled')
        xlabel('time(s)'); xlim([0 ie-is]); xticks(0:1000:ie-is); xticklabels(ticklabs)
        ylabel('Position X (deg)'); ylim([-30 30])
        for t=t1:t2
            color_states(idt,ids,t)
            text(find(ids==2 & idt==t,1,'first'),32,['trial ' num2str(t)])
        end
        id=[find(ids2==0, 1,'first') find(ids2==0,1,'last')];
        patch([id(1) id(2) id(2) id(1)],[-30 -30 30 30],'k','facealpha',0.1, 'edgealpha',0)
        line([0 size(x,1)], [0 0],'color', 'k','linestyle',':')
        line([turn_s turn_s], [-30 30],'color', 'r','linestyle',':')
        line([turn_e turn_e], [-30 30],'color', 'r','linestyle',':')

        text(turn_s,32,['u-turn'])
        text(find(~ids2,1,'first'),32,['turnnel'])

        subplot(2,1,2); hold on
        plot(y,'color','k')
         scatter(find(idx==0),y(idx==0),10,'g','filled')
        scatter(find(idx==3),y(idx==3),20,[0.4940 0.1840 0.5560],'filled')
        scatter(find(idx==1),y(idx==1),20,'r','filled')
        scatter(find(idx==2),y(idx==2),20,'b','filled')

        xlabel('time(s)'); xlim([0 ie-is]); xticks(0:1000:ie-is); xticklabels(ticklabs)
        ylabel('Position Y (deg)'); ylim([-30 30])
        for t=t1:t2
            color_states(idt,ids,t)
        end
        id=[find(ids2==0, 1,'first') find(ids2==0,1,'last')];
        patch([id(1) id(2) id(2) id(1)],[-30 -30 30 30],'k','facealpha',0.1, 'edgealpha',0)
        line([0 size(x,1)], [0 0],'color', 'k','linestyle',':')
        line([turn_s turn_s], [-30 30],'color', 'r','linestyle',':')
        line([turn_e turn_e], [-30 30],'color', 'r','linestyle',':')

        patch([3400 5500 5500 3400], [25 25 30 30],'b','facealpha',0.5, 'edgealpha',0)
        patch([400 1800 1800 400], [25 25 30 30],'r','facealpha',0.5, 'edgealpha',0)
        patch([1900 3300 3300 1900], [25 25 30 30],'y','facealpha',0.5, 'edgealpha',0)

        text(500,28,'Cursor On','color','k'); text(2000,28,'Object On','color','k');  text(3500,28,'Choice Available','color','k');
        text(500,32,'Fixation','color','r'); text(1500,32,'Smooth Pursuit','color','b');  text(3500,32,'Post-Saccadic Oscillation (PSO)','color',[0.4940 0.1840 0.5560]);

        cxt = UE_log.trials.Context(t1); if cxt==1, cxt_s = 'Forest'; else, cxt_s='City'; end
        sgtitle([Animal_id '-' date '-' 'lap ' num2str(lap) ', ' cxt_s],'fontsize',20','FontWeight','b')
        saveas(gca,[ROOT.fig_lap '\' Animal_id '-' date '-' 'lap ' num2str(lap) '.png'])
        close all
%%
        for t=t1:t2
            tr =  rem(t,8);
            cxt = UE_log.trials.Context(t); if cxt==1, cxt_s = 'Forest'; else, cxt_s='City'; end
            dir = UE_log.trials.Direction(t); if dir==1, dir_s='Outbound'; else, dir_s='Inbound'; end
            cho = UE_log.trials.CorrectAnswer(t); if cho==0, cho_s='Left'; else, cho_s='Right'; end
            if UE_log.trials.Choice(t)==UE_log.trials.CorrectAnswer(t), cor_s='Correct'; else, cor_s='Wrong'; end
            obj_l = UE_log.trials.ObjectLeft{t}; obj_r = UE_log.trials.ObjectRight{t};
           loc = tr+1;

            figure('position',[-2419,0,1500, 1000])
            is=find(Datapixx_eye_T.trial==t,1,'first'); ie=find(Datapixx_eye_T.trial==t,1,'last');
            if ~isempty(ie)
                x = X_lp_deg(is:ie); y= Y_lp_deg(is:ie);  idx = Datapixx_eye_T.saccade(is:ie,1); idt = Datapixx_eye_T.trial(is:ie); ids = Datapixx_eye_T.on_trial(is:ie);
                PhaseList = {'Before cursor (-500 ~ 0ms)',['Cursor on (0 ~ ' num2str(sum(ids==2)) 'ms)'],['Object on (' num2str(sum(ids==2)) ' ~ ' num2str(sum(ids==2)+sum(ids==3)) 'ms)'],...
                    ['Choice Available (' num2str(sum(ids==2)+sum(ids==3)) ' ~ ' num2str(sum(ids==2)+sum(ids==3)+sum(ids==4)) 'ms)']};

                for s=1:4
                    subplot(2,2,s); hold on
                 
                    im = imread(['D:\NHP project\실험 셋업 자료\Unreal Assets\Cxt' num2str(cxt) '_Loc' num2str(loc) '.png']);

imagesc(rgb2gray(fliplr(im))); colormap('gray')

% x1=(x+30.72)*2000/54.73; y1=(y+18.93)*1125/36.5685;
x1=(x+28)*2000/54.73; y1=(y+17)*1125/36.5685;
        plot(x1(ids==s),y1(ids==s),'r')
                    scatter(x1(ids==s & idx==0),y1(ids==s & idx==0),15,'g','filled')
                    scatter(x1(ids==s & idx==3),y1(ids==s & idx==3),40,[0.4940 0.1840 0.5560],'filled')
                    scatter(x1(ids==s & idx==1),y1(ids==s & idx==1),40,'r','filled')
                    scatter(x1(ids==s & idx==2),y1(ids==s & idx==2),40,'b','filled')

                    text(x1(find((ids==s),1,'first')),y1(find((ids==s),1,'first'))-50,'start','color','r'); text(x1(find((ids==s),1,'last')),y1(find((ids==s),1,'last'))-50,'end','color','r')
                    xlim([0 2000]); ylim([0 1125]); 
                    xticks([0:500:2000]); xticklabels({'-28','-14','0','14','28'})
                    yticks([0:281:1125]); yticklabels({'-16','-8','0','8','16'})
                    xlabel('Position X (deg)');  ylabel('Position Y (deg)')
                    title(PhaseList{s})
                    axis ij
                    set(gca,'XDir','reverse')
                end

                sgtitle([Animal_id '-' date '-' 'trial ' num2str(t) ', ' cxt_s ', ' dir_s ', loc '  num2str(UE_log.trials.Location(t)) ', ' obj_l '/' obj_r ', ' cho_s '(' cor_s ')'],'fontsize',20','FontWeight','b')
                saveas(gca,[ROOT.fig_trial '\' Animal_id '-' date '-' 'trial ' num2str(t) '.png'])
                close all
            end
        end

    end
end


%%
%%
    for i = 1:20
    figure(1)  
    imshow(processo(:,:,1,i))
      hold on
      plot(X,Y,'o')
      plot(X0,Y0,'o')
      plot(X1,Y1,'o')
      plot(X2,Y2,'o')
      plot(X3,Y3,'o')
      hold off
      F(i) = getframe(gcf) ;
      drawnow
    end
  % create the video writer with 1 fps
  writerObj = VideoWriter('myVideo.avi');
  writerObj.FrameRate = 10;
  % set the seconds per image
% open the video writer
open(writerObj);
% write the frames to the video
for i=1:length(F)
    % convert the image to a frame
    frame = F(i) ;    
    writeVideo(writerObj, frame);
end
% close the writer object
close(writerObj);
%%
function color_states(idt,ids,t)
id1=[find(ids==1 & idt==t,1,'first') find(ids==1 & idt==t,1,'last')];
id2=[find(ids==2 & idt==t,1,'first') find(ids==2 & idt==t,1,'last')];
id3=[find(ids==3 & idt==t,1,'first') find(ids==3 & idt==t,1,'last')];
id4=[find(ids==4 & idt==t,1,'first') find(ids==4 & idt==t,1,'last')];
patch([id2(1) id2(2) id2(2) id2(1)],[-30 -30 30 30],'r','facealpha',0.1, 'edgealpha',0)
patch([id3(1) id3(2) id3(2) id3(1)],[-30 -30 30 30],'y','facealpha',0.1, 'edgealpha',0)
patch([id4(1) id4(2) id4(2) id4(1)],[-30 -30 30 30],'b','facealpha',0.1, 'edgealpha',0)
end


