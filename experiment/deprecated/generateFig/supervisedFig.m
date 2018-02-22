clear all
addpath([fileparts(mfilename('fullpath')) '/nonExposed'])

%% settings

dataPath='../talspStruct2016_supervised_earlyLate/report/figures/';
linewidth=4;
markersize=10;

%% load data

dataTrainLab={'train_mfcc_early_linear','train_mfcc_late_linear',...
    'train_scatT_early_linear','train_scatT_late_linear',...
    'train_logscatT_early_linear','train_logscatT_late_linear',...
    'train_mfcc_early_rbf','train_mfcc_late_rbf',...
    'train_scatT_early_rbf','train_scatT_late_rbf',...
    'train_logscatT_early_rbf','train_logscatT_late_rbf'};

dataTestLab={'test_mfcc_early_linear','test_mfcc_late_linear',...
    'test_scatT_early_linear','test_scatT_late_linear',...
    'test_logscatT_early_linear','test_logscatT_late_linear',...
    'test_mfcc_early_rbf','test_mfcc_late_rbf',...
    'test_scatT_early_rbf','test_scatT_late_rbf',...
    'test_logscatT_early_rbf','test_logscatT_late_rbf'};


for ii=1:length(dataTrainLab)
    load([dataPath 'supervised_' dataTrainLab{ii}]);
    eval([dataTrainLab{ii} '.mean=data.meanData;']);
    eval([dataTrainLab{ii} '.std=data.stdData;']);
end

for ii=1:length(dataTestLab)
    load([dataPath 'supervised_' dataTestLab{ii}]);
    eval([dataTestLab{ii} '.mean=data.meanData;']);
    eval([dataTestLab{ii} '.std=data.stdData;']);
end

disp('')

%% best accuracy train

dataTrainLab={'train_mfcc_early_linear','train_mfcc_late_linear',...
    'train_scatT_early_linear','train_scatT_late_linear',...
    'train_mfcc_early_rbf','train_mfcc_late_rbf',...
    'train_scatT_early_rbf','train_scatT_late_rbf'};

dataTestLab={'test_mfcc_early_linear','test_mfcc_late_linear',...
    'test_scatT_early_linear','test_scatT_late_linear',...
    'test_mfcc_early_rbf','test_mfcc_late_rbf',...
    'test_scatT_early_rbf','test_scatT_late_rbf'};

for ii=1:length(dataTrainLab)
    
    eval(['indMax=find(' dataTrainLab{ii} '.mean(:,1) == max(' dataTrainLab{ii} '.mean(:,1)));']);
    if length(indMax)>1
        disp('')
        indMax=indMax(1);
    end
    
    eval([dataTestLab{ii} '.meanBest=' dataTestLab{ii} '.mean(indMax,:);']);
    eval([dataTestLab{ii} '.stdBest=' dataTestLab{ii} '.std(indMax,:);']);
    
    switch dataTrainLab{ii}
        case 'train_scatT_early_linear'
            test_logscatT_early_linear.meanBest=test_logscatT_early_linear.mean(indMax,:);
            test_logscatT_early_linear.stdBest=test_logscatT_early_linear.std(indMax,:);
        case 'train_scatT_late_linear'
            test_logscatT_late_linear.meanBest=test_logscatT_late_linear.mean(indMax,:);
            test_logscatT_late_linear.stdBest=test_logscatT_late_linear.std(indMax,:);
        case 'train_scatT_early_rbf'
            test_logscatT_early_rbf.meanBest=test_logscatT_early_rbf.mean(indMax,:);
            test_logscatT_early_rbf.stdBest=test_logscatT_early_rbf.std(indMax,:);
        case 'train_scatT_late_rbf'
            test_logscatT_late_rbf.meanBest=test_logscatT_late_rbf.mean(indMax,:);
            test_logscatT_late_rbf.stdBest=test_logscatT_late_rbf.std(indMax,:);
    end
end

