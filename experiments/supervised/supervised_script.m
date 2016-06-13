dataset_path = '~/datasets/dcase2013/scenes_stereo';
method = 'plain';
nfo = 4;

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
opts{1}.time.size = 131072;
opts{1}.time.T = 16384;
opts{1}.time.is_chunked = false;
opts{1}.time.gamma_bounds = [];
opts{1}.time.wavelet_handle = @morlet_1d;
opts{2}.time.nFilters_per_octave = 1;
opts{2}.time.wavelet_handle = @morlet_1d;
if strcmp(method, 'joint')
    opts{2}.gamma.nFilters_per_octave = 1;
    opts{2}.gamma.T = 2^nextpow2(nfo * 4);
end
archs = sc_setup(opts);