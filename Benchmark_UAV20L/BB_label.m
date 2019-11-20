% 绘制视频中bounding box的label，避免耗时匹配，提高二次加工效率，注意如下：
% - 需要和 .\util\configTrackers 配合实现
% - 保存选项为 saveFig

clear;
close all;
warning off all;

paperTitle = 'ECCV2020'; % 针对的会议或期刊名称和负责人
saveFig = true; % true=保存绘图结果, false=不保存

BBlabel_path = ['.\dataAnaly\', paperTitle, '\'];
if ~exist(BBlabel_path, 'dir')
    mkdir(BBlabel_path);
end
addpath('./util');

trks = configTrackers;
plotSetting;
LineWidth = 2;
plotDrawStyle = plotSetting;
location = length(trks); % 自己的tracker放在configTrackers里的最后，画图时才会位于最上图层
plotDrawStyle(:,[location,1]) = plotDrawStyle(:,[1,location]); % 所以把红色标注放到第location个

len=25;
x=0;
y=0.05;
k=1;
ResutlBB_label = figure;

% for i = 1 : length(trks)
for i = length(trks) : -1 : 1
    hold on
    set(gca,'fontname', 'Times New Roman','FontSize',16);
    LineStyle = plotDrawStyle{i}.lineStyle;
    Color = plotDrawStyle{i}.color;
    plot([x,x+len],[y,y],'linestyle',LineStyle,'color',Color,'linewidth',LineWidth);
    tracker_name = trks{i}.namePaper;
    text(x+len+2,y-0.,tracker_name,'fontname', 'Times New Roman','FontSize',10,'Interpreter','tex');
    x=x+100;
    k=k+1;
    if mod(k,6)==0
        k=k-5;
        y=y-0.1;
        x=0;
    end
    if length(trks) == 1
       set(gca, 'XLim',[0 x+len]);
    end
end
axis off
tightfig;

if saveFig == true
    saveDir = [BBlabel_path, 'BBlabel.pdf'];
    print(gcf,'-dpdf',saveDir);
    fprintf('已生成视频中边框的标签，位置 %s\n', saveDir);
end

rmpath('./util');