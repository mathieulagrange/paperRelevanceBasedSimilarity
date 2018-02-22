function [config, store, obs] = tasuea3classifier(config, setting, data)
% tasuea3classifier CLASSIFIER step of the expLanes experiment talspStruct2016_supervised_earlyLate
%    [config, store, obs] = tasuea3classifier(config, setting, data)
%      - config : expLanes configuration state
%      - setting   : set of factors to be evaluated
%      - data   : processing data stored during the previous step
%      -- store  : processing data to be saved for the other steps
%      -- obs    : observations to be saved for analysis

% Copyright: gregoirelafay
% Date: 16-Dec-2016

% Set behavior for debug mode
if nargin==0, talspStruct2016_supervised_earlyLate('do', 3, 'mask', {0 [1 2] 1 0 11 0 0}); return; else store=[]; obs=[]; end


%% store

store.xp_settings=data.xp_settings;
store.soundIndex=data.soundIndex;
store.class=data.class;
store.dataset=data.dataset;

%% Load folds

fileId = fopen([config.inputPath  'dcase2013_task1_filenamekey.txt']);
folds=textscan(fileId,'%s %s %s %s','Delimiter',',');
fclose(fileId);

foldsSoundName=cellfun(@(x) x(1:end-4),folds{4}(2:end),'UniformOutput',false);
foldsIndex=cellfun(@(x) str2double(x(5)),folds{1}(2:end));

[~,indSort]=sort(foldsSoundName);
foldsIndex=foldsIndex(indSort);
foldsLabs=unique(foldsIndex);

switch setting.integration
    case 'late'
        
        foldsIndexSample=repmat(foldsIndex(:)',sum(data.indSample==1),1);
        sampleClass=repmat(store.class(:)',sum(data.indSample==1),1);
        
        foldsIndexSample=foldsIndexSample(:)';
        sampleClass=sampleClass(:)';
        
    case 'early'
        
        sampleClass=store.class(:)';
        
end

%% svm ftrs

acc_svm_ftrs_train= zeros(1,5);
acc_svm_ftrs_test= zeros(1,5);

for jj=1:length(foldsLabs)
    
    switch setting.integration
        case 'early'
            foldIndSampleTest=data.indSample(foldsIndex==foldsLabs(jj));
            foldIndSampleTrain=data.indSample(foldsIndex~=foldsLabs(jj));
            
            X_train=data.features(:,foldsIndex'~=foldsLabs(jj));
            X_test=data.features(:,foldsIndex'==foldsLabs(jj));
            
            trainGt = sampleClass(foldsIndex~=foldsLabs(jj))';
            testGt = sampleClass(foldsIndex==foldsLabs(jj))';
            
        case 'late'
            foldIndSampleTest=data.indSample(foldsIndexSample==foldsLabs(jj));
            foldIndSampleTrain=data.indSample(foldsIndexSample~=foldsLabs(jj));
            
            X_train=data.features(:,foldsIndexSample'~=foldsLabs(jj));
            X_test=data.features(:,foldsIndexSample'==foldsLabs(jj));
            
            trainGt = sampleClass(foldsIndexSample~=foldsLabs(jj))';
            testGt = sampleClass(foldsIndexSample==foldsLabs(jj))';
    end
    
    % normalization
    switch setting.features
        case 'mfcc'
            params.type='stand';
            [X_train,settingNorm] = normFtrs(X_train,params);
            [X_test,~] = normFtrs(X_test,settingNorm);
        case 'scatT'
            params.type='scattering';
            params.ftrsNorm_scat_threshold = 1e2;
            params.ftrsNorm_scat_selection =  1;
            params.ftrsNorm_scat_log =  setting.scat_log;
            [X_train,settingNorm] = normFtrs(X_train,params);
            [X_test,~] = normFtrs(X_test,settingNorm);
            clearvars params
            params.type='stand';
            [X_train,settingNorm] = normFtrs(X_train,params);
            [X_test,~] = normFtrs(X_test,settingNorm);
    end
    
    % similarity
    params.similarity=setting.similarity;
    params.nn=setting.similarity_nn;
    [A] = computeSimilarity([X_train X_test],params);
    
    trainSetting =' -q -c 1';
    
    trainKernel = A(1:size(X_train,2), 1:size(X_train,2));
    testKernel = A(size(X_train,2)+1:end,1:size(X_train,2));
    
    trainSet = [ (1:size(trainKernel,1))' , trainKernel ];
    testSet = [ (1:size(testKernel,1))'  , testKernel  ];
    
    model = svmtrain(trainGt, trainSet, [trainSetting ' -t 4']);
    predict_label_train = svmpredict(trainGt, trainSet, model,'-q');
    predict_label_test = svmpredict(testGt, testSet, model,'-q');
    
    switch setting.integration
        case 'late'
            [predict_label_train] = voteMaj(predict_label_train',foldIndSampleTrain);
            [predict_label_test] = voteMaj(predict_label_test',foldIndSampleTest);
    end
    
    acc_svm_ftrs_train(jj) = mean(predict_label_train(:)'==store.class(foldsIndex'~=foldsLabs(jj)));
    acc_svm_ftrs_test(jj) = mean(predict_label_test(:)'==store.class(foldsIndex'==foldsLabs(jj)));
    
end

obs.acc_svm= acc_svm_ftrs_test;
obs.acc_svm_f1= acc_svm_ftrs_test(1);
obs.acc_svm_f2= acc_svm_ftrs_test(2);
obs.acc_svm_f3= acc_svm_ftrs_test(3);
obs.acc_svm_f4= acc_svm_ftrs_test(4);
obs.acc_svm_f5= acc_svm_ftrs_test(5);