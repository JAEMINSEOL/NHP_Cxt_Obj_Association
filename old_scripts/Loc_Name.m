function Loc = Loc_Name(loc)
if loc==0
    Loc = 'AllLoc';
else
    Loc = ['Loc' num2str(loc)];
end
end