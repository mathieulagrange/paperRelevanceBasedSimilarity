function saveGmm(mix,gmmfilename)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ex. to save a newly created gmm to a file ("gmm/mymodel.gmm"), call 
%% saveGmm(mix, 'gmm/mymodel.gmm')
%% mix is the netlab struct containing gmm parameters
%% mymodel.gmm is a mat file containing a netlab-packed version of mix (see loadGmm)
%% Copyright (C) JJ Aucouturier, 2008
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf(1,'- save gmm in file\n');
p=gmmpak(mix);
% note: if filename is a path including directories, all directories should exist before calling saveGmm
save(gmmfilename,'p');
