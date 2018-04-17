function [correlationMatrix, corrSigma, corrVec] = neuronCorrelationFromTS(internalTS)
 
sizeInt = size(internalTS);
corrMtx = zeros(sizeInt(1),sizeInt(1));
 
%Normalization
avgTS = mean(internalTS,2)*ones(1,sizeInt(2));
stdTS = std(internalTS,0,2)*ones(1,sizeInt(2));
stdTS(avgTS ==0) = 1; %In case the average is zero, we avoid 0/0
normInternalTS = (internalTS - avgTS)./stdTS;
 
for i=1:sizeInt(2)
    vecStates = normInternalTS(:,i);
    corrMtx = corrMtx + vecStates*(vecStates');
end
 
correlationMatrix = corrMtx/sizeInt(2);
corrVec = reshape(triu(correlationMatrix,1),'',1);
corrVec = corrVec(corrVec ~= 0);
 
corrSigma = std(corrVec);
end

