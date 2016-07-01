function [config, store, obs] = scsv1learn(config, setting, data)
% scsv1learn LEARN step of the expLanes experiment sceneSvm
%    [config, store, obs] = scsv1learn(config, setting, data)
%      - config : expLanes configuration state
%      - setting   : set of factors to be evaluated
%      - data   : processing data stored during the previous step
%      -- store  : processing data to be saved for the other steps
%      -- obs    : observations to be saved for analysis

% Copyright: Mathieu Lagrange
% Date: 29-Jun-2016

% Set behavior for debug mode
if nargin==0, sceneSvm('do', 1, 'mask', {},'parallel',4); return; else store=[]; obs=[]; end

expRandomSeed();

fid = fopen('dcase2013_task1_filenamekey.csv');
C = textscan(fid, '%s %s %s %s', 'Delimiter', ',');
fclose(fid);
labels = C{4};
labels(1)=[];
labels = reshape(labels', 5, 20);

ids = 1:100;
ids = reshape(ids, 5, 20);
labels = ceil(rand(1, 100)*10);

sigma = .02;
rbfKernel = @(X,Y) exp(-sigma .* pdist2(X,Y,'euclidean').^2);

dataFileName = ['data/' setting.kernel '_' setting.set '_' setting.features '_' num2str(setting.cut)];
if ~isnan(setting.distance)
    dataFileName = ['data/' setting.kernel '_' setting.set '_' setting.features '_' num2str(setting.select) '_' num2str(setting.cut) '_' setting.distance];
end
data = load(dataFileName,'-mat');

switch setting.features
    case 'random'
        features = randn(100, 13);
end

acc = [];
for k=1:5
    
    trainSetting = ' -q ';
    
    switch setting.kernel
        case 'none'
            trainSet = features(setxor(1:100, ids(k, :)), :);
            testSet = features(ids(k, :), :);
            trainSetting = [trainSetting ' -t 2 -g 0.02 '];
        case 'rbf'
            trainSet = features(setxor(1:100, ids(k, :)), :);
            testSet = features(ids(k, :), :);
            
            trainKernel = rbfKernel(trainSet,trainSet);
            testKernel = rbfKernel(testSet,trainSet);
            
            trainSet = [ (1:80)' , trainKernel ];
            testSet = [ (1:20)'  , testKernel  ];
            trainSetting = [trainSetting ' -t 4'];
            trainGt = labels(setxor(1:100, ids(k, :)))';
            testGt = labels(ids(k, :))';
            
        otherwise
            trainKernel = data.similarityMatrix(data.foldsIndex~=k, data.foldsIndex~=k);
            testKernel = data.similarityMatrix(data.foldsIndex==k, data.foldsIndex~=k);
            
            trainGt = data.class(data.foldsIndex~=k)';
            testGt = data.class(data.foldsIndex==k)';
            
            trainSet = [ (1:80)' , trainKernel ];
            testSet = [ (1:20)'  , testKernel  ];
            trainSetting = [trainSetting ' -t 4'];
            
    end
    model = svmtrain(trainGt, trainSet, trainSetting);
    predict_label = svmpredict(testGt, testSet, model,'-q');

    acc = [acc; mean(predict_label==testGt)];
end

obs.accuracy = acc;