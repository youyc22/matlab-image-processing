clear;
close all;
clc;

% 加载图像
image_path = 'resources/hall.mat';
load(image_path);

% 将图像转换为 double 类型并减去 128
initial = double(hall_gray) - 128;

% 定义 DCT 处理函数
dct_left_zero = @(block_struct) dct_left_zero_func(block_struct.data);
dct_right_zero = @(block_struct) dct_right_zero_func(block_struct.data);
% 使用 blockproc 处理图像
C0 = blockproc(initial, [8, 8], @(block_struct) dct2(block_struct.data));
C1 = blockproc(initial, [8, 8], dct_left_zero);
C2 = blockproc(initial, [8, 8], dct_right_zero);
% 反变换并加回 128
im0 = uint8(blockproc(C0, [8, 8], @(block_struct) idct2(block_struct.data)) + 128);
im1 = uint8(blockproc(C1, [8, 8], @(block_struct) idct2(block_struct.data)) + 128);
im2 = uint8(blockproc(C2, [8, 8], @(block_struct) idct2(block_struct.data)) + 128);
% 显示结果
figure;
subplot(2,2,1); imshow(hall_gray); title('原图');
subplot(2,2,2); imshow(im0); title('原图还原');
subplot(2,2,3); imshow(im1); title('左侧四列置零');
subplot(2,2,4); imshow(im2); title('右侧四列置零');

% 左侧四列置零
function out = dct_left_zero_func(block)
    dct_block = dct2(block);
    dct_block(:, 1:4) = 0;
    out = dct_block;
end

% 右侧四列置零
function out = dct_right_zero_func(block)
    dct_block = dct2(block);
    dct_block(:, 5:8) = 0;
    out = dct_block;
end