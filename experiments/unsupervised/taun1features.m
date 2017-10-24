function [config, store, obs] = taun1features(config, setting, data)
% taun1features FEATURES step of the expLanes experiment talspStruct2016_unsupervised
%    [config, store, obs] = taun1features(config, setting, data)
%      - config : expLanes configuration state
%      - setting   : set of factors to be evaluated
%      - data   : processing data stored during the previous step
%      -- store  : processing data to be saved for the other steps
%      -- obs    : observations to be saved for analysis

% Copyright: gregoirelafay
% Date: 17-Dec-2016

% Set behavior for debug mode
if nargin==0, unsupervised('do', 1, 'mask', {1 3}); return; else store=[]; obs=[]; end

%% setting
store.xp_settings.sr=44100;
store.xp_settings.classes = {'bus','busystreet','office','openairmarket','park','quietstreet','restaurant','supermarket','tube','tubestation'};
store.filter = [];

switch setting.features
    case 'scatT'
        switch setting.dataset
            case '2013'
                fileId = fopen([config.inputPath 'dcase2013/sampleList_train.txt']);
                store.xp_settings.sounds=textscan(fileId,'%s');
                store.xp_settings.sounds=store.xp_settings.sounds{1};
                fclose(fileId);
                
                store.xp_settings.sounds=cellfun(@(x) x(strfind(x,'/')+1:end),store.xp_settings.sounds,'UniformOutput',false);
                
                store.soundIndex=[];
                store.indSample=[];
                store.class=[];
                store.filter=[];
                store.dataset=[];
                store.features=[];
                
                load([config.inputPath 'dcase2013/scattering/dcase2013_timeQ8_train.mat']);
                load([config.inputPath 'dcase2013/scattering/dcase2013_timeQ8_freqs.mat']);
                eval(['Y=dcase2013_timeQ8_train.Y_train;']);
                eval(['X=dcase2013_timeQ8_train.X_train;']);
                eval(['clearvars dcase2013_timeQ8_' setting.dataset ';']);
                
                store.xp_settings.Xfreqs=dcase2013_timeQ8_freqs;
                X=squeeze(X(:,:,3,:));
                
                store.class=Y(:)'+1;
                store.soundIndex=1:length(Y);
                
                nbTrame=size(X,2);
                
                for ii=1:size(X,3)
                    store.features=[store.features squeeze(X(:,:,ii))];
                    store.indSample=[store.indSample ones(1,nbTrame)*ii];
                end
                
                features =store.features;
                features(isinf(mean(features, 2)) | isnan(mean(features, 2)), :) = [];
                features(sum(features, 2)==0, :)=[];
                store.features = features ;
            case '2106'
                
        end
    case {'mfcc', 'scatTime'}
        
        %% setting framing
        
        store.xp_settings.hoptime = 0.025;
        store.xp_settings.wintime = 0.05;
        
        %% setting features
        
        store.xp_settings.melBand=40;
        store.xp_settings.minFreq=27.5;
        store.xp_settings.maxFreq=22050;
        
        store.xp_settings.mfccRank=40;
        store.xp_settings.mfccCoef0=1;
        
        
        %% select sound
        switch setting.dataset
            case '2013'
                fileId = fopen([config.inputPath 'dcase2013/sampleList_train.txt']);
                store.xp_settings.sounds=textscan(fileId,'%s');
                store.xp_settings.sounds=store.xp_settings.sounds{1};
                fclose(fileId);
                
                %% load sound
                
                store.xp_settings.soundIndex = 1:100;
            case {'2016all', '2016'}
                fid = fopen([config.inputPath 'dcase2016/metaDev.txt' ]);
                C = textscan(fid, '%s\t%s');
                devFiles = C{1};
                fclose(fid);
              
                
                fid = fopen([config.inputPath 'dcase2016/meta.txt' ]);
                C = textscan(fid, '%s\t%s');
                fclose(fid);
                
                store.xp_settings.sounds = C{1};
                typo = C{2};
                store.xp_settings.soundIndex=[];
                store.xp_settings.classes = typo(1);
                for k=1:length(typo)
                    if  strcmp(setting.dataset, '2016all') || ~isempty(strfind(store.xp_settings.sounds{k}, '_0_30'))
                        store.xp_settings.soundIndex(end+1) = k;
                    end
                    if ~strcmp(typo{k}, store.xp_settings.classes)
                        store.xp_settings.classes{end+1} = typo{k};
                    end
                end
        end
        
        % init
        store.features = [];
        
        store.soundIndex=zeros(1,length(store.xp_settings.soundIndex));
        store.class=zeros(1,length(store.xp_settings.soundIndex));
        store.dataset=zeros(1,length(store.xp_settings.soundIndex));
        store.indSample=[];
        
        switch setting.features
            case 'scatTime'
                % Prepare scattering "architectures", i.e. filter banks and nonlinearities
                Q1=8;
                opts{1}.time.nFilters_per_octave = Q1;
                opts{1}.time.size = 2^19;
                opts{1}.time.T = 2^14;
                opts{1}.time.is_chunked = false;
                opts{1}.time.gamma_bounds = [0 Q1*11]; % Restrict to top 11 acoustic octaves
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
                
                chunk_length = 2^19;
                hop_length = 2^18;
                nChunks = 4;
                chunk_range = 1:chunk_length;
                S_chunks = cell(1, nChunks);
        end
        
        for jj=1:length(store.xp_settings.soundIndex)
            
            [signal,fs]=audioread([config.inputPath 'dcase' setting.dataset '/' store.xp_settings.sounds{store.xp_settings.soundIndex(jj)}  '.wav']);
            
            if fs~=store.xp_settings.sr
                error('issue with sample rate')
            end
            
            % mono
            if min(size(signal)) > 1
                signal=mean(signal,2);
            end
            
            store.xp_settings.soundDuration = length(signal)/store.xp_settings.sr;
            
            % get features
            switch setting.features
                case 'mfcc'
                    [ftrs.mfcc,~,~] = melfcc(signal(:),store.xp_settings.sr,'wintime',store.xp_settings.wintime,'hoptime',store.xp_settings.hoptime,'minfreq',store.xp_settings.minFreq,'maxfreq',store.xp_settings.maxFreq,'lifterexp',0,'preemph',0,...
                        'nbands',store.xp_settings.melBand,'numcep',store.xp_settings.mfccRank);
                    ftrs.size=size(ftrs.mfcc,2);
                    features = ftrs.mfcc;
                    ftrs.mfcc = features ;
                    
                    % store features
                    store.features = [store.features ftrs.mfcc];
                case 'scatTime'
                    waveform = signal;
                    chunks = cat(2, ...
                        waveform(0*hop_length + chunk_range, :, :), ...
                        waveform(1*hop_length + chunk_range, :, :), ...
                        waveform(2*hop_length + chunk_range, :, :), ...
                        waveform(3*hop_length + chunk_range, :, :));
                    chunks = reshape(chunks, size(chunks, 1), nChunks);
                    parfor chunk_index = 1:nChunks
                        S_chunks{chunk_index} = sc_propagate(chunks(:, chunk_index), archs);
                    end
                    features = cellfun(@sc_format, S_chunks, 'UniformOutput', false);
                    features = cellfun(@(x) x(:, (1+end/4):(3*end/4)), features, ...
                        'UniformOutput', false);
                    features = [features{:}];
                    features(isinf(mean(features, 2)) | isnan(mean(features, 2)), :) = [];
                    features(sum(features, 2)==0, :)=[];
                    ftrs.size=size(features,2);
                    store.features = [store.features features];
            end
            %     store.soundIndex(jj)=store.xp_settings.soundIndex(jj);
            store.soundIndex(jj)=jj;
            store.indSample=[store.indSample ones(1,ftrs.size)*store.soundIndex(jj)];
            switch setting.dataset
                case '2013'
                    soundname=store.xp_settings.sounds{store.xp_settings.soundIndex(jj)}(1:end-2);
                    
                    soundname=soundname(strfind(soundname,'/')+1:end);
                    store.class(jj)=find(strcmp(soundname,store.xp_settings.classes));
                case {'2016all', '2016'}
                    store.class(jj)=find(strcmp(typo{store.xp_settings.soundIndex(jj)}, store.xp_settings.classes));
                    store.filter(jj)=any(strcmp([store.xp_settings.sounds{store.xp_settings.soundIndex(jj)} '.wav'], devFiles));
            end
        end
end