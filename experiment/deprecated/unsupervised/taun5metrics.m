function [config, store, obs] = taun5metrics(config, setting, data)
% taun5metrics METRICS step of the expLanes experiment talspStruct2016_unsupervised
%    [config, store, obs] = taun5metrics(config, setting, data)
%      - config : expLanes configuration state
%      - setting   : set of factors to be evaluated
%      - data   : processing data stored during the previous step
%      -- store  : processing data to be saved for the other steps
%      -- obs    : observations to be saved for analysis

% Copyright: gregoirelafay
% Date: 17-Dec-2016

% Set behavior for debug mode
if nargin==0, unsupervised('do', 5, 'mask', {2 1 2 [4] 5 25 3 7}); return; else store=[]; obs=[]; end

D=1-data.A/max(data.A(:));

rm = rankingMetrics(D, data.class,setting.precision);
eval(['obs.po=rm.precisionAt' num2str(setting.precision) ';']);

for k=1:size(D, 1)
    vec = D(k, :);
    [~, ind] = sort(vec);
    ind = data.class(ind)==data.class(k);
    n(k)=mean(ind(2:setting.precision+1));
end
obs.p = mean(n);

nf=0;
queries = find(~data.filter);

for k=1:length(queries)
    vec = D(queries(1)-1+k, 1:queries(1)-1);
    [~, ind] = sort(vec);
    ind = ind(1:setting.precision);
    ind = data.class(ind)==data.class(queries(k));
    nf(k)=mean(ind);
end

obs.pf = mean(nf);
