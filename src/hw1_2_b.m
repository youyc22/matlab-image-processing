% 指定图像文件相对路径
image_path = 'resources/hall.mat';

% 加载图像
load(image_path);

% 获取图像尺寸
[height, width, ~] = size(hall_color);

% 计算每个棋盘格的大小
grid_height = ceil(height / 8);
grid_width = ceil(width / 8);
% 创建8x8的棋盘格模板
[X, Y] = meshgrid(1:width, 1:height);
big_chessboard = mod(floor(X/grid_width) + floor(Y/grid_height), 2);
chess_image = hall_color;
for c = 1:3
    channel = chess_image(:,:,c);
    channel(big_chessboard == 0) = 0;
    chess_image(:,:,c) = channel;
end

% 显示原图
figure;
subplot(1,2,1);
imshow(hall_color, 'InitialMagnification', 'fit');
title('原图');

% 显示棋盘格效果图
subplot(1,2,2);
imshow(chess_image, 'InitialMagnification', 'fit');
title('8x8棋盘格效果');

