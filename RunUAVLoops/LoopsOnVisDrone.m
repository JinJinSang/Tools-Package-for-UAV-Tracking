 % DFQ  2019/11/20

 function LoopsOnVisDrone(save_dir)                                        % 没有输入，则默认保存在当前文件下下的\all_trk_results\
%%  读取视频序列和groundtruth
where_is_your_groundtruth_folder = 'D:\BaiduNetdiskDownload\VisDrone-test-dev\annotations';         % 包含所有数据集groundtruth文件的路径
where_is_your_VisDrone_database_folder = 'D:\BaiduNetdiskDownload\VisDrone-test-dev\sequences'; % 包含所有数据集图片序列的路径
%VisDrone数据集的视频序列和groundtruth是分开的
%此处仅跑VisDrone2018-SOT-test-dev (共35个sequences)
%VisDrone数据集共35个视频序列，总共29365帧，平均序列长度为839帧
addpath('.\UAV_Basic_Framework\');
run_trackers_info = struct('AutoTrack',@run_AutoTrack);           %需要调参的tracker

%% Read all video names using grouthtruth.txt
ground_truth_folder = where_is_your_groundtruth_folder;
dir_output = dir(fullfile(ground_truth_folder, '\*.txt'));             % 获取该文件夹下的所有的txt文件
contents = {dir_output.name}';  
all_video_name = cell(numel(contents),1);
for k = 1:numel(contents)
    name = contents{k}(1:end-4);                                       % 去掉后缀 .txt
    all_video_name{k,1} = name;                                    % 保存所有数据集名称
end
dataset_num = length(all_video_name);                                  % 从groundtruth总文件数得到数据集总数
main_folder = pwd;                                                     % 获取当前路径
all_trackers_dir = '.\tracker_set\';                                   % 包含所有tracker的文件夹
tracker_name = fieldnames(run_trackers_info);                      % 获取tracker_set的成员名
tracker_name=tracker_name{1};
cd(all_trackers_dir);                                                  % 进入包含所有tracker的文件夹
addpath(genpath(tracker_name));                                    % 添加文件夹以及所有子文件夹的路径
cd(tracker_name);         
if nargin < 1
    save_dir = [main_folder '\loop_results\VisDrone\'];              % 保存跑完的结果到指定文件夹
end
%%
% 需要调的参数系列值以及参数名(手动输入)
set1=[1 2 3 4 5];    name1='p1';
set2=[1 2 3 4 5];    name2='p2';
set3=[1 2 3 4 5];    name3='p3';
set4=[1 2 3 4 5];    name4='p4';

% 需要跑的轮数
num_loops=length(set1)*length(set2)*length(set3)*length(set4);

% 遍历所有sequences
for dataset_count =1:dataset_num
    video_name = all_video_name{dataset_count};                    % 读取数据集名称
    database_folder = where_is_your_VisDrone_database_folder;
    seq = load_video_info_VisDrone(database_folder, ground_truth_folder, video_name); % 加载序列信息
    assignin('base','subS',seq);                                   % 将seq写入工作空间，命名为subS
    
    % main function
     run_tracker = getfield(run_trackers_info, tracker_name); %#ok<GFLD> % 获得run_xxx的函数句柄

    for i=1:length(set1)
        for j=1:length(set2)
            for m=1:length(set3)
                for n=1:length(set4)
                    param1=set1(i);
                    param2=set2(j);
                    param3=set3(m);
                    param4=set4(n);
                    index=(i-1)*length(set2)*length(set3)*length(set4)+(j-1)*length(set3)*length(set4)+(m-1)*length(set4)+n;
                    save_res_dir = [save_dir, tracker_name,num2str(param1),'_',num2str(param2),'_',num2str(param3),'_',num2str(param4),'\']; 
                    if ~exist(save_res_dir, 'dir')
                    mkdir(save_res_dir);
                    end
                    fprintf('%s Loop on %d %s\nindex:%d/%d     ', tracker_name, dataset_count, video_name,index,num_loops);
                    result = run_tracker(seq,param1,param2,param3,param4);               % 执行该tracker的主函数, 注意修改需要遍历的tracker的接口的输入参数
                    % save results
                    results = cell(1,1);                                           % results是包含一个结构体的元胞，结构体包括type,res,fps,len,annoBegin,startFrame六个成员
                    results{1}=result;
                    results{1}.len = seq.len;
                    results{1}.annoBegin = seq.st_frame;    
                    results{1}.startFrame = seq.st_frame;
                    fprintf('fps: %f\n', results{1}.fps);
                    
                     save([save_res_dir, video_name, '_', tracker_name,num2str(param1),'_',num2str(param2),'_',num2str(param3),'_',num2str(param4)]);
                    % plot precision figure
%                     show_visualization =false;                                       % 显示图片（precision_plot）结果
%                     precision_plot_save(results{1}.res, seq.ground_truth, video_name, save_pic_dir, show_visualization);
%                     close all;
                end
            end
        end
    end
end
   
        