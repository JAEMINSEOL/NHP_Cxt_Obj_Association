function X = two_sample_noise_detection(X)
for i = 1:length(X)-3
    x=X(i);
    x1=X(i+1);
    x2=X(i+2);
    x3=X(i+3);
    
    if x2 == x1
        if x ~= x1
            if x2 ~= x3
                if abs(x1-x) < abs(x3-x1)
                    x1 = x;
                else
                    x1 = x3;
                end
                if abs(x2-x) < abs(x3-x2)
                    x2 = x;
                else
                    x2 = x3;
                end
            end
        end
    end
    
    X(i+3) = x3;
    X(i+2) = x2;
    X(i+1) = x1;
    X(i) = x;
end
end