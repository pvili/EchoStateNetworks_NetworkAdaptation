function [ preProcessedTrainData, preProcessedTestData ] =  preProcessArabicDigits( trainData, testData, newPointCount )


sizeTest = size(testData);
sizeTrain = size(trainData);
preProcessedTrainData = cell(sizeTrain(1), sizeTrain(2), sizeTrain(3));
for digitIdx = 1:10
    for sexIdx = 1:2
        listMeanArray = zeros(1,sizeTrain(1));
        for blockIdx = 1:sizeTrain(1) %that's the number of blocks
            blockMtx = trainData{blockIdx, sexIdx, digitIdx};
            sizeBlock = size(blockMtx);
            newBlockMtx = zeros(sizeBlock(1),newPointCount);
            for channelIdx = 1:sizeBlock(1)
                meanArray = mean(blockMtx(channelIdx,:));
                stdArray = std(blockMtx(channelIdx,:));
                arrayTemp = resample(blockMtx(channelIdx,:),newPointCount,sizeBlock(2));
                arrayTemp = (arrayTemp - meanArray)/stdArray;
                newBlockMtx(channelIdx,:) = arrayTemp;
                %Add any filtering you want
            end
            preProcessedTrainData{blockIdx, sexIdx, digitIdx} = newBlockMtx;
            listMeanArray(blockIdx)=mean(newBlockMtx(1,:));
        end
        a=mean(listMeanArray);
        b=std(listMeanArray);
        txt = ['Digit ',num2str(digitIdx),' Sex ',num2str(sexIdx),' Mean ',num2str(a),' Std ', num2str(b)];
        display(txt);
    end
end

%newPointCount = 40;
preProcessedTestData = cell(sizeTest(1), sizeTest(2), sizeTest(3));
for digitIdx = 1:10
    for sexIdx = 1:2
        listMeanArray = zeros(1,sizeTrain(1));
        for blockIdx = 1:sizeTest(1) %that's the number of blocks
            blockMtx = testData{blockIdx, sexIdx, digitIdx};
            sizeBlock = size(blockMtx);
            newBlockMtx = zeros(sizeBlock(1),newPointCount);
            for channelIdx = 1:sizeBlock(1)
                meanArray = mean(blockMtx(channelIdx,:));
                stdArray = std(blockMtx(channelIdx,:));
                arrayTemp = resample(blockMtx(channelIdx,:),newPointCount,sizeBlock(2));
                arrayTemp = (arrayTemp - meanArray)/stdArray;
                newBlockMtx(channelIdx,:) = arrayTemp;
                %Add any filtering you want
            end
            preProcessedTestData{blockIdx, sexIdx, digitIdx} = newBlockMtx;
            listMeanArray(blockIdx)=mean(newBlockMtx(1,:));
        end
        a=mean(listMeanArray);
        b=std(listMeanArray);
        txt = ['Digit ',num2str(digitIdx),' Sex ',num2str(sexIdx),' Mean ',num2str(a),' Std ', num2str(b)];
        display(txt);
    end
end
%plotDigitStuff
end

