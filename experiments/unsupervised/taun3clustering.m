function [config, store, obs] = taun3clustering(config, setting, data)
% taun3clustering CLUSTERING step of the expLanes experiment talspStruct2016_unsupervised
%    [config, store, obs] = taun3clustering(config, setting, data)
%      - config : expLanes configuration state
%      - setting   : set of factors to be evaluated
%      - data   : processing data stored during the previous step
%      -- store  : processing data to be saved for the other steps
%      -- obs    : observations to be saved for analysis

% Copyright: gregoirelafay
% Date: 17-Dec-2016

% Set behavior for debug mode
if nargin==0, unsupervised('do', 3, 'mask', {2 0 2 3 0 1 1 0 2}); return; else store=[]; obs=[]; end

%% seed

rng(0);

%% store

store.xp_settings=data.xp_settings;
store.soundIndex=data.soundIndex;
store.class=data.class;

store.weight=[];
store.centroid=[];
store.indSample=[];
store.centroidClass=[];
store.prediction=[];

%% integration

switch setting.integration
    case 'clustering'
        
        params.clustering='kmeans';

        for jj=unique(data.indSample)
            
            params.similarity='sqeuclidean';
            params.nbc=setting.clustering_nbc;
            params.rep=1;
            params.emptyAction='singleton';
            
            [prediction,centroid] = kmeans(full(data.features(:,data.indSample==jj))',params.nbc,'maxiter',1000,'replicates',params.rep,'start','plus','Distance',params.similarity,'EmptyAction',params.emptyAction);
            centroid=centroid';
            %[prediction,centroid,params] = featuresBasedClustering(data.features(:,data.indSample==jj),params);
            
            %% weight
            
            params.histType='';
            params.nbc=size(centroid,2);
            [weight] = histFeatures(prediction,ones(1,length(prediction)),params);
            
            %% Norm
            
            % weight=weight./sum(weight);
            
            %% store
            store.prediction=[store.prediction prediction+setting.clustering_nbc*(jj-1)];
            store.weight=[store.weight weight];
            store.centroid=[store.centroid centroid];
            store.indSample=[store.indSample ones(1,size(centroid,2))*jj];
            store.centroidClass=[store.centroidClass ones(1,size(centroid,2))*store.class(jj)];
        end
        
    case 'early'
         if setting.pca
           % perform pca
          coeff = pca(data.features');
          data.features = data.features'*coeff;
          data.features = data.features(:, 1:30)';
        end
        
        store.centroid=cell2mat(arrayfun(@(x) mean(data.features(:,data.indSample==x),2),unique(data.indSample),'UniformOutput',false));
        store.indSample=unique(data.indSample);
        store.centroidClass=store.class;
        case 'gmm'
        expRandomSeed();
        setting.nbg=8;
        if strcmp(setting.features(1:4), 'scat') 
           % perform pca
           setting.nbg=4;
          coeff = pca(data.features');
          data.features = data.features'*coeff;
          data.features = data.features(:, 1:30)';
        end
        
        for  i=unique(data.indSample)
            gmmi=[];
            for k=1:10
                dn = full(data.features(:,data.indSample==i))';
                if strcmp(setting.dataset, '2016') && i==33
                    dn = dn + randn(size(dn))*1;
                end
                gmmi = createGmm(dn, setting.nbg);
                if ~(any(isnan(gmmi.priors)) && any(isnan(gmmi.covars(:))))
                    break;
                end
            end
            if any(isnan(gmmi.priors)) || any(isnan(gmmi.covars(:)))
                fprintf(2, 'unable to learn gmm for sample %d, performing kmeans\n', i);
                
                nbcoef=size(dn,2);
                gmmi = gmm(nbcoef, setting.nbg, 'diag');
                % options = foptions;
                options(14) = 200;	% Just use 20 iterations of k-means in initialisation
                options(1)  = -1;
                gmmi = gmminit(gmmi, dn, options);
            end
            store.model{i} = gmmi;
        end
        
end