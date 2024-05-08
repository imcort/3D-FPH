target_image = single(probe_rotated);
target_energy = sqrt(sum(target_image(:).^2));

target_image_rot = imrotate(target_image, 180);

Img = single(probe_single);
[rt, ct] = size(target_image_rot);
[ri, ci]= size(Img);
r_mod = 2^nextpow2(rt + ri);
c_mod = 2^nextpow2(ct + ci);

target_image_p = [target_image_rot zeros(rt, c_mod-ct)];
target_image_p = [target_image_p; zeros(r_mod-rt, c_mod)];

target_fft = fft2(target_image_p);