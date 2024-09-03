clear;
close all;
clc;

image_path = 'resources/hall.mat';
jpeg_path = 'resources/JpegCoeff.mat';

load(image_path);
load(jpeg_path);

initial = double(hall_gray) - 128;
[height, width] = size(initial);
w=width/8;
h=height/8;
dct_1 = blockproc(initial, [8, 8], @(block_struct) dct2(block_struct.data)./QTAB);
out_matrix = zeros(64, w*h);
for i = 1:h
    for j = 1:w
        out_matrix(:, (i-1)*w+j) = round(zig_zag(dct_1((i-1)*8+1:i*8, (j-1)*8+1:j*8),0));
    end
end
% disp(out_matrix);

writematrix(out_matrix, 'hw2_8.csv');
