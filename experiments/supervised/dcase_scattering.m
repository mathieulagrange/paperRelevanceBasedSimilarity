function dcase_scattering(dataset_path, modulations, nfo, nAzimuths)
% Load names
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
opts{1}.time.S_log2_oversampling = 0;
opts{2}.banks.time.nFilters_per_octave = 1;
opts{2}.banks.time.wavelet_handle = @gammatone_1d;
opts{2}.banks.time.sibling_mask_factor = 2^3;
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

% Prepare azimuthal augmentation
azimuths = linspace(0.0, 1.0, nAzimuths);
mixing_matrix = cat(1, azimuths, 1.0 - azimuths);

%
out_file_name = [modulations, '_Q=', num2str(nfo, '%0.2d')];
if strcmp(dataset_path((end-6):end), 'testset')
    out_file_name = [out_file_name, '_test'];
else
    out_file_name = [out_file_name, '_train'];
end
[~,~] = mkdir('memoized_features'); % [~,~] is to ignore the "already exists" warning

%%
nFiles = length(names);
X_features = cell(1, nFiles);
for file_index = 1:nFiles
    name = names{file_index};
    path = fullfile(dataset_path, name);
    stereo_waveform = audioread(path);
    multichannel_waveform = stereo_waveform * mixing_matrix;
    azimuth_features = cell(1, nAzimuths);
    for azimuth_index = 1:nAzimuths
        features = multichannel_scattering( ...
            multichannel_waveform(:, azimuth_index), archs);
        azimuth_features{azimuth_index} = features;
        disp([name, ...
            ', azimuth ', num2str(azimuth_index), ...
            ' finished on worker ', num2str(labindex()), ...
            ' at ', datestr(now(), 'HH:MM:SS')]);
    end
    X_features{file_index} = cat(3, azimuth_features);
end
X_features = cat(4, X_features);
save(fullfile('memoized_features', out_file_name), 'X_features', '-v7.3');
end