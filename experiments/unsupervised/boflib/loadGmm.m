function mix=loadGmm(gmmfilename, nbcoef,nbgmm)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ex. to load a packed-and-saved gmm from a file ("gmm/mymodel.gmm") to a natlab struct, 
%% knowing it's a 50-state gmm constructed from 20-dim mfcc,  call  
%% mix=loadGmm('gmm/mymodel.gmm', 20,50)
%% mix is the netlab struct containing gmm parameters
%% mymodel.gmm is a mat file containing a netlab-packed version of mix (see saveGmm)
%% Copyright (C) JJ Aucouturier, 2008
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf(1,'- load gmm from file\n');
load(gmmfilename,'-mat');
premix=gmm(nbcoef,nbgmm,'diag');
mix = gmmunpak(premix, p);