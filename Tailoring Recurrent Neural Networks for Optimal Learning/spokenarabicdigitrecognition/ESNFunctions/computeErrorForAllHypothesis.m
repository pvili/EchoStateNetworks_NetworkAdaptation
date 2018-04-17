function [ digit, sex,  testErrorArray] = computeErrorForAllHypothesis( reservoirStates, realSignal, WoutSet , channelWeights)
sizeWoutSet = size(WoutSet);
if nargin < 4
    channelWeights = ones(1,sizeWoutSet(1))/sizeWoutSet(1);
end


sizeWoutSet = size(WoutSet);

testErrorArray = zeros(sizeWoutSet(1),sizeWoutSet(3),sizeWoutSet(4));
testErrorMin = 100;
for digitIdx = 1:sizeWoutSet(4)
    for sexIdx = 1:sizeWoutSet(3)
        
        forecastedSignal = WoutSet(:,:,sexIdx,digitIdx)*reservoirStates;
        testError = sqrt(mean((realSignal-forecastedSignal).^2,2));
        testErrorArray(:,sexIdx,digitIdx) = testError;
        combTestError = channelWeights*testError;
        if combTestError < testErrorMin
            digit = digitIdx;
            sex = sexIdx;
            testErrorMin = combTestError ;
        end
    end
end
end

