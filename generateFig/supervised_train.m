clear all
addpath(genpath('functions'))

%% settings

dataset='train'; 
linewidth=2;
markersize=10;

%% load data

d=load(['~/projets/ass_features/report/figures/supervised_earlyInt_' dataset]);
[data{1},leg{1}]=parseTable(d.data.tables{1});

d=load(['~/projets/ass_clustering_features/report/figures/supervised_object2v_Late_' dataset]);
[data{2},leg{2}]=parseTable(d.data.tables{1});

d=load(['~/projets/ass_clustering_features/report/figures/supervised_object_' dataset]);
[data{3},leg{3}]=parseTable(d.data.tables{2});

acc_ei=str2double(data{1}(10:14,:));
m_acc_ei=mean(acc_ei,1);

acc_li=str2double(data{2}(20:24,:));
m_acc_li=mean(acc_li,1);

acc_obj=str2double(data{3}(9:13,:));
m_acc_obj=mean(acc_obj,1);

acc_obj_1v=str2double(data{2}(8:12,:));
m_acc_obj_1v=mean(acc_obj_1v,1);

acc_obj_2v=str2double(data{2}(14:18,:));
m_acc_obj_2v=mean(acc_obj_2v,1);

scat_1=strcmp('scatT',data{1}(1,:));
mfcc_1=strcmp('mfcc',data{1}(1,:));
fr=strcmp('27,5_1000',data{1}(2,:));
stand_1=strcmp('stand',data{1}(6,:));
gaussian_1=strcmp('gaussian_full',data{1}(7,:));
inner_1=strcmp('inner_full',data{1}(7,:));
scat_log_1=strcmp('1',data{1}(5,:));

scat_2=strcmp('scatT',data{2}(1,:));
mfcc_2=strcmp('mfcc',data{2}(1,:));
scat_log_2=strcmp('1',data{2}(3,:));
stand_2=strcmp('stand',data{2}(4,:));
inner_2=strcmp('inner_full',data{2}(5,:));
gaussian_2=strcmp('gaussian_full',data{2}(5,:));

scat_3=strcmp('scatT',data{3}(1,:));
mfcc_3=strcmp('mfcc',data{3}(1,:));
stand_3=strcmp('stand',data{3}(4,:));
emd=strcmp('emd',data{3}(7,:));
closest=strcmp('closest',data{3}(7,:));
average=strcmp('average',data{3}(7,:));
gaussian_3=strcmp('gaussian_full',data{3}(5,:));

%% best acc

ind_best_mfcc_inner_ei   =find(stand_1 & inner_1    & mfcc_1 & fr  & m_acc_ei==max(m_acc_ei(stand_1 & inner_1    & mfcc_1 & fr)));
ind_best_mfcc_gaussian_ei=find(stand_1 & gaussian_1 & mfcc_1 & fr  & m_acc_ei==max(m_acc_ei(stand_1 & gaussian_1 & mfcc_1 & fr)));
ind_best_scat_inner_ei   =find(stand_1 & inner_1    & scat_1       & m_acc_ei==max(m_acc_ei(stand_1 & inner_1    & scat_1)));
ind_best_scat_gaussian_ei=find(stand_1 & gaussian_1 & scat_1       & m_acc_ei==max(m_acc_ei(stand_1 & gaussian_1 & scat_1)));

ind_best_mfcc_inner_li   =find(stand_2 & inner_2    & mfcc_2 & m_acc_li==max(m_acc_li(stand_2 & inner_2    & mfcc_2 )));
ind_best_mfcc_gaussian_li=find(stand_2 & gaussian_2 & mfcc_2 & m_acc_li==max(m_acc_li(stand_2 & gaussian_2 & mfcc_2 )));
ind_best_scat_inner_li   =find(stand_2 & inner_2    & scat_2 & m_acc_li==max(m_acc_li(stand_2 & inner_2    & scat_2 )));
ind_best_scat_gaussian_li=find(stand_2 & gaussian_2 & scat_2 & m_acc_li==max(m_acc_li(stand_2 & gaussian_2 & scat_2 )));

ind_best_mfcc_emd    =find(emd     & stand_3 & gaussian_3 & mfcc_3 & m_acc_obj==max(m_acc_obj(emd     & stand_3 & gaussian_3 & mfcc_3 )));
ind_best_mfcc_closest=find(closest & stand_3 & gaussian_3 & mfcc_3 & m_acc_obj==max(m_acc_obj(closest & stand_3 & gaussian_3 & mfcc_3 )));
ind_best_mfcc_average=find(average & stand_3 & gaussian_3 & mfcc_3 & m_acc_obj==max(m_acc_obj(average & stand_3 & gaussian_3 & mfcc_3 )));
ind_best_scat_emd    =find(emd     & stand_3 & gaussian_3 & scat_3 & m_acc_obj==max(m_acc_obj(emd     & stand_3 & gaussian_3 & scat_3 )));
ind_best_scat_closest=find(closest & stand_3 & gaussian_3 & scat_3 & m_acc_obj==max(m_acc_obj(closest & stand_3 & gaussian_3 & scat_3 )));
ind_best_scat_average=find(average & stand_3 & gaussian_3 & scat_3 & m_acc_obj==max(m_acc_obj(average & stand_3 & gaussian_3 & scat_3 )));

best_setting_mfcc_inner_ei   =data{1}(:,ind_best_mfcc_inner_ei);
best_setting_mfcc_gaussian_ei=data{1}(:,ind_best_mfcc_gaussian_ei);
best_setting_scat_inner_ei   =data{1}(:,ind_best_scat_inner_ei);
best_setting_scat_gaussian_ei=data{1}(:,ind_best_scat_gaussian_ei);

best_setting_mfcc_inner_li   =data{2}(:,ind_best_mfcc_inner_li);
best_setting_mfcc_gaussian_li=data{2}(:,ind_best_mfcc_gaussian_li);
best_setting_scat_inner_li   =data{2}(:,ind_best_scat_inner_li);
best_setting_scat_gaussian_li=data{2}(:,ind_best_scat_gaussian_li);

best_setting_mfcc_emd     =data{3}(:,ind_best_mfcc_emd);
best_setting_mfcc_closest =data{3}(:,ind_best_mfcc_closest);
best_setting_mfcc_average =data{3}(:,ind_best_mfcc_average);
best_setting_scat_emd     =data{3}(:,ind_best_scat_emd);
best_setting_scat_closest =data{3}(:,ind_best_scat_closest);
best_setting_scat_average =data{3}(:,ind_best_scat_average);

disp('')