% for ii=1:length(dataTrainLab)
%     
%     eval(['indMax=find(' dataTrainLab{ii} '.mean(:,1) == max(' dataTrainLab{ii} '.mean(:,1)));']);
%     if length(indMax)>1
%         disp('')
%         indMax=indMax(1);
%     end
%     
%     eval([dataTestLab{ii} '.meanBest=' dataTestLab{ii} '.mean(indMax,:);']);
%     eval([dataTestLab{ii} '.stdBest=' dataTestLab{ii} '.std(indMax,:);']);
% 
% end

M_m=[test_mfcc_early_linear.meanBest(1),test_scatT_early_linear.meanBest(1),test_logscatT_early_linear.meanBest(1);...
    test_mfcc_early_rbf.meanBest(1),test_scatT_early_rbf.meanBest(1),test_logscatT_early_rbf.meanBest(1);...
    test_mfcc_late_linear.meanBest(1),test_scatT_late_linear.meanBest(1),test_logscatT_late_linear.meanBest(1);...
    test_mfcc_late_rbf.meanBest(1),test_scatT_late_rbf.meanBest(1),test_logscatT_late_rbf.meanBest(1)];

M_s=[test_mfcc_early_linear.stdBest(1),test_scatT_early_linear.stdBest(1),test_logscatT_early_linear.stdBest(1);...
    test_mfcc_early_rbf.stdBest(1),test_scatT_early_rbf.stdBest(1),test_logscatT_early_rbf.stdBest(1);...
    test_mfcc_late_linear.stdBest(1),test_scatT_late_linear.stdBest(1),test_logscatT_late_linear.stdBest(1);...
    test_mfcc_late_rbf.stdBest(1),test_scatT_late_rbf.stdBest(1),test_logscatT_late_rbf.stdBest(1)];

M_m_Lab=mat2dataset(M_m,'obsNames',{'early, lin','early, rbf','late, lin','late, rbf'},'varNames',{'MFCCs','scattering','log_scattering'});
M_s_Lab=mat2dataset(round(M_s*100)/100,'obsNames',{'early, lin','early, rbf','late, lin','late, rbf'},'varNames',{'MFCCs','scattering','log_scattering'});

disp(M_m_Lab);
disp(M_s_Lab);

figure(1)
plot([test_mfcc_early_rbf.meanBest(2:end);test_scatT_early_rbf.meanBest(2:end) ;test_logscatT_early_rbf.meanBest(2:end)],'*-','markersize',markersize,'linewidth',linewidth)
set(gca,'xtick',1:3,'xticklabel',{'MFCCs','scattering','log_scattering'})
legend({'1','2','3','4','5'})
xlabel('early')

figure(2)
plot([test_mfcc_late_rbf.meanBest(2:end);test_scatT_late_rbf.meanBest(2:end) ;test_logscatT_late_rbf.meanBest(2:end)],'*-','markersize',markersize,'linewidth',linewidth)
set(gca,'xtick',1:3,'xticklabel',{'MFCCs','scattering','log_scattering'})
legend({'1','2','3','4','5'})
xlabel('late')

% figure(2)=4;
% clf
% plot(mfcc_early.meanBest,'o--','markersize',markersize,'linewidth',linewidth)
% hold on
% plot(mfcc_clustering_average.meanBest,'*--','markersize',markersize,'linewidth',linewidth)
% plot(mfcc_clustering_emd.meanBest,'v--','markersize',markersize,'linewidth',linewidth)
% plot(mfcc_clustering_closest.meanBest,'^--','markersize',markersize,'linewidth',linewidth)
%
%
% plot(logscatT_early.meanBest,'o-','markersize',markersize,'linewidth',linewidth)
% plot(logscatT_clustering_average.meanBest,'*-','markersize',markersize,'linewidth',linewidth)
% plot(logscatT_clustering_emd.meanBest,'v-','markersize',markersize,'linewidth',linewidth)
% plot(logscatT_clustering_closest.meanBest,'^-','markersize',markersize,'linewidth',linewidth)
%
% hold off
% legend({'early, mfcc','ob-a, mfcc','ob-w, mfcc','ob-c, mfcc', ...
%     'early, log-scattering','ob-a, log-scattering','ob-w, log-scattering','ob-c, log-scattering'},'interpreter','none')
% legend('boxoff')
% xlabel('k')
% ylabel('p@k')
% box off
% ylim([0.25 .85])
% disp('')