function [ A ] = rbfKernel(D,method,nn)

% The local scaling method using one specific NN was proposed by: Self-tuning spectral clustering
% (NISP 04)

switch method
    
    case 'sigma'
        
        A = exp(-D./nn);
        
    case {'st-1nn','st-knn'}
        
        nn=min(size(D,1)-1,nn);
    
        [sorted, ~] = sort(D);
        
        switch method
            
            case 'st-1nn'
                ls = sorted(nn+1, :);
                ls = sqrt(ls);
                
            case 'st-knn'
                
                ls = sorted(2:nn, :);
                ls = mean(sqrt(ls),1);
                
        end
        
        A = exp(-D./(ls'*ls));
        
        
end

