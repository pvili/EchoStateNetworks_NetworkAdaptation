function M = scaleFreeNetwork(netDim, edgeCount, gamma, type,  weigthDistribution, weightParam)
    if (nargin < 4)||( type~='i' && type~='o') 
        type = 'b';
    end
    if nargin < 5
        weigthDistribution = 'n';
        weightParam = 1;
    end
    
    if gamma < 2
        display('Wrong initial conditions, gamma<2!!');
        return;
    end
    
%    warningEigsId='MATLAB:eigs:TooManyRequestedEigsForComplexNonsym'; %bug in matlab: it does not let me use eig, but gives a warning if i use eigs
%    warning('off',warningEigsId);

        a = 1/(gamma-1);
        P=(1:netDim).^-a;

        if (type=='b')||(type=='i')
            edgesI=randsample(netDim,int64(edgeCount),true,P);
        else
            edgesI=randsample(netDim,int64(edgeCount),true);
        end

        if (type=='b')||(type=='o')
            edgesJ=randsample(netDim,int64(edgeCount),true,P);
        else
            edgesJ=randsample(netDim,int64(edgeCount),true);
        end

        edgesV=randn(1,edgeCount);

        edgeID=edgesI+edgesJ*(netDim+1);
        repeatedIdx=findRepeatedElementsIdx(edgeID);
        countRepeatedEdges=floor(length(repeatedIdx)/2);
        idxToReplace=floor(repeatedIdx(2*(1:countRepeatedEdges)));


     %%NOTE: No idea why does that happen
     idWarning='MATLAB:NonIntegerInput';
     warning('off',idWarning);

        while countRepeatedEdges~=0
            if (type=='b')||(type=='i')
                edgesI(idxToReplace)=randsample(netDim,countRepeatedEdges,true,P);
            else
                edgesI(idxToReplace)=randsample(netDim,countRepeatedEdges,true);
            end

            if (type=='b')||(type=='o')
                edgesJ(idxToReplace)=randsample(netDim,countRepeatedEdges,true,P);
            else
                edgesJ(idxToReplace)=randsample(netDim,countRepeatedEdges,true);
            end  

            edgeID=edgesI+edgesJ*(netDim+1);
            repeatedIdx=findRepeatedElementsIdx(edgeID);
            countRepeatedEdges=length(repeatedIdx);
            idxToReplace=repeatedIdx((1:countRepeatedEdges));
        end

        if weigthDistribution == 'p' %Power Law
            power = weightParam;
            minVal = 1;
            edgesV = powerLawDistribution(length(edgesV), 1, minVal,-power);
        end


        M=sparse(edgesI,edgesJ,edgesV,netDim,netDim);
        
 %       try
%          catch
%             [M]= generateReservoirNetworkTopologies(netDim, connectivity, spectralRadius, netType, topologyParam, weigthDistribution, weightParam);
%          end
        
end

