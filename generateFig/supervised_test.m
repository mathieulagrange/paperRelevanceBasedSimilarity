clear all
addpath(genpath('functions'))

%% settings

dataset='test';

linewidth=2;
markersize=10;
markerLeg={'diamond','o','*','x','^','v','+','diamond','o','*','x','^','v','+'};

%% load data

d=load(['~/projets/ass_features/report/figures/supervised_earlyInt_' dataset]);
[data{1},leg{1}]=parseTable(d.data.tables{3});

d=load(['~/projets/ass_clustering_features/report/figures/supervised_object2v_Late_' dataset]);
[data{2},leg{2}]=parseTable(d.data.tables{3});

d=load(['~/projets/ass_clustering_features/report/figures/supervised_object_' dataset]);
[data{3},leg{3}]=parseTable(d.data.tables{4});

acc_ei=str2double(data{1}(10:14,:));
m_acc_ei=mean(acc_ei,1);
std_acc_ei=std(acc_ei,[],1);

acc_li=str2double(data{2}(20:24,:));
m_acc_li=mean(acc_li,1);
std_acc_li=std(acc_li,[],1);

acc_obj=str2double(data{3}(9:13,:));
m_acc_obj=mean(acc_obj,1);
std_acc_obj=std(acc_obj,[],1);

acc_obj_1v=str2double(data{2}(8:12,:));
m_acc_obj_1v=mean(acc_obj_1v,1);

acc_obj_2v=str2double(data{2}(14:18,:));
m_acc_obj_2v=mean(acc_obj_2v,1);

scat_1=strcmp('scatT',data{1}(1,:));
mfcc_1=strcmp('mfcc',data{1}(1,:));
mfcc_rank_1=strcmp('40',data{1}(3,:));
mfcc_c0_1=strcmp('1',data{1}(4,:));
fr=strcmp('27,5_1000',data{1}(2,:));
stand_1=strcmp('stand',data{1}(6,:));
gaussian_1=strcmp('gaussian_full',data{1}(7,:));
inner_1=strcmp('inner_full',data{1}(7,:));
nn_10_1=strcmp('0.10',data{1}(8,:));
nn_40_1=strcmp('0.40',data{1}(8,:));
log_1=strcmp('1',data{1}(5,:));


scat_2=strcmp('scatT',data{2}(1,:));
mfcc_2=strcmp('mfcc',data{2}(1,:));
scat_log_2=strcmp('1',data{2}(3,:));
stand_2=strcmp('stand',data{2}(4,:));
inner_2=strcmp('inner_full',data{2}(5,:));
gaussian_2=strcmp('gaussian_full',data{2}(5,:));
nn_10_2=strcmp('0.1',data{2}(6,:));
nn_30_2=strcmp('0.3',data{2}(6,:));
nbc_8_2=strcmp(' 8',data{2}(2,:));
log_2=strcmp('1',data{2}(3,:));

scat_3=strcmp('scatT',data{3}(1,:));
mfcc_3=strcmp('mfcc',data{3}(1,:));
stand_3=strcmp('stand',data{3}(4,:));
emd=strcmp('emd',data{3}(7,:));
closest=strcmp('closest',data{3}(7,:));
average=strcmp('average',data{3}(7,:));
gaussian_3=strcmp('gaussian_full',data{3}(5,:));
nn_10_3=strcmp('0.1',data{3}(6,:));
nn_30_3=strcmp('0.3',data{3}(6,:));
nbc_8_3=strcmp(' 8',data{3}(2,:));
nbc_16_3=strcmp('16',data{3}(2,:));
nbc_32_3=strcmp('32',data{3}(2,:));
log_3=strcmp('1',data{3}(3,:));

%% best acc
leg2={'ei-mfcc-linear','ei-scat-linear','ei-scat-logComp-linear',...
    'ei-mfcc-rbf','ei-scat-rbf','ei-scat-logComp-rbf', ...
    'li-mfcc-linear','li-scat-linear','li-scat-logComp-linear',...
    'li-mfcc-rbf','li-scat-rbf','li-scat-logComp-rbf', ...
    'weighted-mfcc','closest-mfcc','average-mfcc', ...
    'weighted-scat','closest-scat','average-scat', ...
    'weighted-scat-logComp','closest-scat-logComp','average-scat-logComp'};

ind_fig1=[6 3 20 9 12];
ind_fig2=[1 4 15 7 10];

