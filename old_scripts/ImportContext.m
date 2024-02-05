% 
% fv_f = stlread('Forest_context_b.stl');
% 
% 
% patch(fv_f,'FaceColor',       [0.8 0.8 1.0], ...
%          'EdgeColor',       'none',        ...
%          'FaceLighting',    'gouraud',     ...
%          'AmbientStrength', 0.15);
% 
% % Add a camera light, and tone down the specular highlighting
% camlight('headlight');
% material('dull');
% 
% % Fix the axes scaling, and set a nice view angle
% axis('image');
% view([-135 35]);

%%
fv_c = stlread('City_context_b_sky.stl');
fv_c_o = stlread('City_context_o.stl');

for i = 1:size(fv_c.faces,1)
    for j = 1:3
        a = fv_c.faces(i,j);
        vertices_by_f_c(i,(3*j-2):3*j)=fv_c.vertices(a,:);
    end
end

for i = 1:size(fv_c_o.faces,1)
    for j = 1:3
        a = fv_c_o.faces(i,j);
        vertices_by_f_o(i,(3*j-2):3*j)=fv_c_o.vertices(a,:);
    end
end
vertices_by_f_c_o = vertcat(vertices_by_f_c,vertices_by_f_o);
%%
tic
id = find(TickLog_sync_recording_info(:,4)==2 .* TickLog_sync_recording_info(:,5)<10 .* mod(TickLog_sync_recording_info(:,5),2)==1.* TickLog_sync_recording_info(:,13)==0);
[origin_City_Outbound, direction_City_Outbound, intersection_City_Outbound] = Cal3DGazePosition(vertices_by_f_c, TickLog_sync_recording_info, Eye_Analog_sync_recording,id);
toc

tic
id = find(TickLog_sync_recording_info(:,4)==2 .* TickLog_sync_recording_info(:,5)<10 .* mod(TickLog_sync_recording_info(:,5),2)==0.* TickLog_sync_recording_info(:,13)==0);
[origin_City_Outbound_Choice, direction_City_Outbound_Choice, intersection_City_Outbound_Choice] = Cal3DGazePosition(vertices_by_f_c_o, TickLog_sync_recording_info, Eye_Analog_sync_recording,id);
toc

intersection_City_Outbound_2 = intersection_City_Outbound;
intersection_City_Outbound_2(find(intersection_City_Outbound(:,1)==0),:) = [];

intersection_City_Outbound_Choice_2 = intersection_City_Outbound_Choice;
intersection_City_Outbound_Choice_2(find(intersection_City_Outbound_Choice(:,1)==0),:) = [];

savefilename=[animal_id '_' num2str(session_date) '_ProcessedData.mat']; 
save(savefilename)
%%
id = find(SpikeData_info(:,4)==2 .* SpikeData_info(:,5)<10 .* mod(SpikeData_info(:,5),2)==1.* SpikeData_info(:,13)==0);
[origin_City_Outbound_Spike, direction_City_Outbound_Spike, intersection_City_Outbound_Spike] = Cal3DGazePosition(vertices_by_f_c, SpikeData_info, spk_eye,id);

id = find(SpikeData_info(:,4)==2 .* SpikeData_info(:,5)<10 .* mod(SpikeData_info(:,5),2)==0.* SpikeData_info(:,13)==0);
[origin_City_Outbound_Spike_Choice, direction_City_Outbound_Spike_Choice, intersection_City_Outbound_Spike_Choice] = Cal3DGazePosition(vertices_by_f_c_o, SpikeData_info, spk_eye,id);

intersection_City_Outbound_Spike_2 = intersection_City_Outbound_Spike;
intersection_City_Outbound_Spike_2(find(intersection_City_Outbound_Spike(:,1)==0),:) = [];

intersection_City_Outbound_Spike_Choice_2 = intersection_City_Outbound_Spike_Choice;
intersection_City_Outbound_Spike_Choice_2(find(intersection_City_Outbound_Spike_Choice(:,1)==0),:) = [];
%%
intersection_City_Outbound_2(:,5) = knnsearch(Eye_sacc_XY_index_lp(:,3),intersection_City_Outbound_2(:,4));
intersection_City_Outbound_2(:,6) = Eye_sacc_XY_index_lp(intersection_City_Outbound_2(:,5));
intersection_City_Outbound_Choice_2(:,5) = knnsearch(Eye_sacc_XY_index_lp(:,3),intersection_City_Outbound_Choice_2(:,4));
intersection_City_Outbound_Choice_2(:,6) = Eye_sacc_XY_index_lp(intersection_City_Outbound_Choice_2(:,5));
%% Plotting


