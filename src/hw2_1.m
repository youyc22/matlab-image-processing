
% 指定图像文件相对路径
image_path_1 = 'resources/JpegCoeff.mat';
image_path = 'resources/hall.mat';

% 加载图像
load(image_path);

test_hall=double(hall_gray(1:8,1:8));
test_hall_1=test_hall-128;

dct_1=dct2(test_hall_1);
dct_2=dct2(test_hall);

dct_2(1,1)=dct_2(1,1)-128*8;

disp((dct_2-dct_1));