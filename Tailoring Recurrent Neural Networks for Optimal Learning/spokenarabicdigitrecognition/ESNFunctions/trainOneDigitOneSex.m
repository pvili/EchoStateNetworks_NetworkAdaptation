function [Wout, trainingError] = trainOneDigitOneSex(trainArray, W, Win, channels)

if nargin < 4
    tempSize = size(trainArray{1});
    channels = 1:tempSize(1);
end

netDim = length(W);
sizeWin = size(Win);

totalSignalSamples = 0;
for i = 1:length(trainArray)
    tempSize = size(trainArray{i});
    totalSignalSamples = totalSignalSamples + tempSize(2) -1;
end


fullReservoirResults = zeros( netDim + length(channels), totalSignalSamples);
forecastedSignal = zeros(length(channels),totalSignalSamples);

countSignalSamples = 1;
for i = 1:length(trainArray)
    blocData = trainArray{i};
    blocData=blocData(channels,:);
    tempSize = size(blocData);
    tempReservoirResults = computeReservoirStates(W, Win, blocData);
    fullReservoirResults(:,countSignalSamples:(countSignalSamples+tempSize(2)-2)) = tempReservoirResults;
    %From 1 to end-1 for each bloc
    forecastedSignal(:,countSignalSamples:(countSignalSamples+tempSize(2)-2)) = blocData(:,2:end);
    countSignalSamples = (countSignalSamples+tempSize(2));
    
end

Wout = forecastedSignal*pinv(fullReservoirResults);
trainingError =  sqrt(mean((forecastedSignal-Wout*fullReservoirResults).^2,2)./var(blocData,0,2));

% plot(forecastedSignal(1,1:100)','b')
% hold on
% targetSignal = Wout*fullReservoirResults;
% plot((targetSignal(1,1:100))', 'r')
% hold off
end

