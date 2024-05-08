BW = input_image(:,:,3);

angle = atan((525-506)/975-173)
J = imrotate(BW,-angle);
% imshow(J);
% [K,rectout] = imcrop(J);

% x = rectout(1);
% y = rectout(2);
%%
x = rectout(1)+2;
y = rectout(2);
w = 150;
h = 70;
gap_x = 320;
gap_y = 163;

figure(1);
hold on;
imshow(J);
for j=0:4
    for i=0:2
        rectangle('Position',[x + i*gap_x, y + j*gap_y, w, h],'EdgeColor','r');
        pp = imcrop(J,[x + i*gap_x, y + j*gap_y, w, h]);
        imwrite(pp,sprintf('F2_12_%d_%d.png',i,j));
    end
end
