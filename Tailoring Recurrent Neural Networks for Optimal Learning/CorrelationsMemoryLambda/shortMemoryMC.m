function [MCTest, MCTraining, NRMSETest, NRMSETraining] = shortMemoryMC(Win, W, maxMemory, dataLength, initFraction, trainFraction)
if nargin < 5
    trainFraction = (1-initFraction)/2;
end
initLen = dataLength*initFraction;
trainLen = dataLength*(trainFraction + initFraction);
testLen = dataLength - trainLen;

sizeWin = size(Win);
netDim = sizeWin(1);
dataTS=2*rand(dataLength,1)-1;
%dataTS = (dataTS - mean(dataTS))/std(dataTS);


reservoirState = zeros(netDim,1);

reservoirStateMemory = zeros(netDim,trainLen-initLen); 

for t = 1:trainLen 
    u = dataTS(t); 
    reservoirState = tanh( Win*u + W*reservoirState );
    if t > initLen
        reservoirStateMemory(:,t-initLen) = [reservoirState];
    end
end 

%train for all memories
pastInputTrainMtx = zeros(maxMemory,(trainLen-initLen));
for i=1:maxMemory
    pastInputTrainMtx(i,:) = dataTS(initLen-i+2:trainLen-i+1)';
end
Wout = pastInputTrainMtx*pinv(reservoirStateMemory); 
trainOutput = Wout*reservoirStateMemory;

normalizedTrainOutput = (trainOutput - mean(trainOutput,2)*ones(1,trainLen-initLen));
normalizedPastInputTrain = (pastInputTrainMtx - mean(pastInputTrainMtx,2)*ones(1,trainLen-initLen));
covarianceTrain = mean(normalizedTrainOutput.*normalizedPastInputTrain,2);
varTSTraining = var(dataTS(initLen:trainLen));
varOutputTraining = var(trainOutput,0,2);
MCTraining = ((covarianceTrain.^2)./varOutputTraining)/varTSTraining;
NRMSETraining = sqrt(mean((trainOutput - pastInputTrainMtx).^2,2)/varTSTraining);

testOutput = zeros(maxMemory,testLen);
 
for t = 1:testLen 
    u = dataTS(trainLen+t);
    reservoirState = tanh( Win*u + W*reservoirState ); 
    y = Wout*[reservoirState]; 
    testOutput(:,t) = y; 
    % generative mode: 
    %u = y; 
    % this would be a predictive mode: 
end

pastInputTestMtx = zeros(maxMemory,testLen);
for i=1:maxMemory
    pastInputTestMtx(i,:) = dataTS((trainLen-i+2):(dataLength-i+1))';
end

normalizedTestOutput = (testOutput - mean(testOutput,2)*ones(1,testLen));
normalizedPastInputTest = (pastInputTestMtx - mean(pastInputTestMtx,2)*ones(1,testLen));
covarianceTest = mean(normalizedTestOutput.*normalizedPastInputTest,2);
varTSTest = var(dataTS(trainLen:end));
varOutputTest = var(testOutput,0,2);
MCTest = ((covarianceTest.^2)./varOutputTest)/varTSTest;
NRMSETest = sqrt(mean((testOutput - pastInputTestMtx).^2,2)/varTSTest);

%%%We need the training error, and the prediction correlation.
end