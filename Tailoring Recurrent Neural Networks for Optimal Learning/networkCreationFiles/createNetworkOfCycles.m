function [I, J, V] = createNetworkOfCycles(netDim, cyclesCount, cycleLength)

    I = zeros(1, cyclesCount*cycleLength);
    J = zeros(1, cyclesCount*cycleLength);
    V = zeros(1, cyclesCount*cycleLength);
    
    if cycleLength == 1
        display('Asking me to get cycles of length one..')
    else 
            
    I = zeros(1, cyclesCount*cycleLength);
    J = zeros(1, cyclesCount*cycleLength);
    V = zeros(1, cyclesCount*cycleLength);
    
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
        
        weigth = nthroot(abs(randn(1)), cycleLength);%(abs(randn(1)))^(1/cycleLength);
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
        finalSign = cumulatedSign;
        V(c*cycleLength) = finalSign*weigth;
    end
    end
end