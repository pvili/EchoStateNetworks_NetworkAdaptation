addpath(genpath('..'))
%addpath('../networkCreationFiles')

netDim = 1000;
connectivity = 0.05; %must be larger than ln(400)/400 = 0.015
initLen = 500;
testCount = 400;
inputLength = 1;
freqBins = 201;
%load('C:\Users\Pau\Dropbox\30_ESN_Pau\code\CodeForPaper\DataAndPlotting\data\timeSeries\laserTS.mat')
dataLength = 16000%length(laserTS);

L=3
rVec = -1:0.1:1;
colorVec = ['b', 'g', 'k', 'y', 'r'];

fftMean = zeros(freqBins, length(rVec),L);
PSDMean = zeros(((freqBins+1)/2), length(rVec),L);


warningEigsId='MATLAB:eigs:TooManyRequestedEigsForRealSym';
warning('off',warningEigsId);
warningEigsId='MATLAB:eigs:TooManyRequestedEigsForComplexNonsym'; 
warning('off',warningEigsId);
avgLambda = 0.6;
tic


for l=1:L
    for i = 1:length(rVec)
        
        r = rVec(i);
        for test = 1:testCount
            Win = generateInOuMatrixes(netDim, inputLength, 1, 1);
            
            try
                W = createNetworkWithCyclesLengthEnhanced(netDim, connectivity, avgLambda, r, l); 
            catch
                try
                    W = createNetworkWithCyclesLengthEnhanced(netDim, connectivity, avgLambda, r, l); 
                catch
                    W = createNetworkWithCyclesLengthEnhanced(netDim, connectivity, avgLambda, r, l); 
                end
            end
            dataTS=randn(dataLength,1)+1/dataLength/2;%STD=VAR=1
            X = zeros( netDim, dataLength - initLen); 
            x = zeros(netDim,1);

            for t = 1:(dataLength) 
                u = dataTS(t); 
                x = tanh( Win*u + W*x );
                if t > initLen
                    X(:,t-initLen) = x;
                end
            end 

            for n=1:netDim
                [powerDensity, f] = periodogram( X(n,:),[], 'onesided',freqBins,1);
                fftMean(:,i,l) = fftMean(:,i,l) + abs(fft(X(n,:),freqBins))';
                PSDMean(:,i,l) = PSDMean(:,i,l) + powerDensity;
            end
        end
         fftMean(:,i,l) =  fftMean(:,i,l)/netDim/testCount;
         PSDMean(:,i,l) =  PSDMean(:,i,l)/netDim/testCount;
         toc
        i
    end  
        toc


end


save('./reservoirWithCyclesFreqResponse.mat','rVec','fftMean','PSDMean','netDim','connectivity','testCount','L','f')

