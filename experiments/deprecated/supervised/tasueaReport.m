function config = tasueaReport(config)
% tasueaReport REPORTING of the expLanes experiment talspStruct2016_supervised_earlyLate
%    config = tasueaInitReport(config)
%       config : expLanes configuration state

% Copyright: gregoirelafay
% Date: 16-Dec-2016

if nargin==0, talspStruct2016_supervised_earlyLate('report', 'r'); return; end

dataset={'train','test'};
features = {'mfcc','scatT'};
integration = {'early','late'};
scat_log = {'','log'};
similarity = {'linear','rbf'};

for a=1:length(dataset)
    for b=1:length(features)
        for c=1:length(integration)
            for e=1:length(similarity)
                
                switch features{b}
                    case 'mfcc'
                        config = expExpose(config, 't','fontSize','scriptsize','step', 3, 'mask',{a b c 0 e [1 3 5 7]},'obs',[1 2 3 4 5 6],'precision', 2,'save',1,'name',...
                            ['supervised_' dataset{a} '_' features{b} '_' integration{c} '_' similarity{e}]);
                    case 'scatT'
                        for d=1:length(scat_log)
                         config = expExpose(config, 't','fontSize','scriptsize','step', 3, 'mask',{a b c d e [1 3 5 7]},'obs',[1 2 3 4 5 6],'precision', 2,'save',1,'name',...
                            ['supervised_' dataset{a}  '_' scat_log{d} features{b} '_' integration{c} '_' similarity{e}]);                           
                        end
                end
            end
        end
    end
end