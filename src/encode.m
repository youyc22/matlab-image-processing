function [DC_output, AC_output, width, height] = encode( initial, QTAB, DCTAB, ACTAB)

initial = double(initial) - 128;
[height, width] = size(initial);
w=width/8;
h=height/8;

dct_1 = blockproc(initial, [8, 8], @(block_struct) dct2(block_struct.data)./QTAB);

out_matrix = zeros(64, w*h);
for i = 1:h
    for j = 1:w
        out_matrix(:, (i-1)*w+j) = round(zig_zag(dct_1((i-1)*8+1:i*8, (j-1)*8+1:j*8),0));
    end
end

DC = out_matrix(1,:);
AC = out_matrix(2:end,:);

DC_diff = diff(DC);
DC_diff = [DC(1), -DC_diff];

%dc_encode
DC_output = [];
for i = 1: length(DC_diff)
    j = DC_diff(i);
    category = ceil(log2(abs(j)+1)) + 1;
    len = DCTAB(category, 1);
    huff = DCTAB(category,2:len+1);
    bin = double(dec2bin(abs(j)))-48;
    if j < 0
        bin = ~bin;
    end
    if j == 0
        bin_num = [];
    else
        bin_num = bin;
    end
    DC_output = [DC_output, huff, bin_num];
end

%ac_encode
AC_output = [];

for k = 1 : w*h
    AC_k=AC(:,k)';   
    AC_one=[];
    not_zero = find(AC_k);
    if(isempty(not_zero))
        AC_one = [1,0,1,0];
    else
        num_zero = [not_zero(1)-1, diff(not_zero)-1];
        for l = 1:length(num_zero)
            run = num_zero(l);
            if(run > 15)
                run = run - 16;
                AC_one = [AC_one, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1];
            end
            amplitude = AC_k(not_zero(l));
            size_ = ceil(log2(abs(amplitude)+1));
            idx = find(ACTAB(:,1)==run & ACTAB(:,2)==size_);
            len = ACTAB(idx,3);
            huff = ACTAB(idx,4:len+3);
            bin = double(dec2bin(abs(amplitude)))-48;
            if(amplitude < 0)
                bin = ~bin;
            end
            if amplitude == 0
                bin_num = [];
            else
                bin_num = bin;
            end
            AC_one = [AC_one, huff, bin_num];
        end
        AC_one = [AC_one, 1,0,1,0];
    end
    AC_output = [AC_output, AC_one];
end
end