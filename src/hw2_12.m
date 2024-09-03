clear;
close all;
clc;

load('resources/hall.mat');
load('resources/JpegCoeff.mat');

QTAB = QTAB / 2;
[DC_output, AC_output, width, height] = encode(hall_gray, QTAB, DCTAB, ACTAB);
com_ratio = width * height * 8 / (length(DC_output) + length(AC_output));
disp(com_ratio);
re_image = decode(DC_output, AC_output, width, height, QTAB, DCTAB, ACTAB);

subplot(1,2,1);
imshow(hall_gray);
title('原图');

subplot(1,2,2);
imshow(re_image);
title('解码图像');

MSE = sum(sum((double(hall_gray) - double(re_image)).^2)) / (width * height);
PSNR = 10 * log10(255^2 / MSE);
disp(PSNR);