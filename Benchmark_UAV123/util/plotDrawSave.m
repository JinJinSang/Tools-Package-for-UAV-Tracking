function plotDrawSave(numTrk,plotDrawStyle,aveSuccessRatePlot,idxSeqSet,rankNum,rankingType,rankIdx,nameTrkAll,thresholdSet,titleName,xLabelName,yLabelName,paperTitle,evalType)

% legend 用的是tex语法，也就是在 .\util\configTrackers.m
% 里对应tracker的namePaper可用tex语法，例如实现加粗效果 \bf{}
% 同时注意下划线需要转义符号\

legendLocAda = true; % true:legend的位置自适应; false:legend统一在右上角
showGrid = true; % true:图片有灰色网格线; false:没有网格线

for idxTrk=1:numTrk
    %each row is the sr plot of one sequence
    tmp=aveSuccessRatePlot(idxTrk, idxSeqSet,:);
    aa=reshape(tmp,[length(idxSeqSet),size(aveSuccessRatePlot,3)]);
    aa=aa(sum(aa,2)>eps,:);
    
    if idxSeqSet == 1 % 只画一个seq的结果
        bb = aa;
    else
        bb = mean(aa,1);
    end
    
    switch rankingType
        case 'AUC'
            perf(idxTrk) = mean(bb);
            saveScore = mean(bb);
            saveScore = sprintf('%.3f', saveScore);
        case 'threshold'
            perf(idxTrk) = bb(rankIdx);
            saveScore = bb(rankIdx);
            saveScore = sprintf('%.3f', saveScore);
    end
    rankingValues{1,idxTrk} = nameTrkAll{idxTrk}; % 获得跟踪器名称
    rankingValues{2,idxTrk} = saveScore; % 获得该跟踪器在某个att下对应rankingType的值
end

