%% init daq
devname = "Dev1";

daq_device = daq("ni");

addoutput(daq_device, devname, "port0/line8:17", "Digital"); %addr 10

addoutput(daq_device, devname, "ao2", "Voltage"); %current set 1

ch = addinput(daq_device, devname, "ai29", "Voltage");
ch.Range = [0 5];
ch.TerminalConfig = "SingleEnded"; %voltage sense

%% single point
x = decimalToBinaryVector(x_map(15), 5, 'MsbFirst');
y = decimalToBinaryVector(y_map(15), 5, 'MsbFirst');
output_sig = [y x (1 / 19.92)];
write(daq_device, output_sig);


%% init optics
spectrometerObj = icdevice('OceanOptics_OmniDriver.mdd');
connect(spectrometerObj);
disp(spectrometerObj)

% integration time for sensor.
integrationTime = 100e3;
% Spectrometer index to use (first spectrometer by default).
spectrometerIndex = 0;
% Channel index to use (first channel by default).
channelIndex = 0;
% Enable flag.
enable = 1;

invoke(spectrometerObj, 'setIntegrationTime', spectrometerIndex, channelIndex, integrationTime);
% Enable correct for detector non-linearity.
invoke(spectrometerObj, 'setCorrectForDetectorNonlinearity', spectrometerIndex, channelIndex, enable);
% Enable correct for electrical dark.
invoke(spectrometerObj, 'setCorrectForElectricalDark', spectrometerIndex, channelIndex, enable);

%% acq
integrationTime = 600e2;
invoke(spectrometerObj, 'setIntegrationTime', spectrometerIndex, channelIndex, integrationTime);

wavelengths = invoke(spectrometerObj, 'getWavelengths', spectrometerIndex, channelIndex);
spectralData = invoke(spectrometerObj, 'getSpectrum', spectrometerIndex);
plot(wavelengths, spectralData)

%% multi
curr = (1:100)./100.*10;
spec = zeros(2048,100);
%%
for i=1:100
    x = decimalToBinaryVector(x_map(15), 5, 'MsbFirst');
    y = decimalToBinaryVector(y_map(15), 5, 'MsbFirst');
    output_sig = [y x (curr(i) / 19.92)];
    write(daq_device, output_sig);

    pause(0.01);

    integrationTime = 1e2 .* (600 ./ curr(i));
    invoke(spectrometerObj, 'setScansToAverage', spectrometerIndex, 10);
    invoke(spectrometerObj, 'setIntegrationTime', spectrometerIndex, channelIndex, integrationTime);
    
    wavelengths = invoke(spectrometerObj, 'getWavelengths', spectrometerIndex, channelIndex);
    spectralData = invoke(spectrometerObj, 'getSpectrum', spectrometerIndex);

    spec(:,i) = spectralData;

    plot(wavelengths, spectralData)
end

x = decimalToBinaryVector(x_map(15), 5, 'MsbFirst');
y = decimalToBinaryVector(y_map(15), 5, 'MsbFirst');
output_sig = [y x (0.01 / 19.92)];
write(daq_device, output_sig);