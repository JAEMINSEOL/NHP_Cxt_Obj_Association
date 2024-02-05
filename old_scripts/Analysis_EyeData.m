function Analysis_EyeData(Eye_Analog_unreal_recording,Eye_Analog_sync_recording_info,processed_folder_neuralynx,nLap)
%%
cd(processed_folder_neuralynx)
mkdir("EyeData")
addpath(genpath(program_folder))
addpath("F:\NHP project\실험 셋업 자료\Unreal Assets")
close all
%% Cursor position
JoystickID_Eye = CursorPosition(Eye_Analog_sync_recording_info,JoystickLeft_sync_recording,JoystickRight_sync_recording);
%% Eye Data Preprocessing
[X_lp,Y_lp,X_lp_deg, Y_lp_deg,Eye_sacc_XY_index_lp] = Eye_Classification_lowpassfilter(Eye_Analog_unreal_recording);

%%
load('D:\NHP project\Data\Program\Image\Obj_Image.mat')
load('D:\NHP project\Data\Program\Image\Cursor_Image.mat')

% cd([program_folder '\Image'])
% [F_O,F_O_A] = ImportObjImage(3,0.5);
% [ObjBoundary,VOrigin, VPolygon] = MakeObjBoundary(F_O,F_O_A,6);
% save('Obj_Image.mat','F_O','F_O_A','ObjBoundary','ObjChanceLevel')
%  close all
 
% figure;
% bar(horzcat(VOrigin(1:6)',VPolygon(1:6)'))
% xlabel('Object'); ylabel('size(pixel)')
% xticklabels({'Donut','Pumpkin','Turtle','Jellyfish','Octopus','Pizza'})
% set(gca,'FontSize',15,'FontWeight','b')
% legend({'Original','Masked'})

%% InTrial 2D Eyegaze Map
NTrials = size(TrialInfo_sync_recording,1);
FixPoint_Intrials = [];
for t = 1:NTrials
% Plot cross at row 100, column 50
[ChLat(t,1:3),FixPoint_Intrials_temp] = Eye_Plotting_inTrials(Eye_Analog_sync_recording_info(:,4:13),t,X_lp_deg,Y_lp_deg,Eye_sacc_XY_index_lp(:,1));
FixPoint_Intrials = vertcat(FixPoint_Intrials,FixPoint_Intrials_temp);
cd([processed_folder_neuralynx '\EyeData'])
saveas(gcf,[animal_id '-' session_date '-Trial ' num2str(t) '.png']);
close gcf
end
save('Eye_InTrial.mat','FixPoint_Intrials')
%% Eye_Plotting_inTrials_Object_Scatter
o=1;
NTrials = size(TrialInfo_sync_recording,1);
Fix_InObj = NaN(12,NTrials,15,2);
FixPoint_All=[];
for cxt=0:0
    for loc=0:0
        
        
%         if c==1 C='L'; elseif c==2 C='R'; end
        if o==1 O='L'; elseif o==2 O='R'; end
        Cxt = Cxt_Name(cxt);
        Loc = Loc_Name(loc);
        
        for ol=1:6
            [Fix_InObj(ol,:,:,:), FixPoint] = Eye_Plotting_inTrials_Object_Scatter(Eye_Analog_sync_recording_info(:,4:13),JoystickID_Eye,ol,X_lp_deg,Y_lp_deg,Eye_sacc_XY_index_lp(:,1),program_folder,F_O,F_O_A,ObjBoundary,CursorBoundary,1,1,cxt,loc);
%             [Fix_InObj(ol+6,:,:,:), FixPoint_R] = Eye_Plotting_inTrials_Object_Scatter(Eye_Analog_sync_recording_info(:,4:13),JoystickID_Eye,ol,X_lp_deg,Y_lp_deg,Eye_sacc_XY_index_lp(:,1),program_folder,F_O,F_O_A,ObjBoundary,CursorBoundary,2,2,cxt,loc);
            close gcf
            cd([processed_folder_neuralynx '\EyeData'])
            title(['Eye-' Cxt '-' Loc '-Obj-' num2str(ol) '-Scatter-obj' O '-bound-line'])
%             saveas(gcf,['Eye_' Cxt '_' Loc '_Obj_' num2str(ol) '_Scatter_obj' O '_bound_line_avg.png'])
            close gcf
             FixPoint_All = vertcat( FixPoint_All,FixPoint);
        end
    end
end


%% Eye_Plotting_inTrials_Object_Line
for cxt=1:2
    for loc=1:8
        for c=0:0
            for o=0:0
                
                if c==1 C='L'; elseif c==2 C='R'; else C='x'; end
                if o==1 O='L'; elseif o==2 O='R'; else O='x'; end
                
                for ol=0:0
                    Eye_Plotting_inTrials_Object_Line(Eye_Analog_sync_recording_info(:,4:13),cxt,loc,ol,X_lp_deg,Y_lp_deg,Eye_sacc_XY_index_lp(:,1),program_folder,F_O,F_O_A,c,o)
                    cd([processed_folder_neuralynx '\EyeData'])
                     Cxt = Cxt_Name(cxt);
    Loc = num2str(loc);
                    title(['Eye-Obj-' num2str(ol) '-Line-' Cxt '-Loc' Loc 'c' C 'o' O '-PreSample'])
                    saveas(gcf,['Eye_Obj_' num2str(ol) '_Line_' Cxt '_Loc' Loc 'c' C 'o' O '_PreSample.png'])
                    close gcf
                    
                end
            end
        end
    end
