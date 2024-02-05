clear all

cd('F:\NHP project\MRI\20190610\SNU_NABI_NABI\processed')
addpath('F:\NHP project\MATLAB\Analysis\Program')
filename = 'Nabi_Right_HPC.vtk';
verbose = 1;

[vertex,face] = read_vtk(filename, verbose);
X = vertex(1,:);
Y = vertex(2,:);
Z = vertex(3,:);



X2 = [-1.1 :0.5:11.5];
Y2 = [-77.6:-0.332031:-97.6];
Z2 = [173.0:0.332031:190];


Coordinate_diff = [286, 258, 173] - [-0.6, -77.6, 175.6562];



for i = 1:length(X)
    for n = 1:length(X2)-1
        if X2(n) <= X(i) && X2(n+1) >= X(i)
            if abs(X(i) - X2(n)) > abs(X2(n+1) - X(i))
                GridX(i) = X2(n+1);
            else
                GridX(i) = X2(n);
            end
        end
    end
end

for i = 1:length(Y)
    for n = 1:length(Y2)-1
        if Y2(n) >= Y(i) && Y2(n+1) <= Y(i)
            if abs(Y(i) - Y2(n)) > abs(Y2(n+1) - Y(i))
                GridY(i) = Y2(n+1);
            else
                GridY(i) = Y2(n);
            end
        end
    end
end

for i = 1:length(Z)
    for n = 1:length(Z2)-1
        if Z2(n) <= Z(i) && Z2(n+1) >= Z(i)
            if abs(Z(i) - Z2(n)) > abs(Z2(n+1) - Z(i))
                GridZ(i) = Z2(n+1);
            else
                GridZ(i) = Z2(n);
            end
        end
    end
end

Grid = vertcat(GridX, GridY, GridZ)';

MR = [179, 299, 314; ...
    179,284, 306; ...
    179, 267, 299; ...
    171, 267, 287; ...
    171, 262, 288];

for i = 1:length(MR)
Record(i,:) = ConvertMRVoxel(MR(i,:));
end

for i = 1:length(Grid)
Grid_Voxel(i,:) = round(ConvertRecordedXY(Grid(i,:)));
end

Grid_VoxelZ = zeros(max(Grid_Voxel(:,1)), max(Grid_Voxel(:,2)));

hp = scatter3(GridX,GridY,GridZ, 800, GridY, 'filled')
hold on
rc = scatter3(Record(:,1),Record(:,2),Record(:,3), 100,'k', 'filled')
hold on
for i = 1:length(MR)
line([Record(i,1) Record(i,1)], [Record(i,2) Record(i,2)], [Record(i,3) max(GridZ)],'Color','k');
end
colormap('jet');

alpha(hp,.1)





function Record= ConvertMRVoxel(MR)
Record(1,1) = 0.5*MR(1,1) - 81.1;
Record(1,2) = -0.332031*MR(1,2) + 8.063998;
Record(1,3) = 0.332031*MR(1,3) + 80.36332;
end

function MR= ConvertRecordedXY(Record)
MR(1,1) = (Record(1,1) + 81.1)*2;
MR(1,2) = (Record(1,2) - 8.063998)/(-0.332031) ;
MR(1,3) = (Record(1,3)-80.36332)/0.332031;
end