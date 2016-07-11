clear all
addpath(genpath('functions'))

%% settings

% dataset='train'; % test;
dataset='test'; 


linewidth=1.6;
markersize=10;

%% load data
d=load(['~/projets/ass_features/report/figures/unsupervised_earlyInt_' dataset]);
[data{1},leg{1}]=parseTable(d.data.tables{4});

d=load(['~/projets/ass_clustering_features/report/figures/unsupervised_object_' dataset]);
[data{2},leg{2}]=parseTable(d.data.tables{2});


pak_ei=str2double(data{1}(9:17,:));
pak_obj=str2double(data{2}(8:16,:));

scat_ei=strcmp('scatT',data{1}(1,:));
mfcc_ei=strcmp('mfcc',data{1}(1,:));

scat_obj=strcmp('scatT',data{2}(1,:));
mfcc_obj=strcmp('mfcc',data{2}(1,:));

emd=strcmp('emd',data{2}(7,:));
closest=strcmp('closest',data{2}(7,:));
average=strcmp('average',data{2}(7,:));

%% best p@9

ind_best_mfcc_ei=find( mfcc_ei & pak_ei(end,:)==max(pak_ei(end,mfcc_ei)));
ind_best_scat_ei=find( scat_ei & pak_ei(end,:)==max(pak_ei(end,scat_ei)));

best_mfcc_ei=data{1}(:,ind_best_mfcc_ei);
best_scat_ei=data{1}(:,ind_best_scat_ei);

ind_best_mfcc_emd=find(emd &  mfcc_obj & pak_obj(end,:)==max(pak_obj(end,emd & mfcc_obj)));
ind_best_mfcc_closest=find(closest & mfcc_obj & pak_obj(end,:)==max(pak_obj(end,closest & mfcc_obj)));
ind_best_mfcc_average=find(average & mfcc_obj & pak_obj(end,:)==max(pak_obj(end,average & mfcc_obj)));

ind_best_scat_emd=find( emd & scat_obj & pak_obj(end,:)==max(pak_obj(end,emd & scat_obj)));
ind_best_scat_closest=find(closest & scat_obj & pak_obj(end,:)==max(pak_obj(end,closest & scat_obj)));
ind_best_scat_average=find(average &  scat_obj & pak_obj(end,:)==max(pak_obj(end,average & scat_obj)));

best_mfcc_emd=data{2}(:,ind_best_mfcc_emd);
best_mfcc_closest=data{2}(:,ind_best_mfcc_closest);
best_mfcc_average=data{2}(:,ind_best_mfcc_average);

best_scat_emd=data{2}(:,ind_best_scat_emd);
best_scat_closest=data{2}(:,ind_best_scat_closest);
best_scat_average=data{2}(:,ind_best_scat_average);

%% get p@K

freq=strcmp('27,5_1000',data{1}(2,:));
mfcc40=strcmp('40',data{1}(3,:));
c0=strcmp('1',data{1}(4,:));

scat_log=strcmp('1',data{1}(5,:));
stand=strcmp('stand',data{1}(6,:));

gaussian=strcmp('gaussian_full',data{1}(7,:));
nn_10=strcmp('0.10',data{1}(8,:));

pak_ei_mfcc=pak_ei(:,mfcc_ei & gaussian & ~stand & mfcc40 & c0 & nn_10 & freq);
pak_ei_scat=pak_ei(:,scat_ei & gaussian & ~stand  & nn_10 & ~scat_log);
pak_ei_scat_log=pak_ei(:,scat_ei & gaussian & ~stand  & nn_10 & scat_log);

nn_10_obj=strcmp('0.1',data{2}(6,:));
stand_obj=strcmp('stand',data{2}(4,:));
gaussian_obj=strcmp('gaussian_full',data{2}(5,:));
log_obj=strcmp('1',data{2}(3,:));

nbc_8=strcmp(' 8',data{2}(2,:));
nbc_16=strcmp('16',data{2}(2,:));
nbc_32=strcmp('32',data{2}(2,:));

pak_emd_mfcc=pak_obj(:,mfcc_obj & nn_10_obj & ~stand_obj & gaussian_obj & emd & nbc_16);
pak_closest_mfcc=pak_obj(:,mfcc_obj & nn_10_obj & ~stand_obj & gaussian_obj & closest & nbc_8);
pak_average_mfcc=pak_obj(:,mfcc_obj & nn_10_obj & ~stand_obj & gaussian_obj & average & nbc_16);

pak_emd_scat=pak_obj(:,scat_obj & nn_10_obj & ~stand_obj & gaussian_obj & emd & nbc_16 & ~log_obj);
pak_closest_scat=pak_obj(:,scat_obj & nn_10_obj & ~stand_obj & gaussian_obj & closest & nbc_8 & ~log_obj);
pak_average_scat=pak_obj(:,scat_obj & nn_10_obj & ~stand_obj & gaussian_obj & average & nbc_16 & ~log_obj);

pak_emd_scat_log=pak_obj(:,scat_obj & nn_10_obj & ~stand_obj & gaussian_obj & emd & nbc_16 & log_obj);
pak_closest_scat_log=pak_obj(:,scat_obj & nn_10_obj & ~stand_obj & gaussian_obj & closest & nbc_8 & log_obj);
pak_average_scat_log=pak_obj(:,scat_obj & nn_10_obj & ~stand_obj & gaussian_obj & average & nbc_16 & log_obj);

%%
figure(1)
clf
plot(pak_ei_mfcc,'o--','markersize',markersize,'linewidth',linewidth)
hold on
plot(pak_emd_mfcc,'*--','markersize',markersize,'linewidth',linewidth)
plot(pak_closest_mfcc,'x--','markersize',markersize,'linewidth',linewidth)

plot(pak_ei_scat_log,'d-','markersize',markersize,'linewidth',linewidth)
plot(pak_emd_scat_log,'^-','markersize',markersize,'linewidth',linewidth)
plot(pak_closest_scat_log,'v-','markersize',markersize,'linewidth',linewidth)
hold off
legend({'ei, mfcc','ob-w, mfcc','ob-c, mfcc','ei, time-scattering','ob-w, time-scattering','ob-c, time-scattering'},'interpreter','none')
legend('boxoff')
xlabel('k')
ylabel('p@k')
box off
disp('')

figure(2)
clf
plot(pak_ei_scat,'o--','markersize',markersize,'linewidth',linewidth)
hold on
plot(pak_emd_scat,'*--','markersize',markersize,'linewidth',linewidth)
plot(pak_closest_scat,'x--','markersize',markersize,'linewidth',linewidth)
plot(pak_ei_scat_log,'d-','markersize',markersize,'linewidth',linewidth)
plot(pak_emd_scat_log,'^-','markersize',markersize,'linewidth',linewidth)
plot(pak_closest_scat_log,'v-','markersize',markersize,'linewidth',linewidth)
hold off
legend({'ei, w/o log','ob-w, w/o log','ob-c, w/o log','ei','ob-w','ob-c'},'interpreter','none')
legend('boxoff')
xlabel('k')
ylabel('p@k')
box off
disp('')

%% print
figOpt.fontsize=16;
figOpt.height=12;
figOpt.width=20;

printFigures([1 2],['~/papers/paperStructureScene16/paper/gfx/unsupervised_' dataset],figOpt)
