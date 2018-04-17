function eigDensity = eigenvalueDensityGrid(gridSize, repetitions, netDim,...
    connectivity, netType, topologyParam, weigthDistribution, weightParam)

%     eigDensity = zeros(gridSize, gridSize);
%     binEdges = -1:2/gridSize:1;
%     
%     for repIdx=1:repetitions
%         W = generateReservoirNetworkTopologies(netDim, connectivity, ...
%             1, netType, topologyParam, weigthDistribution, weightParam);
%         eigVals = eig(full(W));
%         realPart = real(eigVals);
%         imagPart = imag(eigVals);
%         eigDensity = eigDensity + histcounts2(realPart, imagPart,binEdges, binEdges);
%     end
%     eigDensity = eigDensity/netDim/repetitions;
%%Radius density

    eigDensity = zeros(gridSize,1);
    binEdges = 0:1/gridSize:1;
    
    for repIdx=1:repetitions
        W = generateReservoirNetworkTopologies(netDim, connectivity, ...
            1, netType, topologyParam, weigthDistribution, weightParam);
        eigVals = eig(full(W));
        histVec = histc(abs(eigVals),binEdges);
        eigDensity = eigDensity + histVec(1:gridSize);
    end
    eigDensity = eigDensity/netDim/repetitions;
end