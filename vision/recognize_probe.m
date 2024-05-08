load('centroid.mat')

newData1 = importdata("probe.bmp");
img = newData1.cdata;

img = imrotate(img,-1.4);
figure(1);imshow(img,[]);

icrop = imcrop(img);
imwrite(icrop, 'probe_single.png')
%%
level = multithresh(img);
seg_I = imquantize(img,level);
figure
imshow(seg_I,[])
%%
offset_x = 1619 - 1157.43;
offset_y = 1128 - 1289.46;
points = centroid;
%points = points - centroid(1,:);
points = points + [offset_x offset_y];
hold on;
plot(points(:,1),points(:,2),'ro');