function [ rhoVec, freqProd, rhoIdxVec ] = findRhoHeuristic( fftRespData, signalFFT , freqBins)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
if nargin <3
    freqBins = length(signalFFT);
end
if isrow(signalFFT)
   signalFFT = signalFFT';
end

rVec = (-1:0.1:1)';
fftResp = normalizeFFTResp( fftRespData, freqBins );
s = size(fftRespData);
fftSig = normalizeFFTResp(signalFFT, freqBins);
if isrow(fftSig)
   fftSig = fftSig';
end

rhoIdxVec = zeros(1,s(3));
freqProdVec = zeros(1,s(3));
freqProd = zeros(s(2:3));

for l=1:s(3)
    for i=1:s(2)
      freqProd(i,l) = (mean(fftResp(:,i,l).*fftSig));
    end
    subplot(3,1,l)
    plot(freqProd(:,l));
    [freqProdVec(l), rhoIdxVec(l)] = max(freqProd(:,l));
    %mean(freqProd(:,l).*rVec)/mean(abs(freqProd(:,l)));
    
end

rhoVec = rVec(rhoIdxVec);
end

