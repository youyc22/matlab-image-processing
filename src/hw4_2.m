clear; close all; clc;

load('all_v.mat');
image_in = imread('resources/web_group.bmp');
[height, width, ~] = size(image_in);
thresholds = [0.499, 0.599, 0.699];
L_values = 3:5;

figure('Position', [100, 100, 1200, 900]);

subplot_index = 1;

% 遍历每个 L 值
for L = L_values
    v = eval(sprintf('v_L%d', L));
    for threshold = thresholds
        image_out = face_detect(image_in, v, L, threshold, 15, 15, 60, 60, 14, 13);
        subplot(3, 3, subplot_index);
        imshow(image_out);
        title(sprintf('L = %d, Threshold = %.3f', L, threshold));
        
        subplot_index = subplot_index + 1;
    end
end

% 调整子图之间的间距
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
sgtitle('Face Detection Results for Different L Values and Thresholds', 'FontSize', 16);