function [testDigitArray, testSexArray , testErrorArray ] = fullTestForecastErrorArabDigitRecognition( W, Win, preProcessedTestData, WoutSet, channels, channelWeights)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

sizeBlock = size(preProcessedTestData{1,1,1});
if nargin < 5
    channels = 1:sizeBlock(1);
end
if nargin < 6
    channelWeights = ones(1,length(channels))/length(channels);
end


sizeTest = size(preProcessedTestData);
testErrorArray = zeros(length(channels), sizeTest(2),sizeTest(3), sizeTest(1), sizeTest(2),sizeTest(3));
testDigitArray = zeros(  sizeTest(1), sizeTest(2),sizeTest(3));
testSexArray = zeros( sizeTest(1), sizeTest(2),sizeTest(3));


%figure(2)
for digitIdData = 1:sizeTest(3)
    for sexIdData = 1:sizeTest(2)
        testArray = extractArrayBlock(preProcessedTestData, sexIdData, digitIdData);
        for i = 1:length(testArray)
            blocData = testArray{i};
            blocData=blocData(channels,:);
            realSignal = blocData(:,2:end);
            reservoirStates = computeReservoirStates(W, Win, blocData);
            
            [ testDigitArray(i, sexIdData, digitIdData), testSexArray(i, sexIdData, digitIdData),  testErrorTemp] = computeErrorForAllHypothesis( reservoirStates, realSignal, WoutSet, channelWeights);
            testErrorArray(:,:,:,i,sexIdData, digitIdData) = testErrorTemp;
            
%             if i<20 && i>15
%                 subplot(4,5,2*(digitIdData-1)+sexIdData)
%                 plot(realSignal,'b')
%                 hold on
%                 plot(WoutSet(:,:,sexIdData,digitIdData)*reservoirStates,'g');
%                 axis([1, 40, -3, 3])
%             end
        end

    end
end

end