
image_path = 'resources/hall.mat';

% 加载图像
load(image_path);

test_hall=double(hall_gray(1:8,1:8));

dct_my=my_dct2(test_hall);
dct_matlab=dct2(test_hall);

disp(dct_my-dct_matlab);