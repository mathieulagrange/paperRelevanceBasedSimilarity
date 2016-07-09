%% Load tensor of features
features_path = ...
    'experiments/supervised/memoized_features/dcase2013_timeQ8_test';
load(features_path)

%% Draw a histogram
% Pick a scattering subband index
scattering_index = 50;
nBins = 100;
freq = dcase2013_timeQ8_test.freqs(scattering_index)

X = dcase2013_timeQ8_test.X_test;
X = X(scattering_index, :, :, :);

% Center azimuth only
X = X(:, :, 3, :);
X = X(:);

%%
%figure(1);

histogram(X, nBins, 'EdgeColor', 'none', 'FaceColor', 'b', ...
    'FaceAlpha', 1.0);
%export_fig -transparent feature_histogram.png

%%
figure(2);
histogram(log(max(X,0)), nBins, 'EdgeColor', 'none', 'FaceColor', 'r', ...
    'FaceAlpha', 1.0);
ax = gca();
ax.XAxisLocation = 'origin';
ax.YAxisLocation = 'origin';
ax.Box = 'off';
export_fig -transparent feature_histogram_logcompressed.png