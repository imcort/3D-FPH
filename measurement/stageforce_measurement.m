dq = daq("ni");

% out1 = addoutput(dq, "Dev1", "ao0", "Voltage");
% write(dq, 0);

ch1 = addinput(dq,"Dev1","ai2","Voltage");
ch1.Range = [-2 2];
ch1.TerminalConfig = "SingleEnded";

ch2 = addinput(dq,"Dev1","ai3","Voltage");
ch2.Range = [-2 2];
ch2.TerminalConfig = "SingleEnded";

ch3 = addinput(dq,"Dev1","ai4","Voltage");
ch3.Range = [-2 2];
ch3.TerminalConfig = "SingleEnded";

ch4 = addinput(dq,"Dev1","ai5","Voltage");
ch4.Range = [-2 2];
ch4.TerminalConfig = "SingleEnded";

ch = addinput(dq,"Dev1", "Port0/Line3:4","Digital");

dq.Rate = 2000;
read(dq,10)
%%
%read(dq,1)
result = [];
k = 498;
b = -1289 + 2.5*k;

dq.ScansAvailableFcn = @(src,evt) plotDataAvailable(src, evt);
dq.ScansAvailableFcnCount = 2000;
start(dq,"continuous")

%inData = read(d,"all")
% for i=1:10000
% 
%     data = read(dq,1);
%     weight = [mean(data.Dev1_ai2) mean(data.Dev1_ai3) mean(data.Dev1_ai4) mean(data.Dev1_ai5)];
%     subplot(121);bar(weight);%ylim([-200 1000]);
%     xticklabels(["RU" "RD" "LD" "LU"]);
%     weight = weight.*k+b;
%     round(sum(weight)*0.0098*100)./100 %N
%     
%     result = [result weight'];
%     subplot(122);plot(smooth(sum(result),4));
%     drawnow
% 
% end

function plotDataAvailable(src, ~)
    [data, timestamps, ~] = read(src, src.ScansAvailableFcnCount, "OutputFormat", "Matrix");
    plot(timestamps, data);
end