addpath(genpath('../../'));
addpath('../../../networkCreationFiles');
 
numberOfTestedSeries=200; 
mackeyDelay=17;

testRunlength = 84;
netDim=1000;
connectivity=0.05;
inputLength=1;
outputLength=1;

seqLength=10000;

AlphaVec=0.5:0.05:1;
numberOfDist=length(AlphaVec);


NRMSEList = zeros(numberOfTestedSeries,numberOfDist);
eigenValList = zeros(netDim,numberOfTestedSeries,numberOfDist);


t0=cputime;

warningEigsId='MATLAB:eigs:TooManyRequestedEigsForComplexNonsym';
%bug in matlab: it does not let me use eig, but gives a warning if i use eigs
warning('off',warningEigsId);

disp('Spectral Radius');

tic  
t=0;


for testSerie=1:numberOfTestedSeries

t=toc;
txt = ['   SeriesTest: ', num2str(testSerie),'  time ', num2str(t/60), 'm'];
disp(txt); 

    trainseq=generateMGTSequence(10000, 1000, mackeyDelay, 10);
    testseq=generateMGTSequence(10000, 1000, mackeyDelay, 10); 

    for ATry=1:numberOfDist
        intWM=generateReservoirNetworkTopologies(netDim, connectivity, 1, 'e',0);
        [inWM, ofbWM, initialOutWM]=generateInOuMatrixes(netDim, inputLength, outputLength, 1);
        [outWM, intWM] = trainOutWMPrediction(intWM, inWM, ofbWM, trainseq, AlphaVec(ATry));
        [e, NRMSE] = testPrediction(testseq, intWM, inWM, ofbWM, outWM);
        NRMSEList(testSerie,ATry) = NRMSE;
        eigenValList(:,testSerie,ATry) = eigs(intWM,netDim);
    end
end


filename = ['../../Data/MG_SpecRad_',date,'_MG17.mat'];

%filename=[filename,date,'.mat'];
save(filename, 'NRMSEList', 'eigenValList', 'netDim', 'AlphaVec');