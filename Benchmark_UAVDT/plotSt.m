close all
clear
clc

plotDrawStyle = {struct('color',[1,0,0],'lineStyle','p'),...
    struct('color',[0,1,0],'lineStyle','h'),...
    struct('color',[0,0,1],'lineStyle','x'),...
    struct('color',[0,0,0],'lineStyle','s'),...
    struct('color',[1,0,1],'lineStyle','v'),...
    struct('color',[0,1,1],'lineStyle','*'),...
    struct('color',[0.5,0.5,0.5],'lineStyle','d'),...
    struct('color',[136,0,21]/255,'lineStyle','o'),...
    struct('color',[255,127,39]/255,'lineStyle','^'),...
    struct('color',[0,162,232]/255,'lineStyle','+'),...
    struct('color',[163,73,164]/255,'lineStyle','>'),...
    struct('color',[12,73,123]/255,'lineStyle','<'),...
    struct('color',[12,73,255]/255,'lineStyle','<'),...
    struct('color',[0.1,0.6,0.2],'lineStyle','d'),...
    struct('color',[234,0,12]/255,'lineStyle','o'),...
    struct('color',[128,60,39]/255,'lineStyle','^'),...
    struct('color',[0,135,122]/255,'lineStyle','+'),...
    struct('color',[34,73,255]/255,'lineStyle','>'),...
    struct('color',[12,73,10]/255,'lineStyle','<'),...
    struct('color',[0.1,0.86,0.4],'lineStyle','h'),...
    struct('color',[0.5,0,1],'lineStyle','x'),...
    struct('color',[0.1,0.32,1],'lineStyle','o'),...
    struct('color',[11, 132, 87]/255,'lineStyle','>'),...
    struct('color',[97, 111, 57]/255,'lineStyle','<'),...
    struct('color',[86, 13, 13]/255,'lineStyle','^'),...
    struct('color',[255, 98, 165]/255,'lineStyle','x'),...
    struct('color',[0, 183, 168]/255,'lineStyle','.'),...
    struct('color',[190, 151, 220]/255,'lineStyle','s'),...
    struct('color',[167,209,41]/255,'lineStyle','d'),...
    struct('color',[50,219,198]/255,'lineStyle','h'),...
    struct('color',[215,215,0]/255,'lineStyle','+'),...
    };
    
y = [0.701
0.700
0.700
0.683
0.680
0.677
0.675
0.671
0.667
0.660
0.656
0.656
0.649
0.603
0.602
0.596
];

x = [46.7
16.38
20.40
7.55
41.05
32.48
26.56
8.60
6.61
0.67
1.10
3.24
4.34
3.39
20.15
9.02
];

TrkSet = {'AMCF'   % 0.710 0.503
'ECO'               % 0.684 0.492 
'ASRCF'
'ADNet'
'CFNet'             % 0.675 0.478
'TADT'           % 0.663 0.467
'PTAV'            % 0.627 0.457
'MCCT'              % 0.625 0.439
'DeepSTRCF'              % 0.625 0.439
'MCPF'               % 0.601 0.425
'CCOT'              % 0.598 0.385
'FCNT'
'CREST'
'IBCCF'
'CF2'
'HDT'
};

FPSSet = { 'Ours' 
'CVPR2017'
'CVPR2019'
'CVPR2017'
'CVPR2017'
'CVPR2019'
'ICCV2017'
'CVPR2018'
'CVPR2018'
'CVPR2017'
'ECCV2016'
'ICCV2015'
'ICCV2017'
'ICCV2017'
'ICCV2015'
'CVPR2016'
% 'CVPR2018'
% 'CVPR2017'
% 'ICCV2017'
% 'ICCV2015'
% 'ECCV2014'
% 'CVPR2017'
% 'CVPR2018'
% 'CVPR2016'
% 'ICCV2015'
% 'ICCV2017'
% 'CVPR2016'
% 'CVPR2017'
% 'AAAI2018'
% 'ICCV2015'
% 'TPAMI2016'
% 'ECCVwc2014'
% 'CVPR2017'
% 'BMVC2014'
% 'TPAMI2012'
% 'TPAMI2015'
% 'TPAMI2015'
% 'ECCV2012'
% 'CVPR2012'
% 'PR2013'
% 'IJCV2008'
% 'CVPR2009'
};
    
FontSize = 20;
figure;
for ii = 1:length(x)
%     plot(x(ii),y(ii),'color',plotDrawStyle{ii}.color, 'Marker', plotDrawStyle{ii}.lineStyle, 'MarkerSize',12, 'LineWidth',2);
%     scatter(x(ii),y(ii), plotDrawStyle{ii}.color, 'Marker', plotDrawStyle{ii}.lineStyle, 'MarkerSize',12, 'LineWidth',2);
    scatter(x(ii),y(ii),300,plotDrawStyle{ii}.color,plotDrawStyle{ii}.lineStyle, 'LineWidth', 2.5);
     
%     for i = 1 : str_len
%         printf("%c", str[i]);  
%         printf("\n");
%         i = i + 1;
%     end
    
    tmpName{ii} = [TrkSet{ii}, ' (' FPSSet{ii} ')' ];
%     tmpName{ii} = sprintf('%.*s\n', 20 ,[TrkSet{ii}, ' (' FPSSet{ii} ')' ]);
    
    hold on;
end

legend1=legend(tmpName,'Interpreter', 'none','fontsize',15, 'location', 'southeastoutside');
% legend('boxoff')
set(legend1, 'Fontname', 'Times New Roman','FontWeight','normal');
axis([0 50 0.59 0.72]); 
xlabel('Speed','Fontname', 'Times New Roman','FontSize',FontSize,'fontweight','bold');
ylabel('Precision','Fontname', 'Times New Roman','FontSize',FontSize,'fontweight','bold');
set(gca,'FontSize',FontSize,'fontweight','bold'); % 改变坐标刻度大小
set(gca,'Fontname','Times New Roman'); 
set(gcf, 'position', [0 0 2200 480]);
grid on; box on;
tightfig;

print(gcf,'-dpdf','CompScat.pdf');