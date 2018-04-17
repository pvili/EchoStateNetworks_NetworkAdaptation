function [ fftResp ] = normalizeFFTResp( fftMean, freqBins )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

% sigma = 1;
% sz = 1;    % length of gaussFilter vector
% x = linspace(-sz / 2, sz / 2, sz);
% gaussFilter = exp(-x .^ 2 / (2 * sigma ^ 2));
% gaussFilter = gaussFilter / sum (gaussFilter); % normalize


s=size(fftMean);
if nargin <2
    freqBins = s(1);
end
newFFTSize = s;
newFFTSize(1) = freqBins;
fftResp = zeros(newFFTSize);

if s(2) == 1
      fResp = fftMean;%conv(fftMean(:,i),gaussFilter, 'same');
      normFFT = fResp-mean(fResp);
      if(s(1) > freqBins)
          normFFT = interp1(0:(s(1)-1),normFFT,0:(s(1)/(freqBins)):(s(1)-1),'linear');     
      end
      fftResp = normFFT;
elseif length(s) == 2
    for i=1:s(2)
      fftResp(:,i) = normalizeFFTResp( fftMean(:,i), freqBins );
    end
else
    for l=1:s(3)
         fftResp(:,:,l) = normalizeFFTResp(fftMean(:,:,l),freqBins);
    end
end

end

