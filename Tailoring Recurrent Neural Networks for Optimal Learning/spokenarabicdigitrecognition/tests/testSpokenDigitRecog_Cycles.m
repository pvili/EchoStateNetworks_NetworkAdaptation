load('../DataSpokenArabicDigit/ArabicDigitData_preprocessed.mat')
addpath('../../networkCreationFiles');
addpath(genpath('../'))


netDim = 100;
connectivity = 0.1;
specRad = 1;
channels = 1;
numbTests = 200;

channelsVec = 1:13;
rVec = -1:0.1:1;
lambda = 0.62;
normMethod = 'l';

L=3;

correctDigitMtx = zeros(channels, 2, 10, numbTests, length(rVec), L, channels);
correctSexMtx = zeros(channels, 2, 10, numbTests, length(rVec), L, channels);


warningEigsId='MATLAB:eigs:TooManyRequestedEigsForRealSym';
warning('off',warningEigsId);
warningEigsId='MATLAB:eigs:TooManyRequestedEigsForComplexNonsym'; 
warning('off',warningEigsId);

tic

   for l=1:L
    for rIdx = 1:length(rVec)
        r = rVec(rIdx);
        toc
        for t=1:numbTests
            try
            W = createNetworkWithCycles(netDim, connectivity, lambda, r, l, normMethod) ;
            Win = generateInOuMatrixes(netDim, length(channels)+1);
            [correctDigitMtx(:,:,:,t,rIdx,l,channels), correctSexMtx(:,:,:,t,rIdx,l,channels) ] = trainTestArabDigitRecognition( W, Win, trainData,testData,channels);
            catch
                try
                    W = createNetworkWithCycles(netDim, connectivity, lambda, r, l, normMethod) ;
                    Win = generateInOuMatrixes(netDim, length(channels)+1);
                    [correctDigitMtx(:,:,:,t,rIdx,l,channels), correctSexMtx(:,:,:,t,rIdx,l,channels) ] = trainTestArabDigitRecognition( W, Win, trainData,testData,channels);
                catch
                    W = createNetworkWithCycles(netDim, connectivity, lambda, r, l, normMethod) ;
                    Win = generateInOuMatrixes(netDim, length(channels)+1);
                    [correctDigitMtx(:,:,:,t,rIdx,l,channels), correctSexMtx(:,:,:,t,rIdx,l,channels) ] = trainTestArabDigitRecognition( W, Win, trainData,testData,channels);
                end
            end
        end
    end
   end

correctDigitMtx = squeeze(correctDigitMtx);%in case we use more channels

filename = ['arabDigitPerformanceCycles',date,'.mat']
save(filename, 'correctDigitMtx', 'rVec', 'lambda', 'connectivity', 'netDim', 'normMethod');

