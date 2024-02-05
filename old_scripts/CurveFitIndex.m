function ModelIndex = CurveFitIndex(RawData,nSession,Crit)
id = 'curvefit:fit:noStartPoint';
warning('off',id)

nContents = size(RawData,2)-1;
Model = 'c/(1+exp(-a*(x-b)))';
ModelIndex = nan(nSession,6,nContents);

for k = 1:nSession
    for c = 1: nContents
        RawY = RawData(:,c+1,k);
        RawY(isnan(RawY))=[];
        RawX = (1:length(RawY))';
        if length(RawX)>2
            [f,gof] = fit(RawX,RawY,Model );
            
            if gof.rsquare > Crit
                ModelIndex(k,1,c) = f.a;
                ModelIndex(k,2,c) = f.b;
                ModelIndex(k,3,c) = f.c;
                if ~isempty(find(RawY>f.c))
                    ModelIndex(k,4,c) = RawX(min(find(RawY>f.c)));
                end
                M = mean(RawY(1:3,1));
                if 1
                    ModelIndex(k,5,c)=M;
                end
            end
            
            ModelIndex(k,end,c) = gof.rsquare;
        end
    end
    
end
end