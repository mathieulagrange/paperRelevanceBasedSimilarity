% Before running this script, the libraries scattering.m and rastamat must
% have been added to the path
dataset_path = '~/datasets/dcase2013/scenes_stereo';
Q1 = 8;
nAzimuths = 5;

dcase_scattering(dataset_path, Q1);
dcase_scattering([dataset_path, '_testset'], Q1);
