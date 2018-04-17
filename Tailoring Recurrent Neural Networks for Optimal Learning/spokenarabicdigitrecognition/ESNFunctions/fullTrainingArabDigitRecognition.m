function [ WoutSet, trainingErrorVec, channelWeightDigit, channelWeightSex ] = fullTrainingArabDigitRecognition( W, Win, preProcessedTrainData, channels)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
if nargin < 4
    tempSize = size(preProcessedTrainData{1,1,1});
    channels = 1:tempSize(1);
end

sizeTrain = size(preProcessedTrainData);
trainingErrorVec = zeros(length(channels), sizeTrain(2),sizeTrain(3));
WoutSet = zeros(length(channels), length(W)+length(channels), sizeTrain(2),sizeTrain(3));

%figure(1)
for digitIdTrain = 1:sizeTrain(3)
    for sexIdTrain = 1:sizeTrain(2)
        
        trainArray = extractArrayBlock(preProcessedTrainData, sexIdTrain, digitIdTrain);
        [WoutSet(:,:,sexIdTrain, digitIdTrain), trainingErrorVec(:,sexIdTrain, digitIdTrain)] = trainOneDigitOneSex(trainArray, W, Win, channels);
        
        
%             for i=15:20
%                 data = trainArray{i};
%                 reservoirStates = computeReservoirStates(W, Win, data(channels,:));
%                 subplot(4,5,2*(digitIdTrain-1)+sexIdTrain)
%                 plot(data(channels,2:end),'b')
%                 hold on
%                 plot(WoutSet(:,:,sexIdTrain,digitIdTrain)*reservoirStates,'g');
%                 axis([1, 40, -3, 3])
%             end
    end
    
end

if length(channels) == 1
    channelWeightDigit = 1;
    channelWeightSex = 1;
else
    %WRONG!
    sexNormalizingMtx = repmat(sum(trainingErrorVec,2),[1, sizeTrain(2),1]);
    channelToSexMtx=mean(trainingErrorVec./sexNormalizingMtx,3);
    
    channelWeightSex = squeeze(mean(trainingErrorVec./sexNormalizingMtx,3));
    
    digitNormalizingMtx = repmat(sum(trainingErrorVec,3),[1, 1,sizeTrain(3)]);
    channelWeightDigit = squeeze(mean(trainingErrorVec./digitNormalizingMtx,2));
end

end

