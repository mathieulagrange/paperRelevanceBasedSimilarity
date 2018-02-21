function config = taunReport(config)
% taunReport REPORTING of the expLanes experiment talspStruct2016_unsupervised
%    config = taunInitReport(config)
%       config : expLanes configuration state

% Copyright: gregoirelafay
% Date: 17-Dec-2016

if nargin==0, unsupervised('report', 'r', 'reportName', 'ml'); return; end


config = expExpose(config, 'p', 'mask', {2 0 2 [1 3] 0 1 1}, 'expand', 'precision', 'obs', 'p', 'percent', 1, 'save', 'baselines');
config = expExpose(config, 'p', 'mask', {2 0 2 [1 2] 1 1}, 'expand', 'precision', 'obs', 'p', 'percent', 1, 'save', 'overall');
config = expExpose(config, 'p', 'mask', {2 2 0 [1 2] 1 1}, 'expand', 'precision', 'obs', 'p', 'percent', 1, 'save', 'log');
return

features = {'mfcc','scatT'};
scat_log = {'','log'};
integration = {'early','clustering'};
similarity_dist = {'emd','average','closest'};

for a=1:length(features)
    for c=1:length(integration)   
        switch integration{c} 
            case 'early'
                switch features{a}
                    case 'mfcc'
                        config = expExpose(config, 't','fontSize','scriptsize','step', 5, 'mask',{2 a 0 c 0 [1 2 3] 0},'obs',[1 2 3 4 5 6 7 8 9],'precision', 2,'save',1,'name', ...
                            ['unsupervised_test_' features{a} '_' integration{c}]);
                    case 'scatT'
                        for b=1:length(scat_log)
                            config = expExpose(config, 't','fontSize','scriptsize','step', 5, 'mask',{2 a b c 0 [1 2 3] 0},'obs',[1 2 3 4 5 6 7 8 9],'precision', 2,'save',1,'name', ...
                                ['unsupervised_test_' scat_log{b} features{a} '_' integration{c}]);
                        end
                end  
            case 'clustering'
                for d=1:length(similarity_dist)
                    switch features{a}
                        case 'mfcc'
                            config = expExpose(config, 't','fontSize','scriptsize','step', 5, 'mask',{2 a 0 c 0 [1 2 3] d},'obs',[1 2 3 4 5 6 7 8 9],'precision', 2,'save',1,'name', ...
                                ['unsupervised_test_' features{a} '_' integration{c} '_' similarity_dist{d}]);
                        case 'scatT'
                            for b=1:length(scat_log)
                                config = expExpose(config, 't','fontSize','scriptsize','step', 5, 'mask',{2 a b c 0 [1 2 3] d},'obs',[1 2 3 4 5 6 7 8 9],'precision', 2,'save',1,'name', ...
                                    ['unsupervised_test_' scat_log{b} features{a} '_' integration{c} '_' similarity_dist{d}]);
                            end
                    end  
                end
        end
    end
end


