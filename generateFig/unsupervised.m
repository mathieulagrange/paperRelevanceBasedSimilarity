clear all
addpath(genpath('functions'))

%% settings

% dataset='train'; % test;
dataset='test'; 

dataPath={['~/projets/ass_features/report/figures/unsupervised_earlyInt_' dataset]};

linewidth=2;
markersize=10;

%% load data
data=cell(1,length(dataPath));
leg=cell(1,length(dataPath));

for jj=1:length(dataPath)
    d=load(dataPath{jj});
    [data{jj},leg{jj}]=parseTable(d.data(1).tables{end});
end

pak_early=str2double(data{1}(9:15,:));

scat=strcmp('scatT',data{1}(1,:));
mfcc=strcmp('mfcc',data{1}(1,:));

%% best p@9

ind_best_mfcc=find( mfcc & pak_early(end,:)==max(pak_early(end,mfcc)));
ind_best_scat=find( scat & pak_early(end,:)==max(pak_early(end,scat)));

best_setting_mfcc=data{1}(:,ind_best_mfcc);
best_setting_scat=data{1}(:,ind_best_scat(1));

freq=strcmp('27,5_1000',data{1}(2,:));
mfcc40=strcmp('40',data{1}(3,:));
c0=strcmp('1',data{1}(4,:));
scat_log=strcmp('1',data{1}(5,:));
stand=strcmp('stand',data{1}(6,:));
gaussian=strcmp('gaussian_full',data{1}(7,:));
nn_10=strcmp('0.10',data{1}(8,:));


pak_early_mfcc=pak_early(:,mfcc & gaussian & ~stand & mfcc40 & c0 & nn_10 & freq);
pak_early_scat=pak_early(:,scat & gaussian & ~stand  & nn_10 & ~scat_log);
pak_early_scat_log=pak_early(:,scat & gaussian & ~stand  & nn_10 & scat_log);

%%
figure(1)
clf
plot(pak_early_mfcc,'o-','markersize',markersize,'linewidth',linewidth)
hold on
plot(pak_early_scat_log,'+-','markersize',markersize,'linewidth',linewidth)
hold off
legend({'ei, mfcc','ei, time-scattering'},'interpreter','none')
legend('boxoff')
set(gca,'xtick',1:7,'xticklabel',3:9)
xlabel('k')
ylabel('p@k')
box off
disp('')

figure(2)
clf
plot(pak_early_scat,'o-','markersize',markersize,'linewidth',linewidth)
hold on
plot(pak_early_scat_log,'+-','markersize',markersize,'linewidth',linewidth)
hold off
legend({'ei, w/o log','ei, w/ log'},'interpreter','none')
legend('boxoff')
set(gca,'xtick',1:7,'xticklabel',3:9)
xlabel('k')
ylabel('p@k')
box off
disp('')

%% print
figOpt.fontsize=16;
figOpt.height=15;
figOpt.width=20;

printFigures([1 2],['~/papers/paperStructureScene16/paper/gfx/unsupervised_' dataset],figOpt)
