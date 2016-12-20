function [ A ] = computeSimilarity(X,param)

X=full(X');

switch param.similarity
    
    case {'cosine'}
        D=squareform(pdist(X,param.similarity));
        A=1-D/(max(D(:)));  
    case 'linear'
        A = X * X';    
    case 'rbf'
        D = dist2(X, X);
        nn=max([1 round(param.nn*size(D,2))]);
        [ A ] = rbfKernel(D,'st-1nn',nn); 
        
    otherwise
        error('invalid similarity setting.')

end

clearvars Xnorm d D;

A = (A + A') / 2;

end

