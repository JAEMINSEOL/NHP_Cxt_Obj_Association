function X = one_sample_noise_spike_detection(X)
for i = 1:length(X)-2
    x=X(i);
    x1=X(i+1); 
    x2=X(i+2);
    
    if x2>x1 && x1<x
        if abs(x1-x) < abs(x2-x1)
            x1 = x;
        else
            x1 = x2;
        end
    else
        if x2<x1 && x1>x
            if abs(x1-x) < abs(x2-x1)
                x1 = x;
            else
                x1 = x2;
            end
        end
    end
    
    X(i+2) = x2;
    X(i+1) = x1;
    X(i) = x;
end
end