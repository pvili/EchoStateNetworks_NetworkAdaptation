load('../DataSpokenArabicDigit/ArabicDigitData_preprocessed.mat')
addpath('../../networkCreationFiles');
addpath(genpath('../'))

netDim = 100;
connectivity = 0.2;
specRad = 0.9;
channels = 1;
numbTests = 200;

%channelsVec = 1:13;
channelsVec = 1; % We only want to work with one channel...
rVec = -1:0.05:1;


id='MATLAB:eigs:TooManyRequestedEigsForComplexNonsym';
warning('off',id);

tic



specRadVec = [0.3:0.1:1];
correctDigitMtx = zeros(length(channels),2,10, numbTests, length(specRadVec), length(channels));
correctSexMtx = zeros(length(channels),2,10, numbTests, length(specRadVec), length(channels));
eigListVal = zeros(netDim,numbTests, length(specRadVec), length(channels));
tic
for channels=1:length(channelsVec)
    
    for alphaIdx = 1:length(specRadVec)
        for t=1:numbTests
            W = generateReservoirNetworkTopologies(netDim, connectivity, specRadVec(alphaIdx),'e', 0);
            Win = generateInOuMatrixes(netDim, length(channels)+1);
            [correctDigitMtx(:,:,:,t,alphaIdx,channels), correctSexMtx(:,:,:,t,alphaIdx,channels) ] = trainTestArabDigitRecognition( W, Win, trainData,testData,channels);
              eigListVal(:,t,alphaIdx,channels) = ((eigs(W,netDim)));
        end
        toc
    end
end

correctSexMtx = squeeze(correctSexMtx);
correctDigitMtx = squeeze(correctDigitMtx);

filename = ['../Data/arabDigitPerformance_SpecRad',date,'.mat']
save(filename, 'correctDigitMtx', 'correctSexMtx', 'specRadVec', 'connectivity', 'netDim','eigListVal');




specRadVec = [0.7, 0.8, 0.9, 1];
SF_Levels = [6, 5, 4.3333, 3.5, 3, 2.6666, 2.5, 2.25, 2.111, 2];
correctDigitMtx = zeros(length(channels),2,10, numbTests, length(SF_Levels), length(specRadVec), length(channels));
correctSexMtx = zeros(length(channels),2,10, numbTests, length(SF_Levels), length(specRadVec), length(channels));
eigListVal = zeros(netDim,numbTests, length(SF_Levels), length(specRadVec), length(channels));

tic
for channels=1:length(channelsVec)
    
    for alphaIdx = 1:length(specRadVec)
        for sfIdx = 1:length(SF_Levels)
            for t=1:numbTests
                W = generateReservoirNetworkTopologies(netDim, connectivity, specRadVec(alphaIdx), 's',SF_Levels(sfIdx));
                Win = generateInOuMatrixes(netDim, length(channels)+1);
                [correctDigitMtx(:,:,:,t,sfIdx,alphaIdx,channels), correctSexMtx(:,:,:,t,sfIdx,alphaIdx,channels) ] = trainTestArabDigitRecognition( W, Win, trainData,testData,channels);
                eigListVal(:,t,sfIdx,alphaIdx,channels) = ((eigs(W,netDim)));
            end
        toc
        end
    end
end

correctSexMtx = squeeze(correctSexMtx);
correctDigitMtx = squeeze(correctDigitMtx);

filename = ['../Data/arabDigitPerformance_SF',date,'.mat']
save(filename, 'correctDigitMtx', 'correctSexMtx', 'specRadVec', 'SF_Levels', 'connectivity', 'netDim','eigListVal');





specRadVec = [0.7, 0.8, 0.9, 1];
minPowLev=2;
maxPowLev=5;
numberOfDist=10;
powerLevels=minPowLev+(maxPowLev-minPowLev)/numberOfDist*(0:(numberOfDist-1));
correctDigitMtx = zeros(length(channels),2,10, numbTests, length(powerLevels), length(specRadVec), length(channels));
correctSexMtx = zeros(length(channels),2,10, numbTests, length(powerLevels), length(specRadVec), length(channels));
eigListVal = zeros(netDim, numbTests, length(powerLevels), length(specRadVec), length(channels));

tic
for channels=1:length(channelsVec)
    
    for alphaIdx = 1:length(specRadVec)
        for plIdx = 1:length(powerLevels)
            for t=1:numbTests
                W = generateNetworkPowerLaw(netDim, connectivity, specRadVec(alphaIdx), powerLevels(plIdx));
                Win = generateInOuMatrixes(netDim, length(channels)+1);
                [correctDigitMtx(:,:,:,t,plIdx,alphaIdx,channels), correctSexMtx(:,:,:,t,plIdx,alphaIdx,channels) ] = trainTestArabDigitRecognition( W, Win, trainData,testData,channels);
                eigListVal(:,t,plIdx,alphaIdx,channels) = ((eigs(W,netDim)));
            end
        toc
        end
    end
end

correctSexMtx = squeeze(correctSexMtx);
correctDigitMtx = squeeze(correctDigitMtx);

filename = ['../Data/arabDigitPerformance_PL',date,'.mat']
save(filename, 'correctDigitMtx', 'correctSexMtx', 'specRadVec','powerLevels', 'connectivity', 'netDim','eigListVal');


