%% init daq
devname = "Dev2";

daq_device = daq("ni");

addoutput(daq_device, devname, "port0/line8:17", "Digital"); %addr 10

addoutput(daq_device, devname, "ao2", "Voltage"); %current set 1

% ch = addinput(daq_device, devname, "ai29", "Voltage");
% ch.Range = [0 5];
% ch.TerminalConfig = "SingleEnded"; %voltage sense

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

%%
load('map_m06.mat')

start_mA = 1 / 19.92;

total_spectral = [];

for xx=14:25
    for yy=1:32
        x = decimalToBinaryVector(x_map(xx), 5, 'MsbFirst');
        y = decimalToBinaryVector(y_map(yy), 5, 'MsbFirst');
        output_sig = [y x start_mA];
        
        write(daq_device, output_sig);
        
        figure(1)
        plot(total_spectral,'DisplayName','total_spectral')
        drawnow

        integrationTime = 10e3;
        invoke(spectrometerObj, 'setIntegrationTime', spectrometerIndex, channelIndex, integrationTime);

        spectralData = invoke(spectrometerObj, 'getSpectrum', spectrometerIndex);

        [xx yy max(spectralData)]

        integrationTime = 50000 ./ (max(spectralData)./10e3)
        if(integrationTime > 1000e3)
            integrationTime = 1000e3;
        end
        invoke(spectrometerObj, 'setIntegrationTime', spectrometerIndex, channelIndex, integrationTime);

        spectralData = invoke(spectrometerObj, 'getSpectrum', spectrometerIndex);
        % output_sig = [y x 0];
        % write(daq_device, output_sig);    
        % 
        % spectralData = spectralData - invoke(spectrometerObj, 'getSpectrum', spectrometerIndex);

        total_spectral = [total_spectral spectralData];
    end
end
output_sig = [y x 0];
write(daq_device, output_sig);


%% acq
integrationTime = 10e2;
invoke(spectrometerObj, 'setIntegrationTime', spectrometerIndex, channelIndex, integrationTime);

wavelengths = invoke(spectrometerObj, 'getWavelengths', spectrometerIndex, channelIndex);
spectralData = invoke(spectrometerObj, 'getSpectrum', spectrometerIndex);
plot(wavelengths, spectralData)

%%
pos = [];

for i=1:1024
    if max(total_spectral(:,i)) > 60000
        pos = [pos i];
    end

end

xx = ceil(pos./32);
yy = pos-(xx-1).*32;

%%

x = decimalToBinaryVector(x_map(18), 5, 'MsbFirst');
y = decimalToBinaryVector(y_map(19), 5, 'MsbFirst');
output_sig = [y x start_mA];
write(daq_device, output_sig);

integrationTime = 30e2;
invoke(spectrometerObj, 'setIntegrationTime', spectrometerIndex, channelIndex, integrationTime);

wavelengths = invoke(spectrometerObj, 'getWavelengths', spectrometerIndex, channelIndex);
spectralData = invoke(spectrometerObj, 'getSpectrum', spectrometerIndex);
plot(wavelengths, spectralData)