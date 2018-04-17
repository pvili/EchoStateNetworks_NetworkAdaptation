function [ rhoVec, rhoIdx ] = findOptimalRhoCombination( fftRespData, signalFFT, rhoSum, LVec )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
if nargin < 4
    sR = size(fftRespData);
    LVec = 1:sR(end);
end
rhoSum = min(rhoSum,1);

fftResp = normalizeFFTResp( fftRespData );

[ rhoVec, freqProd, rhoIdxVec ] = findRhoHeuristic( fftRespData, signalFFT);

rVec = -1:0.1:1;
L1Norm = sum(abs(rhoVec));
if L1Norm > rhoSum
    freqOverlap = zeros(21,21,21);
    for i=1:21
        freqOverlap(i, :, :) = freqOverlap(i, :, :) + ones(1,21,21)*freqProd(i,1);
        freqOverlap(:, i, :) = freqOverlap(:, i, :) + ones(21,1,21)*freqProd(i,2);  
        freqOverlap(:, :, i) = freqOverlap(:, :, i) + ones(21,21,1)*freqProd(i,3);     
    end
    
    impossibleRhoL1 = zeros(21,21,21);
    
    i=11;
    for i=1:21
        for j=1:21
            for k=1:21
                if 0.1*(abs(i-11) + abs(j-11) + abs(k-11)) > rhoSum
                    impossibleRhoL1(i,j,k) = -inf;
                end
            end
        end
    end
%     
    middleRVec = 11;
    nonValidLengths = zeros(21,21,21);
%     
    for i=1:21
        for j=1:21
            for k=1:21
            if ~sum(LVec==3) && k~=middleRVec
                nonValidLengths(i,j,k) = -inf;
            end
            if ~sum(LVec==1) && i~=middleRVec
                nonValidLengths(i,j,k) = -inf;
            end
            if ~sum(LVec==2) && j~=middleRVec
                nonValidLengths(i,j,k) = -inf;
            end
            end
        end
    end
%     
    freqOverlap = freqOverlap + impossibleRhoL1 +nonValidLengths;
    
    [ maxVal, rhoIdx ] = max3dArray( freqOverlap );
    rhoVec = rVec(rhoIdx);
    
end




end

