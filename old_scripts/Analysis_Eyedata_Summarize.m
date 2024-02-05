%%

addpath(genpath(program_folder))
close all
%% Eye Data Preprocessing
[X_lp,Y_lp,X_lp_deg, Y_lp_deg,Eye_sacc_XY_index_lp] = Eye_Classification_lowpassfilter(Eye_Analog_unreal_recording);

if max(Eye_Analog_sync_recording_info(:,2)) < 10
Eye_Analog_sync_recording_info(:,2) = (Eye_Analog_sync_recording_info(:,2) + 5) * 192; % Analog voltage값으로 기록된 gaze X position data를 monitor 해상도에 맞게 변환 ([-5 5] -> [0 1920])
Eye_Analog_sync_recording_info(:,3) = (Eye_Analog_sync_recording_info(:,3) + 5) * 108;
end

if size(Eye_Analog_sync_recording_info,2)<12
    temp_1 = [9;Eye_Analog_sync_recording_info(:,6)];
    ie = find([Eye_Analog_sync_recording_info(:,6);9]==0 & temp_1(:,1)==3);
    for i=1:length(ie)-1
        Eye_Analog_sync_recording_info(ie(i):ie(i+1),12) = i;
    end
    Eye_Analog_sync_recording_info(:,13) = 0;
end

 Eye_mat = array2table(Eye_Analog_sync_recording_info,'VariableNames',{'Timestamp','Eye_X','Eye_Y','context','area','phase','ObjLeft','ObjRight','Direction','Response','Correctness','Trial','Void'});
  Eye_mat.saccade = ~Eye_sacc_XY_index_lp(:,1);
  
  %%
  load([mother_drive 'Program\Image\Obj_Image.mat'])
