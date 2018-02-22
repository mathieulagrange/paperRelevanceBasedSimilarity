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
if nargin==0, unsupervised('do', 4:5, 'mask', {1, 2, 2, 4, 0, 0, 3}); return; else store=[]; obs=[]; end

%% store

store.xp_settings=data.xp_settings;
store.soundIndex=data.soundIndex;
store.class=data.class;
if isfield(data, 'filter')
    store.filter=data.filter;
end
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



switch setting.integration
    case 'close'
        for k=1:length(data.class)
            for l=k+1:length(data.class)
                dkl = dist2(data.centroid(:, data.indSample==k)', data.centroid(:, data.indSample==l)');
                if setting.similarity_nn~=0
                    if setting.similarity_nn<1
                        nn=max([1 round(setting.similarity_nn*size(dkl,2))]);
                    else
                        nn = setting.similarity_nn;
                    end
                    dkl = rbfKernel(dkl,'st-1nn',nn);
                end
                dkl = dkl(:);
                d(k, l) = min(dkl(dkl~=0));
                d(l, k) = d(k, l);
            end
        end
        store.A=1-d;
        d=1-d;
        d=(d+d')/2;
        %         d(logical(eye(size(d)))) = 1;
        store.A = d;

    case 'clustering'
        simClus= computeSimilarity(store.centroid,params);
        
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
   
    case 'early'
        simClus= computeSimilarity(store.centroid,params);
        store.A = simClus;
    case 'gmm'
        d=[];
        for k=1:length(data.model)
            vec=[];
            parfor l=k+1:length(data.model)
                vec(l) = distanceModelToModel(data.model{k}, data.model{l}, 2000);
            end
            for l=k+1:length(data.model)
                d(k, l) = vec(l);
                d(l, k) = d(k, l);
            end
        end
        store.A = 1-d;
end