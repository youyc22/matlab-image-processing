clear;
close all;
clc;

load('all_v.mat');
image_in = imread('resources/web_group.bmp');
[height, width, ~] = size(image_in);

% % 输入图像顺时针旋转90度
% image_rotate_90 = imrotate(image_in, -90);

% v = v_L4;
% image_out = face_detect(image_rotate_90, v, 4, 0.595, 15, 15, 60, 60, 14, 13);
% figure;
% imshow(image_out);
% title('Face Detection Result for L = 4, Threshold = 0.599, Rotated 90 Degrees Clockwise');

% 输入图像高度不变，宽度拉伸为原来的2倍

% image_stretch = imresize(image_in, [height, width * 2]);
% v = v_L4;
% image_out = face_detect(image_stretch, v, 4, 0.610, 15, 15, 60, 60, 14, 13);
% figure;
% imshow(image_out);
% title('Face Detection Result for L = 4, Threshold = 0.599, Width Stretched 2 Times');

% % 改变输入图像的颜色（调亮和调暗）

% image_dark = image_in * 0.9;
% v = v_L4;
% image_out = face_detect(image_dark, v, 4, 0.612, 15, 15, 60, 60, 14, 13);
% figure;
% imshow(image_out);
% title('Face Detection Result for L = 4, Threshold = 0.599, Darkened');

image_bright = image_in * 1.08;
v = v_L4;
image_out = face_detect(image_bright, v, 4, 0.590, 15, 15, 60, 60, 14, 13);
figure;
imshow(image_out);
title('Face Detection Result for L = 4, Threshold = 0.599, Brightened');



