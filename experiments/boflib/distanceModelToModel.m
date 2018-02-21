function d=distanceModelToModel(model1, model2, nsamples)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% computes a monte-carlo estimate of the Kullback-Leibler distance between two gmms
%% both models in argument should be similar to the output of mix = createGmm(data, nbgmm) (i.e. a netlab struct with a gmmm)
%% and have compatible dimensionality
%% nsamples is the number of samples used to estimate the distribution. Recommended value= 2000. (linear cpu dependency, log precision)
%% can be used to compute a similarity measure between songs, based on their BOF distribution
%% Copyright (C) JJ Aucouturier, 2008
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% sample from models
samples1 = gmmsamp(model1,nsamples);
samples2 = gmmsamp(model2,nsamples);
% compute symmetric distance
a=distanceDataToModel(samples2,model1);
b=distanceDataToModel(samples1,model2);
d=(a+b)/2;