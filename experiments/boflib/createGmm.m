function mix = createGmm(data, nbgmm)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ex. to create a gmm with 50 states from a mfcc matrix ("mymfcc") and save it to a file ("gmm/mymodel.gmm"), call 
%% mix = createGmm(mymfcc, 'gmm/mymodel.gmm', 50)
%% mix is the netlab struct containing gmm parameters
%% mymodel.gmm is a mat file containing a netlab-packed version of mix (see saveGMM)
%% Copyright (C) JJ Aucouturier, 2008
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%fprintf(1,'- compute gmm\n');
nbcoef=size(data,2);
mix = gmm(nbcoef, nbgmm, 'diag');
% options = foptions;
options(14) = 20;	% Just use 20 iterations of k-means in initialisation
options(1)  = -1;
mix = gmminit(mix, data, options);
options = zeros(1, 18);
options(1)  = -1;		% Prints out error values.
options(14) = 100;		% Number of iterations.
[mix, options, errlog] = gmmem(mix, data, options);

% note: if netlab prints a "warning:divide by zero", then the resulting gmm is probably corrupted. 
% Try calling "createGMM" again with the same arguments. 
% Such numerical errors often happen in local minima, so likely that a simple rerun will avoid the trap.
