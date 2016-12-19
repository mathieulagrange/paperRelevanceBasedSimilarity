function features = multichannel_scattering(waveform, archs)
%% Truncation
original_length = 30 * 44100;
truncated_length = 5 * 2^18;
start = 1 + (original_length - truncated_length) / 2;
stop = original_length - start + 1;
waveform = waveform(start:stop, :);
nAzimuths = size(waveform, 2);
if nAzimuths > 1
    waveform = reshape(waveform, size(waveform, 1), 1, size(waveform, 2));
end

%% Chunking
chunk_length = 2^19;
hop_length = 2^18;
chunk_range = 1:chunk_length;
chunks = cat(2, ...
    waveform(0*hop_length + chunk_range, :, :), ...
    waveform(1*hop_length + chunk_range, :, :), ...
    waveform(2*hop_length + chunk_range, :, :), ...
    waveform(3*hop_length + chunk_range, :, :));
nChunks = 4;
chunks = reshape(chunks, size(chunks, 1), nChunks * nAzimuths);

%%
S_chunks = cell(1, nChunks);
parfor chunk_index = 1:nChunks
    S_chunks{chunk_index} = sc_propagate(chunks(:, chunk_index), archs);
end

features = cellfun(@sc_format, S_chunks, 'UniformOutput', false);
features = cellfun(@(x) x(:, (1+end/4):(3*end/4)), features, ...
    'UniformOutput', false);
features = [features{:}];
end

