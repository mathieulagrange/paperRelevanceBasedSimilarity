nfo = 8;
line_width = 2;

opts{1}.time.nFilters_per_octave = nfo;
opts{1}.time.size = 2^19;
opts{1}.time.T = 2^14;
opts{1}.time.is_chunked = false;
opts{1}.time.gamma_bounds = [0 nfo*11]; % Restrict to top 11 acoustic octaves
opts{1}.time.wavelet_handle = @gammatone_1d;
opts{2}.banks.time.nFilters_per_octave = 1;
opts{2}.banks.time.wavelet_handle = @gammatone_1d;
opts{2}.banks.time.T = 2^17;

archs = sc_setup(opts);

psi1_fts = display_bank(archs{1}.banks{1});
psi2_fts = display_bank(archs{2}.banks{1});

%%
psi1_ft = psi1_fts(:, 40);
psi1_ift = ifftshift(ifft(psi1_ft));
psi1_ift = psi1_ift((end/2) + (-300:1000));
psi1 = [real(psi1_ift),imag(psi1_ift)];
abspsi1 = abs(psi1_ift);

psi2_ft = psi2_fts(:, 11);
psi2_ift = ifftshift(ifft(psi2_ft));
psi2_ift = psi2_ift((end/2) + (-3000:10000));
psi2 = [real(psi2_ift),imag(psi2_ift)];
abspsi2 = abs(psi2_ift);

figure(1);
plot(psi1, 'LineWidth', line_width)
axis off
hold on
plot(abspsi1, 'LineWidth', 2 * line_width);
hold off;
export_fig -transparent gammatone_Q8.png

figure(2);
plot(psi2, 'LineWidth', line_width);
axis off
hold on
plot(abspsi2, 'LineWidth', 2 * line_width);
hold off;
export_fig -transparent gammatone_Q1.png