sel{1}= mfcc_rank_1 & mfcc_c0_1  & stand_1 & fr & mfcc_1 & inner_1;
sel{2}= ~log_1      & stand_1    & scat_1  & inner_1;
sel{3}= log_1       & stand_1    & scat_1  & inner_1;
sel{4}= mfcc_rank_1 & mfcc_c0_1  & stand_1 & fr & mfcc_1 & gaussian_1 & nn_10_1;
sel{5}= ~log_1      & stand_1    & scat_1  & gaussian_1 & nn_40_1;
sel{6}= log_1       & stand_1    & scat_1  & gaussian_1 & nn_40_1;

sel{7}=  mfcc_2 & stand_2  & inner_2    & nbc_8_2;
sel{8}=  scat_2 & stand_2  & inner_2    & nbc_8_2 & ~log_2;
sel{9}=  scat_2 & stand_2  & inner_2    & nbc_8_2 & log_2;
sel{10}= mfcc_2 & stand_2  & gaussian_2 & nbc_8_2 & nn_10_2;
sel{11}= scat_2 & stand_2  & gaussian_2 & nbc_8_2 & nn_10_2 & ~log_2;
sel{12}= scat_2 & stand_2  & gaussian_2 & nbc_8_2 & nn_10_2 & log_2;

sel{13}= emd     & mfcc_3 & stand_3  & nbc_16_3 & nn_10_3;
sel{14}= closest & mfcc_3 & stand_3  & nbc_16_3 & nn_10_3;
sel{15}= average & mfcc_3 & stand_3  & nbc_32_3 & nn_30_3;
sel{16}= emd     & scat_3 & stand_3  & nbc_16_3 & nn_10_3 & ~log_3;
sel{17}= closest & scat_3 & stand_3  & nbc_32_3 & nn_10_3 & ~log_3;
sel{18}= average & scat_3 & stand_3  & nbc_8_3  & nn_30_3 & ~log_3;
sel{19}= emd     & scat_3 & stand_3  & nbc_16_3 & nn_10_3 & log_3;
sel{20}= closest & scat_3 & stand_3  & nbc_32_3 & nn_10_3 & log_3;
sel{21}= average & scat_3 & stand_3  & nbc_8_3  & nn_30_3 & log_3;

acc_f=[];

for jj=1:length(leg2)
    if ~isempty(strfind(leg2{jj},'ei'))
        disp([leg2{jj} ' : acc=' num2str(m_acc_ei(sel{jj})) ', std=' num2str(std_acc_ei(sel{jj}))])
        acc_f=[acc_f acc_ei(:,sel{jj})];
    elseif ~isempty(strfind(leg2{jj},'li'))
        disp([leg2{jj} ' : acc=' num2str(m_acc_li(sel{jj})) ', std=' num2str(std_acc_li(sel{jj}))])
        acc_f=[acc_f acc_li(:,sel{jj})];        
    else
        disp([leg2{jj} ' : acc=' num2str(m_acc_obj(sel{jj})) ', std=' num2str(std_acc_obj(sel{jj}))])
        acc_f=[acc_f acc_obj(:,sel{jj})];        
    end
    
end

figure(1)
clf
hold on
for jj=1:size(acc_f,1)
    plot(acc_f(jj,ind_fig1),'marker',markerLeg{jj},'markersize',markersize,'linewidth',linewidth)
end
hold off
set(gca,'xtick',1:length(ind_fig1),'xticklabel',leg2(ind_fig1),'xticklabelrotation',45)
legend('f1','f2','f3','f4','f5','orientation','horizontal','location','north')
legend boxoff
xlim([0.8 length(ind_fig1)+.2])
ylim([0.2 1])
disp('')

figure(2)
clf
hold on
for jj=1:size(acc_f,1)
    plot(acc_f(jj,ind_fig2),'marker',markerLeg{jj},'markersize',markersize,'linewidth',linewidth)
end
hold off
set(gca,'xtick',1:length(ind_fig2),'xticklabel',leg2(ind_fig2),'xticklabelrotation',45)
legend('f1','f2','f3','f4','f5','orientation','horizontal','location','north')
legend boxoff
xlim([0.8 length(ind_fig2)+.2])
ylim([0.2 1])
disp('')

%% print
figOpt.fontsize=16;
figOpt.height=15;
figOpt.width=20;

printFigures(1,['~/papers/paperStructureScene16/paper/gfx/supervised_linear_' dataset],figOpt)
printFigures(2,['~/papers/paperStructureScene16/paper/gfx/supervised_rbf_' dataset],figOpt)