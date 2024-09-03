clear; 
close all; 
clc;

v_all = struct();
for L = 3 : 5
    v = zeros(1,2^(3*L));
    for i = 1 : 33
        image_path = sprintf('resources/Faces/%d.bmp',i);
        v = v + generate_v(imread(image_path), L);
    end
    v = v / 33;
    subplot(3,1,L-2);
    plot(v);
    title(sprintf('L = %d', L));
    v_all.(sprintf('v_L%d', L)) = v;
end
% 储存所有的 v
save('all_v.mat', '-struct', 'v_all');