end
%% Overall InTrial Fixation Points
for cxt = 1:2
    for loc = 1:8
        for res = 1:2
            EyePlotting_inTrials_Overall(cxt,loc,res,FixPoint_Intrials)
            cd([processed_folder_neuralynx '\EyeData'])
            Res = Res_Name(res);
saveas(gcf,['Cxt ' num2str(cxt) '-Loc ' num2str(loc) '-' Res '.jpg']);
        end
    end
end
Fix_InTrials =[];
for t = 1:NTrials
    FI = squeeze(FixPoint_Intrials(t,:,:));
    FI(isnan(FI(:,1)),:)=[];
    Fix_InTrials = vertcat(Fix_InTrials,FI);
end
FixPoint_Intrials = Fix_InTrials;
%%
for res = 1:2
    for ol=1:6
        
        EyePlotting_inTrials_Overall(0,0,res,ol,0,FixPoint_Intrials)
    end
    for or=1:6
        
        EyePlotting_inTrials_Overall(0,0,res,0,or,FixPoint_Intrials)
    end
end
%%
for cxt = 1:2
    for loc=1:8
        for res=1:2
            EyePlotting_inTrials_Overall(cxt,loc,res,0,0,FixPoint_Intrials)
            %         close gcf
        end
    end
end



%%
for t = 1:1
EyeGazeMovie(Eye_Analog_sync_recording_info(:,4:13),t,X_lp_deg,Y_lp_deg,Eye_sacc_XY_index_lp(:,1),program_folder,F_O,F_O_A,JoystickID_Eye)
end
%%
for c=0:2
    for l=1:8
        for r=1:2
            for o=1:6
% EyeGazeMovie(Eye_Analog_sync_recording_info(:,4:13),t,X_lp_deg,Y_lp_deg,Eye_sacc_XY_index_lp(:,1),program_folder,F_O,F_O_A,JoystickID_Eye)
EyeGazeMovie_Obj(Eye_Analog_sync_recording_info(:,4:13),c,l,o,r,X_lp_deg,Y_lp_deg,Eye_sacc_XY_index_lp(:,1),program_folder,F_O,F_O_A,JoystickID_Eye)
            end
        end
    end
end
%% Load Context .stl Image
load('STLImportedContexts.mat')

% cd([program_folder '\Image'])
% 
% STL_Forest_Landscape = stlread_NHP('Forest_context_b.stl');
% STL_Forest_Foliage = stlread_NHP('Forest_Foliage2_Poly.stl');
% STL_City = stlread_NHP('City_context_b.stl');
% 
% STL_Forest_Sky = stlread_NHP('Forest_Sky.stl');
% STL_City_Sky = stlread_NHP('City_Sky.stl');
% %%
% STL_City_Sky.vertices(:,2) = STL_City_Sky.vertices(:,2)+200.8;
% STL_City_Sky.vertices(:,1) = STL_City_Sky.vertices(:,1)-81.7;
% STL_City_Sky.vertices = STL_City_Sky.vertices*50000;
% % STL_City_Sky.vertices(STL_City_Sky.vertices(:,3)<-2000,:) = NaN;
% 
% STL_Forest_Sky.vertices(:,2) = STL_Forest_Sky.vertices(:,2)-8.9;
% STL_Forest_Sky.vertices(:,1) = STL_Forest_Sky.vertices(:,1)-81.2;
% STL_Forest_Sky.vertices = STL_Forest_Sky.vertices*50000;
% STL_Forest_Sky.vertices(STL_Forest_Sky.vertices(:,3)<-2000,:) = NaN;
% 
% 
% STL_Forest.faces = []; 
% for f = 1:length(STL_Forest.vertices)/3-1
%         STL_Forest.faces(f,1:3) = [3*(f-1)+1,3*(f-1)+2,3*(f-1)+3];
% end


%    
% STL_City_o = stlread_NHP('City_context_o.stl');
% STL_City_All.vertices = vertcat(STL_City_o.vertices,STL_City.vertices);
% STL_City_All.faces = []; 
% for f = 1:length(STL_City_All.vertices)/3-1
%         STL_City_All.faces(f,1:3) = [3*(f-1)+1,3*(f-1)+2,3*(f-1)+3];
% end
%%
% clear origin direction intersection FixPoint
% origin = NaN(nLap,8,20000,5); intersection = NaN(nLap,8,20000,4); direction = NaN(nLap,8,20000,4); FixPoint_InterTrial = NaN(nLap,8,20000,5);
%% Inter Trial Interval 3D Eyegaze Map
tic;
for l=93:nLap
    for d=1:2
        tic;
[origin(l,d,:,:), direction(l,d,:,:), intersection(l,d,:,:),FixPoint_InterTrial(l,d,:,:),FigTitle,fig,ax1] = Eye_Plotting_InterTrial(STL_Forest,STL_City,STL_Forest_Sky,STL_City_Sky,TrialInfo_sync_recording,l,d,TickLog_sync_recording_info,Eye_Analog_sync_recording_info,Eye_sacc_XY_index_lp(:,1),X_lp,Y_lp);
cd([processed_folder_neuralynx '\EyeData'])
% savefig(fig,[FigTitle '.fig']);
% saveas(fig,[FigTitle '.jpg']);
close gcf
l
toc;
    end
end
save('Eye_InterTrial.mat','FixPoint_InterTrial')
toc;