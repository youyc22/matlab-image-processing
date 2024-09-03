clear;
close all;
clc;

% 加载图像
image_path = 'resources/hall.mat';
load(image_path);

% 将图像转换为 double 类型并减去 128
initial = double(hall_gray) - 128;

hall_T = blockproc(initial, [8, 8], @(block_struct) (dct2(block_struct.data))');
hall_90 = blockproc(initial, [8, 8], @(block_struct) (rot90(dct2(block_struct.data), 1)));
hall_180 = blockproc(initial, [8, 8], @(block_struct) (rot90(dct2(block_struct.data), 2)));

hall_1 = uint8(blockproc(hall_T, [8, 8], @(block_struct) idct2(block_struct.data)) + 128);
hall_2 = uint8(blockproc(hall_90, [8, 8], @(block_struct) idct2(block_struct.data)) + 128);
hall_3 = uint8(blockproc(hall_180, [8, 8], @(block_struct) idct2(block_struct.data)) + 128);

subplot(2,2,1);
imshow(hall_gray);
title('原图');

subplot(2,2,2);
imshow(hall_1);
title('原图转置');

subplot(2,2,3);
imshow(hall_2);
title('原图旋转90度');

subplot(2,2,4);
imshow(hall_3);
title('原图旋转180度');
