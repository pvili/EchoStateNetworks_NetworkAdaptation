addpath('../networkCreationFiles');

load('laserTS.mat');
 
winLength=3;
gaussFilter = gausswin(winLength);
gaussFilter = gaussFilter / sum(gaussFilter);
data = conv(laserTS,gaussFilter);
data = data(winLength:(end-winLength))';
numberOfTestedSeries = 200;

specRad = 1;
connectivity = 0.1;
netDim = 100;
inputLength = 2;
trainFraction = 0.6;
initFraction = 0.1;
forecastingSteps = 1;


AlphaVec=0.2:0.05:1;
numberOfDist=length(AlphaVec);

wId = 'MATLAB:eigs:TooManyRequestedEigsForComplexNonsym';
warning('off',wId)

tic
NRMSEList = zeros(numberOfTestedSeries,numberOfDist);
eigenValList = zeros(netDim,numberOfTestedSeries,numberOfDist);

for testSerie=1:numberOfTestedSeries

t=toc;
txt = ['   SeriesTest: ', num2str(testSerie),'  time ', num2str(t/60), 'm'];
disp(txt); 

    for ATry=1:length(AlphaVec)
        specRad = AlphaVec(ATry);
        W=generateReservoirNetworkEllyp(netDim, connectivity, specRad, 0);
        [Win]=generateInOuMatrixes(netDim, inputLength, 1, 1);
        [NRMSE, predictedSignal, StartTime] = predictSignalUnivariate(data, forecastingSteps, W, Win, trainFraction, initFraction);
        NRMSEList(testSerie,ATry) = NRMSE;
        eigenValList(:,testSerie,ATry) = eigs(W,netDim);
    end
end
filename = ['../Data/laser_SpecRad', date,'.mat'];
save(filename, 'NRMSEList', 'eigenValList', 'netDim', 'AlphaVec', 'connectivity');




minPowLev=2;
maxPowLev=5;
numberOfEigenv=netDim;
%specRad = 1;
numberOfDist = 10;

NRMSEList=zeros(numberOfTestedSeries,numberOfDist);
eigenValList=zeros(netDim, numberOfTestedSeries,numberOfDist);
powerLevels=minPowLev+(maxPowLev-minPowLev)/numberOfDist*(0:(numberOfDist-1));


warningEigsId='MATLAB:eigs:TooManyRequestedEigsForComplexNonsym';
%bug in matlab: it does not let me use eig, but gives a warning if i use eigs
warning('off',warningEigsId);

tic

disp('Power Law Weight');
specRadVec = [0.6,0.7]

for sRIdx = 1:length(specRadVec)
    alpha = specRadVec(sRIdx);
    for testSerie=1:numberOfTestedSeries
        txt = [' Time series: ', num2str(testSerie), ' Net size: ', num2str(netDim)];
        disp(txt);
        toc

        for powLevelN=1:numberOfDist

            W=generateNetworkPowerLaw(netDim, connectivity, alpha, powerLevels(powLevelN));
            [Win]=generateInOuMatrixes(netDim, inputLength, 1, 1);
            [NRMSE, predictedSignal, StartTime] = predictSignalUnivariate(data, forecastingSteps, W, Win, trainFraction, initFraction);
            NRMSEList(testSerie,powLevelN) = NRMSE;
            eigenValList(:,testSerie,powLevelN)=eigs(W,netDim);
        end

    end

filename = ['../Data/laser_PL_', date,'.mat'];
save(filename, 'NRMSEList', 'eigenValList', 'netDim', 'alpha','powerLevels', 'connectivity');
end




numberOfEigenv=netDim;

SF_Levels = [6, 5, 4.3333, 3.5, 3, 2.6666, 2.5, 2.25, 2.111, 2];


NRMSEList=zeros(numberOfTestedSeries,length(SF_Levels));
eigenValList=zeros(numberOfEigenv, numberOfTestedSeries,length(SF_Levels));

warningEigsId='MATLAB:eigs:TooManyRequestedEigsForComplexNonsym';
%bug in matlab: it does not let me use eig, but gives a warning if i use eigs
warning('off',warningEigsId);

disp('Scale Free');
tic
specRadVec = [0.6,0.7]

for sRIdx = 1:length(specRadVec)
    alpha = specRadVec(sRIdx);
    for testSerie=1:numberOfTestedSeries
        txt = [' Time series: ', num2str(testSerie), ' Net size: ', num2str(netDim)];
        disp(txt);
        toc


        for SFLevelN=1:length(SF_Levels)

            W=generateReservoirNetworkTopologies(netDim, connectivity, alpha, 's',SF_Levels(SFLevelN));
            [Win]=generateInOuMatrixes(netDim, inputLength, 1, 1);
            [NRMSE, predictedSignal, StartTime] = predictSignalUnivariate(data, forecastingSteps, W, Win, trainFraction, initFraction);
            NRMSEList(testSerie,SFLevelN) = NRMSE;
            eigenVals=eigs(W,numberOfEigenv);
            eigenValList(:,testSerie,SFLevelN)=eigenVals;
            
        end
    end

filename = ['../Data/laser_SF', date,'.mat'];
save(filename, 'NRMSEList', 'eigenValList', 'netDim', 'specRadVec', 'connectivity','SF_Levels');
end




% %
% specRad = 0.65;
% connectivity = 0.1;
% netDim = 100;
% inputLength = 2;
% trainFraction = 0.6;
% initFraction = 0.1;
% forecastingSteps = 1;
% 
% rVec = -1:0.05:1;
% testCount= 200;
% 
% NRMSEList = zeros(testCount, length(rVec));
% 
% for i=1:length(rVec)
% for t=1:200
%     
%     W = generateReservoirNetworkEllyp(netDim, connectivity, specRad, rVec(i));
%     [Win]=generateInOuMatrixes(netDim, inputLength, 1, 1);
%     [mse, predictedSignal, StartTime] = predictSignalUnivariate(data, forecastingSteps, W, Win, trainFraction, initFraction);
%     NRMSEList(t,i) = mse;
%     %predictSignalSimple(data, forecastingSteps, W, Win, trainFraction, initFraction, 1e-4);
% end
% 
% end
% save('.\Results\rhoLaser_Alpha065.mat','rVec','NRMSEList')