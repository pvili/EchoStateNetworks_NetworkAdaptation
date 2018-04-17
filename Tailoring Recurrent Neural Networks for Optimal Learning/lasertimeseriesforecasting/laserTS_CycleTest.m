addpath('../networkCreationFiles');


load('laserTS.mat');
winLength=3;
gaussFilter = gausswin(winLength);
gaussFilter = gaussFilter / sum(gaussFilter);
data = conv(laserTS,gaussFilter);
data = data(winLength:(end-winLength))';

lambda = 0.42;
lambda = 0.7;
specRad = 0.7;
connectivity = 0.1;
netDim = 100;
inputLength = 2;
trainFraction = 0.6;
initFraction = 0.1;
forecastingSteps = 1;
normMethod = 's';

rVec = -1:0.1:1;
testCount= 200;
L=3;

NRMSEList = zeros(testCount, length(rVec), L);

warningEigsId='MATLAB:eigs:TooManyRequestedEigsForComplexNonsym';
%bug in matlab: it does not let me use eig, but gives a warning if i use eigs
warning('off',warningEigsId);

tic
for l = 1:L
    l
for i=1:length(rVec)
    toc
    rVec(i)
for t=1:200
    
    try
    
    W = createNetworkWithCycles(netDim, connectivity, lambda, rVec(i), l , normMethod) ;
    [Win]=generateInOuMatrixes(netDim, inputLength, 1, 1);
    [mse, predictedSignal, StartTime] = predictSignalUnivariate(data, forecastingSteps, W, Win, trainFraction, initFraction);
    NRMSEList(t,i,l) = mse;
    
    catch
        try
            W = createNetworkWithCycles(netDim, connectivity, lambda, rVec(i), l, normMethod) ;
            [Win]=generateInOuMatrixes(netDim, inputLength, 1, 1);
            [mse, predictedSignal, StartTime] = predictSignalUnivariate(data, forecastingSteps, W, Win, trainFraction, initFraction);
            NRMSEList(t,i,l) = mse;
        catch
            W = createNetworkWithCycles(netDim, connectivity, lambda, rVec(i), l, normMethod) ;
            [Win]=generateInOuMatrixes(netDim, inputLength, 1, 1);
            [mse, predictedSignal, StartTime] = predictSignalUnivariate(data, forecastingSteps, W, Win, trainFraction, initFraction);
            NRMSEList(t,i,l) = mse;
        end
    end
    

end
end
end
filename = ['LaserTest_Cycles',date,'.mat'];
save(filename,'rVec','NRMSEList','L','lambda', 'normMethod');
