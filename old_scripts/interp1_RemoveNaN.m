function vy = interp1_RemoveNaN(x,y,vx)
vy = interp1(x,y,vx);
vy(isnan(vy))=[];
end