function [data l f]= computeMfccs(audio,fs, nbcoef)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ex. to compute 20 mfcc from "data/audio1.wav", call 
%% data = computeMfccs("data/audio1.wav"1,20);
%% data is a N * 20 matrix, where N is the number of 2048-pt, 50-percent-overlap frames in the signal
%% Copyright (C) JJ Aucouturier, 2008
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~exist('nbcoef', 'var'), nbcoef=20; end

% convert to mono
if(size(audio,2)==2)
    audio=.5*(audio(:,1)+audio(:,2));
end
% compute mfcc
%fprintf(1,'- compute mfcc\n');
win=2048; % frame size
hop=win*0.5;
w='t'; % triangular filters

% cuts zeros at the beginning of a file, if needed
i=1;
while (audio(i)==0)
    i=i+1;
end
audio=audio(i:end);

Z=enframe(audio,hamming(win),hop);
clear audio;
[data l f]=mfc(Z,fs,w,nbcoef,floor(3*log(fs)),win,hop,0,0.5);
clear Z;
