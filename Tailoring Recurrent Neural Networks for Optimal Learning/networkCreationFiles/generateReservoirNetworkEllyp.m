function [intWM, rescaling]= generateReservoirNetworkEllyp(netDim, connectivity, spectralRadius, RParam,  weigthDistribution, weightParam)
%generates the reservoir matrix (the inner network). 
  if nargin < 5
      weigthDistribution = 'n';
      weightParam = 0;
  end
    asymmetricConnectivity = (1-abs(RParam))*connectivity;
    symmetricConnectivity = abs(RParam)*connectivity;
%    asymmetricConnectivity = (1-abs(RParam))*connectivity/(1-symmetricConnectivity); 
%For some weeeird reason, the connectivity already includes collisions...
    %we have to add this extra to the asymmetric Connectivity because later
    %we will relete each cell of the asymetric if there is a conflict with
    %the symmetric one
     
    intWMA = sprandn(netDim, netDim, asymmetricConnectivity);
%     [I, J, V] = find(intWMA);
%     VNormal=sqrt(2)*erfinv(2*V-1);
%     intWMA = sparse(I, J, VNormal,netDim,netDim);
%     %%intWMA = spfun(@minusPoint5,intWMA);
    
    intWMS = sprandsym(netDim,symmetricConnectivity);
     
%    %Convert those to uniform dist.
%     [I,J,V] = find(intWMS);
%      V=sign(V).*(rand(size(V))/2);
%      intWMS_I=sparse(I,J,V,netDim,netDim);
%     intWMS=triu(intWMS_I)+triu(intWMS_I)'-diag(diag(intWMS_I));
    if sign(RParam)==-1
        intWMS=-1*triu(intWMS)+tril(intWMS)+diag(diag(intWMS));
    end
    
    %we delete the asymetric part of if there is a collision
    intWMA(intWMS~=0)=0;
    intWM=intWMS+intWMA;
    
    if weigthDistribution=='p'
        [I,J,V] = find(intWM);
        V = powerLawDistribution(length(V), 1, 1,-weightParam);
        binaryRand = sign(rand(size(V))-0.5);
        V = V .*binaryRand;
        intWM = sparse(I,J,V,netDim,netDim);
    end

try
    maxval = max(abs(eigs(intWM,1)));
    if isempty(maxval)
        maxval = max(abs(eig(full(intWM))));
    end
    intWM = intWM/maxval;
    intWM = spectralRadius * intWM;
    
    rescaling=maxval;
    
catch
  [intWM, rescaling]= generateReservoirNetworkEllyp(netDim, connectivity, spectralRadius, RParam);
end
end