figure;
p= patch(fv_c,'FaceColor',       [0.8 0.8 1], ...
    'EdgeColor',       'none',        ...
    'FaceLighting',    'gouraud',     ...
    'AmbientStrength', 0.15);
alpha(0.2);

hold on

p2= patch(fv_c_o,'FaceColor',       [0.8 0.8 1], ...
    'EdgeColor',       'none',        ...
    'FaceLighting',    'gouraud',     ...
    'AmbientStrength', 0.15);
alpha(0.2);


% Add a camera light, and tone down the specular highlighting
camlight('headlight');
material('dull');

% Fix the axes scaling, and set a nice view angle
axis('image');
view([-135 35]);


% id = find(spk_run(:,1) .* spk_context(:,2) .* spk_void);
% spk_ROI = horzcat(SpikeData_info(id,2:3),spk_eye(id,2:3));
% 
% ox = spk_ROI(:,1);
% oy = -spk_ROI(:,2);
% oz = ones(length(id),1) * 141;
% origin = [ox oy oz];
% 
% dx = ones(length(id),1)*109;
% dy = -(spk_ROI(:,3)-960)*(218.75/1920);
% dz = 240.625-(spk_ROI(:,4)-540)*(240.625/1080)-141;
% direction = [dx dy dz];
% 
% hold on
% id = spk_context(:,2).* sum(spk_area(:,2:10),2).* spk_void ;
% x = SpikeData_info(find(id),2);
% y = SpikeData_info(find(id),3)*-1;
% z = ones(length(x),1)*200;
% scatter3(ox+dx,oy+dy,oz+dz,5,'r','filled')


% id = find(spk_run(:,2) .* spk_context(:,2) .* spk_void);
% spk_ROI = horzcat(SpikeData_info(id,2:3),spk_eye(id,2:3));
% 
% ox = spk_ROI(:,1);
% oy = -spk_ROI(:,2);
% oz = ones(length(id),1) * 141;
% origin = [ox oy oz];
% 
% dx = -ones(length(id),1)*109;
% dy = -(spk_ROI(:,3)-960)*(218.75/1920);
% dz = 240.625-(spk_ROI(:,4)-540)*(240.625/1080)-141;
% direction = [dx dy dz];





% origin2 = origin;
% 
% direction2 = direction;
% 
% 
% origin2(find(intersection(:,1)==0),:) = [];
% direction2(find(intersection(:,1)==0),:) = [];




hold on
s1 = scatter3(intersection_City_Outbound_2(is:ie,1),intersection_City_Outbound_2(is:ie,2),intersection_City_Outbound_2(is:ie,3),20,'k','filled');
s1.MarkerFaceAlpha = 0.5;
s2 = scatter3(intersection_City_Outbound_Choice_2(is:ie,1),intersection_City_Outbound_Choice_2(is:ie,2),intersection_City_Outbound_Choice_2(is:ie,3),20,'k','filled');
s2.MarkerFaceAlpha = 0.5;

x = intersection_City_Outbound_2 .* intersection_City_Outbound_2(:,6); 
s3 = scatter3(x(is:ie,1),x(is:ie,2),x(is:ie,3),20,'r','filled');
s3.MarkerFaceAlpha = 0.5;

x = intersection_City_Outbound_Choice_2 .* intersection_City_Outbound_Choice_2(:,6); 
s4 = scatter3(x(is:ie,1),x(is:ie,2),x(is:ie,3),20,'r','filled');
s4.MarkerFaceAlpha = 0.5;

% s2 = scatter3(intersection_City_Outbound_Choice_2(:,1),intersection_City_Outbound_Choice_2(:,2),intersection_City_Outbound_Choice_2(:,3),10,'k','filled');
% s2.MarkerFaceAlpha = 0.5;

% scatter3(intersection_City_Outbound_Spike_2(:,1),intersection_City_Outbound_Spike_2(:,2),intersection_City_Outbound_Spike_2(:,3),10,'r','filled');
% scatter3(intersection_City_Outbound_Spike_Choice_2(:,1),intersection_City_Outbound_Spike_Choice_2(:,2),intersection_City_Outbound_Spike_Choice_2(:,3),10,'r','filled');

% scatter3(origin2(:,1),origin2(:,2),origin2(:,3),30,'k','filled')
% quiver3(origin2(:,1), origin2(:,2), origin2(:,3), direction2(:,1), direction2(:,2), direction2(:,3), 15);

% 
% hold on
% id = spk_context(:,2).* spk_area(:,11).* spk_void ;
% x = SpikeData_info(find(id),2);
% y = SpikeData_info(find(id),3)*-1;
% z = ones(length(x),1)*200;
% scatter3(x,y,z,5,'k','filled')
