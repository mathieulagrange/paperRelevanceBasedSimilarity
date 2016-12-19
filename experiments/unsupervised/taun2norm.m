function [config, store, obs] = taun2norm(config, setting, data)
% taun2norm NORM step of the expLanes experiment talspStruct2016_unsupervised
%    [config, store, obs] = taun2norm(config, setting, data)
%      - config : expLanes configuration state
%      - setting   : set of factors to be evaluated
%      - data   : processing data stored during the previous step
%      -- store  : processing data to be saved for the other steps
%      -- obs    : observations to be saved for analysis

% Copyright: gregoirelafay
% Date: 17-Dec-2016

% Set behavior for debug mode
if nargin==0, talspStruct2016_unsupervised('do', 2, 'mask', {}); return; else store=[]; obs=[]; end

%% store

store.xp_settings=data.xp_settings;
store.soundIndex=data.soundIndex;
store.class=data.class;

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

%% Normalisation

switch setting.features
    case 'scatT'
        params.type='scattering';
        params.ftrsNorm_scat_threshold = 1e2;
        params.ftrsNorm_scat_selection = 1;
        params.ftrsNorm_scat_log =  setting.scat_log;
        [store.features,~] = normFtrs(store.features,params);
end
