function img_out = face_detect(img_in, v, L, threshold, h_step, w_step, h_unit,w_unit, line_width, min_len)
    [height, width, ~] = size(img_in);
    % 初始化
    h_num = floor((height - h_unit) / h_step + 1);
    w_num = floor((width - w_unit) / w_step + 1);
    h_multiple = floor(h_unit / h_step);
    w_multiple = floor(w_unit / w_step);
    unit_top = [];
    unit_left = [];
    unit_count = 0;

    % 计算每个单元的v值与给定v值的差异
    for h = 1 : h_num
        for w = 1 : w_num
            h_start = (h-1) * h_step;
            w_start = (w-1) * w_step;
            test_img = img_in(h_start + 1 : h_start + h_unit, w_start + 1 : w_start + w_unit, :);
            test_v = generate_v(test_img, L);
            diff = 1 - sum(sqrt(test_v) .* sqrt(v));
            if diff < threshold
                unit_count = unit_count + 1;
                unit_top(unit_count) = h;
                unit_left(unit_count) = w;
            end
        end
    end
    img_detect = zeros([h_num w_num]);
    rows = repmat((1 : h_num)', 1, w_num);
    cols = repmat([1 : w_num], h_num, 1);
    for i = 1 : 1 : unit_count
        one_detect = double((rows >= unit_top(i) & rows <= (unit_top(i)+h_multiple-1)) ...
                & (cols >= unit_left(i) & cols <= (unit_left(i)+w_multiple-1)));
        img_detect = max(img_detect, one_detect);
    end

    % 对二值图像进行连通区域标记
    [labs, n] = bwlabel(img_detect);
    min_left = zeros(n, 1) + w_num;
    min_top = zeros(n, 1) + h_num;
    max_right = zeros(n, 1);
    max_bottom = zeros(n, 1);

    % 计算每个连通区域的边界
    for i = 1 : unit_count
        lab = labs(unit_top(i), unit_left(i));
        min_left(lab) = min(min_left(lab), unit_left(i));
        min_top(lab) = min(min_top(lab), unit_top(i));
        max_right(lab) = max(max_right(lab), unit_left(i)+w_multiple-1);
        max_bottom(lab) = max(max_bottom(lab), unit_top(i)+h_multiple-1);
    end

    % 去除过小或者太狭长的区域
    flags = ones(n, 1);
    for i = 1 : n
        r_w = double(max_right(i) - min_left(i) +1);
        r_h = double(max_bottom(i) - min_top(i) +1);
        if ((r_w < min_len) && (r_h < min_len)) || r_w / r_h >= 1.9 || r_h / r_w >= 1.9
            flags(i) = 0;
        end
    end
    
    % 分割合并的人脸
    draw_rectangle = false(size(img_in));
    for i = 1 : 1 : n
        % 如果当前连通区域被标记为不需要处理，则跳过
        if flags(i) == 0
            continue;
        end
        % 找出属于当前连通区域的所有单元
        region_units = find(labs == i);
        [region_rows, region_cols] = ind2sub(size(labs), region_units);
        
        % 将单元坐标组合成一个矩阵
        unit_coords = [region_rows, region_cols];
        
        % 使用K-means聚类(假设最多分为2个矩形)
        [idx, centroids] = kmeans(unit_coords, 2);

        % 设置距离阈值
        distance_threshold = 16;
        
        % 判断是否需要分割
        if size(unique(idx, 'rows'), 1) > 1 && pdist(centroids) >= distance_threshold % 如果确实分成了两类
            rectangles = [];
            for k = 1:2
                cluster_units = unit_coords(idx == k, :);
                
                % 为每个聚类计算新的边界
                new_min_left = min(cluster_units(:, 2));
                new_min_top = min(cluster_units(:, 1));
                new_max_right = max(cluster_units(:, 2));
                new_max_bottom = max(cluster_units(:, 1));
                
                % 添加矩形信息
                rectangles = [rectangles; new_min_left, new_min_top, new_max_right, new_max_bottom];
            end
            
            % 检查两个矩形是否重叠
            overlap_threshold = 0.3;  % 重叠阈值，可以根据需要调整
            rect1 = rectangles(1, :);
            rect2 = rectangles(2, :);
            
            % 计算重叠区域
            x_overlap = max(0, min(rect1(3), rect2(3)) - max(rect1(1), rect2(1)));
            y_overlap = max(0, min(rect1(4), rect2(4)) - max(rect1(2), rect2(2)));
            overlap_area = x_overlap * y_overlap;
            
            % 计算两个矩形的面积
            area1 = (rect1(3) - rect1(1) + 1) * (rect1(4) - rect1(2) + 1);
            area2 = (rect2(3) - rect2(1) + 1) * (rect2(4) - rect2(2) + 1);
            
            % 计算重叠比例（相对于较小的矩形）
            min_area = min(area1, area2);
            overlap_ratio = overlap_area / min_area;
            
            if overlap_ratio > overlap_threshold
                % 如果重叠比例大于阈值，合并两个矩形
                merged_rect = [
                    min(rect1(1), rect2(1));  % 最小左边界
                    min(rect1(2), rect2(2));  % 最小上边界
                    max(rect1(3), rect2(3));  % 最大右边界
                    max(rect1(4), rect2(4))   % 最大下边界
                ];
                
                % 计算合并矩形的中心
                center_x = (merged_rect(1) + merged_rect(3)) / 2;
                center_y = (merged_rect(2) + merged_rect(4)) / 2;
                
                % 计算合并矩形的宽度和高度
                width = merged_rect(3) - merged_rect(1) + 1;
                height = merged_rect(4) - merged_rect(2) + 1;
                
                % 调整合并矩形的大小，使其更接近原始矩形的平均大小
                avg_width = (rect1(3) - rect1(1) + rect2(3) - rect2(1) + 2) / 2;
                avg_height = (rect1(4) - rect1(2) + rect2(4) - rect2(2) + 2) / 2;
                
                adjusted_width = (width + avg_width) / 2;
                adjusted_height = (height + avg_height) / 2;
                
                % 计算调整后的矩形边界
                adjusted_rect = [
                    max(1, round(center_x - adjusted_width / 2)),
                    max(1, round(center_y - adjusted_height / 2)),
                    min(w_num, round(center_x + adjusted_width / 2)),
                    min(h_num, round(center_y + adjusted_height / 2))
                ];
                
                rectangles = adjusted_rect;
            end

            rectangles = reshape(rectangles, [], 4);

            % 绘制矩形
            for r = 1:size(rectangles, 1)
                top_start = (rectangles(r, 2) - 1) * h_step + 1;
                bottom_end = rectangles(r, 4) * h_step;
                left_start = (rectangles(r, 1) - 1) * w_step + 1;
                right_end = rectangles(r, 3) * w_step;
                
                draw_rectangle(top_start : bottom_end, ...
                 left_start : left_start + line_width) = true;
                draw_rectangle(top_start : top_start + line_width, left_start: right_end) = true;
                draw_rectangle(top_start: bottom_end, max(1, right_end - line_width) : right_end) = true;
                draw_rectangle(max(1, bottom_end - line_width) : bottom_end, left_start : right_end) = true;
            end
        else
            % 绘制矩形
            top_start = (min_top(i) - 1) * h_step + 1;
            bottom_end = max_bottom(i) * h_step;
            left_start = (min_left(i) - 1) * w_step + 1;
            right_end = max_right(i) * w_step;
            draw_rectangle( top_start : bottom_end, left_start : left_start + line_width) = true;
            draw_rectangle( top_start : top_start + line_width, left_start: right_end) = true;
            draw_rectangle( top_start: bottom_end, max(1, right_end - line_width) : right_end) = true;
            draw_rectangle(max(1, bottom_end - line_width) : bottom_end, left_start : right_end) = true;
        end
    end
    % 绘制红色边框的矩形
    draw = cat(3, draw_rectangle, false(size(draw_rectangle)), false(size(draw_rectangle)));
    img_in(draw) = uint8(255);
    img_out = img_in;
end

