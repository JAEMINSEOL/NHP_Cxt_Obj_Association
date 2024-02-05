function A = MakeTransLImage(X,alpha)

% X is your image
[M,N,O] = size(X);
%Assign A as zero
A = ones(M,N)*alpha;
%Iterate through X, to assign A
for i=1:M
      for j=1:N
         if sum(squeeze(X(i,j,:)) == 0)==3   %Assuming uint8, 255 would be white
            A(i,j) = 0;      %Assign 1 to transparent color(white)
         end
      end
end

end