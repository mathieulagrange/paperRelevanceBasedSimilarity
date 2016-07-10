clear all
addpath(genpath('functions'))

%% settings

dataset='train'; 
dataPath={['~/projets/ass_features/report/figures/supervised_earlyInt_' dataset]};

linewidth=2;
markersize=10;

%% load data

data=cell(1,length(dataPath));
leg=cell(1,length(dataPath));

for jj=1:length(dataPath)
    d=load(dataPath{jj});
    [data{jj},leg{jj}]=parseTable(d.data(1).tables{end});
end

acc=str2double(data{1}(10:14,:));
m_acc=mean(acc,1);

scat=strcmp('scatT',data{1}(1,:));
mfcc=strcmp('mfcc',data{1}(1,:));
fr=strcmp('27,5_1000',data{1}(2,:));
stand=strcmp('stand',data{1}(6,:));
gaussian=strcmp('gaussian_full',data{1}(7,:));
inner=strcmp('inner_full',data{1}(7,:));
scat_log=strcmp('1',data{1}(5,:));

%% best acc

ind_best_mfcc_inner=find(stand & inner & mfcc & fr  & m_acc==max(m_acc(stand & inner & mfcc & fr)));
ind_best_gaussian=find(stand & gaussian & mfcc & fr  & m_acc==max(m_acc(stand & gaussian & mfcc & fr)));
ind_best_scat_inner=find(stand & inner & scat & m_acc==max(m_acc(stand & inner & scat)));
ind_best_scat_gaussian=find(stand & gaussian & scat & m_acc==max(m_acc(stand & gaussian & scat)));

best_setting_mfcc_inner=data{1}(:,ind_best_mfcc_inner);
best_setting_mfcc_gaussian=data{1}(:,ind_best_gaussian);
best_setting_scat_inner=data{1}(:,ind_best_scat_inner);
best_setting_scat_gaussian=data{1}(:,ind_best_scat_gaussian);
disp('')