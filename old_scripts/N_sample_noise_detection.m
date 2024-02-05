function X = N_sample_noise_detection(Xs,n)

    if n == 2
        X = one_sample_noise_spike_detection(Xs);
    else
        X = N_sample_noise_detection(Xs,n-1);
    end
    
    
    for j = 1:length(X)-n-1
        x = arrange_data(X,n,j);
        
        if length(unique(x(1:n)))==1
            if X(j) ~= x(1)
                if x(n) ~= x(n+1)
                    
                    if abs(x(1)-X(j)) < abs(x(n+1)-x(1))
                        c = X(j);
                    else
                        c = x(n+1);
                    end
                    
                    X(j+1:j+n,1) = c;

                end
            end
        end
    end
end

                
