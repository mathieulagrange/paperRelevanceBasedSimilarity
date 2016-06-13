dataset_path = '~/datasets/dcase2013/scenes_stereo';

% Load names
listing = list_dir(dataset_path);
names = {listing.name};

% Remove hidden files
names = names(~cellfun(@(x) x(1)=='.', names))

% Get class indices
classes = { ...
    'bus', 'busystreet', 'office', 'openairmarket', 'park', ...
    'quietstreet', 'restaurant', 'supermarket', 'tube', 'tubestation'};
class_names = cellfun(@(x) x(1:(end-6)), names, 'UniformOutput', false);
y = cellfun(@(x) find(strcmp(x, classes)), class_names) - 1;