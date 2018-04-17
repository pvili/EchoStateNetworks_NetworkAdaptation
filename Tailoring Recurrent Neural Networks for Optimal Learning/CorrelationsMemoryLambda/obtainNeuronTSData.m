function [sigmaCorr, Lambda, corrMtx] = obtainNeuronTSData(W, Win, dataLength, initLen)

sizeWin = size(Win);
inSize = sizeWin(2);
netDim = length(W);
dataTS=2*rand(dataLength,1)-1;%generateMGTSequence(dataLength,initLen, 17, 10);

X = zeros(inSize + netDim, dataLength - initLen); 
% run the reservoir with the data and collect X 
%ER
x = zeros(netDim,1); 
for t = 1:(dataLength) 
    u = dataTS(t); 
    x = tanh( x + Win*u + W*x );
    if t > initLen
        X(:,t-initLen) = [u;x];
    end
end % train the output   

try
    Lambda = mean(abs(eigs(W,netDim)));
catch
    Lambda = mean(abs(eig(full(W))));
end
%Lambda = spectralMetric(eigs(W,netDim));
[corrMtx, sigmaCorr] = neuronCorrelationFromTS(X(2:end,:));

%NOTE: this should contain the same info as the correlations, verify!
%meanRedundantInfo=computeMeanNonRedundantInfoFromTS( X(2:end,:) );