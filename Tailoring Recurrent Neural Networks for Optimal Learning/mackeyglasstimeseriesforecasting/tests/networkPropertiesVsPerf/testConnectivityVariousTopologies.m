addpath(genpath('../../'));
addpath('../../../networkCreationFiles');

numberOftests=100;
specRad=1;

netDim=1000;
connectivity=0.05;
connectivityVec = 0.01:0.01:0.1;
inputLength=1;
outputLength=1;

NRMSEListC=zeros(numberOftests,length(connectivityVec));
NRMSEListER=zeros(numberOftests,length(connectivityVec));
NRMSEListSF6=zeros(numberOftests,length(connectivityVec));
NRMSEListSF3=zeros(numberOftests,length(connectivityVec));
NRMSEListSF2=zeros(numberOftests,length(connectivityVec));
NRMSEListR=zeros(numberOftests,length(connectivityVec));

tic;

for testSerie=58:numberOftests
    t=toc;
    txt = [' Time series: ', num2str(testSerie), ' Net size: ', num2str(netDim), '  time ', num2str(t/60), 'm'];
    disp(txt);

    trainseq=generateMGTSequence(10000, 1000, 17, 10);
    testseq=generateMGTSequence(10000, 1000, 17, 10);

    for c=1:length(connectivityVec)
        connectivity = connectivityVec(c);
        
        intWM=generateReservoirNetworkTopologies(netDim, connectivity, 1, 'w', 0);
        [inWM, ofbWM]=generateInOuMatrixes(netDim, inputLength, outputLength, 1);
        [outWM, intWM] = trainOutWMPrediction(intWM, inWM, ofbWM, trainseq, specRad);
        [e, NRMSE] = testPrediction(testseq, intWM, inWM, ofbWM, outWM);
        NRMSEListC(testSerie,c) = NRMSE;

        intWM=generateReservoirNetworkTopologies(netDim, connectivity, 1, 'e', 0);
        [inWM, ofbWM]=generateInOuMatrixes(netDim, inputLength, outputLength, 1);
        [outWM, intWM] = trainOutWMPrediction(intWM, inWM, ofbWM, trainseq, specRad);
        [e, NRMSE] = testPrediction(testseq, intWM, inWM, ofbWM, outWM);
        NRMSEListER(testSerie,c) = NRMSE;

        intWM=generateReservoirNetworkTopologies(netDim, connectivity, 1, 's', 6);
        [inWM, ofbWM]=generateInOuMatrixes(netDim, inputLength, outputLength, 1);
        [outWM, intWM] = trainOutWMPrediction(intWM, inWM, ofbWM, trainseq, specRad);
        [e, NRMSE] = testPrediction(testseq, intWM, inWM, ofbWM, outWM);
        NRMSEListSF6(testSerie,c) = NRMSE;
 
        intWM=generateReservoirNetworkTopologies(netDim, connectivity, 1, 's', 3);
        [inWM, ofbWM]=generateInOuMatrixes(netDim, inputLength, outputLength, 1);
        [outWM, intWM] = trainOutWMPrediction(intWM, inWM, ofbWM, trainseq, specRad);
        [e, NRMSE] = testPrediction(testseq, intWM, inWM, ofbWM, outWM);
        NRMSEListSF3(testSerie,c) = NRMSE;
    
        intWM=generateReservoirNetworkTopologies(netDim, connectivity, 1, 's', 2);
        [inWM, ofbWM]=generateInOuMatrixes(netDim, inputLength, outputLength, 1);
        [outWM, intWM] = trainOutWMPrediction(intWM, inWM, ofbWM, trainseq, specRad);
        [e, NRMSE] = testPrediction(testseq, intWM, inWM, ofbWM, outWM);
        NRMSEListSF2(testSerie,c) = NRMSE;
        
        intWM=generateReservoirNetworkTopologies(netDim, connectivity, 1, 'r', 0);
        [inWM, ofbWM]=generateInOuMatrixes(netDim, inputLength, outputLength, 1);
        [outWM, intWM] = trainOutWMPrediction(intWM, inWM, ofbWM, trainseq, specRad);
        [e, NRMSE] = testPrediction(testseq, intWM, inWM, ofbWM, outWM);
        NRMSEListR(testSerie,c) = NRMSE;
    end
    
end

filename = ['testConnectivityVariousTopologies_' date '_Alpha1.mat'];
save(filename,'netDim','connectivityVec','NRMSEListC','NRMSEListR','NRMSEListER','NRMSEListSF6','NRMSEListSF3', 'NRMSEListSF2','specRad');
%plotTestWeightDist_II