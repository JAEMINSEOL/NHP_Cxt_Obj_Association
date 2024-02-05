function [ ax ] = DataDensityPlot( x, y, levels,we, he,Resolution,xmin, xmax,ymin,ymax )
%DATADENSITYPLOT Plot the data density 
%   Makes a contour map of data density
%   x, y - data x and y coordinates
%   levels - number of contours to show
%
% By Malcolm Mclean
%
ax=  axes;
  w = round(we/Resolution); h = round(he/Resolution);
    map = dataDensity(x, y, w, h,[xmin xmax ymin ymax],50);
    map = map - min(min(map));
    map = floor(map ./ max(max(map)) * (levels-1));
%     f = figure();
    
    mapEx=zeros(ymax,xmax);
    for i=1:size(map,1)
        for j = 1:size(map,2)
            mapEx(Resolution*(i-1)+1:i*Resolution,Resolution*(j-1)+1:j*Resolution) = map(i,j);
        end
    end

    im=image(mapEx,'Parent',ax);
%     set(im,'AlphaData', (log(mapEx+1)/max(max(log(mapEx+1)))));
%     ax.ALim=[0 0.5];
%     alpha color
%     set(gca, 'XTick', [1 w]);
%     set(gca, 'XTickLabel', [min(x) max(x)]);
%     set(gca, 'YTick', [1 h]);
%     set(gca, 'YTickLabel', [min(y) max(y)]);
    
    function [ dmap ] = dataDensity( x, y, width, height, limits, fudge )
%DATADENSITY Get a data density image of data 
%   x, y - two vectors of equal length giving scatterplot x, y co-ords
%   width, height - dimensions of the data density plot, in pixels
%   limits - [xmin xmax ymin ymax] - defaults to data max/min
%   fudge - the amount of smear, defaults to size of pixel diagonal
%
% By Malcolm McLean
%
    if(nargin == 4)
        limits(1) = min(x);
        limits(2) = max(x);
        limits(3) = min(y);
        limits(4) = max(y);
    end
    deltax = (limits(2) - limits(1)) / width;
    deltay = (limits(4) - limits(3)) / height;
    if(nargin < 6)
        fudge = sqrt(deltax^2 + deltay^2);
    end
    dmap = zeros(height, width);
    for ii = 0: height - 1
        yi = limits(3) + ii * deltay + deltay/2;
        for jj = 0 : width - 1
            xi = limits(1) + jj * deltax + deltax/2;
            dd = 0;
            for kk = 1: length(x)
                dist2 = (x(kk) - xi)^2 + (y(kk) - yi)^2;
                dd = dd + 1 / ( dist2 + fudge); 
            end
            dmap(ii+1,jj+1) = dd;
        end
    end
            
end

end
