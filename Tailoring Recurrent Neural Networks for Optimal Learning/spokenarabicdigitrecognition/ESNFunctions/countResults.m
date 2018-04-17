function [digitCorrectFractionErrorMtx, sexCorrectFractionMtx] = countResults(testDigit, testSex)
 
sTestDigit = size(testDigit); 
sTestSex = size(testSex); 
     
sexCorrectFractionMtx = zeros(sTestDigit(2), sTestDigit(3));
digitCorrectFractionErrorMtx = zeros(sTestSex(2), sTestSex(3));
 
for digitIdx = 1:sTestDigit(3)
    for sexIdx = 1:sTestDigit(2)
        vecCorrectSex = testSex(:,sexIdx, digitIdx)==(ones(sTestSex(1),1)*sexIdx);
        vecCorrectDigit = testDigit(:,sexIdx, digitIdx)==(ones(sTestSex(1),1)*digitIdx);
        sexCorrectFractionMtx(sexIdx, digitIdx) = mean(vecCorrectSex);
        digitCorrectFractionErrorMtx(sexIdx, digitIdx) = mean(vecCorrectDigit);
    end
end
 
end
