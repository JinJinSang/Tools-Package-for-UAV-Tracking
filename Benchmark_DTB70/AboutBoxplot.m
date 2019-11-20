% 绘制各属性分数组成的箱型图

function AboutBoxplot()
close all;
clear,clc;

addpath('./util');

saveFig = true; % true=保存绘图结果, false=不保存

paperTitle = 'ICRA19_LFL'; % 针对的会议或期刊名称和作者
typeSet = {'Precision', 'Success'};
evalTypeSet = {'OPE'}; % 'SRE', 'OPE'

fontSize = 15; % 图片中字体大小

dataPath = ['.\dataAnaly\', paperTitle, '\AboutAtt\'];

trackers=configTrackers;
num_tracker = length(trackers);

for count_trk = 1 : num_tracker
    tracker_name_set{count_trk} = trackers{count_trk}.namePaper;
end

figWidth = num_tracker*120;
figHeight = 500;
figSize = [0 0 figWidth figHeight];

for typeNum = 1:length(typeSet)
    matrix = [];
    plot_table = importdata([dataPath, typeSet{typeNum} '_att.mat']);
    for ii = 2:size(plot_table,1)
        rowLabels{ii-1} = plot_table{ii, 1};
        for jj = 2:(size(plot_table,2)-1) % -1是因为最后一列是overall的分数
            aa = plot_table{ii,jj};
            matrix(ii-1,jj-1) = str2double(aa); % 注意matrix里的元素是char类型，要变化下
            columnLabels{jj-1} = plot_table{1, jj};
        end
    end
    matrix = 100*matrix; % 转成百分号表示
    matrix_2 = matrix';
    figure;
    boxplot(matrix_2);
    set(gca,'xtick',1:num_tracker);
    set(gca,'FontSize',fontSize,'fontname','Times New Roman');
    ylabel(typeSet{typeNum},'fontsize',fontSize,'fontname','Times New Roman','fontweight','bold');
    xlabel('Trackers','fontsize',fontSize,'fontname','Times New Roman','fontweight','bold');
    set(gca, 'XTickLabel', tracker_name_set);
    set(gcf, 'position', figSize);
    tightfig;
    
    saveDir = [dataPath typeSet{typeNum} '_boxplot.pdf'];
    if saveFig == true
        print(gcf,'-dpdf',saveDir);
        fprintf('箱型图已生成，位置 %s\n', saveDir);
    end
end
rmpath('./util');