function zigzag_sequence = zig_zag(matrix,direction)
    % 获取矩阵维度
    [m, n] = size(matrix);
    zigzag_sequence = zeros(1, m*n);
    i = 1;
    j = 1;
    for k = 1:(m*n)
        zigzag_sequence(k) = matrix(i, j);
        if direction == 1 % 向下移动
            if j == 1 || i == m
                if i == m
                    j = j + 1;
                else
                    i = i + 1;
                end
                direction = 0;
            else
                i = i + 1;
                j = j - 1;
            end
        else % 向上移动
            if i == 1 || j == n
                if j == n
                    i = i + 1;
                else
                    j = j + 1;
                end
                direction = 1;
            else
                i = i - 1;
                j = j + 1;
            end
        end
    end
end