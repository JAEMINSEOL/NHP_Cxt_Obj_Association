function Cxt = Cxt_Name(cxt)
switch cxt
    case 0
        Cxt = 'AllCxt';
    case 1
        Cxt = 'Forest';
    case 2
        Cxt = 'City';
    case 3
        Cxt = 'Desert';
    case 4
        Cxt = 'Snowfield';
    otherwise
        Cxt = 'Undefined';
end
end