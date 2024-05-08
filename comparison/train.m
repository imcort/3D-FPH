[XTrain,YTrain] = digitTrain4DArrayData;  
whos YTrain

layers = [
    imageInputLayer([28 28 1])
    
    convolution2dLayer(3,8,'Padding','same')
    batchNormalizationLayer
    reluLayer    
    convolution2dLayer(3,16,'Padding','same','Stride',2)
    batchNormalizationLayer
    reluLayer
    convolution2dLayer(3,32,'Padding','same','Stride',2)
    batchNormalizationLayer
    reluLayer
    
    fullyConnectedLayer(10)
    softmaxLayer
    classificationLayer];

options = trainingOptions('sgdm', ...
    'MaxEpochs',5, ...
    'Verbose',false, ...
    'Plots','training-progress');
net = trainNetwork(XTrain,YTrain,layers,options);

[XTest,YTest] = digitTest4DArrayData;
YPredicted = classify(net,XTest);

%%
rng default
[XTrain,YTrain] = cancer_dataset;
YTrain(:,1:10)

net = patternnet(10);
net = train(net,XTrain,YTrain);

YPredicted = net(XTrain);
YPredicted(:,1:10)

plotconfusion(YTrain,YPredicted)