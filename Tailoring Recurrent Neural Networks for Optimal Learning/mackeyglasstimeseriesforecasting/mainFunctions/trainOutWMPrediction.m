function [outWM intWM msetestresult teacherVariance] = trainOutWMPrediction(intWM, inWM, ofbWM, trainseq, specrad, initialOutWM,  noiselevel, linearOutputUnits, linearNetwork, WienerHopf, initialRunlength, sampleRunlength,freeRunlength, teacherscaling, teachershift)

if nargin<4
    display('Without intWM nor Trainseq, there is not much to do!');
end

if nargin<5
    specrad = 0.85;
end
%specrad should be 0.85
 intWM0 = intWM;
intWM = specrad * intWM0;

% training sequence trainseq must have been produced by earlier call of
% generateMGSequence
sampleout = trainseq';
intNetSize=size(intWM);
netDim = intNetSize(1);

if nargin<14
    noiselevel = 0.0000000001;
    linearOutputUnits = 0; % 1 = use linear output units, 0 = sigmoid output units
    linearNetwork = 0; % 1 = use liner units in DR, 0 = use tanh units

    % 1 = compute linear regression directly by solving Wiener Hopf equation
    % with inverting covariance matrix; 0 = compute linear regression via
    % pseudoinverse. 1 is much faster and more space-economical, but less accurate. 
    WienerHopf = 0; 
    initialRunlength = 1000;
    sampleRunlength = 2000;
    freeRunlength = 0;
    teacherscaling = 0.8;
    teachershift = [0];
    outputLength = 1;
    inputLength = 1;
    initialOutWM = zeros(outputLength, netDim + inputLength);
end 

totalDim = netDim + inputLength + outputLength;

plotRunlength = floor(200);
sparsePlotting = 0; %1= true, 0=false
plotStates = [1 2 3 4]; % plot internal network states of ...
% units indicated in row vector; maximally 4 are plotted

% disp(sprintf('SR = %g   tsc = %g   tsh = %g   netsize = %g  noise = %g   N = %g',...
%     specrad, teacherscaling, teachershift, netDim, noiselevel, ...
%          sampleRunlength));


totalstate =  zeros(totalDim,1);    
internalState = totalstate(1:netDim);
outWM = initialOutWM;
stateCollectMat = zeros(sampleRunlength, netDim + inputLength);
teachCollectMat = zeros(sampleRunlength, outputLength);
teacherPL = zeros(outputLength, plotRunlength);
netOutPL = zeros(outputLength, plotRunlength);
if inputLength > 0
    inputPL = zeros(inputLength, plotRunlength);
end
statePL = zeros(length(plotStates),plotRunlength);
plotindex = 0;
msetest = zeros(1,outputLength); 
msetrain = zeros(1,outputLength); 


for i = 1:initialRunlength + sampleRunlength + freeRunlength + plotRunlength 
    
    if inputLength > 0
        in = [0.02];  % in is column vector  
    else in = [];
    end
    teach = [teacherscaling * sampleout(1,i) + teachershift];    % teach is column vector     
    
    %write input into totalstate
    if inputLength > 0
        totalstate(netDim+1:netDim+inputLength) = in; 
    end
    %update totalstate except at input positions  
    if linearNetwork
        if noiselevel == 0 |  i > initialRunlength + sampleRunlength
            internalState = ([intWM, inWM, ofbWM]*totalstate);  
        else
            internalState = ([intWM, inWM, ofbWM]*totalstate + ...
                noiselevel * 2.0 * (rand(netDim,1)-0.5));
            %             internalState = ([intWM, inWM, ofbWM]*totalstate + ...
            %              noiselevel * 2.0 * (randn(netDim,1)));
        end
    else
        if noiselevel == 0 |  i > initialRunlength + sampleRunlength
            internalState = f([intWM, inWM, ofbWM]*totalstate);  
        else
            internalState = f([intWM, inWM, ofbWM]*totalstate + ...
                noiselevel * 2.0 * (rand(netDim,1)-0.5));
            %             internalState = f([intWM, inWM, ofbWM]*totalstate + ...
            %              noiselevel * 2.0 * (randn(netDim,1)));
        end
    end
    
    if linearOutputUnits
        netOut = outWM *[internalState;in];
    else
        netOut = f(outWM *[internalState;in]);
    end
    totalstate = [internalState;in;netOut];    
    
    %collect states and results for later use in learning procedure
    if (i > initialRunlength) & (i <= initialRunlength + sampleRunlength) 
        collectIndex = i - initialRunlength;
        stateCollectMat(collectIndex,:) = [internalState' in']; %fill a row
        if linearOutputUnits
            teachCollectMat(collectIndex,:) = teach';
        else
            teachCollectMat(collectIndex,:) = (fInverse(teach))'; %fill a row
        end
    end
    %force teacher output 
    if i <= initialRunlength + sampleRunlength
        totalstate(netDim+inputLength+1:netDim+inputLength+outputLength) = teach' ; 
    end
    %update msetest
    if i > initialRunlength + sampleRunlength + freeRunlength
        for j = 1:outputLength
            msetest(1,j) = msetest(1,j) + (teach(j,1)- netOut(j,1))^2;
        end
    end
    %compute new model
    if i == initialRunlength + sampleRunlength
        if WienerHopf
            covMat = stateCollectMat' * stateCollectMat / sampleRunlength;
            pVec = stateCollectMat' * teachCollectMat / sampleRunlength;
            outWM = (pinv(covMat) * pVec)';
        else
            outWM = (pinv(stateCollectMat) * teachCollectMat)'; 
        end
        %compute mean square errors on the training data using the newly
        %computed weights
        for j = 1:outputLength
            if linearOutputUnits
                msetrain(1,j) = sum((teachCollectMat(:,j) - ...
                    (stateCollectMat * outWM(j,:)')).^2);
            else
                msetrain(1,j) = sum((f(teachCollectMat(:,j)) - ...
                    f(stateCollectMat * outWM(j,:)')).^2);
            end
            msetrain(1,j) = msetrain(1,j) / sampleRunlength;
        end
    end  
    
    
    
    
%write plotting data into various plotfiles
    if i > initialRunlength + sampleRunlength + freeRunlength 
        plotindex = plotindex + 1;
        if inputLength > 0
            inputPL(:,plotindex) = in;
        end
        teacherPL(:,plotindex) = teach; 
        netOutPL(:,plotindex) = netOut;
        for j = 1:length(plotStates)
            statePL(j,plotindex) = totalstate(plotStates(j),1);
        end
    end
end
%end of the great do-loop

% print diagnostics 

msetestresult = msetest / plotRunlength;
teacherVariance = var(teacherPL');

end








