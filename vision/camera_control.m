

vid = videoinput("gentl", 1, "Mono8");


src = getselectedsource(vid);
%src.ExposureTime = 25000;
start(vid);
global basepic;
basepic = getsnapshot(vid);

hFig = figure;

vidRes = vid.VideoResolution;
imWidth = vidRes(1)
imHeight = vidRes(2)
nBands = vid.NumberOfBands;
hImage = imagesc( zeros(imHeight, imWidth, nBands) );

setappdata(hImage,'UpdatePreviewWindowFcn',@mypreview_fcn);

preview(vid, hImage);


function mypreview_fcn(obj,event,himage)
    % Example update preview window function.
    
    % Get timestamp for frame.
%     tstampstr = event.Timestamp;
%     
%     % Get handle to text label uicontrol.
%     ht = getappdata(himage,'HandleToTimestampLabel');
%     
%     % Set the value of the text label.
%     ht.String = tstampstr;
    global basepic;
    % Display image data.
    a = double(event.Data) + double(basepic);
    %a = imresize(a,0.25);
    %reducedsnap = histeq(imgset,256);
    amaxmin = max(a(:))-min(a(:));
    amin = min(a(:));
    b=(a-amin)./(amaxmin).*255;
    pause(0.1);
    himage.CData = uint8(b);
    
end