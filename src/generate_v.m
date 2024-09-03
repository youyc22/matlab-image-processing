function v = generate_v(image_in, L)
    v = zeros(1, 2^(3 * L));
    [h, w, ~] = size(image_in);
    image_re = reshape(image_in, h * w, 3);
    for i = 1 : h*w
        index = floor(double(image_re(i,1))/(2^(8-L))) * 2^(2*L) + floor(double(image_re(i,2))/(2^(8-L))) * 2^L + floor(double(image_re(i,3))/(2^(8-L))) + 1;
        v(index) = v(index) + 1;
    end
    v = v / (h * w);
end