function [W] = createNetworkWithCycles(netDim, connectivity, lambda, fractionCycles, cycleLength, normalizationMethod) 
   if nargin < 6
       normalizationMethod = 'l';
   end
    if cycleLength == 1
        a = abs(fractionCycles);
        W = sprandn(netDim, netDim, connectivity*(1-a));
        W = W/max(abs(eigs(W)));
        I = fractionCycles*speye(netDim);
        W = W + I;
        
        if a ~=1
            W = W/mean(abs(eigs(W,netDim)))*lambda;
        else
            W = I*lambda;
        end
        
    else
    
    N2=netDim * netDim;
   edgeCount = N2 * connectivity ;
    
    %Remove remainders
    cyclesCount = floor(edgeCount*abs(fractionCycles)/cycleLength);
    edgesInCycles = cycleLength*cyclesCount;
    fractionNonCyclic = connectivity*(edgeCount - edgesInCycles)/edgeCount;
    
    I = zeros(1,edgesInCycles);
    J = zeros(1,edgesInCycles);
    V = zeros(1,edgesInCycles);
    
    
%     if cycleLength == 1
%         distributionSigns = [1;1];
%         probOfFirst = 1;
%     else
%         if mod(cycleLength,2) == 1
%             row1 = [ones(1,floor(cycleLength/2)),-1*ones(1,ceil(cycleLength/2))];
%             row2 = [ones(1,floor(cycleLength/2)+2),-1*ones(1,ceil(cycleLength/2)-2)];
%             distributionSigns = [row1;row2];
%             probOfFirst = 0.75;
%         else
%             distributionSigns = [ones(1,(cycleLength/2)),-1*ones(1,(cycleLength/2))];
%             probOfFirst=0.5;
%         end
%     end
    
    cycleListEncoded = randperm(netDim^cycleLength,cyclesCount);
    cyclesMat = zeros(cycleLength, cyclesCount);
    netDimPowers = int32(netDim.^(0:(cycleLength-1)));
    for c=1:cyclesCount
        cycleEncoded = cycleListEncoded(c);
        for n= 1:cycleLength
            cyclesMat(n,c) = mod(idivide(cycleEncoded,netDimPowers(n),'floor'),netDim)+1;
        end
    end
    
    for c=1:cyclesCount
        
        weigth = abs(randn(1));%(abs(randn(1)))^(1/cycleLength);
        cumulatedSign = 1;
        
        for n= 1:(cycleLength-1)
            sig = sign(randn(1));
            I((c-1)*cycleLength+n) = cyclesMat(n,c);
            J((c-1)*cycleLength+n) = cyclesMat(n+1,c);
            V((c-1)*cycleLength+n) = weigth*sig;
            cumulatedSign = cumulatedSign*sig;
        end
        I(c*cycleLength) = cyclesMat(cycleLength,c);
        J(c*cycleLength) = cyclesMat(1,c);
        finalSign = cumulatedSign*sign(fractionCycles);
        V(c*cycleLength) = finalSign*weigth;
    end
    
    Wcyc = sparse(I,J,V,netDim,netDim);
    Wnoncyc = sprandn(netDim, netDim, fractionNonCyclic);
    W = Wcyc + Wnoncyc;

    if normalizationMethod~='n' %n means no normalized
        if normalizationMethod=='l'
            W = W/mean(abs(eigs(W,netDim)))*lambda;
        else
            W = W/max(abs(eigs(W,1)))*lambda;
        end
    end
    end
end