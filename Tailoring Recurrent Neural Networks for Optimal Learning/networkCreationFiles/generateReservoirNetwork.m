function [intWM]= generateReservoirNetwork(netDim, connectivity, spectralRadius)
%generates the reservoir matrix (the inner network). 

try    

        intWM = sprandn(netDim, netDim, connectivity);
        %intWM = spfun(@minusPoint5,intWM);
        maxval = max(abs(eigs(intWM,1)));
        intWM = intWM/maxval;
        intWM = spectralRadius * intWM;
    
catch
    intWM= generateReservoirNetwork(netDim, connectivity, spectralRadius);
end
    end