clear;
close all;
clc;

load("resources\hall.mat");
load("resources\JpegCoeff.mat");

[height, width] = size(hall_gray);
initial = double(hall_gray) - 128;
w=width/8;
h=height/8;

dct_1 = blockproc(initial, [8, 8], @(block_struct) dct2(block_struct.data)./QTAB);

out_matrix = zeros(64, w*h);
for i = 1:h
    for j = 1:w
        out_matrix(:, (i-1)*w+j) = round(zig_zag(dct_1((i-1)*8+1:i*8, (j-1)*8+1:j*8),0));
    end
end

info_num = w * h ;
info_in = double(randi([0,1],info_num,1));
info_in = info_in * 2 - 1;

out_matrix_3 = out_matrix;
for i = 1:info_num
    not_zero = find(out_matrix_3(:,i));
    if not_zero(end) == 64
        out_matrix_3(64,i) = info_in(i);
    else
        out_matrix_3(not_zero(end)+1,i) = info_in(i);
    end
end

% out_matrix_bin = dec2bin(out_matrix);
% for i = 1:info_num
%     out_matrix_bin(i*4,8) = info_in(i);
% end

% out_matrix_2 = signed_bin2dec(out_matrix_bin);
% out_matrix_3 = reshape(out_matrix_2, 64 , w*h);

DC = out_matrix_3(1,:);
AC = out_matrix_3(2:end,:);

DC_diff = diff(DC);
DC_diff = [DC(1), -DC_diff];

%dc_encode
DC_output = [];
for i = 1: length(DC_diff)
    j = DC_diff(i);
    category = ceil(log2(abs(j)+1)) + 1;
    len = DCTAB(category, 1);
    huff = DCTAB(category,2:len+1);
    bin = double(dec2bin(abs(j)))-48;
    if j < 0
        bin = ~bin;
    end
    if j == 0
        bin_num = [];
    else
        bin_num = bin;
    end
    DC_output = [DC_output, huff, bin_num];
end

%ac_encode
AC_output = [];

for k = 1 : w*h
    AC_k=AC(:,k)';   
    AC_one=[];
    not_zero = find(AC_k);
    if(isempty(not_zero))
        AC_one = [1,0,1,0];
    else
        num_zero = [not_zero(1)-1, diff(not_zero)-1];
        for l = 1:length(num_zero)
            run = num_zero(l);
            if(run > 15)
                run = run - 16;
                AC_one = [AC_one, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1];
            end
            amplitude = AC_k(not_zero(l));
            size_ = ceil(log2(abs(amplitude)+1));
            idx = find(ACTAB(:,1)==run & ACTAB(:,2)==size_);
            len = ACTAB(idx,3);
            huff = ACTAB(idx,4:len+3);
            bin = double(dec2bin(abs(amplitude)))-48;
            if(amplitude < 0)
                bin = ~bin;
            end
            if amplitude == 0
                bin_num = [];
            else
                bin_num = bin;
            end
            AC_one = [AC_one, huff, bin_num];
        end
        AC_one = [AC_one, 1,0,1,0];
    end
    AC_output = [AC_output, AC_one];
end

com_ratio = width * height * 8 / (length(DC_output) + length(AC_output));
disp(com_ratio);

re_image = decode(DC_output, AC_output, width, height, QTAB, DCTAB, ACTAB);

MSE = sum(sum((double(hall_gray) - double(re_image)).^2)) / (width * height);
PSNR = 10 * log10(255^2 / MSE);
disp(PSNR);

subplot(1,2,1);
imshow(hall_gray);
title("原图");

subplot(1,2,2);
imshow(re_image);
title("方案三");