%% Load waveform
dataset_path = '~/datasets/dcase2013/scenes_stereo';
file_name = 'openairmarket05.wav';
file_path = fullfile(dataset_path, file_name);
[stereo_waveform, sample_rate] = audioread(file_path);

%% Truncate waveform
nSamples = 2^20;
stereo_waveform = stereo_waveform(0 + (1:nSamples), :);

%% Make a multichannel waveform
nAzimuths = 5;
azimuths = [linspace(0, 1, 5); linspace(1, 0, 5)];
multichannel_waveform = stereo_waveform * azimuths;

%% Plot waveforms
for azimuth_index = 1:nAzimuths
    azimuth_waveform = multichannel_waveform(:, azimuth_index);
    figure(azimuth_index);
    plot(azimuth_waveform);
    axis off;
end

%% Create scattering architectures
nfo = 8;
opts{1}.time.nFilters_per_octave = nfo;
opts{1}.time.size = nSamples;
opts{1}.time.T = 2^14;
opts{1}.time.is_chunked = false;
opts{1}.time.gamma_bounds = [0 nfo*7]; % Restrict to top 11 acoustic octaves
opts{1}.time.wavelet_handle = @gammatone_1d;
opts{1}.time.S_log2_oversampling = 0;
archs = sc_setup(opts);

%% Compute wavelet transforms
[S, U] = sc_propagate(multichannel_waveform, archs);
scalograms = permute(S{1+1}.data, [3 1 2]);

%% Display augmented scalograms
for azimuth_index = 1:nAzimuths
    azimuth_scalogram = scalograms(:, :, azimuth_index);
    figure(5 + azimuth_index - 1);
    imagesc(azimuth_scalogram);
    axis off;
    colormap rev_gray;
end

%% Pick an azimuth
azimuth_index = 3;
scalogram = scalograms(:, :, azimuth_index);

%% Log compression
figure(11);
log_scalogram = log(scalogram);
log_scalogram = max(log_scalogram, 0); % threshold to increase contrast
imagesc(log_scalogram);
axis off;
colormap rev_gray;

%% Feature selection
starting_octave = 3;
starting_gamma = 1 + (starting_octave - 1) * nfo;
truncated_scalogram = log_scalogram(starting_gamma:end, :);
figure(12);
imagesc(max(truncated_scalogram, 0));

%% Load memoized features
memoized_path = ...
    'experiments/supervised/memoized_features/dcase2013_timeQ8_train.mat';
training_data = load(memoized_path);
X_train = training_data.dcase2013_timeQ8_train.X_train;

%% Compute mean and standard deviation
X_sizes = size(X_train);
X_train = reshape(X_train, X_sizes(1), prod(X_sizes(2:end)));
X_mean = mean(X_train, 2);
X_std = std(X_train, [], 2);
gamma_range = starting_gamma + (1:size(truncated_scalogram, 1)) - 1;
X_mean = X_mean(gamma_range);
X_std = X_std(gamma_range);

%% Standardization
centered_scalogram = bsxfun(@minus, truncated_scalogram, X_mean);
standardized_scalogram = bsxfun(@rdivide, centered_scalogram, X_std);