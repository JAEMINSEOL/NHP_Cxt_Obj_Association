% Z1_display_choice_event_picture
sz=60;
ROOT.fig_lap = ['X:\E-Phys Analysis\NHP project\Property sheet\Preprocessing\lap\' Animal_id '_' date];
ROOT.fig_trial = ['X:\E-Phys Analysis\NHP project\Property sheet\Preprocessing\trial\' Animal_id '_' date];
%% display
for lap=1:round(size(UE_log.trials,1)/8)
    %%
    t1=(lap-1)*8+1; t2=(lap-1)*8+8;
    is=find(Datapixx_eye_T.lap==lap,1,'first'); ie=find(Datapixx_eye_T.lap==lap,1,'last');
    if ~isempty(ie)
        x = X_lp_deg(is:ie); y= Y_lp_deg(is:ie);  idx = Datapixx_eye_T.saccade(is:ie,1); 


        idt = Datapixx_eye_T.trial(is:ie); ids = Datapixx_eye_T.on_trial(is:ie);
        vx = Eye_Speed_deg_inst_lp(is:ie,1); vy = Eye_Speed_deg_inst_lp(is:ie,2); ax = Eye_Acc_deg_inst_lp(is:ie,1); ay = Eye_Acc_deg_inst_lp(is:ie,2); pup=Datapixx_eye_T.pupil(is:ie);
        idturn=Datapixx_eye_T.on_turn(is:ie); ids2 = Datapixx_eye_T.on_lap(is:ie);
        turn_s=find(idturn,1,'first'); turn_e=find(idturn,1,'last');

        ticklabs={};
        for i=0:round((ie-is)/1000), ticklabs{i+1} = num2str(i); end

        figure('Position',[-2419,219,2477,641]);
        subplot(2,1,1); hold on


        plot(x,'color','k')
        %         scatter(find(idx==0),x(idx==0),10,'g','filled')
        scatter(find(idx==1),x(idx==1),20,'r','filled')
        scatter(find(idx==2),x(idx==2),20,'b','filled')
        scatter(find(idx==3),x(idx==3),20,[0.4940 0.1840 0.5560],'filled')
        xlabel('time(s)'); xlim([0 ie-is]); xticks(0:1000:ie-is); xticklabels(ticklabs)
        ylabel('Position X (deg)'); ylim([-30 30])
        for t=t1:t2
            color_states(idt,ids,t,30)
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
        %          scatter(find(idx==0),y(idx==0),10,'g','filled')
        scatter(find(idx==3),y(idx==3),20,[0.4940 0.1840 0.5560],'filled')
        scatter(find(idx==1),y(idx==1),20,'r','filled')
        scatter(find(idx==2),y(idx==2),20,'b','filled')

        xlabel('time(s)'); xlim([0 ie-is]); xticks(0:1000:ie-is); xticklabels(ticklabs)
        ylabel('Position Y (deg)'); ylim([-30 30])
        for t=t1:t2
            color_states(idt,ids,t,30)
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
        text(500,32,'Fixation','color','r'); text(1500,32,'Ocular following (drift)','color','b');  text(4000,32,'Post-Saccadic Oscillation (PSO)','color',[0.4940 0.1840 0.5560]);

        cxt = UE_log.trials.Context(t1); if cxt==1, cxt_s = 'Forest'; else, cxt_s='City'; end
        sgtitle([Animal_id '-' date '-' 'lap ' num2str(lap) ', ' cxt_s],'fontsize',20','FontWeight','b')
        saveas(gca,[ROOT.fig_lap '\' Animal_id '-' date '-' 'lap ' num2str(lap) '.png'])
        close all

        %% speed verification
         figure('Position',[-2419,219,2477,641]);
        subplot(2,1,1); hold on


        plot(vx,'color','k')
        %         scatter(find(idx==0),x(idx==0),10,'g','filled')
        scatter(find(idx==1),vx(idx==1),20,'r','filled')
        scatter(find(idx==2),vx(idx==2),20,'b','filled')
        scatter(find(idx==3),vx(idx==3),20,[0.4940 0.1840 0.5560],'filled')
        xlabel('time(s)'); xlim([0 ie-is]); xticks(0:1000:ie-is); xticklabels(ticklabs)
        ylabel('Speed X (deg / s)'); ylim([-1500 1500])
        for t=t1:t2
            color_states(idt,ids,t,1500)
            text(find(ids==2 & idt==t,1,'first'),1600,['trial ' num2str(t)])
        end
        id=[find(ids2==0, 1,'first') find(ids2==0,1,'last')];
        patch([id(1) id(2) id(2) id(1)],[-1500 -1500 1500 1500],'k','facealpha',0.1, 'edgealpha',0)
        line([0 size(vx,1)], [0 0],'color', 'k','linestyle',':')
        line([turn_s turn_s], [-1500 1500],'color', 'r','linestyle',':')
        line([turn_e turn_e], [-1500 1500],'color', 'r','linestyle',':')

        text(turn_s,32,['u-turn'])
        text(find(~ids2,1,'first'),1600,['turnnel'])

        subplot(2,1,2); hold on
        plot(vy,'color','k')
        %          scatter(find(idx==0),y(idx==0),10,'g','filled')
        scatter(find(idx==3),vy(idx==3),20,[0.4940 0.1840 0.5560],'filled')
        scatter(find(idx==1),vy(idx==1),20,'r','filled')
        scatter(find(idx==2),vy(idx==2),20,'b','filled')

        xlabel('time(s)'); xlim([0 ie-is]); xticks(0:1000:ie-is); xticklabels(ticklabs)
        ylabel('Speed Y (deg / s)'); ylim([-1500 1500])
        for t=t1:t2
            color_states(idt,ids,t,1500)
        end
        id=[find(ids2==0, 1,'first') find(ids2==0,1,'last')];
        patch([id(1) id(2) id(2) id(1)],[-1500 -1500 1500 1500],'k','facealpha',0.1, 'edgealpha',0)
        line([0 size(x,1)], [0 0],'color', 'k','linestyle',':')
        line([turn_s turn_s], [-1500 1500],'color', 'r','linestyle',':')
        line([turn_e turn_e], [-1500 1500],'color', 'r','linestyle',':')

%         patch([3400 5500 5500 3400], [25 25 30 30],'b','facealpha',0.5, 'edgealpha',0)
%         patch([400 1800 1800 400], [25 25 30 30],'r','facealpha',0.5, 'edgealpha',0)
%         patch([1900 3300 3300 1900], [25 25 30 30],'y','facealpha',0.5, 'edgealpha',0)

%         text(500,28,'Cursor On','color','k'); text(2000,28,'Object On','color','k');  text(3500,28,'Choice Available','color','k');
text(500,1600,'Fixation','color','r'); text(1500,1600,'Ocular following (drift)','color','b');  text(4000,1600,'Post-Saccadic Oscillation (PSO)','color',[0.4940 0.1840 0.5560]);

        cxt = UE_log.trials.Context(t1); if cxt==1, cxt_s = 'Forest'; else, cxt_s='City'; end
        sgtitle([Animal_id '-' date '-' 'lap ' num2str(lap) ', ' cxt_s],'fontsize',20','FontWeight','b')
        saveas(gca,[ROOT.fig_lap '\speed_' Animal_id '-' date '-' 'lap ' num2str(lap) '.png'])
        close all
        %%
        for t=t1:t2
            tr =  rem(t,8);
            cxt = UE_log.trials.Context(t); if cxt==1, cxt_s = 'Forest'; else, cxt_s='City'; end
            direct = UE_log.trials.Direction(t); if direct==1, dir_s='Outbound'; else, dir_s='Inbound'; end
            cho = UE_log.trials.CorrectAnswer(t); if cho==0, cho_s='Left'; else, cho_s='Right'; end
            if UE_log.trials.Choice(t)==UE_log.trials.CorrectAnswer(t), cor_s='Correct'; else, cor_s='Wrong'; end
            obj_l = UE_log.trials.ObjectLeft{t}; obj_r = UE_log.trials.ObjectRight{t};
            loc = tr; if loc==0, loc=8; end

            figure('position',[-2419,0,1500, 1000])
            is=find(Datapixx_eye_T.trial==t,1,'first'); ie=find(Datapixx_eye_T.trial==t,1,'last');
            if ~isempty(ie)
%                 x = X_lp_deg(is:ie); y= Y_lp_deg(is:ie);  
                    x = X_lp(is:ie); y= Y_lp(is:ie); 
x1=(x+5)*2000/10; y1=(y+5)*1125/10;
                idx = Datapixx_eye_T.saccade(is:ie,1); idt = Datapixx_eye_T.trial(is:ie); ids = Datapixx_eye_T.on_trial(is:ie);
                PhaseList = {'Before cursor (-500 ~ 0ms)',['Cursor on (0 ~ ' num2str(sum(ids==2)) 'ms)'],['Object on (' num2str(sum(ids==2)) ' ~ ' num2str(sum(ids==2)+sum(ids==3)) 'ms)'],...
                    ['Choice Available (' num2str(sum(ids==2)+sum(ids==3)) ' ~ ' num2str(sum(ids==2)+sum(ids==3)+sum(ids==4)) 'ms)']};

                for s=1:4
                    subplot(2,2,s); hold on

                    im = imread(['D:\NHP project\실험 셋업 자료\Unreal Assets\with disc\Cxt' num2str(cxt) '_Loc' num2str(loc) '.png']);
                    imx = rgb2gray((im));

                    imgl = imread(['D:\NHP project\실험 셋업 자료\Unreal Assets\' obj_l '_Left.png']);
            imglx=rgb2gray((imgl));
            imgr = imread(['D:\NHP project\실험 셋업 자료\Unreal Assets\' obj_r '_Right.png']);
            imgrx=rgb2gray((imgr));

                    imagesc(im); colormap('gray')

                               alphaData=ones(1127,2002); alphaData(imglx==0)=0;
                imagesc(imgl, 'AlphaData', alphaData)

                alphaData=ones(1127,2002); alphaData(imgrx==0)=0;
                imagesc(imgr, 'AlphaData', alphaData)


                    % x1=(x+30.72)*2000/54.73; y1=(y+18.93)*1125/36.5685;
%                     x1=(x+29)*2000/54.73; y1=(y+17)*1125/36.5685;
                    xs=x1(ids==s); ys=y1(ids==s);
%                     plot(x1(ids==s),y1(ids==s),'k')
                    %                     scatter(x1(ids==s & idx==0),y1(ids==s & idx==0),15,'g','filled')
%                     scatter(x1(ids==s & idx==3),y1(ids==s & idx==3),sz,[0.4940 0.1840 0.5560],'filled')

                    k=1; temp=idx(ids==s); temp(1)=1; temp(end)=1; sac_arrow=[];
                    for sa=1:size(temp,1)-1
                        if temp(sa)~=0 && temp(sa+1)==0, sac_arrow(k,1)=sa; end
                        if temp(sa)==0 && temp(sa+1)~=0; sac_arrow(k,2)=sa; k=k+1; end
                    end
                    for sa=1:size(sac_arrow,1)
                        quiver(xs(sac_arrow(sa,1)),ys(sac_arrow(sa,1)), xs(sac_arrow(sa,2))-xs(sac_arrow(sa,1)), ys(sac_arrow(sa,2))-ys(sac_arrow(sa,1)),...
                            'color','w','LineWidth',2,'autoscale','off')
                    end

                    scatter(x1(ids==s & idx==3),y1(ids==s & idx==3),sz,'m','LineWidth',1)
                    scatter(x1(ids==s & idx==1),y1(ids==s & idx==1),sz,'r','LineWidth',1)
                    scatter(x1(ids==s & idx==2),y1(ids==s & idx==2),sz,'c','LineWidth',1)

                    text(x1(find((ids==s),1,'first')),y1(find((ids==s),1,'first'))-50,'st','color','r','fontweight','b');
                    text(x1(find((ids==s),1,'last')),y1(find((ids==s),1,'last'))-50,'end','color','r','fontweight','b')
                    xlim([0 2000]); ylim([0 1125]);
%                     xticks([0:500:2000]); 
%                     yticks([0:281:1125]); 
                    xlabel('Position X (px)');  ylabel('Position Y (px)')
                    title(PhaseList{s})
                    axis ij
                    %                     set(gca,'XDir','reverse')
                end

                sgtitle([Animal_id '-' date '-' 'trial ' num2str(t) ', ' cxt_s ', ' dir_s ', loc '  num2str(UE_log.trials.Location(t)) ', ' obj_l '/' obj_r ', ' cho_s '(' cor_s ')'],'fontsize',20','FontWeight','b')
                saveas(gca,[ROOT.fig_trial '\Color_deg_' Animal_id '-' date '-' 'trial ' num2str(t) '.png'])
                close all
            end
        end

    end
end
%%
%%
function color_states(idt,ids,t, h)
id1=[find(ids==1 & idt==t,1,'first') find(ids==1 & idt==t,1,'last')];
id2=[find(ids==2 & idt==t,1,'first') find(ids==2 & idt==t,1,'last')];
id3=[find(ids==3 & idt==t,1,'first') find(ids==3 & idt==t,1,'last')];
id4=[find(ids==4 & idt==t,1,'first') find(ids==4 & idt==t,1,'last')];
patch([id2(1) id2(2) id2(2) id2(1)],[-h -h h h],'r','facealpha',0.1, 'edgealpha',0)
patch([id3(1) id3(2) id3(2) id3(1)],[-h -h h h],'y','facealpha',0.1, 'edgealpha',0)
patch([id4(1) id4(2) id4(2) id4(1)],[-h -h h h],'b','facealpha',0.1, 'edgealpha',0)
end
