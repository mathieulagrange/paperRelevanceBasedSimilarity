

%%
opts{1}.time.size = N;
opts{1}.time.T = 2^10;
opts{1}.time.max_scale = 8*opts{1}.time.T;
opts{1}.time.nFilters_per_octave = 24;
opts{1}.time.gamma_bounds = ...
    [1+opts{1}.time.nFilters_per_octave*1 ...
    opts{1}.time.nFilters_per_octave*10];
opts{1}.time.max_Q = 12;
opts{1}.time.is_chunked = false;

archs = sc_setup(opts);


%%
addpath(genpath('~/scattering.m'));
data_dir = '~/datasets/scenes_stereo_testset';
wav_id = 4;
wav_name = ['park', sprintf('%02d', wav_id), '.wav'];
wav_path = [data_dir, '/', wav_name];
disp(wav_path);


[y, sample_rate] = audioread(wav_path);
y = 0.5 * (y(:, 1) + y(:, 2));
N = 2^20;
y = y(1:2^20);

S = sc_propagate(y, archs);

%%
scalogram = S{1+1}.data.';

x_duration = opts{1}.time.size / sample_rate;
freq_hz = [50, 100, 200, 500, 1000, 2000, 5000, 10000, 20000];
xi = archs{1}.banks{1}.spec.mother_xi * sample_rate;
freq_semitones = 1 + ...
    round(log2(xi ./ freq_hz) * opts{1}.time.nFilters_per_octave);
freq_semitones = sort(unique(freq_semitones));

imagesc([0.0, x_duration], opts{1}.time.gamma_bounds, ...
    100 * flipud(log1p(1e1*scalogram)));
colormap rev_magma;
set(gca, 'YDir', 'normal');
set(gca(), 'Xtick', [0:5:20.0]);
set(gca(), 'Ytick', sort(opts{1}.time.gamma_bounds(2) - freq_semitones));
set(gca(), 'YTickLabel', freq_hz/1000);
xlabel('Time (s)');

export_fig park_scalogram.png -m8 -transparent
ylabel('Frequency (kHz)');