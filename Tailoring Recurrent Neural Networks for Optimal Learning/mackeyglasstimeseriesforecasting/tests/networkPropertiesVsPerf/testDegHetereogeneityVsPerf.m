addpath(genpath('../../'));
addpath('../../../networkCreationFiles');

numbTests=50;
netDim=1000;
inputLength=1;
outputLength=1;
specRad=1;

warningEigsId='MATLAB:eigs:TooManyRequestedEigsForComplexNonsym'; %bug in matlab: it does not let me use eig, but gives a warning if i use eigs
warning('off',warningEigsId);

gammaVec=[6,4.33333,3.5,3,2.66667,2.42857,2.25,2.11111,2];
connVec=[0.01, 0.04, 0.08];

NRMSEList=zeros(numbTests,length(connVec),length(gammaVec));
eigenVals=zeros(netDim, numbTests,length(connVec),length(gammaVec));

tic


for connIdx=1:length(connVec)
    for gammaIdx=1:length(gammaVec)
        for i=1:numbTests

            trainseq=generateMGTSequence(10000, 1000, 17, 10);
            testseq=generateMGTSequence(10000, 1000, 17, 10);        

            intWM=generateReservoirNetworkTopologies(netDim, connVec(connIdx), 1, 's', gammaVec(gammaIdx));
            [inWM, ofbWM, initialOutWM]=generateInOuMatrixes(netDim, inputLength, outputLength, 1);
            [outWM, intWM] = trainOutWMPrediction(intWM, inWM, ofbWM, trainseq, specRad);
            [e, NRMSE] = testPrediction(testseq, intWM, inWM, ofbWM, outWM);
            NRMSEList(i,connIdx,gammaIdx)=NRMSE;
            eigenVals(:,i,connIdx,gammaIdx)=eigs(intWM,netDim);

        end
        toc
    end
end

save('testSF_Connectivity_Alpha1.mat','NRMSEList','eigenVals', 'gammaVec', 'connVec','specRad');
