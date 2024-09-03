function dct_result = my_dct2(input_matrix)
    [M, ~] = size(input_matrix);
    
    di1 = 1:2:2*M-1;
    di2 = (1:M-1)';
    D = cos(pi/(2*M)*di1.*di2);
    D = sqrt(2/M)*[1/sqrt(2)*ones(1,M); D];
    dct_result = D*input_matrix*D';
end