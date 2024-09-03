function indices = find_smaller_ones(matrix, ratio)
    flattened = zig_zag(matrix, 0);
    num_to_select = ceil(numel(flattened) / ratio);
    [~, sorted_indices] = sort(flattened);
    indices = sorted_indices(1:num_to_select);
end