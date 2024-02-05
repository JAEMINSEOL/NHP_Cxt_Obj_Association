function Fix_Seq= isequal_All(Fix_Sequence,Target,NTrials)
    Fix_Seq_temp=[];
l = length(Target);
for t=1:NTrials
Fix_Seq_temp(t,1)= isequal(squeeze(Fix_Sequence(1,t,1:l))',Target);
end
Fix_Seq = find(Fix_Seq_temp);
end