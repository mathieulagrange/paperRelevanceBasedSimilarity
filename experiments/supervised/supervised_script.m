% Before running this script, the libraries scattering.m and rastamat must
% have been added to the path
dataset_path = '~/datasets/dcase2013/scenes_stereo';
modulations = 'time';
nfo = 8;
nAzimuths = 5;

dcase_scattering(dataset_path, modulations, nfo, nAzimuths);
dcase_scattering([dataset_path,'_testset'], modulations, nfo, nAzimuths);