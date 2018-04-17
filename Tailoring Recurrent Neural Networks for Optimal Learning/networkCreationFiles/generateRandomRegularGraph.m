function W = generateRandomRegularGraph(netDim, edgesPerNode, spectralRadius, weigthDistribution, weightParam)

if nargin < 4
    weigthDistribution = 'n';
    weightParam =0;
end

try

    edgeCountMax = netDim*edgesPerNode;
    I = zeros(edgeCountMax,1);
    J = zeros(edgeCountMax,1);

    I_origiMtx = ones(edgesPerNode,1)*(1:netDim);
    I = reshape(I_origiMtx,'',1);
    
    
    for j=1:edgesPerNode
        J_idx = ((0:(netDim-1))*edgesPerNode)+j;
        J_value = randsample(netDim,netDim,false);
        J(J_idx) = J_value;
    end
    
    repeatRedundanceRemoval = 1;
    
    while repeatRedundanceRemoval ==1
        repeatRedundanceRemoval = 0;
        for i=1:netDim
            J_segment = J(((i-1)*edgesPerNode+1):(i*edgesPerNode));
            indexToRepeatedValue = findRepeatedElementsIdx(J_segment);

            if(length(indexToRepeatedValue))~=0
                repeatRedundanceRemoval = 1;
                %swap edges
                populationForSwaping = [1:((i-1)*edgesPerNode), (i*edgesPerNode+1):(netDim*edgesPerNode)];
                swapCandidates = randsample(populationForSwaping,length(indexToRepeatedValue),false);
                
                tempJ = J(indexToRepeatedValue + (i-1)*edgesPerNode*ones(size(indexToRepeatedValue)));
                J(indexToRepeatedValue+ (i-1)*edgesPerNode*ones(size(indexToRepeatedValue)))= J(swapCandidates);
                J(swapCandidates) = tempJ;
            end
        end
    end
%     vectorDest = 1:netDim;
%     openSlots = ones(netDim,1)*edgesPerNode;
%     %edgeSwaps = randsample(netDim*netDim,edgeCountMax,false);
%     %maxSwapValue=netDim*(netDim-1);
%     
%     for i=1:netDim
%         %populationDest = vectorDest(openSlots~=0);
%         newDest = randsample(populationDest,edgesPerNode,true, openSlots);
%         [Values_unique, idx_u] = unique(newDest);
%         while length(idx_u)~=0
%             tempSlots = openSlots - openSlots()
%             newDest = [newDest, randsample(populationDest,edgesPerNode,true, openSlots);
%         end
%         J((1+(i-1)*edgesPerNode):(i*edgesPerNode)) = newDest;
%         openSlots(newDest) = openSlots(newDest)-1;
%     end
%     
    if weigthDistribution == 'p' %Power Law
        power = weightParam;
        minVal = 1;
        V = powerLawDistribution(edgeCountMax, 1, minVal,-power);
    else
        V = randn(edgeCountMax,1);
    end
    
    W = sparse(I,J,V, netDim, netDim);
    
    maxval = max(abs(eigs(W,1)));
    if isempty(maxval)
        maxval = max(abs(eig(full(W))));
    end
    W = W/maxval;
    W = spectralRadius * W;
catch
    W = generateRandomRegularGraph(netDim, edgesPerNode, spectralRadius, weigthDistribution, weightParam);
end
    
end