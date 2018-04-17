function [errorsVector, NRMSE] = testPrediction(testseq, intWM, inWM, ofbWM, outWM, initialRunlength, testRunlength, trialshift, numberOfTrials, plotRunlength ,teacherscaling, teachershift, inputLength, outputLength,signalLevels)
% this script tests a learnt model of the MG tau17 attractor on numberOfTrials 
% portions of a test sequence testseq. Each of the portions is predicted
% for 84 time units. Several global vars need to have been determined
% before this script can be run by a call to learn.


if nargin<5
   display('we need the matrixes and Testseq!');
end
if nargin<7
    % use the first 2000 step subsequence of testseq to prime model and 
    % produce the network state after that
    initialRunlength = 2000;
end
if nargin<8
    testRunlength = 84;
end
if nargin<9
    trialshift=testRunlength;%Jaegertrialshift = 84; but we want to use the testseq to the maximum
end
if nargin<10
   numberOfTrials = 50;
    %numberOfTrials=floor((length(testseq)-initialRunlength)/trialshift); 
end
if nargin<15
    teacherscaling = 0.8;
    teachershift = [0];
    inputLength = min(size(inWM));
    outputLength = min(size(outWM));
end

sampleout = testseq';
netDim=length(intWM);
totalDim = netDim+inputLength+outputLength;

totalstate =  zeros(totalDim,1);    
internalState = totalstate(1:netDim);

for i = 1:initialRunlength   
    in = 0.02;
    teach = [teacherscaling * sampleout(1,i) + teachershift];         
    %write input into totalstate
    totalstate(netDim+1:netDim+inputLength) = in; 
    %update totalstate except at input positions  
    internalState = f([intWM, inWM, ofbWM]*totalstate); 
    netOut = f(outWM *[internalState;in]);
    totalstate = [internalState;in;netOut];      
    totalstate(netDim+inputLength+1:netDim+inputLength+outputLength) = teach' ; 
end
startstate = totalstate;
% end of initial priming

outputCollectMat = zeros(testRunlength, numberOfTrials);
teacherCollectMat = zeros(testRunlength, numberOfTrials);
outputCollectMatMG = zeros(testRunlength,numberOfTrials);

for trials = 1:numberOfTrials
    % continue forced simulation run for trialshift steps
    totalstate = startstate;
    for i = 1:trialshift   
        in = 0.02;     
        teach = [teacherscaling * ...
                sampleout(1,initialRunlength + i + (trials - 1)*trialshift) + teachershift];         
        %write input into totalstate
        totalstate(netDim+1:netDim+inputLength) = in; 
        %update totalstate except at input positions  
        internalState = f([intWM, inWM, ofbWM]*totalstate); 
        netOut = f(outWM *[internalState;in]);
        totalstate = [internalState;in;netOut];      
        totalstate(netDim+inputLength+1:netDim+inputLength+outputLength) = teach' ; 
    end
    startstate = totalstate;
    
    for i = 1:testRunlength         
        in = 0.02;     
        teach = [teacherscaling * ...
                sampleout(1,initialRunlength + i + (trials - 1)*trialshift + trialshift) ...
                + teachershift];         
        %write input into totalstate
        totalstate(netDim+1:netDim+inputLength) = in; 

        %update totalstate except at input positions  
        internalState = f([intWM, inWM, ofbWM]*totalstate); 
        linearCombOutputs = outWM *[internalState;in];
        netOut = f(linearCombOutputs);
        totalstate = [internalState;in;netOut];      
        outputCollectMat(i, trials) = netOut;
        teacherCollectMat(i, trials) = teach; 
        outputCollectMatMG(i, trials) = linearCombOutputs;
    end
end

% compute the normalized root MSE for 84 step prediction

% compute variance of original MG series
teachVar = var(fInverse(sampleout));
% undo the tanh transformation of the training data to recover (shifted)
% original MG data
teacherCollectMatMG = fInverse(teacherCollectMat);
% compute average NMSE of 84 step predictions
errorsVector = outputCollectMatMG(testRunlength,:) - teacherCollectMatMG(testRunlength,:);
NRMSE = sqrt(mean(errorsVector.^2)/teachVar); % result 3.0999e-005


end