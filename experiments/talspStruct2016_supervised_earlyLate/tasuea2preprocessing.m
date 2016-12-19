function [config, store, obs] = tasuea2preprocessing(config, setting, data)
% tasuea2normalization NORMALIZATION step of the expLanes experiment talspStruct2016_supervised_earlyLate
%    [config, store, obs] = tasuea2preprocessing(config, setting, data)
%      - config : expLanes configuration state
%      - setting   : set of factors to be evaluated
%      - data   : processing data stored during the previous step
%      -- store  : processing data to be saved for the other steps
%      -- obs    : observations to be saved for analysis

% Copyright: gregoirelafay
% Date: 16-Dec-2016

% Set behavior for debug mode
if nargin==0, talspStruct2016_supervised_earlyLate('do', 3, 'mask', {1 1 1 1 1 1 1}); return; else store=[]; obs=[]; end

%% store

store.xp_settings=data.xp_settings;
store.soundIndex=data.soundIndex;
store.class=data.class;
store.dataset=data.dataset;

%% get features

X=[];
features2use=strsplit(setting.features,'_');
for jj=1:length(features2use)
    eval(['X=[X ; data.features.' features2use{jj} '];']);
end

%% pooling

switch setting.features
    case 'mfcc'
        store.features=[];
        store.indSample=[];
        for jj=unique(data.indSample)
            X_tmp=X(:,data.indSample==jj);
            step=round(0.250/store.xp_settings.hoptime);
            onsets=1:step:size(X_tmp,2);
            offsets=[onsets(2:end)-1 size(X_tmp,2)];
            X_tmp=featuresPooling(X_tmp,'mean',onsets,offsets,0,0,store.xp_settings.hoptime);
            store.features = [store.features X_tmp];
            store.indSample=[store.indSample ones(1,size(X_tmp,2))*jj];
        end
    otherwise
        store.features=X;
        store.indSample=data.indSample;
end

clearvars X

%% Rectify

switch setting.features
    case 'scatT'
        store.features(store.features<0)=0;
end

%% integration

switch setting.integration
    case 'early'
        store.features=cell2mat(arrayfun(@(x) mean(store.features(:,store.indSample==x),2),unique(store.indSample),'UniformOutput',false));
        store.indSample=unique(store.indSample);
end
