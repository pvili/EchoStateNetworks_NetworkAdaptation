netDim = 400;
connectivity = 0.05;
dataLength = 4500;
initLen = 500;
testCount = 100;
inputLength = 1;
maxMemory = 30;

warningEigsId='MATLAB:eigs:TooManyRequestedEigsForComplexNonsym'; %bug in matlab: it does not let me use eig, but gives a warning if i use eigs
warning('off',warningEigsId);


tic
specRadVec = 0.7:0.1:1
stdCorr_ER = zeros(testCount, length(specRadVec));
lambdaList_ER = zeros(testCount, length(specRadVec));
MCTrainingList_ER = zeros(maxMemory,testCount, length(specRadVec));
MCTestList_ER = zeros(maxMemory,testCount, length(specRadVec));


for i = 1:length(specRadVec)
    specRad = specRadVec(i);
    for t = 1:testCount
        Win = generateInOuMatrixes(netDim, inputLength, 1, 1);
        W = generateReservoirNetworkTopologies(netDim, connectivity, specRad, 'e', 0);
        [MCTest, MCTrain, NRMSETest, NRMSETrain] = shortMemoryMC(Win, W, maxMemory, dataLength, initLen/dataLength, 0.5);
       [stdCorr, Lambda, corrMtx] = obtainNeuronTSData(W, Win, dataLength, initLen);
       stdCorr_ER(t,i) = (stdCorr);
       lambdaList_ER(t,i) = Lambda;
        MCTrainingList_ER(:,t,i) = MCTrain;
        MCTestList_ER(:,t,i) = MCTest;

    end
    toc
end

specRad=1;
gammaVec = [6,4,3,2]
stdCorr_SF = zeros(testCount, length(gammaVec));
lambdaList_SF = zeros(testCount, length(gammaVec));
MCTrainingList_SF = zeros(maxMemory,testCount, length(gammaVec));
MCTestList_SF = zeros(maxMemory,testCount, length(gammaVec));

for i = 1:length(gammaVec)
    gamma = gammaVec(i);
    for t = 1:testCount
        Win = generateInOuMatrixes(netDim, inputLength, 1, 1);
        W = generateReservoirNetworkTopologies(netDim, connectivity, 1, 's', gamma);
        [MCTest, MCTrain, NRMSETest, NRMSETrain] = shortMemoryMC(Win, W, maxMemory, dataLength, initLen/dataLength, 0.5);
        [stdCorr, Lambda, corrMtx] = obtainNeuronTSData(W, Win, dataLength, initLen);
        stdCorr_SF(t,i) = (stdCorr);
        lambdaList_SF(t,i) = Lambda;
        MCTrainingList_SF(:,t,i) = MCTrain;
        MCTestList_SF(:,t,i) = MCTest;
        
    end
    toc
end

betaVec = [4, 3, 2.2];%2:0.4:3.6
stdCorr_PL = zeros(testCount, length(betaVec));
lambdaList_PL = zeros(testCount, length(betaVec));

MCTrainingList_PL = zeros(maxMemory,testCount, length(betaVec));
MCTestList_PL = zeros(maxMemory,testCount, length(betaVec));


for i = 1:length(betaVec)
    beta = betaVec(i);
    for t = 1:testCount
        Win = generateInOuMatrixes(netDim, inputLength, 1, 1);
        W = generateReservoirNetworkTopologies(netDim, connectivity, 1, 'e', 0,'p',beta);
        [MCTest, MCTrain, NRMSETest, NRMSETrain] = shortMemoryMC(Win, W, maxMemory, dataLength, initLen/dataLength, 0.5);
        [stdCorr, Lambda, corrMtx] = obtainNeuronTSData(W, Win, dataLength, initLen);
        stdCorr_PL(t,i) = (stdCorr);
        lambdaList_PL(t,i) = Lambda;
        MCTrainingList_PL(:,t,i) = MCTrain;
        MCTestList_PL(:,t,i) = MCTest;

    end
    toc
end

% connecVec = 0.02:0.02:0.1
% stdCorr_CI = zeros(testCount, length(betaVec));
% lambdaList_CI = zeros(testCount, length(betaVec));
% 
% MCTrainingList_CI = zeros(maxMemory,testCount, length(connecVec));
% MCTestList_CI = zeros(maxMemory,testCount, length(connecVec));
% 
% for i = 1:length(connecVec)
%     connectivity = connecVec(i);
%     for t = 1:testCount
%         Win = generateInOuMatrixes(netDim, inputLength, 1, 1);
%         W = generateReservoirNetworkTopologies(netDim, connectivity, 1, 'w', 0);
%         [MCTest, MCTrain, NRMSETest, NRMSETrain] = shortMemoryMC(Win, W, maxMemory, dataLength, initLen/dataLength, 0.5);
%         [stdCorr, Lambda, rI] = obtainNeuronTSData(W, Win, dataLength, initLen);
%         stdCorr_CI(t,i) = (stdCorr);
%         lambdaList_CI(t,i) = Lambda;
%         MCTrainingList_CI(:,t,i) = MCTrain;
%         MCTestList_CI(:,t,i) = MCTest;
% 
%     end
%     toc
% end

connecVec = [10, 50, 100]/netDim;%0.02:0.02:0.1
stdCorr_R = zeros(testCount, length(connecVec));
lambdaList_R = zeros(testCount, length(connecVec));

MCTrainingList_R = zeros(maxMemory,testCount, length(connecVec));
MCTestList_R = zeros(maxMemory,testCount, length(connecVec));

for i = 1:length(connecVec)
    connectivity = connecVec(i);
    for t = 1:testCount
        Win = generateInOuMatrixes(netDim, inputLength, 1, 1);
        W = generateReservoirNetworkTopologies(netDim, connectivity, 1, 'r', 0);
        [MCTest, MCTrain, NRMSETest, NRMSETrain] = shortMemoryMC(Win, W, maxMemory, dataLength, initLen/dataLength, 0.5);
        [stdCorr, Lambda, rI] = obtainNeuronTSData(W, Win, dataLength, initLen);
        stdCorr_R(t,i) = (stdCorr);
        lambdaList_R(t,i) = Lambda;
        MCTrainingList_R(:,t,i) = MCTrain;
        MCTestList_R(:,t,i) = MCTest;

    end
    toc
end

save('memoryTrain',...
    'stdCorr_ER', 'lambdaList_ER', 'MCTestList_ER',...
    'stdCorr_SF', 'lambdaList_SF', 'MCTestList_SF',...
    'stdCorr_PL', 'lambdaList_PL', 'MCTestList_PL',...
    'stdCorr_R', 'lambdaList_R', 'MCTestList_R', ...
    'connecVec','betaVec','gammaVec','specRadVec');

filename = ['lambdaCorrMemory',date,'.mat'];
save(filename,...
    'stdCorr_ER', 'lambdaList_ER', 'MCTestList_ER',...
    'stdCorr_SF', 'lambdaList_SF', 'MCTestList_SF',...
    'stdCorr_PL', 'lambdaList_PL', 'MCTestList_PL',...
    'stdCorr_R', 'lambdaList_R', 'MCTestList_R', ...
    'connecVec','betaVec','gammaVec','specRadVec');
%    'stdCorr_CI', 'lambdaList_CI', 'MCTestList_CI',...