function [intWM, rescaling]= generateReservoirNetworkSelfLoop(netDim, connectivity, spectralRadius, LeackyCoeff)
%generates the reservoir matrix (the inner network). 
  
    connectivity = (1-abs(RParam))*connectivity;
    intWM = sprandn(netDim, netDim, connectivity);
    intWM = intWM + LeackyCoeff * speye(netDim, netDim);

try
    maxval = max(abs(eigs(intWM,1)));
    intWM = intWM/maxval;
    intWM = spectralRadius * intWM;
    
    rescaling=maxval;
    
catch
  [intWM, rescaling]= generateReservoirNetworkSelfLoop(netDim, connectivity, spectralRadius, LeackyCoeff)
end
end