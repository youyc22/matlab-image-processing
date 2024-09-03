clear;
close all;
clc;

% 创建频率向量
w = linspace(0, pi, 1000);

% 计算频率响应
H = 1 - exp(-1j * w);

% 计算幅度响应（以分贝为单位）
magnitude_db = 20 * log10(abs(H));

% 计算相位响应
phase = (angle(H)-pi)* 180 / pi;

% 绘制幅度响应
figure;
subplot(2,1,1);
plot(w/pi, magnitude_db);
grid on;
title('差分编码系统的幅度响应');
xlabel('归一化频率 (×π rad/sample)');
ylabel('幅度 (dB)');

% 绘制相位响应
subplot(2,1,2);
plot(w/pi, phase);
grid on;
title('差分编码系统的相位响应');
xlabel('归一化频率 (×π rad/sample)');
ylabel('相位 (°)');