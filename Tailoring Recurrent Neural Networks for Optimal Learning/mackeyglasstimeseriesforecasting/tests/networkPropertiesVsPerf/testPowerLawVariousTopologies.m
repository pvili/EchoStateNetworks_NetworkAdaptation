addpath(genpath('../../'));
addpath('../../../networkCreationFiles');

%numberOftests = 50;
numberOfTestedSeries=100;

netDim=1000;
connectivity=0.05;
inputLength=1;
outputLength=1;
numberOfEigenv=netDim;
powerLevels=1.8:0.2:3.8;
numberOfDist = length(powerLevels);


NRMSEListER=zeros(numberOfTestedSeries,numberOfDist);
NRMSEListSF2=zeros(numberOfTestedSeries,numberOfDist);
NRMSEListSF3=zeros(numberOfTestedSeries,numberOfDist);
NRMSEListSF6=zeros(numberOfTestedSeries,numberOfDist);
NRMSEListC=zeros(numberOfTestedSeries,numberOfDist);
NRMSEListR=zeros(numberOfTestedSeries,numberOfDist);

eigenVals=zeros(numberOfEigenv, numberOfTestedSeries,numberOfDist);
radialSpectralDensity=zeros(numberOfTestedSeries,numberOfDist);

t0=0;
tic
for testSerie=1:numberOfTestedSeries
    t=toc;
    txt = [' Time series: ', num2str(testSerie), ' Net size: ', num2str(netDim), '  time ', num2str((t-t0)/60), 'm'];
    t0=t;
    disp(txt);

    trainseq=generateMGTSequence(10000, 1000, 17, 10);
    testseq=generateMGTSequence(10000, 1000, 17, 10);

    for powLevelN=1:numberOfDist
        
        intWM=generateReservoirNetworkTopologies(netDim, connectivity, 1, 'e', 0, 'p', powerLevels(powLevelN));
        [inWM, ofbWM]=generateInOuMatrixes(netDim, inputLength, outputLength, 1);
        [outWM, intWM] = trainOutWMPrediction(intWM, inWM, ofbWM, trainseq, 0.85);
        [e, NRMSE] = testPrediction(testseq, intWM, inWM, ofbWM, outWM);
        NRMSEListER(testSerie,powLevelN) = NRMSE;
        
        intWM=generateReservoirNetworkTopologies(netDim, connectivity, 1, 's', 2, 'p', powerLevels(powLevelN));
        [inWM, ofbWM]=generateInOuMatrixes(netDim, inputLength, outputLength, 1);
        [outWM, intWM] = trainOutWMPrediction(intWM, inWM, ofbWM, trainseq, 0.85);
        [e, NRMSE] = testPrediction(testseq, intWM, inWM, ofbWM, outWM);
        NRMSEListSF2(testSerie,powLevelN) = NRMSE;
        
        intWM=generateReservoirNetworkTopologies(netDim, connectivity, 1, 's', 3, 'p', powerLevels(powLevelN));
        [inWM, ofbWM]=generateInOuMatrixes(netDim, inputLength, outputLength, 1);
        [outWM, intWM] = trainOutWMPrediction(intWM, inWM, ofbWM, trainseq, 0.85);
        [e, NRMSE] = testPrediction(testseq, intWM, inWM, ofbWM, outWM);
        NRMSEListSF3(testSerie,powLevelN) = NRMSE;
        
        intWM=generateReservoirNetworkTopologies(netDim, connectivity, 1, 's', 6, 'p', powerLevels(powLevelN));
        [inWM, ofbWM]=generateInOuMatrixes(netDim, inputLength, outputLength, 1);
        [outWM, intWM] = trainOutWMPrediction(intWM, inWM, ofbWM, trainseq, 0.85);
        [e, NRMSE] = testPrediction(testseq, intWM, inWM, ofbWM, outWM);
        NRMSEListSF6(testSerie,powLevelN) = NRMSE;
        
        intWM=generateReservoirNetworkTopologies(netDim, connectivity, 1, 'w', 0, 'p', powerLevels(powLevelN));
        [inWM, ofbWM]=generateInOuMatrixes(netDim, inputLength, outputLength, 1);
        [outWM, intWM] = trainOutWMPrediction(intWM, inWM, ofbWM, trainseq, 0.85);
        [e, NRMSE] = testPrediction(testseq, intWM, inWM, ofbWM, outWM);
        NRMSEListC(testSerie,powLevelN) = NRMSE;
        
        intWM=generateReservoirNetworkTopologies(netDim, connectivity, 1, 'r', 0, 'p', powerLevels(powLevelN));
        [inWM, ofbWM]=generateInOuMatrixes(netDim, inputLength, outputLength, 1);
        [outWM, intWM] = trainOutWMPrediction(intWM, inWM, ofbWM, trainseq, specRad);
        [e, NRMSE] = testPrediction(testseq, intWM, inWM, ofbWM, outWM);
        NRMSEListR(testSerie,powLevelN) = NRMSE;
        
    end

end


filename = ['testPowerLawVariousTopologies_' date '.mat'];
save(filename,'netDim','powerLevels','NRMSEListC','NRMSEListER','NRMSEListSF6','NRMSEListSF3', 'NRMSEListSF2');