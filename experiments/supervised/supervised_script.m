dataset_path = '~/datasets/dcase2013/scenes_stereo';
method = 'plain';
nfo = 4;
nAzimuths = 5;

% Load names
listing = list_dir(dataset_path);
names = {listing.name};

% Remove hidden files
names = names(~cellfun(@(x) x(1)=='.', names));

% Make a cell array of paths
paths = cellfun(@(x) fullfile(dataset_path, x), names, 'UniformOutput', false);

% Parse class indices to get annotation vector y
classes = { ...
    'bus', 'busystreet', 'office', 'openairmarket', 'park', ...
    'quietstreet', 'restaurant', 'supermarket', 'tube', 'tubestation'};
class_names = cellfun(@(x) x(1:(end-6)), names, 'UniformOutput', false);
y = cellfun(@(x) find(strcmp(x, classes)), class_names) - 1;

% Prepare scattering "architectures", i.e. filter banks and nonlinearities
clear opts;
opts{1}.time.nFilters_per_octave = nfo;
opts{1}.time.size = 2^19;
opts{1}.time.T = 2^14;
opts{1}.time.is_chunked = false;
opts{1}.time.gamma_bounds = [0 nfo*11]; % Restrict to top 11 acoustic octaves
opts{1}.time.wavelet_handle = @morlet_1d;
opts{1}.time.S_log2_oversampling = 0;
opts{2}.banks.time.nFilters_per_octave = 1;
opts{2}.banks.time.wavelet_handle = @morlet_1d;
opts{2}.banks.time.sibling_mask_factor = 2^8;
opts{2}.banks.time.T = 2^17;
if strcmp(method, 'joint')
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

% Prepare azimuthal augmentation
azimuths = linspace(0.0, 1.0, nAzimuths);
mixing_matrix = cat(1, azimuths, 1.0 - azimuths);

%%

nFiles = length(paths);
file_index = 1
%for file_index = 1:nFiles
    path = paths{file_index};
    stereo_waveform = audioread(path);
    multichannel_waveform = stereo_waveform * mixing_matrix;
    [features, scattergram] = ...
        multichannel_scattering(multichannel_waveform, archs);
%end