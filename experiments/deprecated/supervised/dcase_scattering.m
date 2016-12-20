function dcase_scattering(dataset_path, Q1)
% Load names
listing = list_dir(dataset_path);
names = {listing.name};

% Remove hidden files
names = names(~cellfun(@(x) x(1)=='.', names));

% Keep only WAV extension
names = names(cellfun(@(x) strcmp(x((end-3):end), '.wav'), names));

% Prepare scattering "architectures", i.e. filter banks and nonlinearities
opts{1}.time.nFilters_per_octave = Q1;
opts{1}.time.size = 2^19;
opts{1}.time.T = 2^14;
opts{1}.time.is_chunked = false;
opts{1}.time.gamma_bounds = [0 Q1*11]; % Restrict to top 11 acoustic octaves
opts{1}.time.wavelet_handle = @gammatone_1d;
opts{1}.time.S_log2_oversampling = 0;
opts{2}.banks.time.nFilters_per_octave = 1;
opts{2}.banks.time.wavelet_handle = @gammatone_1d;
if strcmp(modulations, 'time')
    opts{2}.banks.time.sibling_mask_factor = 2^6;
elseif strcmp(modulations, 'timefrequency')
    opts{2}.banks.time.sibling_mask_factor = 2^3;
end
opts{2}.banks.time.T = 2^17;
if strcmp(modulations, 'timefrequency')
    opts{2}.banks.gamma.nFilters_per_octave = 1;
    opts{2}.banks.gamma.T = 2^nextpow2(Q1 * 4);
end
opts{2}.invariants.time.size = 2^19;
opts{2}.invariants.time.T = 2^14;
opts{2}.invariants.time.subscripts = 1;
opts{3}.invariants.time.size = 2^19;
opts{3}.invariants.time.T = 2^14;
opts{3}.invariants.time.subscripts = 1;
archs = sc_setup(opts);

% Prepare paths for memoized features
out_file_name = [modulations, '_Q=', num2str(Q1, '%0.2d')];
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
    waveform = mean(stereo_waveform, 2);
    X_features{file_index} = sc_propagate(waveform(:, azimuth_index), archs);
    disp([name, ...
        ' finished on worker ', num2str(labindex()), ...
        ' at ', datestr(now(), 'HH:MM:SS')]);
end
X_features = cat(1, X_features{:}).';
save(fullfile('memoized_features', out_file_name), 'X_features', '-v7.3');
end