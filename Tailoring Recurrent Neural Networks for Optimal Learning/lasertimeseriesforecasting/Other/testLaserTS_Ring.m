addpath('../networkCreationFiles');


load('laserTS.mat');
winLength=3;
gaussFilter = gausswin(winLength);
gaussFilter = gaussFilter / sum(gaussFilter);
data = conv(laserTS,gaussFilter);
data = data(winLength:(end-winLength))';

lambda = 0.40;
specRadVec = [0.6, 0.7, 0.8, 0.9];
netDim = 100;
inputLength = 2;
trainFraction = 0.6;
initFraction = 0.1;
forecastingSteps = 1;

connectivityVec = [0.02, 0.04, 0.08, 0.16, 0.32];
testCount= 200;

NRMSEList_Unidirectional = zeros(testCount, length(connectivityVec), length(specRadVec));
NRMSEList_Bidirectional = zeros(testCount, length(connectivityVec), length(specRadVec));

lambdaVec_Bidirectional = zeros(testCount, length(connectivityVec), length(specRadVec));
lambdaVec_Unidirectional = zeros(testCount, length(connectivityVec), length(specRadVec));

warningEigsId='MATLAB:eigs:TooManyRequestedEigsForComplexNonsym';
%bug in matlab: it does not let me use eig, but gives a warning if i use eigs
warning('off',warningEigsId);

tic

for s=1:length(specRadVec)
    specRad = specRadVec(s);
    for i=1:length(connectivityVec)
        toc
        c=connectivityVec(i)
        for t=1:testCount
            [Win]=generateInOuMatrixes(netDim, inputLength, 1, 1);

            W = generateReservoirNetworkTopologies(netDim, c, specRad, 'w', 0);
            [mse] = predictSignalUnivariate(data, forecastingSteps, W, Win, trainFraction, initFraction);
            NRMSEList_Bidirectional(t,i,s) = mse;
            lambdaVec_Bidirectional(t,i,s) = mean(abs(eigs(W,netDim)));

            W = generateReservoirNetworkTopologies(netDim, c, specRad, 'c', 0);
            [mse] = predictSignalUnivariate(data, forecastingSteps, W, Win, trainFraction, initFraction);
            NRMSEList_Unidirectional(t,i,s) = mse;
            lambdaVec_Unidirectional(t,i,s) = mean(abs(eigs(W,netDim)));

        end
    end
end

save('LasetTest_Rings.mat','connectivityVec','NRMSEList_Unidirectional','NRMSEList_Bidirectional','specRadVec', 'lambdaVec_Unidirectional', 'lambdaVec_Bidirectional');
