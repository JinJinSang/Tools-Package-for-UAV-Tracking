function seq = load_video_info_DTB70(video_path)

% \groundtruth.txt DTB70
ground_truth = dlmread([video_path '\groundtruth_rect.txt']); 
seq.ground_truth = ground_truth;        % 保存groundtruth
seq.init_rect = ground_truth(1,:);      % 初始化数据为groundtruth第一行，[x y w h]
target_sz = [ground_truth(1,4), ground_truth(1,3)];
seq.target_sz = target_sz;
seq.pos = [ground_truth(1,2), ground_truth(1,1)] + floor(target_sz/2);
seq.st_frame = 1;
seq.len = size(ground_truth, 1);
seq.en_frame = seq.st_frame + seq.len - 1;
seq.init_rect = ground_truth(1,:);
img_path = [video_path '\img\'];
img_files_struct = dir(fullfile(img_path, '*.jpg'));
img_files = {img_files_struct.name};
seq.name = video_path(24:end-5);
seq.s_frames = img_files(1,:);
seq.video_path = img_path;
for i = 1 : length(seq.s_frames)
    seq.s_frames{i} = [img_path seq.s_frames{i}];         % 每一帧都具有完整的路径
end
end