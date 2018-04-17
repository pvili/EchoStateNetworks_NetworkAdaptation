function [W] = createNetworkWithMultipleCycles(netDim, connectivity, lambda, rhoByCycle, cycleLengths, normalizationMethod) 
   if nargin < 6
       normalizationMethod = 'l';
   end
   if nargin < 5
       cycleLengths = 1:length(rhoByCycle);
   end

   %Cycles of length 1 not counted on the connectivity
   
   [cycleLengths, idxList] = sort(cycleLengths);
   initAdd = 1;
   rho1 = 0;
   if cycleLengths(1) == 1
       cycleLengths = cycleLengths(2:end);
       rhoByCycle = rhoByCycle(idxList);
       rho1 = rhoByCycle(1);
       rhoByCycle = rhoByCycle(2:end);
       initAdd = 2;
   end
   
   if sum(rhoByCycle)>1
        rhoByCycle = rhoByCycle/sum(rhoByCycle);
   end
   
    N2=netDim * netDim;
    edgeCount = floor(N2 * connectivity);
    edgesPerCycle = abs(rhoByCycle)*edgeCount;
    cyclesCount = floor(edgesPerCycle./cycleLengths);
    randomEdgesCount = edgeCount - sum(cyclesCount.*cycleLengths);
    if randomEdgesCount<0
        display(' Edges in cycles add up to more than the connectivity');
        edgesPerCycle = abs(rhoByCycle)*edgeCount/sum(abs(rhoByCycle));
        cyclesCount = floor(edgesPerCycle./cycleLengths);
    end
    
    I = zeros(1,edgeCount);
    J = zeros(1,edgeCount);
    V = zeros(1,edgeCount);
    idxEdge = 1;
    
    for c=1:length(cycleLengths)
        if cyclesCount(c)>0
             [Ic, Jc, Vc] = createNetworkOfCycles(netDim, cyclesCount(c), cycleLengths(c));
             I(idxEdge:(idxEdge + cyclesCount(c)* cycleLengths(c))-1) = Ic;
             J(idxEdge:(idxEdge + cyclesCount(c)* cycleLengths(c))-1) = Jc;
             V(idxEdge:(idxEdge + cyclesCount(c)* cycleLengths(c))-1) = sign(rhoByCycle(c))*Vc; %Weight the cycles to avoid larger cycles dominance
             idxEdge = (idxEdge + cyclesCount(c)* cycleLengths(c))-1;
        end
    end
    
    if(randomEdgesCount > 0)
        encodedRandomEdges = randperm(netDim^2,randomEdgesCount);
        Irand = floor(encodedRandomEdges/netDim);
        Jrand = mod(encodedRandomEdges,netDim)+1;
        Vrand = randn(1,randomEdgesCount);
        I(idxEdge:(idxEdge + randomEdgesCount)-1) = Irand;
        J(idxEdge:(idxEdge + randomEdgesCount)-1) = Jrand;
        V(idxEdge:(idxEdge + randomEdgesCount)-1) = Vrand;
    end
    nonNullIdx = (I~=0);
    W = sparse(I(nonNullIdx),J(nonNullIdx),V(nonNullIdx), netDim, netDim);
    
    if normalizationMethod~='n' %n means no normalized
        if normalizationMethod=='l'
            W = W/mean(abs(eigs(W,netDim)));
        else
            W = W/max(abs(eigs(W,1)));
        end
    end
    correctedLambda = lambda*(1-abs(rho1));
    W = W*correctedLambda + sparse(eye(netDim))*rho1;
end