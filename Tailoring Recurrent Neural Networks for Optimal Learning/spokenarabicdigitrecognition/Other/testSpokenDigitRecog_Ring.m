load('../DataSpokenArabicDigit/ArabicDigitData_preprocessed.mat')
addpath('../../networkCreationFiles');
addpath(genpath('../'))

netDim = 100;
connectivityVec = [0.02, 0.04, 0.08, 0.16];
specRad = 1;
channels = 1;
numbTests = 100;
inputLength = 2


channelsVec = 1:13;
specRadVec = 0.8:0.1:1.1;
lambda = 0.62;


correctDigitMtx_Unidirectional = zeros(channels, 2, 10, numbTests, length(connectivityVec), length(specRadVec),channels);
correctDigitMtx_Bidirectional = zeros(channels, 2, 10, numbTests, length(connectivityVec), length(specRadVec),channels);

correctSexMtx = zeros(channels, 2, 10, numbTests, length(connectivityVec), length(specRadVec), channels);

lambdaMtx_Unidirectional = zeros(numbTests, length(connectivityVec), length(specRadVec));
lambdaMtx_Bidirectional = zeros(numbTests, length(connectivityVec), length(specRadVec));

warningEigsId='MATLAB:eigs:TooManyRequestedEigsForComplexNonsym';
%bug in matlab: it does not let me use eig, but gives a warning if i use eigs
warning('off',warningEigsId);
		
tic

for s=1:length(specRadVec)
    specRad = specRadVec(s)
    for i=1:length(connectivityVec)
        toc
        c=connectivityVec(i)
        
        for t=1:numbTests
            
           try
            [Win]=generateInOuMatrixes(netDim, inputLength, 1, 1);
            W = generateReservoirNetworkTopologies(netDim, c, specRad, 'w', 0);
            lambdaMtx_Bidirectional(t,i,s) = mean(abs(eigs(W,netDim)));
            [correctDigitMtx_Bidirectional(:,:,:,t,i,s,channels), correctSexMtx(:,:,:,t,i,s,channels) ] = trainTestArabDigitRecognition( W, Win, trainData,testData,channels);
            catch
                try
                    [Win]=generateInOuMatrixes(netDim, inputLength, 1, 1);
                    W = generateReservoirNetworkTopologies(netDim, c, specRad, 'w', 0);
                    lambdaMtx_Bidirectional(t,i,s) = mean(abs(eigs(W,netDim)));
                    [correctDigitMtx_Bidirectional(:,:,:,t,i,s,channels), correctSexMtx(:,:,:,t,i,s,channels) ] = trainTestArabDigitRecognition( W, Win, trainData,testData,channels);
                catch
                    [Win]=generateInOuMatrixes(netDim, inputLength, 1, 1);
                    W = generateReservoirNetworkTopologies(netDim, c, specRad, 'w', 0);
                    lambdaMtx_Bidirectional(t,i,s) = mean(abs(eigs(W,netDim)));
                    [correctDigitMtx_Bidirectional(:,:,:,t,i,s,channels), correctSexMtx(:,:,:,t,i,s,channels) ] = trainTestArabDigitRecognition( W, Win, trainData,testData,channels);
                end
           end
           
          try
            [Win]=generateInOuMatrixes(netDim, inputLength, 1, 1);
            W = generateReservoirNetworkTopologies(netDim, c, specRad, 'c', 0);
            lambdaMtx_Unidirectional(t,i,s) = mean(abs(eigs(W,netDim)));
            [correctDigitMtx_Unidirectional(:,:,:,t,i,s,channels), correctSexMtx(:,:,:,t,i,s,channels) ] = trainTestArabDigitRecognition( W, Win, trainData,testData,channels);
            catch
                try
                    [Win]=generateInOuMatrixes(netDim, inputLength, 1, 1);
                    W = generateReservoirNetworkTopologies(netDim, c, specRad, 'c', 0);
                    lambdaMtx_Unidirectional(t,i,s) = mean(abs(eigs(W,netDim)));
                    [correctDigitMtx_Unidirectional(:,:,:,t,i,s,channels), correctSexMtx(:,:,:,t,i,s,channels) ] = trainTestArabDigitRecognition( W, Win, trainData,testData,channels);
                catch
                    [Win]=generateInOuMatrixes(netDim, inputLength, 1, 1);
                    W = generateReservoirNetworkTopologies(netDim, c, specRad, 'c', 0);
                    lambdaMtx_Unidirectional(t,i,s) = mean(abs(eigs(W,netDim)));
                    [correctDigitMtx_Unidirectional(:,:,:,t,i,s,channels), correctSexMtx(:,:,:,t,i,s,channels) ] = trainTestArabDigitRecognition( W, Win, trainData,testData,channels);
                end
           end
        end
      end
end


correctDigitMtx_Unidirectional = squeeze(correctDigitMtx_Unidirectional);
correctDigitMtx_Bidirectional = squeeze(correctDigitMtx_Bidirectional);

filename = ['../../Data/arabDigitPerformance_Rings.mat']
save(filename, 'correctDigitMtx_Bidirectional', 'lambdaMtx_Bidirectional','correctDigitMtx_Unidirectional', 'lambdaMtx_Unidirectional','specRadVec', 'connectivityVec', 'netDim');
