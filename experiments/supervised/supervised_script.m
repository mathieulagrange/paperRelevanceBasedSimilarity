% Before running this script, the libraries scattering.m and rastamat must
% have been added to the path
dataset_path = '~/datasets/dcase2013/scenes_stereo';
modulations = 'time-frequency';
nfo = 8;
nAzimuths = 5;

dcase_scattering(dataset_path, 'time', 8, nAzimuths);
dcase_scattering([dataset_path,'_testset'], 'time', 8, nAzimuths);

dcase_scattering(dataset_path, 'time', 4, nAzimuths);
dcase_scattering([dataset_path,'_testset'], 'time', 4, nAzimuths);

%%
dataset_path = '~/datasets/dcase2013/scenes_stereo';
modulations = 'time-frequency';
nfo = 8;
nAzimuths = 1;

listing = list_dir(dataset_path);
names = {listing.name};

% Remove hidden files
names = names(~cellfun(@(x) x(1)=='.', names));

% Keep only WAV extension
names = names(cellfun(@(x) strcmp(x((end-3):end), '.wav'), names));

% Prepare scattering "architectures", i.e. filter banks and nonlinearities
opts{1}.time.nFilters_per_octave = nfo;
opts{1}.time.size = 2^19;
opts{1}.time.T = 2^14;
opts{1}.time.is_chunked = false;
opts{1}.time.gamma_bounds = [0 nfo*11]; % Restrict to top 11 acoustic octaves
opts{1}.time.wavelet_handle = @gammatone_1d;
opts{2}.banks.time.nFilters_per_octave = 1;
opts{2}.banks.time.wavelet_handle = @gammatone_1d;
opts{2}.banks.time.sibling_mask_factor = 2^6;
opts{2}.banks.time.T = 2^17;
if strcmp(modulations, 'time-frequency')
    opts{2}.banks.gamma.nFilters_per_octave = 1;
    opts{2}.banks.gamma.T = 2^nextpow2(nfo * 4);
end
opts{2}.invariants.time.size = 2^19;
opts{2}.invariants.time.T = 2^14;
opts{2}.invariants.time.subscripts = 1;
opts{3}.invariants.time.size = 2^19;
opts{3}.invariants.time.T = 2^14;
opts{3}.invariants.time.subscripts = 1;
archs = sc_setup(opts);
