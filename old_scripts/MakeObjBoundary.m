function [ObjBoundary,VOrigin, VPolygon] = MakeObjBoundary(F_O,F_O_A,m)
%%
n3 = size(F_O,1);
n=n3/4;

ObjBoundary = NaN(n3,1600,2);

for on=1:n3
figure;
im = imshow(rgb2gray(squeeze(F_O(on,:,:,:))));
im.AlphaData = squeeze(F_O_A(on,:,:));
mask = squeeze(F_O_A(on,:,:,:))/ 0.5;
VOrigin(on) = sum(mask,'all');
mask_m = mask;
for i = 1+m:1125-m
    for j=1+m:2000-m
        if mask(i,j)==1
            mask_m(i-m:i+m,j-m:j+m)=1;
        end
    end
end
hold on
poly=mask2poly(mask_m,'Outer','MINDIST');



switch on
    case 1
        poly(and(and(poly(:,1)>630, poly(:,1)<690),and(poly(:,2)>450, poly(:,2)<500)),:)=[];
    case 2
        poly(and(poly(:,1)==625,poly(:,2)==395),:)=[];
        
    case 1+2*n
        poly(and(and(poly(:,1)>1300, poly(:,1)<1370),and(poly(:,2)>450, poly(:,2)<500)),:)=[];
    case 2+2*n
        poly(and(poly(:,1)==1301,poly(:,2)==395),:)=[];
        %     case 3
        %         poly(and(poly(:,1)==1293,poly(:,2)==430),:)=[];
        %     case 3+2*n
        %         poly(and(poly(:,1)==1394,poly(:,2)==540),:)=[];
        
    case 5
        poly(and(and(poly(:,1)>700, poly(:,1)<730),and(poly(:,2)>450, poly(:,2)<500)),:)=[];
        poly(and(and(poly(:,1)>580, poly(:,1)<620),and(poly(:,2)>440, poly(:,2)<500)),:)=[];
        poly(and(poly(:,1)==583,poly(:,2)==509),:)=[];
    case 5+2*n
        poly(and(and(poly(:,1)>1370, poly(:,1)<1420),and(poly(:,2)>450, poly(:,2)<500)),:)=[];
        poly(and(and(poly(:,1)>1260, poly(:,1)<1300),and(poly(:,2)>440, poly(:,2)<500)),:)=[];
        poly(and(poly(:,1)==1286,poly(:,2)==426),:)=[];
        poly(and(poly(:,1)==1292,poly(:,2)==512),:)=[];
end


ObjBoundary(on,1:length(poly),:)=poly;
ObjBoundary(on,length(poly)+1,:)=poly(1,:);
 plot(ObjBoundary(on,:,1),ObjBoundary(on,:,2),'r');
 
 
 xv = ObjBoundary(on,:,1)'; xv(isnan(xv))=[];
yv = ObjBoundary(on,:,2)'; yv(isnan(yv))=[];
mask_m2 = poly2mask(xv,yv,1125,2000);
VPolygon(on) = sum(mask_m2,'all');
end