saveDir = ['.\dataAnaly\', paperTitle, '\data_', evalType, '\'];
if ~exist(saveDir, 'dir')
    mkdir(saveDir);
end
save([saveDir titleName], 'rankingValues'); % 保存该跟踪器名称及其在某个att下对应rankingType的值

[tmp, indexSort]=sort(perf,'descend');

i=1;
AUC=[];
bb_set = [];

fontSize = 20;
fontSizeLegend =14;
lineWidth = 4; % 画线的线粗

for idxTrk=indexSort(1:rankNum)

    tmp=aveSuccessRatePlot(idxTrk,idxSeqSet,:);
    aa=reshape(tmp,[length(idxSeqSet),size(aveSuccessRatePlot,3)]);
    aa=aa(sum(aa,2)>eps,:);
    
    if idxSeqSet == 1 % 只画一个seq的结果
        bb = aa;
    else
        bb = mean(aa,1);
    end
    
    switch rankingType
        case 'AUC'
            score = mean(bb);
            tmp = sprintf('%.3f', score);
        case 'threshold'
            score = bb(rankIdx);
            tmp = sprintf('%.3f', score);
    end
    
    bb_set = [bb_set; bb];
    tmpName{i} = [nameTrkAll{idxTrk} ' [' tmp ']'];
    h(i) = plot(thresholdSet,bb,'color',plotDrawStyle{i}.color, 'lineStyle', plotDrawStyle{i}.lineStyle,'lineWidth', lineWidth);
    hold on;
    % 最后再次覆盖画1遍，保证排名越高图层越高
    if i == rankNum
        for ii = rankNum:-1:1
           funcName = ['h(', num2str(ii), ') = plot(thresholdSet,bb_set(', num2str(ii), ',:),', '''color'',', 'plotDrawStyle{', num2str(ii), '}.color,', '''lineStyle'',', 'plotDrawStyle{', num2str(ii), '}.lineStyle,', '''lineWidth'',', num2str(lineWidth), ');'];
           eval(funcName);
        end
    end
    i=i+1;
end

if legendLocAda == true
    switch rankingType % 生成图时 legend 的位置在左下角（southwest）或右下角（southeast）
            case 'AUC'
            legend1 = legend(tmpName,'Interpreter', 'tex', 'fontsize', fontSizeLegend,'location', 'northeast');
            case 'threshold'
            legend1 = legend(tmpName,'Interpreter', 'tex', 'fontsize', fontSizeLegend,'location', 'southeast');
    end
else
    legend1=legend(tmpName,'Interpreter', 'tex','fontsize',fontSizeLegend);
end
set(legend1, 'Fontname', 'Times New Roman','FontWeight','normal'); % 设置legend字体

token = strfind(titleName,' - '); if ~isempty(token), subst = token(1)+3; else, subst = 1; end % yu
title(titleName(subst:end),'fontsize',fontSize,'fontname','Times New Roman','fontweight','bold'); % 图片标题
xlabel(xLabelName,'fontsize',fontSize,'fontname','Times New Roman','fontweight','bold'); % 横轴名称
ylabel(yLabelName,'fontsize',fontSize,'fontname','Times New Roman','fontweight','bold'); % 纵轴名称
set(gca,'FontName','Times New Roman','fontSize',fontSize,'fontweight','bold'); % 设置坐标轴值字体
set(gca,'YLim',[0 0.8]); 
if showGrid == true
    grid on;
end

% legend1=legend(tmpName(1:round(length(tmpName)/2)),'Interpreter', 'none','fontsize',fontSizeLegend,'Location','NorthWest');
% legend2=legend(tmpName(round(length(tmpName)/2)+1:end),'Interpreter', 'none','fontsize',fontSizeLegend,'Location','SouthEast');

%for too many
%plots--------------------------------------------------------------

% switch metricType
%     case 'error'
%         ah1 = gca;
%         %         legend1=legend(ah1,h(1:round(length(tmpName)/2)),tmpName(1:round(length(tmpName)/2)),'Interpreter', 'none','fontsize',fontSizeLegend,'Location','NorthWest');
%         legend1=legend(ah1,h(1:5),tmpName(1:5),'Interpreter', 'none','fontsize',fontSizeLegend,'Location','NorthWest');
%         
%         title(titleName,'fontsize',fontSize);
%         xlabel(xLabelName,'fontsize',fontSize);
%         ylabel(yLabelName,'fontsize',fontSize);
%         
%         ah2=axes('position',get(gca,'position'), 'visible','off');
%         legend2=legend(ah2,h(6:end),tmpName(6:end),'Interpreter', 'none','fontsize',fontSizeLegend,'Location','SouthEast');
%     case 'overlap'
%         ah1 = gca;
%         legend1=legend(ah1,h(1:5),tmpName(1:5),'Interpreter', 'none','fontsize',fontSizeLegend,'Location','NorthEast');
%         title(titleName,'fontsize',fontSize);
%         xlabel(xLabelName,'fontsize',fontSize);
%         ylabel(yLabelName,'fontsize',fontSize);
%         
%         ah2=axes('position',get(gca,'position'), 'visible','off');
%         legend2=legend(ah2,h(6:end),tmpName(6:end),'Interpreter', 'none','fontsize',fontSizeLegend,'Location','SouthWest');
% end

%     switch metricType
%         case 'error'
%             ah1 = gca;
%             %         legend1=legend(ah1,h(1:round(length(tmpName)/2)),tmpName(1:round(length(tmpName)/2)),'Interpreter', 'none','fontsize',fontSizeLegend,'Location','NorthWest');
% %             legend1=legend(ah1,h(1:round(length(tmpName)/2)),tmpName(1:round(length(tmpName)/2)),'Interpreter', 'none','fontsize',fontSizeLegend,'Position',[0.55 0.1 0.1 0.4]);
% 
%             legend1=legend(ah1,h,tmpName,'Interpreter', 'none','fontsize',fontSizeLegend,'Location','SouthEast');
%             title(titleName,'fontsize',fontSize);
%             xlabel(xLabelName,'fontsize',fontSize);
%             ylabel(yLabelName,'fontsize',fontSize);
% 
% %             ah2=axes('position',get(gca,'position'), 'visible','off');
% %             legend2=legend(ah2,h(round(length(tmpName)/2)+1:end),tmpName(round(length(tmpName)/2)+1:end),'Interpreter', 'none','fontsize',fontSizeLegend,'Location','SouthEast');
%         case 'overlap'
%             ah1 = gca;
% %             legend1=legend(ah1,h(1:round(length(tmpName)/2)),tmpName(1:round(length(tmpName)/2)),'Interpreter', 'none','fontsize',fontSizeLegend,'Location','NorthEast');
%             legend1=legend(ah1,h,tmpName,'Interpreter', 'none','fontsize',fontSizeLegend,'Location','SouthWest');
%             title(titleName,'fontsize',fontSize);
%             xlabel(xLabelName,'fontsize',fontSize);
%             ylabel(yLabelName,'fontsize',fontSize);
% 
% %             ah2=axes('position',get(gca,'position'), 'visible','off');
% %             legend2=legend(ah2,h(round(length(tmpName)/2)+1:end),tmpName(round(length(tmpName)/2)+1:end),'Interpreter', 'none','fontsize',fontSizeLegend,'Location','SouthWest');
%     end
%     
%     axes('fontsize',14);
%     set(legend1,'FontSize',fontSizeLegend);
%     set(legend2,'FontSize',fontSizeLegend);
%     set(legend1,'Interpreter','none',...
%     'Position',[0.800694444444435 0.117313517441224 0.0984375 0.521055753262159],...
%     'FontSize',fontSizeLegend);
% hold off

% saveas(gcf,figName,'png');

end