function [A,params] = histSimilarity(sceneFeatures,params,gd)

switch params.histDist
    
    case 'emd'
        
        D=zeros(size(sceneFeatures,2),size(sceneFeatures,2));
        
        f=1-gd;
        
        flowType=3;
        extra_mass_penalty= -1;
        
        for aa=1:size(sceneFeatures,2)
            for bb=aa+1:size(sceneFeatures,2)
                
                W1=sceneFeatures(:,aa);
                W2=sceneFeatures(:,bb);
                
                F=f(W1~=0,W2~=0);
                
                W1(W1==0)=[];
                W2(W2==0)=[];
                if ~isempty(W1) && ~isempty(W2)
                if length(W1)==length(W2)
                    
                    % just assume non symetric ground distance
                    D(aa,bb)= emd_hat_mex(W1,W2,F,extra_mass_penalty);
                    
                else % non equal size histograms
                    
                    extra_mass_penalty=0;
                    [D(aa,bb),~]= emd_hat_mex_nes(W1,W2,F,extra_mass_penalty,flowType);
                    
                end
                end
                D(bb,aa)=D(aa,bb);
            end
        end
        
    case {'average','closest'}
        
        [A] = clusterBasedSimilarity(gd,params);
        
        
end

switch params.histDist
    
    case {'average','closest'}
        
        if ~isempty(A(isnan(A)))
            error([params.histDist ': dist outputs nan values'])
        end
        
        if sum(sum(A-A'))~=0
            error('Similarity matrix is not symetric')
        end
        
    otherwise
        
        if ~isempty(D(isnan(D)))
            error([params.histDist ': dist outputs nan values'])
        end
        
        if ~isempty(D(isinf(D)))
            A=zeros(size(D));
            A(~isinf(D))=1-D(~isinf(D))/max(D(~isinf(D)));
        else
            A=exp(-D/mean(squareform(D)));
        end
end


end

