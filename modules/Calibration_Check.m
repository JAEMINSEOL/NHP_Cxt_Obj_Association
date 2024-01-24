function Calibration_Check(Eye_Analog_datapixx,EventLog_datapixx)

%%
x = Eye_Analog_datapixx(:,1); y = Eye_Analog_datapixx(:,2);
C = (-3:3:3);

Eye_Raw = [Eye_Analog_datapixx(:,4) Eye_Analog_datapixx(:,1) Eye_Analog_datapixx(:,2) Eye_Analog_datapixx(:,3)];
[~,~,~, ~,Eye_sacc_XY_index_lp] = Eye_Classification_lowpassfilter(Eye_Raw);
%%
t=1; s=1; Cali_ID=[]; Inc_ID=[];
for i=1:length(EventLog_datapixx)
    if or(strcmp(EventLog_datapixx{i,1},'CaliEnd'),strcmp(EventLog_datapixx{i,1},'CaliStart'))
        Cali_ID(t,1)=i;

        t=t+1;
    end

    if or(strcmp(EventLog_datapixx{i,1},'CaliNum'),strcmp(EventLog_datapixx{i,1},'Water'))
        Inc_ID(s,1)=i;

        s=s+1;
    end
end
Inc_ID(Inc_ID>Cali_ID(end)+1)=[];

Cali_index = cell2mat(EventLog_datapixx(1:Cali_ID(end),2:3));
Cali_index = Cali_index(Inc_ID,:);
Cali_index(:,3) = knnsearch(Eye_Analog_datapixx(:,4),Cali_index(:,1));
SaccIndex = Eye_sacc_XY_index_lp(:,1);
%%

c = hsv(9); Cali_Circle=[]; r=0.2;
x = Eye_Analog_datapixx(:,1); y = Eye_Analog_datapixx(:,2);
FixPoint_Obj = [];

f1=figure;
for cl=1:9
    idcx = mod(cl,3); if idcx==0 idcx=3; end
    idcy = fix((cl-1)/3)+1;

    cl2 = c(cl,:);
    Circle_JM(C(idcx),C(idcy)*(-1),r,cl2)
    hold on
end

for i= 1:size(Cali_index,1)-1
    if Cali_index(i+1,2)==0 && Cali_index(i,2)~=0
        id = [Cali_index(i,3):Cali_index(i+1,3)];
        [FixPoint] = FindFixationPoint(SaccIndex,x,y,id,'mid');
        if size(FixPoint,1)<3
FixPoint = FixPoint(1,:);
        else
          FixPoint = FixPoint(end-2:end-1,:);  
        end
        % scatter(FixPoint(end-2:end-1,1), FixPoint(end-2:end-1,2),40,c(Cali_index(i,2),:),'filled')
        scatter(FixPoint(:,1), FixPoint(:,2),10,c(Cali_index(i,2),:),'filled')
        hold on
        scatter(FixPoint(end,1), FixPoint(end,2),40,c(Cali_index(i,2),:),'filled','MarkerEdgeColor',[0 0 0])
        % scatter(x(Cali_index(i,3):Cali_index(i+1,3)),y(Cali_index(i,3):Cali_index(i+1,3)),20,c(Cali_index(i,2),:),'filled','MarkerEdgeColor',[0 0 0])
        line(FixPoint(:,1), FixPoint(:,2),'Color','k')
        line(FixPoint(:,1), FixPoint(:,2),'Color','k')
    end
end

xlim([-5.5 5.5]); ylim([-5.5 5.5])
xlabel('Eye X data (V)'); ylabel('Eye Y data (V)')
hold off
%%
f2=figure;
for cl=1:9
    idcx = mod(cl,3); if idcx==0 idcx=3; end
    idcy = fix((cl-1)/3)+1;
    cl2 = c(cl,:);
    Circle_JM(C(idcx),C(idcy)*(-1),r,'k')
    hold on
    Cali_Circle(cl,:) = [C(idcx),C(idcy)*(-1)];
end
%%
for i= 1:size(Cali_index,1)-1
    if Cali_index(i+1,2)==0 && Cali_index(i,2)~=0
        cl = Cali_index(i,2);
        id = [Cali_index(i,3):Cali_index(i+1,3)];
        [FixPoint] = FindFixationPoint(SaccIndex,x,y,id,'mid');
        if size(FixPoint,1)<3
FixPoint_temp = FixPoint(1,:);
        else
        FixPoint_temp = FixPoint(end-2:end,:);
        end
        FixPoint_temp(:,4) = sqrt((FixPoint_temp(:,1)-Cali_Circle(cl,1)).^2+(FixPoint_temp(:,2)-Cali_Circle(cl,2)).^2);
        FixPoint_Obj(cl,1:2) = FixPoint_temp(find(FixPoint_temp(:,4)==min(FixPoint_temp(:,4)),1),1:2);


        %
        %                  line(f1,FixPoint(end-2:end-1,1), FixPoint(end-2:end-1,2),'Color','k')
        %                  line(f1,FixPoint(end-1:end,1), FixPoint(end-1:end,2),'Color','k')
    end
end
scatter(FixPoint_Obj(:,1), FixPoint_Obj(:,2),40,'r','filled')
H = fitgeotrans(FixPoint_Obj,Cali_Circle,'affine');
[x,y]=transformPointsForward(H,FixPoint_Obj(:,1),FixPoint_Obj(:,2));
scatter(x, y,40,'k')
X=[0;1;2;-2;-2]; Y = [0;1;-3;-3;3];

[x,y]=transformPointsForward(H,X,Y);
scatter(X, Y,40,'b','filled')
scatter(x, y,40,'b')

xlim([-5.5 5.5]); ylim([-5.5 5.5])
xlabel('Eye X data (V)'); ylabel('Eye Y data (V)')

%%
interpn(FixPoint_Obj(:,1:2),[0,0],Cali_Circle(:,1:2))