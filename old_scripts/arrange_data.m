
function x = arrange_data(X,n,j)

for i = 1:n+1
            x(i) = X(j+i);
end
end