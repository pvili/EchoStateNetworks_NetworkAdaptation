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
lambda = 0.55; 
normMethod = 'l';

rVec = -1:0.1:1;
testCount= 200;
L=3;

NRMSEList = zeros(numberOfTestedSeries,length(rVec), L);


warningEigsId='MATLAB:eigs:TooManyRequestedEigsForComplexNonsym';
%bug: Matlab does not let me use eig, but gives a warning if i use eigs
warning('off',warningEigsId);

 

tic
disp('Cycles MG');
    
for l=1:L
%l=1

    for RTry=1:length(rVec)
        toc
        RTry
        for testSerie=1:numberOfTestedSeries
            try
	            NRMSE =  testOnceCycles( netDim, connectivity, lambda, rVec(RTry), l, normMethod);
            catch
                try 
                    NRMSE =  testOnceCycles( netDim, connectivity, lambda, rVec(RTry), l, normMethod);
                catch 
                    NRMSE =  testOnceCycles( netDim, connectivity, lambda, rVec(RTry), l, normMethod);
                end
            end
            NRMSEList(testSerie,RTry,l) = NRMSE;
        end
    end
end

filename=['../../Data/MG_Cycles_',date,'.mat'];
save(filename, 'NRMSEList',  'netDim', 'lambda', 'rVec','L', 'normMethod');