function config = taunReport(config)
% taunReport REPORTING of the expLanes experiment talspStruct2016_unsupervised
%    config = taunInitReport(config)
%       config : expLanes configuration state

% Copyright: gregoirelafay
% Date: 17-Dec-2016

if nargin==0, unsupervised('report', 'r'); return; end

config = expExpose(config, 'p','step', 6, 'obs', 1:9, 'mask', {0 0 2 0 0 1 0 5},...
    'addSpecification', {'markersize', 10, 'linewidth',1.6},...
    'plotAxisProperties', 'polishFig', 'save', 1, 'visible', 1);

return
