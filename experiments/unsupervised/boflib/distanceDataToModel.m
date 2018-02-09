function d = distanceDataToModel(data,model)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% computes the averaged log-likelihood of the data given the model
%% data should be similar to the output of data = computeMfccs(audiofilename, nbcoef) (i.e. a N*M matrix of floats)
%% model should be similar to the output of mix = createGmm(data, nbgmm) (i.e. a netlab struct with a gmmm)
%% and the dimensionality of data should be compatible with that of model
%% outputs a float, scaled between 0 and +inf, which can be interpreted as a distance (i.e. 0 : best match)
%% what to do with this :
%% 1) Classification (1)
%% to do ML classification, compute the distanceDataToModel(data,model_i) of a given data set 
%% to a set of models trained to represent different classes, and assign the class corresponding to the model which gives the smallest "distance" (i.e. the best likelihood)
%% 2) Similarity
%% use this function as in distanceModelToModel to compute a distance score between the models of 2 audio signals (note : this is not a distance in the mathematically sense, i.e. only approximates triangular inequality, etc.)
%% 3) Classification (2)
%% use the similarity function above to retrieve all nearest neighbors to a given signal in a dataset, and do nearest neighbor classification, i.e. assign the class which is most represented in the -say 10 - nearest neighbors
%% Copyright (C) JJ Aucouturier, 2008
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nsamples = size(data,1);
d=-sum(log(gmmprob(model, data)))/nsamples;