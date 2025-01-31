% load('X:\E-Phys Analysis\NHP project\Eye_parsed\TrialStart_500ms_part.mat')
%%
% load('X:\E-Phys Analysis\NHP project\Eye_parsed\Objecton_500ms.mat')
% sample_num = randperm(size(whole_set,2),10000);
% part_set = whole_set(sample_num);
% clear whole_set
% save('X:\E-Phys Analysis\NHP project\Eye_parsed\TrialStart_500ms_part.mat','part_set','sample_num')
load('X:\E-Phys Analysis\NHP project\Eye_parsed\TrialStart_500ms_part.mat')
%%
data=[]; labels=[];
for d = 1:numel(part_set)
    data(d,:,:) = table2array(part_set(d).data(1:300,1:2));
    labels(d,1) = part_set(d).trial_info.Context * (part_set(d).trial_info.Location+1);

%     switch part_set(d).trial_info.ObjectLeft{1}
%         case 'Pumpkin'
%             labels(d,1)=1;
%         case 'Donut'
%             labels(d,1)=2;
%         case 'Jellyfish'
%             labels(d,1)=3;
%         case 'Turtle'
%             labels(d,1)=4;
%         case 'Pizza'
%             labels(d,1)=5;
%         case 'Octopus'
%             labels(d,1)=6;
%     end
end

data = reshape(data,numel(part_set),[]);
labels = full(ind2vec(labels'))';
%%
% NN size
hiddenLayerSize = [100, 50]; % hidden layer size 정의 
net = patternnet(hiddenLayerSize);

% 데이터 분할
net.divideParam.trainRatio = 0.7; % for training set
net.divideParam.valRatio = 0.15; % for validation set
net.divideParam.testRatio = 0.15; % for test set

% Training
[net,tr] = train(net, data', labels');

% prediection
predictions = net(data');

%%
groundTruth = labels'; % 실제 레이블
[~,predictedLabels] = max(predictions,[],1); % 예측된 레이블
predictedLabels = full(ind2vec(predictedLabels));

%  변수 초기화
accuracyPerClass = zeros(1, size(groundTruth, 1));

% 클래스별 정확도 계산
for i = 1:size(groundTruth, 1)
    accuracyPerClass(i) = sum(groundTruth(i, :) == predictedLabels(i, :) & groundTruth(i, :)==1) / sum(groundTruth(i, :)==1);
end

% 전체 정확도 계산
accuracy = nanmean(accuracyPerClass);
accuracyPercentage = 100 * accuracy;

fprintf('Decoding Accuracy: %.2f%%\n', accuracyPercentage);