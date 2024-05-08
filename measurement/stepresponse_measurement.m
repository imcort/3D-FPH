%%
devname = "Dev2";

daq_device = daq("ni");

addoutput(daq_device, devname, "port0/line8:17", "Digital"); %addr 10

addoutput(daq_device, devname, "ao2", "Voltage"); %current set 1

ch = addinput(daq_device, devname, "ai29", "Voltage");
ch.Range = [0 5];
ch.TerminalConfig = "SingleEnded"; %voltage sense

%%
load('map_m06.mat')

sweep_points = 1601;
row_x = 15;
col_y = 15;

curr = 1/20;

x = decimalToBinaryVector(x_map(row_x), 5, 'MsbFirst');
y = decimalToBinaryVector(y_map(col_y), 5, 'MsbFirst');

output_sig = zeros(sweep_points,11);

for i=1:sweep_points
    output_sig(i,1:10) = [y x];
    if i>(sweep_points*0.5)
        output_sig(i,11) = 0;
    else
        output_sig(i,11) = curr;
    end
end
output_sig(sweep_points,11) = 0;

%%
c = [zeros(60,1); ones(40,1)] .* curr;
output_sig(1:1600,11) = [c; c; c; c; c; c; c; c; c; c; c; c; c; c; c; c;];
%%
%daq_device.Rate = 10000;
%result = readwrite(daq_device,output_sig);
figure(1);
yyaxis left
plot(result.Dev2_ai29)
yyaxis right
plot(output_sig(:,end))
figure(2);
plot(diff(result.Dev2_ai29,2));