load([mother_drive 'Program\Image\Cursor_Image.mat'])
  
  FixPoint(:,1) = Eye_mat.Eye_X;
  FixPoint(:,2) = Eye_mat.Eye_Y;
  %%
  in=zeros(size(FixPoint,1),4);
  for i = 1:size(FixPoint,1)
      ol=Eye_mat.ObjLeft(i);
      or=Eye_mat.ObjRight(i)+6;
      
      in(i,1) = InObj(ObjBoundary,FixPoint(i,:),ol);
      in(i,2) = InObj(ObjBoundary,FixPoint(i,:),or);
      
      if (FixPoint(i,1)>520 && FixPoint(i,1)<805) && (FixPoint(i,2)>330 && FixPoint(i,2)<615)
          in(i,3)=1;
      elseif (FixPoint(i,1)>1195 && FixPoint(i,1)<1480) && (FixPoint(i,2)>330 && FixPoint(i,2)<615)
          in(i,4)=1;
      end
  end
  Eye_mat.InLObj=in(:,1);
  Eye_mat.InRObj=in(:,2);
  Eye_mat.InLDisc=in(:,3);
  Eye_mat.InRDisc=in(:,4);
  
  %%
  Eye.trial = zeros(max(Eye_mat.Trial),8);
  Eye.trial_fix = zeros(max(Eye_mat.Trial),16);
  Eye.trial_fix_sum = zeros(max(Eye_mat.Trial),6);
  clear id
  for t = 1:max(Eye_mat.Trial)
      id.t=find(Eye_mat.Trial==t);
      id.p0=find(and(Eye_mat.Trial==t,Eye_mat.phase==-1));
      id.p1=find(and(Eye_mat.Trial==t,Eye_mat.phase==1));
      id.p2=find(and(Eye_mat.Trial==t,Eye_mat.phase==2));
      id.p3=find(and(Eye_mat.Trial==t,Eye_mat.phase==3));
      
      Eye.trial_fix(t,1)=sum(Eye_mat.saccade(id.p0));
      Eye.trial_fix(t,2)=sum(Eye_mat.saccade(id.p0) & Eye_mat.InLDisc(id.p0));
      Eye.trial_fix(t,3)=sum(Eye_mat.saccade(id.p0) & Eye_mat.InRDisc(id.p0));
      
      Eye.trial_fix(t,4)=sum(Eye_mat.saccade(id.p1));
      Eye.trial_fix(t,5)=sum(Eye_mat.saccade(id.p1) & Eye_mat.InLDisc(id.p1));
      Eye.trial_fix(t,6)=sum(Eye_mat.saccade(id.p1) & Eye_mat.InRDisc(id.p1));
      
      Eye.trial_fix(t,7)=sum(Eye_mat.saccade(id.p2));
      Eye.trial_fix(t,8)=sum(Eye_mat.saccade(id.p2) & Eye_mat.InLDisc(id.p2));
      Eye.trial_fix(t,9)=sum(Eye_mat.saccade(id.p2) & Eye_mat.InRDisc(id.p2));
      Eye.trial_fix(t,10)=sum(Eye_mat.saccade(id.p2) & Eye_mat.InLObj(id.p2));
      Eye.trial_fix(t,11)=sum(Eye_mat.saccade(id.p2) & Eye_mat.InRObj(id.p2));
      
      Eye.trial_fix(t,12)=sum(Eye_mat.saccade(id.p3));
      Eye.trial_fix(t,13)=sum(Eye_mat.saccade(id.p3) & Eye_mat.InLDisc(id.p3));
      Eye.trial_fix(t,14)=sum(Eye_mat.saccade(id.p3) & Eye_mat.InRDisc(id.p3));
      Eye.trial_fix(t,15)=sum(Eye_mat.saccade(id.p3) & Eye_mat.InLObj(id.p3));
      Eye.trial_fix(t,16)=sum(Eye_mat.saccade(id.p3) & Eye_mat.InRObj(id.p3));
      
      Eye.trial(t,1)=t;
      Eye.trial(t,2)=max(Eye_mat.context(id.t));
      Eye.trial(t,3)=max(Eye_mat.ObjLeft(id.t));
      Eye.trial(t,4)=max(Eye_mat.ObjRight(id.t));
      Eye.trial(t,5)=max(Eye_mat.Direction(id.t));
      Eye.trial(t,6)=max(Eye_mat.Response(id.t));
      Eye.trial(t,7)=max(Eye_mat.Correctness(id.t));
      Eye.trial(t,8)=min(Eye_mat.Void(id.p2));
      
      if Eye.trial(t,5)==1, d2=2; else, d2=1; end
      Eye.trial_fix_sum(t,1)=(Eye.trial_fix(t,9+Eye.trial(t,5))+Eye.trial_fix(t,14+Eye.trial(t,5)))/...
         (Eye.trial_fix(t,7)+Eye.trial_fix(t,12));
     Eye.trial_fix_sum(t,2)=(Eye.trial_fix(t,9+d2)+Eye.trial_fix(t,14+d2))/...
         (Eye.trial_fix(t,7)+Eye.trial_fix(t,12));
     
    Eye.trial_fix_sum(t,3)=(Eye.trial_fix(t,10)+Eye.trial_fix(t,15))/...
         (Eye.trial_fix(t,7)+Eye.trial_fix(t,12));
     Eye.trial_fix_sum(t,4)=(Eye.trial_fix(t,11)+Eye.trial_fix(t,16))/...
         (Eye.trial_fix(t,7)+Eye.trial_fix(t,12));
     
     Eye.trial_fix_sum(t,5)=(Eye.trial_fix(t,2)+Eye.trial_fix(t,5))/...
         (Eye.trial_fix(t,1)+Eye.trial_fix(t,4));
     if isnan(Eye.trial_fix_sum(t,5)), Eye.trial_fix_sum(t,5)=0; end
     Eye.trial_fix_sum(t,6)=(Eye.trial_fix(t,3)+Eye.trial_fix(t,6))/...
         (Eye.trial_fix(t,1)+Eye.trial_fix(t,4));
     if isnan(Eye.trial_fix_sum(t,6)), Eye.trial_fix_sum(t,6)=0; end
  end
  
  %%
  Eye.session=[]; hp = round(size(Eye.trial,1)/2);
  for i=1:2
          id = find(Eye.trial(:,5)==i & Eye.trial(:,7)==1);
  Eye.session.CWLR(1,2*i-1) = mean(Eye.trial_fix_sum(id,3));
  Eye.session.CWLR(1,2*i) = mean(Eye.trial_fix_sum(id,4));
  
  id = find(Eye.trial(:,5)==i & Eye.trial(:,7)==1 & Eye.trial(:,1)<=hp);
  Eye.session.CWLR(2,2*i-1) = mean(Eye.trial_fix_sum(id,3));
  Eye.session.CWLR(2,2*i) = mean(Eye.trial_fix_sum(id,4));
  
  id = find(Eye.trial(:,5)==i & Eye.trial(:,7)==1 & Eye.trial(:,1)>hp);
  Eye.session.CWLR(3,2*i-1) = mean(Eye.trial_fix_sum(id,3));
  Eye.session.CWLR(3,2*i) = mean(Eye.trial_fix_sum(id,4));
  end
  
  for h=1:3
      if h==1, is=1; ie = size(Eye.trial,1);
      elseif h==2, is=1; ie = hp;
     elseif h==3, is=hp+1; ie = size(Eye.trial,1); end
              
     lt = (sum(Eye.trial_fix(is:ie,10))+sum(Eye.trial_fix(is:ie,15)));
     rt = (sum(Eye.trial_fix(is:ie,11))+sum(Eye.trial_fix(is:ie,16)));
     Eye.session.fix(h,1) = (lt-rt)/(lt+rt);
     
     Eye.session.fix(h,2) = length(find(sum(Eye.trial_fix_sum(is:ie,3:4),2)==0));
     Eye.session.fix(h,3) = length(find(Eye.trial_fix_sum(is:ie,3) & ~Eye.trial_fix_sum(is:ie,4)));
     Eye.session.fix(h,4) = length(find(~Eye.trial_fix_sum(is:ie,3) & Eye.trial_fix_sum(is:ie,4)));
     
     Eye.session.fix(h,5) = length(find(Eye.trial_fix_sum(is:ie,5) | Eye.trial_fix_sum(is:ie,6)));
     Eye.session.fix(h,6) = length(find(Eye.trial_fix_sum(is:ie,5) & ~Eye.trial_fix_sum(is:ie,6)));
     Eye.session.fix(h,7) = length(find(~Eye.trial_fix_sum(is:ie,5) & Eye.trial_fix_sum(is:ie,6)));
     Eye.session.fix(h,8) = mean(Eye.trial_fix_sum(is:ie,5));
     Eye.session.fix(h,9) = mean(Eye.trial_fix_sum(is:ie,6));
     for o=1:6
         idol = find(Eye.trial(is:ie,3)==o); idor = find(Eye.trial(is:ie,4)==o);
     Eye.session.obj(h,o) = mean(vertcat(Eye.trial_fix_sum(idol,3),Eye.trial_fix_sum(idor,4)));
     end
  end
  
  %%
  
   table_temp1 = array2table(Eye.session.CWLR,'VariableNames',{'CorrectLeft', 'CorrectRight','WrongLeft','WrongRight'});
   table_temp2 = array2table(Eye.session.fix(:,1:4),'VariableNames',{'bias','NLandNR','OnlyL','OnlyR'});
       
   
   Eye_table.([animal_id '_' session_date]).trial = array2table( Eye.trial_fix,'VariableNames',{'PreCursor_All','PreCursor_LDisc','PreCursor_RDisc',...
       'PreSample_All','PreSample_LDisc','PreSample_RDisc','Sample_All','Sample_LDisc','Sample_RDisc','Sample_LObj','Sample_RObj','Choice_All','Choice_LDisc','Choice_RDisc','Choice_LObj','Choice_RObj'});
   Eye_table.([animal_id '_' session_date]).session.FixOnObj =  horzcat(table_temp2,table_temp1);
   Eye_table.([animal_id '_' session_date]).session.Disc_BeforeObjOn = array2table( Eye.session.fix(:,5:9),'VariableNames',{'NLandNR','OnlyL','OnlyR','LDiscRate','RDiscRate'});
   Eye_table.([animal_id '_' session_date]).session.FixBtwObj = array2table(Eye.session.obj,'VariableNames',{'Pumpkin','Donut','Jellyfish','Turtle','Pizza','Octopus'});
   
save([mother_drive 'EyeData_Summary.mat'],'Eye_table','-append');
   %%
  function in = InObj(ObjBoundary,FixPoint_f,ol)
  if ol==0
      in=0;
  else
        xv = ObjBoundary(ol,:,1)'; xv(isnan(xv))=[];
        yv = ObjBoundary(ol,:,2)'; yv(isnan(yv))=[];
        
        xq = FixPoint_f(1,1);
        yq = FixPoint_f(1,2);
        [in,oxn] = inpolygon(xq,yq,xv,yv);
  end
    end