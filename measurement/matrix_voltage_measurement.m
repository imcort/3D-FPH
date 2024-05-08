%%
dqcurr = daq("ni");
addoutput(dqcurr,"Dev2","ao2","Voltage");
sweep_curr_max = 0.1; %% mA

write(dqcurr,sweep_curr_max ./ 19.94);


%%
load('corr.mat');
volt_result = zeros(32,32);
output_sig = zeros(1024,12);
%%
for i=1:32
    for j=1:32
        output_sig(j+32*(i-1),1:10) = newrowcolumn_tolist(corrx(j),corry(i));
    end
end

%% 

dq = daq("ni");
addoutput(dq,"Dev2","port0/line8:17","Digital");
addoutput(dq,"Dev2","ao2","Voltage");
ch = addinput(dq,"Dev2", "ai29", "Voltage");
get(ch);
ch.TerminalConfig = "SingleEnded";
set(ch);

%% set current
sweep_curr_max = 0.1; %% mA
for i=1:1024
    output_sig(i,11) = sweep_curr_max ./ 19.94;
end

%% single light on
flush(dq)
write(dq, output_sig(36,:))

%%
resistance = [data(2:1024) data(1)];
volt_result = reshape(resistance,[32 32]);
imagesc(volt_result)
%%

flush(dq)
dq.Rate = 2047;
preload(dq,output_sig);
dq.ScansAvailableFcn = @(src,evt) plotDataAvailable(src, evt);
dq.ScansAvailableFcnCount = 1024;
start(dq,"RepeatOutput");

function plotDataAvailable(src, ~)
    [data, timestamps, ~] = read(src, src.ScansAvailableFcnCount, "OutputFormat", "Matrix");
    data = data';
    resistance = [data(2:1024) data(1)];
    volt_result = reshape(resistance,[32 32]);
    figure(1);
    imagesc(volt_result);
    colorbar
    figure(2);
    plot(resistance)
    drawnow
end
