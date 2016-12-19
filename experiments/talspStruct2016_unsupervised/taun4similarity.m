function [config, store, obs] = taun4similarity(config, setting, data)
% taun4similarity SIMILARITY step of the expLanes experiment talspStruct2016_unsupervised
%    [config, store, obs] = taun4similarity(config, setting, data)
%      - config : expLanes configuration state
%      - setting   : set of factors to be evaluated
%      - data   : processing data stored during the previous step
%      -- store  : processing data to be saved for the other steps
%      -- obs    : observations to be saved for analysis

% Copyright: gregoirelafay
% Date: 17-Dec-2016

% Set behavior for debug mode
if nargin==0, talspStruct2016_unsupervised('do', 4, 'mask', {}); return; else store=[]; obs=[]; end

%% store

store.xp_settings=data.xp_settings;
store.soundIndex=data.soundIndex;
store.class=data.class;
store.dataset=data.dataset;

store.weight=data.weight;
store.indSample=data.indSample;
store.centroid=data.centroid;
store.centroidClass=data.centroidClass;
store.prediction=data.prediction;

%% get clusters Similarity

params.mode='centroid';
params.similarity='rbf';
params.nn=setting.similarity_nn;
params.class=store.centroidClass;

simClus= computeSimilarity(store.centroid,params);

switch setting.integration
    
    case 'clustering'
        
        %% reshape weights
        
        onsets=1:size(data.weight,1):size(simClus,2)-size(data.weight,1)+1;
        offsets=[onsets(2:end)-1 size(simClus,2)];
        weight=zeros(size(simClus,2),size(data.weight,2));
        
        for jj=1:size(weight,2)
            weight(onsets(jj):offsets(jj),jj)=data.weight(:,jj);
        end
        
        %% scenes similarity
        
        params.histDist=setting.similarity_dist;
        params.indSample=store.indSample;
        
        [store.A,store.params] = histSimilarity(weight,params,simClus);
        
    otherwise
        
        store.A = simClus;
end