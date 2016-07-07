function X_freqs = get_time_frequencies(nfo)

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
opts{2}.banks.time.sibling_mask_factor = 2^6;
opts{2}.banks.time.T = 2^17;
opts{2}.invariants.time.size = 2^19;
opts{2}.invariants.time.T = 2^14;
opts{2}.invariants.time.subscripts = 1;
opts{3}.invariants.time.size = 2^19;
opts{3}.invariants.time.T = 2^14;
opts{3}.invariants.time.subscripts = 1;
archs = sc_setup(opts);

x = randn(2^19, 1);
S = sc_propagate(x, archs);

%%
S1_refs = generate_refs(S{1+1}.data, 1, S{1+1}.ranges{1+0});
for S1_ref_index = 1:size(S1_refs, 2)
    S{1+1}.data = subsasgn(S{1+1}.data, S1_refs(:, S1_ref_index), S1_ref_index);
end
S2_refs = generate_refs(S{1+2}.data, 1, S{1+2}.ranges{1+0});
for S2ref_index = 1:size(S2_refs, 2)
    S{1+2}.data = subsasgn( ...
        S{1+2}.data, S2_refs(:, S2ref_index), ...
        S2ref_index);
end
formatted_S = sc_format(S);
refs = formatted_S(:, 1);

%%
networks = [ ...
    repmat(1, size(S1_refs, 2), 1) ; ...
    repmat(2, size(S2_refs, 2), 1)];

%%
gamma1_start = S{1+1}.ranges{1}(1,2);
nS1_refs = length(S1_refs);
S1_paths(1:nS1_refs) = struct('gamma', [], 'gamma2', []);
for ref_index = 1:nS1_refs
    gamma1_index = S1_refs(ref_index).subs{2};
    gamma1 = (gamma1_index - 1) + gamma1_start;
    S1_paths(ref_index).gamma = gamma1;
end

nS2_refs = length(S2_refs);
S2_paths(1:nS2_refs) = struct('gamma', [], 'gamma2', []);
gamma2_start = S{1+2}.ranges{2}(1);
for ref_index = 1:nS2_refs
    S2_path = struct('gamma', [], 'gamma2', []);
    gamma2_index = S2_refs(1,ref_index).subs{1};
    S2_path.gamma2 = gamma2_index + (gamma2_start - 1);
    gamma1_index = S2_refs(2,ref_index).subs{2};
    gamma1_range = S{1+2}.ranges{1}{gamma2_index}(:,2);
    gamma1_start = gamma1_range(1);
    S2_path.gamma = gamma1_start + gamma1_index - 1;
    S2_paths(ref_index) = S2_path;
end


%%
S_paths = [S1_paths, S2_paths];
sample_rate = 44100;
gamma1_motherfrequency = sample_rate * ...
    S{1+1}.variable_tree.time{1}.gamma{1}.leaf.spec.mother_xi;
gamma1_frequencies = gamma1_motherfrequency * ...
    [S{1+1}.variable_tree.time{1}.gamma{1}.leaf.metas.resolution];
gamma1s = [S_paths.gamma];
X_freqs = gamma1_frequencies(gamma1s);
end