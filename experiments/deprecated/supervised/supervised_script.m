% Before running this script, the library scattering.m must have been added
% to the MATLAB path
%dataset_path = '~/datasets/dcase2013/scenes_stereo';
dataset_path = ...
    '/archive/rmb456/private_datasets/DCASE2013_SC/scenes_stereo';
Q1 = 8;

dcase_scattering(dataset_path, Q1);
dcase_scattering([dataset_path, '_testset'], Q1);