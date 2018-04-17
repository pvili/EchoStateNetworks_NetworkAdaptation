function [intWM]= generateReservoirNetworkTopologies(netDim, connectivity, spectralRadius, netType, topologyParam, weigthDistribution, weightParam)
%generates the reservoir matrix (the inner network). 

if nargin<4
    netType = 'e';
end

if nargin < 6
    weigthDistribution = 'n';
    weightParam = 1; 
end

try
    %Fix the number of nodes in each net. The nodes are evenly distirbuted
    switch netType
        case 'e' %Erdos-Reny
            intWM = generateReservoirNetworkEllyp(netDim, connectivity, spectralRadius, topologyParam, weigthDistribution, weightParam);
        case 's' %scale free
            intWM = scaleFreeNetwork(netDim, netDim*netDim*connectivity, topologyParam, 'b', weigthDistribution, weightParam);
            maxval = max(abs(eigs(intWM,1)));
            if isempty(maxval)
               maxval = max(abs(eig(full(intWM))));
            end
            intWM = intWM/maxval *spectralRadius;
        case 'w' %Watz-Strogatz. If param=0, it's a lattice
            intWM = generateNetworkWattsStrogatz(netDim, connectivity*netDim, spectralRadius, topologyParam, weigthDistribution, weightParam);
        case 'c' %circling: from a to b to c to d to a
            intWM = generateNetworkWattsStrogatz(netDim, [connectivity*netDim, 0], spectralRadius, topologyParam, weigthDistribution, weightParam);
        case 'r'
            intWM = generateRandomRegularGraph(netDim, floor(connectivity*netDim), spectralRadius, weigthDistribution, weightParam);
        otherwise
            display('No type selected, taking Erdos-Reny');
            intWM = sprandn(netDim, netDim, connectivity);
    end
    
    if sum(sum(isnan(intWM) == 1)) ~= 0 || sum(sum(isinf(intWM) == 1)) ~= 0
        netType
        weigthDistribution
        connectivity
        topologyParam
        [intWM]=generateReservoirNetworkTopologies(netDim, connectivity, spectralRadius, netType, topologyParam, weigthDistribution, weightParam);

    end
    
catch
    netType
    connectivity
    topologyParam
%    intWM =generateReservoirNetworkTopologies(netDim, connectivity, spectralRadius, netType, topologyParam, weigthDistribution, weightParam);

end
end