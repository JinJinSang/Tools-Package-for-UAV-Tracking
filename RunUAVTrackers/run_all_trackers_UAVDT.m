% DFQ 2019/11/20

function run_all_trackers_UAVDT(save_dir)                                        % 没有输入，则默认保存在当前文件下下的\all_trk_results\
%%  读取视频序列和groundtruth
where_is_your_groundtruth_folder = 'D:\BaiduNetdiskDownload\UAVDT\anno';         % 包含所有数据集groundtruth文件的路径
where_is_your_UAVDT_database_folder = 'D:\BaiduNetdiskDownload\UAVDT\data_seq'; % 包含所有数据集图片序列的路径
%UAVDT数据集的视频序列和groundtruth是分开的
%UAVDT数据集共50个视频序列，总共37084帧图像，平均序列长度为741.68帧
addpath('.\UAV_Basic_Framework\');

%% Read all video names using grouthtruth.txt
ground_truth_folder = where_is_your_groundtruth_folder;
dir_output = dir(fullfile(ground_truth_folder, '\*.txt'));             % 获取该文件夹下的所有的txt文件
contents = {dir_output.name}';
all_video_name = cell(numel(contents),1);
for k = 1:numel(contents)
    name = contents{k}(1:end-7);                                       % 去掉后缀 .txt
    all_video_name{k,1} = name;                                    % 保存所有数据集名称
end
dataset_num = length(all_video_name);                                  % 从groundtruth总文件数得到数据集总数
main_folder = pwd;                                                     % 获取当前路径
all_trackers_dir = '.\tracker_set\';                                   % 包含所有tracker的文件夹
if nargin < 1
    save_dir = [main_folder '\all_trk_results\UAVDT\'];              % 保存跑完的结果到指定文件夹
end
run_trackers_info = trackers_info();                                   % 获取运行tracker的函数信息，函数最好是run_xxx(seq, res_path, bSaveImage))这种形式
tracker_name_set=cell(length(run_trackers_info),1);
for t=1:length(run_trackers_info)
    tracker_name_set(t) = fieldnames(run_trackers_info{t});                      % 获取tracker_set的成员名
end
tracker_num = length(tracker_name_set);                                % 获取tracker_set里的总数
cd(all_trackers_dir);                                                  % 进入包含所有tracker的文件夹
%%
for tracker_count = 1: tracker_num
    tracker_name = tracker_name_set{tracker_count};
    addpath(genpath(tracker_name));                                    % 添加文件夹以及所有子文件夹的路径
    cd(tracker_name);                                                  % 进入指定tracker的文件夹
    save_res_dir = [save_dir, tracker_name,'\']; 
    save_pic_dir = [save_res_dir, 'res_picture\'];               
    if ~exist(save_res_dir, 'dir')
        mkdir(save_res_dir);
        mkdir(save_pic_dir);
    end
    for dataset_count=1:dataset_num
        video_name = all_video_name{dataset_count};           % 读取数据集名称
        database_folder = where_is_your_UAVDT_database_folder;
        seq = load_video_info_UAVDT(database_folder, ground_truth_folder, video_name); % 加载序列信息
        assignin('base','subS',seq);                                   % 将seq写入工作空间，命名为subS
       
        % main function
        run_tracker = getfield(run_trackers_info{tracker_count}, tracker_name_set{tracker_count}); %#ok<GFLD> % 获得run_xxx的函数句柄
        fprintf('run %s on %d %s ', tracker_name, dataset_count, video_name);
        result = run_tracker(seq);               % 执行该tracker的主函数
     
        % save results
        results = cell(1,1);                                           % results是包含一个结构体的元胞，结构体包括type,res,fps,len,annoBegin,startFrame六个成员
        results{1}=result;
        results{1}.len = seq.len;
        results{1}.annoBegin = seq.st_frame;
        results{1}.startFrame = seq.st_frame;
        fprintf('fps: %f\n', results{1}.fps);
        
        save([save_res_dir, video_name, '_', tracker_name]);
        % plot precision figure
        show_visualization =false;                                       % 显示图片（precision_plot）结果
        precision_plot_save(results{1}.res, seq.ground_truth, video_name, save_pic_dir, show_visualization);
        close all;
    end
    cd ..;                                                             % 回到包含所有tracker的文件夹中
    rmpath(genpath(tracker_name));                                     % 移除文件夹以及所有子文件夹的路径
end