% 指定图像文件相对路径
image_path = 'resources/hall.mat';

% 加载图像
load(image_path);

% 显示图像
figure;
imshow(hall_color,'InitialMagnification','fit');

% 获取图像尺寸
[height,width,~] = size(hall_color);

% 计算圆的参数
center_x = width / 2;
center_y = height / 2;
radius = min(height, width) / 2;

% 在图像上绘制红色圆
hold on;
th = 0:pi/100:2*pi;
x = radius * cos(th) + center_x;
y = radius * sin(th) + center_y;
plot(x, y, 'r', 'LineWidth', 2);
hold off;