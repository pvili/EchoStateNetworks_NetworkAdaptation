addpath(genpath('../../'));
addpath('../../../networkCreationFiles');

 numberOfTestedSeries=200;
 numberOfDist=10;
 netDim=1000;
 connectivity=0.05;
 inputLength=1;
 outputLength=1;

testRunlength = 84;%prediction steps
minPowLev=2;
maxPowLev=5;
numberOfEigenv=netDim;
%specRad = 1;

NRMSEList=zeros(numberOfTestedSeries,numberOfDist);
eigenValList=zeros(netDim, numberOfTestedSeries,numberOfDist);
powerLevels=minPowLev+(maxPowLev-minPowLev)/numberOfDist*(0:(numberOfDist-1));

warningEigsId='MATLAB:eigs:TooManyRequestedEigsForComplexNonsym';
%bug in matlab: it does not let me use eig, but gives a warning if i use eigs
warning('off',warningEigsId);

t0=cputime;

disp('Power Law Weight');
specRadVec = [0.8,0.9,1]

for sRIdx = 1:length(specRadVec)
    alpha = specRadVec(sRIdx);
    for testSerie=1:numberOfTestedSeries
        t=cputime-t0;
        txt = [' Time series: ', num2str(testSerie), ' Net size: ', num2str(netDim), '  time ', num2str(t/60), 'm'];
        disp(txt);

        trainseq=generateMGTSequence(10000, 1000, 17, 10);
        testseq=generateMGTSequence(10000, 1000, 17, 10);

        for powLevelN=1:numberOfDist
            intWM=generateReservoirNetworkTopologies(netDim, connectivity, alpha, 'e', 0, 'p', powerLevels(powLevelN));
            [inWM, ofbWM, initialOutWM]=generateInOuMatrixes(netDim, inputLength, outputLength, 1);
            [outWM, intWM] = trainOutWMPrediction(intWM, inWM, ofbWM, trainseq, 1);
            [e, NRMSE] = testPrediction(testseq, intWM, inWM, ofbWM, outWM);
            NRMSEList(testSerie,powLevelN) = NRMSE;
            eigenValList(:,testSerie,powLevelN)=eigs(intWM,netDim);
        end

    end

filename = ['../../Data/MG_PL_', date,'_MG17.mat'];
save(filename, 'NRMSEList', 'eigenValList', 'netDim', 'alpha','powerLevels');
end