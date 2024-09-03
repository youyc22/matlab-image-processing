function zigzag = zig_zag_1(matrix, direction)
    [m, n] = size(matrix);
    zigzag = zeros(1, m*n);
    [i, j] = deal(1, 1);
    
    for k = 1:m*n
        zigzag(k) = matrix(i, j);
        disp(zigzag(k))
        if direction && (j == 1 || i == m) || ~direction && (i == 1 || j == n)
            if direction
                [i, j] = deal(i + (i < m), j + (i == m));
            else
                [i, j] = deal(i + (j == n), j + (j < n));
            end
            direction = ~direction;
        else
            [i, j] = deal(i + 2*direction - 1, j - 2*direction + 1);
        end
    end
end