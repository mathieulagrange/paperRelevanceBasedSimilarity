clear all
addpath([fileparts(mfilename('fullpath')) '/nonExposed'])

%% settings

dataPath='../unsupervised/report/figures/';
linewidth=1.6;
markersize=10;

%% load data

dataLab={'mfcc_early','mfcc_clustering_closest','mfcc_clustering_average','mfcc_clustering_emd',...
    'scatT_early','scatT_clustering_closest','scatT_clustering_average','scatT_clustering_emd',...
    'logscatT_early','logscatT_clustering_closest','logscatT_clustering_average','logscatT_clustering_emd'};

for ii=1:length(dataLab)
    load([dataPath 'unsupervised_test_' dataLab{ii}]); 
    eval([dataLab{ii} '.mean=data.meanData;']); 
end

disp('')

%% best p@9

for ii=1:length(dataLab)
    eval(['indMax=find(' dataLab{ii} '.mean(:,end) == max(' dataLab{ii} '.mean(:,end)));']);
    if length(indMax)>1
        eval(['indMax=indMax(find(' dataLab{ii} '.mean(indMax,1) == max(' dataLab{ii} '.mean(indMax,1))));'])
        if length(indMax)>1
           error('') 
        end
    end
    eval([dataLab{ii} '.meanBest=' dataLab{ii} '.mean(indMax,:);']); 
     eval([dataLab{ii} '.meanBest=' dataLab{ii} '.meanBest(1, :);']); % ML
end

disp('')

%% figure 

figure(1)
clf
plot(scatT_early.meanBest,'d--','markersize',markersize,'linewidth',linewidth)
hold on
plot(scatT_clustering_emd.meanBest,'*--','markersize',markersize,'linewidth',linewidth)
plot(scatT_clustering_closest.meanBest,'x--','markersize',markersize,'linewidth',linewidth)
plot(logscatT_early.meanBest,'o-','markersize',markersize,'linewidth',linewidth)
plot(logscatT_clustering_emd.meanBest,'v-','markersize',markersize,'linewidth',linewidth)
plot(logscatT_clustering_closest.meanBest,'^-','markersize',markersize,'linewidth',linewidth)
hold off
legend({'early, scattering','RbQ-w, scattering','RbQ-c, scattering','early, log-scattering','RbQ-w, log-scattering','RbQ-c, log-scattering'},'interpreter','none')
legend('boxoff')
xlabel('k')
ylabel('p@k')
box off
ylim([.25 .85])
disp('')

figure(2)
clf

plot(mfcc_early.meanBest,'o--','markersize',markersize,'linewidth',linewidth)
hold on
plot(mfcc_clustering_average.meanBest,'*--','markersize',markersize,'linewidth',linewidth)
plot(mfcc_clustering_emd.meanBest,'v--','markersize',markersize,'linewidth',linewidth)
plot(mfcc_clustering_closest.meanBest,'^--','markersize',markersize,'linewidth',linewidth)


plot(logscatT_early.meanBest,'o-','markersize',markersize,'linewidth',linewidth)
plot(logscatT_clustering_average.meanBest,'*-','markersize',markersize,'linewidth',linewidth)
plot(logscatT_clustering_emd.meanBest,'v-','markersize',markersize,'linewidth',linewidth)
plot(logscatT_clustering_closest.meanBest,'^-','markersize',markersize,'linewidth',linewidth)

hold off
legend({'early, mfcc','RbQ-a, mfcc','RbQ-w, mfcc','RbQ-c, mfcc', ...
    'early, log-scattering','RbQ-a, log-scattering','RbQ-w, log-scattering','RbQ-c, log-scattering'},'interpreter','none')
legend('boxoff')
xlabel('k')
ylabel('p@k')
box off
ylim([0.25 .85])
disp('')
 
figOpt.fontsize=16;
figOpt.height=20;
figOpt.width=20;

printFigures([1 2],[fileparts(mfilename('fullpath')) '/figures/unsupervised_'],figOpt)