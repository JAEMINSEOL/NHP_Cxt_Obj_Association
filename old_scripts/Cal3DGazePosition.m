function [origin, direction,intersection] = Cal3DGazePosition(p1,p2,p3, time, Xpos,Ypos,Xgaze,Ygaze,id,d)

%% Organize origin, direction vectors
tic
if d==2
dindex = -1;
else
    dindex = 1;
end


x3 = [Xgaze Ygaze];
x1 = [Xpos Ypos];
t = time;
gaze_ROI = horzcat(x1,x3,t); 
distV = 113;
distR = 1300;
squareY = 218.75;
squareZ = 240.625;
height = 185;

ox = gaze_ROI(:,1);
oy = -gaze_ROI(:,2)+40*dindex;
oz = ones(length(id),1) * height;
origin = [ox oy oz t]; 

dx = ones(length(id),1)*distV;
dy = -gaze_ROI(:,3)*(240/10)*dindex;
dz = -gaze_ROI(:,4)*(120/10);



    dx = dx*dindex;

direction_p = [dx dy dz]; 
for le = 1:length(direction_p)
    direction_size = sqrt(direction_p(le,1)^2 + direction_p(le,2)^2 + direction_p(le,3)^2);
    direction(le,:) = direction_p(le,:)/direction_size;
end

toc
%%


parfor i = 1:size(origin,1)
    intersection_temp = [];
    
    for j = 1:size(p1,1)
        %         p1 = vertices_by_f(j,1:3);
        %         p2 = vertices_by_f(j,4:6);
        %         p3 = vertices_by_f(j,7:9);
        if d==1
            if p1(j,1)>origin(i,1) || p2(j,1)>origin(i,1) || p3(j,1)>origin(i,1)
                [flag, tlength] = RayTriangleIntersection(origin(i,1:3), direction(i,1:3), p1(j,1:3), p2(j,1:3), p3(j,1:3));
                if flag ==1 && tlength~=0
                    intersection_temp(j,1:3) = origin(i,1:3) + tlength*direction(i,1:3);
%                     intersection_temp(j,4) = origin(i,4);
                end
            end
        elseif d==2
            if p1(j,1)<origin(i,1) || p2(j,1)<origin(i,1) || p3(j,1)<origin(i,1)
                [flag, tlength] = RayTriangleIntersection(origin(i,1:3), direction(i,1:3), p1(j,1:3), p2(j,1:3), p3(j,1:3));
                if flag ==1 && tlength~=0
                    intersection_temp(j,1:3) = origin(i,1:3) + tlength*direction(i,1:3);
%                     intersection_temp(j,4) = origin(i,4);
                end

            end
        end
    end
    
    
    if ~isempty(intersection_temp)
        idN = find(intersection_temp(:,1:4)==[0 0 0 0]);
        idN(idN>size(intersection_temp,1),:)=[];
        intersection_temp(idN,1:4) = NaN;
%         intersection_temp(find(intersection_temp(:,1)==0),:) = []; % lap start보다 x값이 작은 intersection_temp를 제외
        if d==1
        intersection_temp(find(intersection_temp(:,1)<origin(i,1)),:) = []; % origin 보다 x값이 작은 intersection_temp를 제외
        intersection_temp(find(intersection_temp(:,1)<700),:) = []; % 터널 입구보다 뒤에 찍히는 intersection point를 제외
        elseif d==2
            intersection_temp(find(intersection_temp(:,1)>origin(i,1)),:) = []; % origin 보다 x값이 큰 intersection_temp를 제외
        end
    end
    if ~isempty(intersection_temp)
if max(max(~isnan(intersection_temp)))
        if d==1
            intersection(i,:) = intersection_temp(min(find(intersection_temp(:,1)==min(intersection_temp(:,1)))),:); % 제외되지 않은 intersection_temp 값들 중 최소값을 현재 origin, direction에서의 intersection 값으로 함
        elseif d==2
            intersection(i,:) = intersection_temp(max(find(intersection_temp(:,1)==max(intersection_temp(:,1)))),:); % 제외되지 않은 intersection_temp 값들 중 최대값을 현재 origin, direction에서의 intersection 값으로 함
        end
else
    intersection(i,:) = [0 0 0 0];
end
    end
end

end
