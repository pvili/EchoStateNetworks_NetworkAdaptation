function [M ]= generateCirculantNetwork(netDim, linksPerNode, lambda, normalizationMethod)
%generates the reservoir matrix (the inner network).

if nargin <4
    lambda = 1;
    normalizationMethod = 'n';
end

totalEdgeCount = linksPerNode*netDim;
I = zeros(totalEdgeCount,1);
J = zeros(totalEdgeCount,1);
for i=1:netDim
    for j=1:linksPerNode
        idx = (i-1)*linksPerNode+j;
        I(idx) = mod(i-j-1,netDim)+1;
        J(idx) = i;
    end
end
V = randn(totalEdgeCount, 1);
M = sparse(I, J, V);

    if normalizationMethod~='n' %n means no normalized
        if normalizationMethod=='l'
            M = M/mean(abs(eig(full(M))))*lambda;
        else
            M = M/max(abs(eig(full(M))))*lambda;
        end
    end
end
