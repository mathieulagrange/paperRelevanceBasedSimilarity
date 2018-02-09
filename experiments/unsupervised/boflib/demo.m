%% a demo fo the BOF package
%% Copyright (C) JJ Aucouturier, 2008
%% credits: Mike Brookes for MFCC code, Chris Bishop for GMM code

fprintf(1,'compute mfcc for market soundscape\n');
[audio,fs]=wavread('data/Market 004-a-001-extrait4.mp3.wav');
data1 = computeMfccs(audio, fs, 20);
fprintf(1,'compute mfcc for boulevard1 soundscape\n');
[audio,fs]=wavread('data/Boulevard 002-001-extrait10.mp3.wav');
data2 = computeMfccs(audio, fs, 20);
fprintf(1,'compute mfcc for boulevard2 soundscape\n');
[audio,fs]=wavread('data/Boulevard 006-a-002-extrait6.mp3.wav');
data3 = computeMfccs(audio,fs, 20);

fprintf(1,'compute gmm for market soundscape\n');
mix1 = createGmm(data1, 10);
fprintf(1,'compute gmm for boulevard1 soundscape\n');
mix2 = createGmm(data2, 10);
fprintf(1,'compute gmm for boulevard2 soundscape\n');
mix3 = createGmm(data3, 10);
fprintf(1,'compute gmm for boulevard class\n');
mix23 = createGmm([data2;data3], 10);

fprintf(1,'save gmm for market soundscape\n');
saveGmm(mix1,'gmms/market.gmm');
fprintf(1,'save gmm for boulevard1 soundscape\n');
saveGmm(mix2,'gmms/boulevard1.gmm');
fprintf(1,'save gmm for boulevard2 soundscape\n');
saveGmm(mix3,'gmms/boulevard2.gmm');
fprintf(1,'save gmm for boulevard class\n');
saveGmm(mix23,'gmms/boulevard-class.gmm');

fprintf(1,'load gmm for market soundscape\n');
mix1=loadGmm('gmms/market.gmm',20,10);
fprintf(1,'load gmm for boulevard1 soundscape\n');
mix2=loadGmm('gmms/boulevard1.gmm',20,10);
fprintf(1,'load gmm for boulevard2 soundscape\n');
mix3=loadGmm('gmms/boulevard2.gmm',20,10);
fprintf(1,'load gmm for boulevard class\n');
mix23=loadGmm('gmms/boulevard-class.gmm',20,10);

fprintf(1,'distances between gmms:\n');
fprintf(1,'d(market, boulevard1) = %f\n',distanceModelToModel(mix1, mix2, 2000));
fprintf(1,'d(market, boulevard2) = %f\n',distanceModelToModel(mix1, mix3, 2000));
fprintf(1,'d(boulevard1, boulevard2) = %f\n',distanceModelToModel(mix2, mix3, 2000));

fprintf(1,'distance to class model:\n');
fprintf(1,'-log p(market / class=boulevard) = %f\n',distanceDataToModel(data1, mix23));
fprintf(1,'-log p(boulevard1 / class=boulevard) = %f\n',distanceDataToModel(data2, mix23));
fprintf(1,'-log p(boulevard2 / class=boulevard) = %f\n',distanceDataToModel(data3, mix23));

