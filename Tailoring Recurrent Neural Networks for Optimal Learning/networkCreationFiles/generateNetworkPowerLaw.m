function [intWM]= generateNetworkPowerLaw(netDim, connectivity, spectralRadius, power)
%generates the reservoir matrix (the inner network). 

minVal=1;

if nargin<4
    power = 2;
end
try    
    %Fix the number of nodes in each net. The nodes are evenly distirbuted
    intWM = sprand(netDim, netDim, connectivity);
    [I J V]=find(intWM);
    W=powerLawDistribution(length(V), 1, minVal,-power);
    while sum(W)==Inf
        W=powerLawDistribution(length(V), 1, minVal,-power);
    end
    W=W.*(sign(rand(size(V))-0.5));
    intWM=sparse(I,J,W);
    maxval = max(abs(eigs(intWM,1)));
    intWM = intWM/maxval;
    intWM = spectralRadius * intWM;
  
catch
    intWM= generateNetworkPowerLaw(netDim, connectivity, spectralRadius, power);
end
end