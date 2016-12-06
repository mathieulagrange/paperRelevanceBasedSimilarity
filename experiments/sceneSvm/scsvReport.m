function config = scsvReport(config)
% scsvReport REPORTING of the expLanes experiment sceneSvm
%    config = scsvInitReport(config)
%       config : expLanes configuration state

% Copyright: Mathieu Lagrange
% Date: 29-Jun-2016

if nargin==0, sceneSvm('report', 'rh'); return; end

%% label

setVal={'train','test'};

%% get best setting

set=1;
% config = expExpose(config, 't','fontSize','scriptsize','step', 1, 'mask', {0 0 1 set 0 0},'obs',1,'precision', 2);
% 
cut=1;
select=2;
gcaStyle='set(gca,''xtick'',1:6,''xticklabel'',[])';

% config = expExpose(config, 'p','fontSize','scriptsize','step', 1, 'mask', {0 0 cut set 0 select},'obs',1,'precision', 2, ...
%     'plotAxisProperties',{'fontsize',16},...
%     'plotCommand',{'legend(''mfcc, objBased, closest'',''mfcc, objBased, EMD'',''Scat, objBased, closest'',''Scat, objBased, EMD'',''mfcc, baseline'',''Scat, baseline'')', ...
%     'ylabel(''accuracy'')','ylim([.3 1])',gcaStyle,['title(''MFCC vs. Scattering using SVM on ' setVal{set} ''')']});

%% run test set with best setting
set=2;

% config = expExpose(config, 'p','fontSize','scriptsize','step', 1, 'mask', {0 0 cut set 0 select},'obs',1,'precision', 2, ...
%     'plotAxisProperties',{'fontsize',16},...
%     'plotCommand',{'legend(''mfcc, objBased, closest'',''mfcc, objBased, EMD'',''Scat, objBased, closest'',''Scat, objBased, EMD'',''mfcc, baseline'',''Scat, baseline'')', ...
%     'ylabel(''accuracy'')','ylim([.3 1])',gcaStyle,['title(''MFCC vs. Scattering using SVM on ' setVal{set} ''')']});

select=0;
kernel=2;
distance=0;
config = expExpose(config, 'p','fontSize','scriptsize','step', 1, 'mask', {0 kernel cut set distance select},'obs',1,'precision', 2, ...
    'plotAxisProperties',{'fontsize',16},'expand','select','plotCommand',{'legend(''mfcc, closest'',''mfcc, EMD'',''Scattering, closest'',''Scattering, EMD'')'});
