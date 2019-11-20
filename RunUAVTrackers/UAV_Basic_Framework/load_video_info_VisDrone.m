function seq = load_video_info_VisDrone(video_path, gt_path, video_name)

% \groundtruth.txt LASOT
% \groundtruth_rect.txt OTB DTB
% \<seq_name>.txt
ground_truth = dlmread([gt_path '\' video_name  '.txt']); % 
seq.ground_truth = ground_truth;        % 保存groundtruth
seq.init_rect = ground_truth(1,:);      % 初始化数据为groundtruth第一行，[x y w h]

target_sz = [ground_truth(1,4), ground_truth(1,3)];
seq.target_sz = target_sz;
seq.pos = [ground_truth(1,2), ground_truth(1,1)] + floor(target_sz/2);

seq.video_name = video_name;
seq.st_frame = 1;
seq.len = size(ground_truth, 1);
seq.en_frame = seq.st_frame + seq.len - 1;
seq.init_rect = ground_truth(1,:);

img_path = [video_path '\' video_name '\'];

img_files_struct = dir(fullfile(img_path, '*.jpg'));
% img_files = img_files(4:end);
img_files = {img_files_struct.name};

% img_files = [img_path img_files];
% if exist([img_path num2str(1, '%04i.png')], 'file'),
%     img_files = num2str((1:seq.len)', [img_path '%04i.png']);
% elseif exist([img_path num2str(1, '%04i.jpg')], 'file'),
%     img_files = num2str((1:seq.len)', [img_path '%04i.jpg']);
% elseif exist([img_path num2str(1, '%04i.bmp')], 'file'),
%     img_files = num2str((1:seq.len)', [img_path '%04i.bmp']);
% else
%     error('No image files to load.')
% end
seq.s_frames = img_files(1,:);
% seq.s_frames = cellstr(img_files_struct);
seq.video_path = img_path;

for i = 1 : length(seq.s_frames)
    seq.s_frames{i} = [img_path seq.s_frames{i}];         % 每一帧都具有完整的路径
end
end