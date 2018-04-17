function [ NRMSE ] = testOnceCycles( netDim, connectivity, lambda, r, l, normMethod)
   if nargin < 6
       normMethod = 'l';%Use 's' for specRad
   end
   
    trainseq=generateMGTSequence(10000, 1000, 17, 10);
    testseq=generateMGTSequence(10000, 1000, 17, 10); 

    intWM=createNetworkWithCycles(netDim, connectivity, lambda, r, l,normMethod ) ;

    [inWM, ofbWM]=generateInOuMatrixes(netDim, 1, 1, 1);
    [outWM, intWM] = trainOutWMPrediction(intWM, inWM, ofbWM, trainseq, 1);
    [e, NRMSE] = testPrediction(testseq, intWM, inWM, ofbWM, outWM);
            %NRMSEList(testSerie,RTry,l) = NRMSE;

end

