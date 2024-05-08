%% https://ww2.mathworks.cn/help/vision/ug/object-counting.html
newData1 = importdata("pyramids_mask.bmp");
img = newData1.cdata;
figure(1);imshow(img,[]);

%%
I2 = im2bw(img,0.41);
%figure(3);imshow(I2,[]);

%%
Im = imclose(I2, strel('square',5));
%figure(3);imshow(Im,[]);

%%
hBlob = vision.BlobAnalysis('MinimumBlobArea',500,'MaximumCount',2048,'MaximumBlobArea', 800);
[area,centroid,bbox] = hBlob(Im);
hold on;
plot(centroid(:,1),centroid(:,2),'ro');
title(sprintf("num:%d",size(centroid,1)));

%% calculate
figure(2);
x_sort = diff(sort(centroid(:,1)));
subplot(211);plot(x_sort);
y_sort = diff(sort(centroid(:,2)));
subplot(212);plot(y_sort);

[pks,locs] = findpeaks(x_sort, 'MinPeakHeight', 10, 'SortStr', 'ascend');
%%
pixelwidth = 200./(mean(pks(1:32)) + mean(pks(33:end)))