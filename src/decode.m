function re_image = decode(DC_output, AC_output, width,height,QTAB,DCTAB,ACTAB)

re_image = zeros (height,width);
block_num = height*width/64;

DC_re = zeros(1,block_num);
i=1;
idx=1;
while i <= length(DC_output)
    for j = 1:size(DCTAB,1)
        if DCTAB(j,2:DCTAB(j,1)+1) == DC_output(i:i+DCTAB(j,1)-1)
            category = j-1;
            i = i+DCTAB(j,1);
            if(category == 0)
                DC_re(idx) = 0;
                idx=idx+1;
            else
                magnitude = DC_output(i:i+category-1);
                if(magnitude(1) == 0)
                    DC_re(idx) = -bin2dec(char(~magnitude+48));
                    idx=idx+1;
                else
                    DC_re(idx) = bin2dec(char(magnitude+48));
                    idx=idx+1;
                end
            end
            i = i+category;
            break;
        end
    end
end
for k = 2: block_num
    DC_re(k) = DC_re(k-1)-DC_re(k);
end

AC_re = zeros(block_num,63);
idx_1=1;
idx_2=1;
idx_3=1;
ZRL = [1,1,1,1,1,1,1,1,0,0,1];
EOB = [1,0,1,0];

while idx_1 <= length(AC_output)
    if EOB == AC_output(idx_1:idx_1+3)
        idx_1 = idx_1+4;
        idx_2 = idx_2+1;
        idx_3 = 1;
    elseif idx_1 <= length(AC_output)-10 & ZRL == AC_output(idx_1:idx_1+10) 
        AC_re(idx_2,idx_3:idx_3+15) = 0;
        idx_1 = idx_1+11;
        idx_3 = idx_3+16;
    else
        for j = 1:size(ACTAB,1)
            if idx_1 + ACTAB(j,3) -1 <= length(AC_output) & ACTAB(j,4:ACTAB(j,3)+3)==AC_output(idx_1:idx_1+ACTAB(j,3)-1) 
                %idx_3 = idx_3+ACTAB(j,1);
                idx_1 = idx_1+ACTAB(j,3);
                AC_re(idx_2, idx_3:idx_3+ACTAB(j,1)-1) = 0;
                idx_3 = idx_3+ACTAB(j,1);
                amplitude = AC_output(idx_1:idx_1+ACTAB(j,2)-1);
                if amplitude(1) == 0
                    AC_re(idx_2,idx_3) = -bin2dec(char(~amplitude+48));
                    idx_3 = idx_3+1;
                else
                    AC_re(idx_2,idx_3) = bin2dec(char(amplitude+48));
                    idx_3 = idx_3+1;
                end
                idx_1 = idx_1+ACTAB(j,2);
                break
            end
        end
    end
end
AC_re =AC_re';

im_re = cat(1, DC_re, AC_re);

w=width/8;
h=height/8;

im_block = zeros(1,64);

index = reshape(1:64,8,8)';
indxe_1 = zig_zag(index,1);

for i = 1:h
    for j = 1:w
        im_block(indxe_1) = im_re(:,(i-1)*w+j);
        im_block = reshape(im_block,8,8);
        im_block = idct2(im_block.*QTAB);
        re_image((i-1)*8+1:i*8,(j-1)*8+1:j*8) = im_block;
    end
end

re_image = uint8(re_image+128);
end