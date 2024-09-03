clear;
close all;
clc;

load ("resources\hall.mat");
load ("resources\JpegCoeff.mat");
[height, width] = size(hall_gray);inf

info_size = width * height ;


    % info = dec2bin(randi([0, 1], info_size, 1));
    info = dec2bin(ones(info_size, 1));
    hall_bin = dec2bin(hall_gray);
    hall_bin(:,8)=info;
    hall_image = bin2dec(hall_bin);
    hall_image_1 = reshape(hall_image, height, width);

    [DC_output, AC_output, width, height] = encode(hall_image_1, QTAB, DCTAB, ACTAB);
    hall_image_2 = decode(DC_output, AC_output, width, height, QTAB, DCTAB, ACTAB);

    hall_bin_2 = dec2bin(hall_image_2);
    info_2 = hall_bin_2(:,8);
    accuracy = sum(info == info_2) / info_size;
    disp(accuracy);
