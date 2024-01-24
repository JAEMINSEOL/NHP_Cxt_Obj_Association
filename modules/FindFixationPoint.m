function [FixPoint] = FindFixationPoint(SaccIndex,x,y,id,option)
j=1; k=1; l=1; FixPoint=[];
for i = 1:length(id)
    if SaccIndex(id(i))==0
        
        if i==1
            FixPoint_f(j,1) = x(id(i));
            FixPoint_f(j,2) = y(id(i));
            FixPoint_f(j,3) = id(i);
            j = j+1;
        elseif SaccIndex(id(i-1))==1
            FixPoint_f(j,1) = x(id(i));
            FixPoint_f(j,2) = y(id(i));
            FixPoint_f(j,3) = id(i);
            j = j+1;
        end
        
        if i==length(id)
            FixPoint_l(k,1) = x(id(i));
            FixPoint_l(k,2) = y(id(i));
            FixPoint_l(k,3) = id(i);
            k = k+1;
        elseif SaccIndex(id(i+1))==1
            FixPoint_l(k,1) = x(id(i));
            FixPoint_l(k,2) = y(id(i));
            FixPoint_l(k,3) = id(i);
            k = k+1;
        end

        
        FixPoint(l,1) = x(id(i));
        FixPoint(l,2) = y(id(i));
        FixPoint(l,3) = id(i);
        l = l+1;
        
    end
end

if strcmp(option,'first')
    FixPoint = FixPoint_f;
elseif strcmp(option,'last')
    FixPoint = FixPoint_l;
elseif strcmp(option,'mid')
    FixPoint=[];
    FixPoint(:,3) = floor((FixPoint_l(:,3) + FixPoint_f(:,3))/2);
    FixPoint(:,1) = x(FixPoint(:,3));
    FixPoint(:,2) = y(FixPoint(:,3));
end

end