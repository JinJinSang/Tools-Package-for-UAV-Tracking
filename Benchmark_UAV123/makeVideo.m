% 写入图片帧生成视频的文件

close all;
clear,clc;

fps = 30; % 视频帧率，因为用的是UAV123@10fps数据集，所以选10
paperTitle = 'ICRA19_LFL'; % 针对的会议或期刊名称和作者
framesPath = ['.\dataAnaly\', paperTitle, '\videoImgs\']; % 图像序列所在路径
videosPath = ['.\dataAnaly\', paperTitle, '\videos\']; % 创建视频文件夹
if ~exist(videosPath, 'dir')
    mkdir(videosPath);
end
files_struct = dir(fullfile(framesPath));
files_struct(1:2) = []; % 删除.和..文件夹
num_seqs = length(files_struct);

fprintf('Total number of videos: %d\n', num_seqs);

t_video_make_st = clock;

parfor seq_count = 1 : num_seqs
    video_name = files_struct(seq_count).name;
    target_frames = dir([framesPath video_name '/*.png']); % 图片后缀是png
    start_frame = 1; % 开始帧
    end_frame = length(target_frames); % 结束帧
    video = [videosPath video_name '.avi']; % 即将制作的视频
    if exist(video, 'file') % 文件存在返回2
        delete(video); % 保证创建视频对象时开始时其为空
    end
    fprintf('Start making video %d: %s', seq_count, video_name);
    video_object = VideoWriter(video);  % 创建avi视频文件对象
    video_object.FrameRate = fps;
    open(video_object); % 打开文件等待写入
    for frame = start_frame : end_frame % 读入图片
        % fileName=sprintf('%04d',i); % 根据文件名而定
        file_name=num2str(frame);
        frames = imread([framesPath video_name '/' file_name,'.png']);
        writeVideo(video_object, frames); % 写入内容
    end
    close(video_object); % 关闭文件
    fprintf(' End!\n');
end
t_video_make_end = clock;
t_video_make = etime(t_video_make_end, t_video_make_st);
fprintf('End making videos, total time spent: %.2fs. All videos are in: %s\n', t_video_make, videosPath);
