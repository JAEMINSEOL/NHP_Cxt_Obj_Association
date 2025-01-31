function Eye_all = G_GetValidEyeData(ROOT)

% ROOT.Save = 'Z:\E-Phys Analysis\NHP project'


Animal_List = {'Nabi','Yoda'};

Eye_all=[]; Eye_dats=struct;

for aid = 1:2
    Animal_id = Animal_List{aid};

Session_List = readtable([ROOT.Save '\' Animal_id '_SessionSummary.xlsx']);

Valid_Session = Session_List(Session_List.Error==0,:);
Valid_Session=sortrows(Valid_Session,'session');
writetable(Valid_Session,[ROOT.Save '\' Animal_id '_Valid_Sessions.xlsx'],'writemode','replacefile')

parfor vid=1:size(Valid_Session,1)
    date = num2str(Valid_Session.session(vid));
    dat = load([ROOT.Save '\Eye_parsed\' Animal_id '_' date '.mat'],'Datapixx_eye_T');
    temp = dat.Datapixx_eye_T;
    temp.session=vid*ones(size(temp,1),1);
    temp.animal=aid*ones(size(temp,1),1);
   OutArray{vid,1} = temp;
end
Eye_dats.(['dat_' num2str(aid)]) = OutArray;
end


for aid2=1:2
    for vid2=1:numel(Eye_dats.(['dat_' num2str(aid2)]))
        Eye_all = [Eye_all; Eye_dats.(['dat_' num2str(aid2)]){vid2}];
    end
end

writetable(Eye_all,[ROOT.Save '\Eye_all.xlsx'],'writemode','replacefile')