addpath(genpath('../../'));
addpath('../../../networkCreationFiles');

numberOfTestedSeries=200;
 numberOfDist=10;
 netDim=1000;
 connectivity=0.05;
 inputLength=1;
 outputLength=1;

testRunlength = 84;
minPowLev=2;
maxPowLev=5;
numberOfEigenv=netDim;

SF_Levels = [6, 5, 4.3333, 3.5, 3, 2.6666, 2.5, 2.25, 2.111, 2];


NRMSEList=zeros(numberOfTestedSeries,length(SF_Levels));
eigenValList=zeros(numberOfEigenv, numberOfTestedSeries,length(SF_Levels));

warningEigsId='MATLAB:eigs:TooManyRequestedEigsForComplexNonsym';
%bug in matlab: it does not let me use eig, but gives a warning if i use eigs
warning('off',warningEigsId);

t0=cputime;

disp('Scale Free');

specRadVec = [0.8,0.9,1]

for sRIdx = 1:length(specRadVec)
    alpha = specRadVec(sRIdx);
    for testSerie=1:numberOfTestedSeries
        t=cputime-t0;
        txt = [' Time series: ', num2str(testSerie), ' Net size: ', num2str(netDim), '  time ', num2str(t/60), 'm'];
        disp(txt);

        trainseq=generateMGTSequence(10000, 1000, 17, 10);
        testseq=generateMGTSequence(10000, 1000, 17, 10);

        for SFLevelN=1:length(SF_Levels)

            intWM=generateReservoirNetworkTopologies(netDim, connectivity, alpha, 's',SF_Levels(SFLevelN));
            [inWM, ofbWM, initialOutWM]=generateInOuMatrixes(netDim, inputLength, outputLength, 1);
            [outWM, intWM] = trainOutWMPrediction(intWM, inWM, ofbWM, trainseq, 1);
            [e, NRMSE] = testPrediction(testseq, intWM, inWM, ofbWM, outWM);
            NRMSEList(testSerie,SFLevelN) = NRMSE;
            eigenVals=eigs(intWM,numberOfEigenv);
            eigenValList(:,testSerie,SFLevelN)=eigenVals;
            
        end
    end

filename = ['../../Data/MG_SF_', date,'_MG17.mat'];
save(filename, 'NRMSEList', 'eigenValList', 'netDim', 'specRadVec', 'SF_Levels');
end