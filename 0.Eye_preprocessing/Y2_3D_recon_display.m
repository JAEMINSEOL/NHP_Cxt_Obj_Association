% Y2_3D_recon_display
c=1; d=1;
if c==1, c_str = 'Forest'; else, c_str = 'City'; end
if d==1, d_str = 'Outbound'; else, d_str = 'Inbound'; end
animal_str = 'Nabi';

minx=-10000; maxx=30000;
miny=-10000; maxy = 10000;
miny = miny - 20000*(c-1); maxy = maxy - 20000*(c-1);

cxt = (squeeze(origin(:,1,1,2))<0)+1;

sample = squeeze(intersection(1,1,:,:));
idx = squeeze(FixPoint_InterTrial(1,1,:,:));

id=cxt==c;
sum_temp = squeeze(intersection(id,d,:,:));
sum_idx = squeeze(FixPoint_InterTrial(id,d,:,:));

gaze=[]; gaze_idx = [];
for t=1:size(sum_temp,1)
gaze = [gaze; squeeze(sum_temp(t,:,:))];
gaze_idx = [gaze_idx; squeeze(sum_idx(t,:,:))];
end
gaze_idx(isnan(gaze(:,1)),:)=[]; gaze(isnan(gaze(:,1)),:)=[];
gaze(gaze(:,3)<0,3) = 0;

%%

data = gaze;
x=data(:,1); y=data(:,2); z=data(:,3);
if max(y)<0, y=y+20000; end
npt = numel(x) ; % Total Number of Points

% Define domain and grid parameters
nbins    = 60 ;
maxDim   = 30000 ;
binEdges = linspace(0,maxDim,nbins+1) ;

% Count density
% we start counting density along in the [X,Y] plane (Z axis aglomerated)
[Nz,binEdges,~,binX,binY] = histcounts2(y,x,binEdges,binEdges) ;

% preallocate 3D containers
N3d = zeros(nbins,nbins,nbins) ; % 3D matrix containing the counts
Npc = zeros(nbins,nbins,nbins) ; % 3D matrix containing the percentages
colorpc = zeros(npt,1) ;         % 1D vector containing the percentages

% we do not want to loop on every block of the domain because:
%   - depending on the grid size there can be many
%   - a large number of them can be empty
% So we first find the [X,Y] blocks which are not empty, we'll only loop on
% these blocks.
validbins = find(Nz) ;                              % find the indices of non-empty blocks
[xbins,ybins] = ind2sub([nbins,nbins],validbins) ;  % convert linear indices to 2d indices
nv = numel(xbins) ;                                 % number of block to process

% Now for each [X,Y] block, we get the distribution over a [Z] column and
% assign the results to the full 3D matrices
for k=1:nv
    % this block coordinates
    xbin = xbins(k) ;
    ybin = ybins(k) ;

    % find linear indices of the `x` and `y` values which are located into this block
    idx = find( binX==xbin & binY==ybin ) ;
    % make a subset with the corresponding 'z' value
    subZ = z(idx) ;
    % find the distribution and assign to 3D matrices
    [Nz,~,zbins] = histcounts( subZ , binEdges ) ;
    N3d(xbin,ybin,:) = Nz ;         % total counts for this block
    Npc(xbin,ybin,:) = Nz ./ npt ;  % density % for this block

    % Now we have to assign this value (color or percentage) to all the points
    % which were found in the blocks
    vzbins = find(Nz) ;
    for kz=1:numel(vzbins)
        thisColorpc = Nz(vzbins(kz)) ./ npt * 100 ;
        idz   = find( zbins==vzbins(kz) ) ;
        idx3d = idx(idz) ;
        colorpc(idx3d) = thisColorpc ;
    end

end
% assert( sum(sum(sum(N3d))) == npt ) % double check we counted everything

% Display final result
h=figure;
hs=scatter3(x, y, z, 3 , colorpc ,'filled' );
xlabel('X'),ylabel('Y'),zlabel('Z')
cb = colorbar ;
cb.Label.String = 'Probability density estimate';
colormap jet


hold on
[X,Y] = meshgrid(minx:1000:35000, -15000:1000:15000);
Z = zeros(size(X,1),size(X,2));
surf(X,Y,Z,'FaceColor','w','EdgeColor',[.8 .8 .8])
line([-10000 35000],[0 0], [0 0],'color','k')

title([animal_str '-' c_str '-' d_str])

% colormap(flipud(pink))

%%


data = gaze;
x=data(:,1); y=data(:,2); z=data(:,3);
z=zeros(size(data,1));
if max(y)<0, y=y+20000; end
npt = numel(x) ; % Total Number of Points

% Define domain and grid parameters
nbins    = 60 ;
maxDim   = 30000 ;
binEdges = linspace(0,maxDim,nbins+1) ;

% Count density
% we start counting density along in the [X,Y] plane (Z axis aglomerated)
[Nz,binEdges,~,binX,binY] = histcounts2(y,x,binEdges,binEdges) ;

% preallocate 3D containers
N3d = zeros(nbins,nbins,nbins) ; % 3D matrix containing the counts
Npc = zeros(nbins,nbins,nbins) ; % 3D matrix containing the percentages
colorpc = zeros(npt,1) ;         % 1D vector containing the percentages

% we do not want to loop on every block of the domain because:
%   - depending on the grid size there can be many
%   - a large number of them can be empty
% So we first find the [X,Y] blocks which are not empty, we'll only loop on
% these blocks.
validbins = find(Nz) ;                              % find the indices of non-empty blocks
[xbins,ybins] = ind2sub([nbins,nbins],validbins) ;  % convert linear indices to 2d indices
nv = numel(xbins) ;                                 % number of block to process

% Now for each [X,Y] block, we get the distribution over a [Z] column and
% assign the results to the full 3D matrices
for k=1:nv
    % this block coordinates
    xbin = xbins(k) ;
    ybin = ybins(k) ;

    % find linear indices of the `x` and `y` values which are located into this block
    idx = find( binX==xbin & binY==ybin ) ;
    % make a subset with the corresponding 'z' value
    subZ = z(idx) ;
    % find the distribution and assign to 3D matrices
    [Nz,~,zbins] = histcounts( subZ , binEdges ) ;
    N3d(xbin,ybin,:) = Nz ;         % total counts for this block
    Npc(xbin,ybin,:) = Nz ./ npt ;  % density % for this block

    % Now we have to assign this value (color or percentage) to all the points
    % which were found in the blocks
    vzbins = find(Nz) ;
    for kz=1:numel(vzbins)
        thisColorpc = Nz(vzbins(kz)) ./ npt * 100 ;
        idz   = find( zbins==vzbins(kz) ) ;
        idx3d = idx(idz) ;
        colorpc(idx3d) = thisColorpc ;
    end

end
% assert( sum(sum(sum(N3d))) == npt ) % double check we counted everything

% Display final result
h=figure;
hs=scatter3(x, y, z, 3 , colorpc ,'filled' );
xlabel('X'),ylabel('Y'),zlabel('Z')
cb = colorbar ;
cb.Label.String = 'Probability density estimate';
colormap jet


hold on
[X,Y] = meshgrid(minx:1000:35000, -15000:1000:15000);
Z = zeros(size(X,1),size(X,2));
surf(X,Y,Z,'FaceColor','w','EdgeColor',[.8 .8 .8])
line([-10000 35000],[0 0], [0 0],'color','k')

title([animal_str '-' c_str '-' d_str])

% colormap(flipud(pink))
