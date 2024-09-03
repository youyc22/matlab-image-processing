function dec = signed_bin2dec(bin_array)
    
    [m, n] = size(bin_array);
    dec = zeros(m,1);

    for i = 1:m
        if bin_array(i,1) == '1'
            dec(i) = bin2dec(bin_array(i,:)) - 2^n;
        else
            dec(i) = bin2dec(bin_array(i,:));
        end
    end
end