% Before running this script, the library scattering.m must have been added
% to the MATLAB path
%dataset_path = '~/datasets/dcase2013/scenes_stereo';
dataset_path = '/scratch/vl1019/datasets/scenes_stereo';
Q1 = 8;

dcase_scattering(dataset_path, Q1);
dcase_scattering([dataset_path, '_testset'], Q1);