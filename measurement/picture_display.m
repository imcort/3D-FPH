%%
pic = imresize(cdata,[32 32]);
picbw = im2gray(pic);
imshow(picbw);

%%
picbw = ones(32,32);
%% init daq
devname = "Dev1";

daq_device = daq("ni");

addoutput(daq_device, devname, "port0/line8:17", "Digital"); %addr 10

addoutput(daq_device, devname, "ao2", "Voltage"); %current set 1

ch = addinput(daq_device, devname, "ai29", "Voltage");
ch.Range = [0 5];
ch.TerminalConfig = "SingleEnded"; %voltage sense

x = decimalToBinaryVector(x_map(15), 5, 'MsbFirst');
y = decimalToBinaryVector(y_map(15), 5, 'MsbFirst');
output_sig = [y x (1 / 19.92)];
write(daq_device, output_sig);
%%

%%
picshow = double(picbw) ./ max(max(double(picbw)));
load('map_m06.mat')

start_mA = 1 / 19.92;

output_sig = [];

for xx=1:32
    for yy=1:32
        x = decimalToBinaryVector(x_map(xx), 5, 'MsbFirst');
        y = decimalToBinaryVector(y_map(33-yy), 5, 'MsbFirst');
        mA = ((picshow(xx,yy))).*start_mA;
        output_sig = [output_sig ;[y x mA]];
    end
end
output_sig = [output_sig ;[y x 0]];
%%
flush(daq_device);
%preload(daq_device, output_sig);
daq_device.Rate = 100000;
%start(daq_device,"continuous");
%output_sig = [y x 0];
while(1)
    readwrite(daq_device, output_sig)
end