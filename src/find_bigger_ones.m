function indices = find_bigger_ones(matrix, ratio)
    flattened = zig_zag(matrix, 0);
    num_to_select = ceil(numel(flattened) / ratio);
    [~, sorted_indices] = sort(flattened);
    indices = sorted_indices(end-num_to_select+1:end);
end