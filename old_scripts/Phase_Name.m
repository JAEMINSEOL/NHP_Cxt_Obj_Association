function Phase = Phase_Name(phase)
switch phase
    case -1
        Phase = 'PreCursor';
    case 1
        Phase = 'PreSample';
    case 2
        Phase = 'Sample';
    case 3
        Phase = 'Choice';
    otherwise
        Phase = 'Undefined';
end
end