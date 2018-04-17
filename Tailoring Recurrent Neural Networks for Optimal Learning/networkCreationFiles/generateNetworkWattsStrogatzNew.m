function [intWM ]= generateNetworkWattsStrogatzNew(netDim, linksPerNode, spectralRadius, rewiringProb)
%generates the reservoir matrix (the inner network).

if length(linksPerNode)>2
    disp('Links per node has more than 2D!!');
end

A = zeros(netDim);
deg = zeros(netDim,2);
if length(linksPerNode)==1
    if mod(linksPerNode,2) ~= 0
        disp('Links per node should be a 2*x integer!!');
    end
    for i = 1:netDim
        deg(i,1) = linksPerNode/2;
        deg(i,2) = linksPerNode/2;
    end
elseif length(linksPerNode)==2
    for i = 1:netDim
        if rand > 0.5
            deg(i,1) = linksPerNode(1);
            deg(i,2) = linksPerNode(2);
        else
            deg(i,1) = linksPerNode(2);
            deg(i,2) = linksPerNode(1);
        end
    end
end

for i=1:netDim
    for j=1:deg(i,1)
        a = mod(i-j-1,netDim)+1;
        A(a,i) = 1;
    end
    for j=1:deg(i,2)
        b = mod(i+j-1,netDim)+1;
        A(i,b) = 1;
    end
end

B = zeros(netDim);
for i = 1:netDim
    num = 0;
    for j = 1:netDim
        if A(i,j) == 1
            if rand > rewiringProb
                B(i,j) = 1;
                num = num + 1;
            end
        end
    end
    B(i,randsample(find(B(i,:)==0),deg(i,2)-num))=1;
    if (sum(B(i,:)) ~= deg(i,2)) & (0 ~= rewiringProb)
        disp('rewire degree error!!')
    end
end

B = (rand(netDim)*2.0-1.0).*B;
B = sparse(B);
try
    maxval = max(abs(eigs(B,1)));
    intWM = B/maxval*spectralRadius;
catch
    intWM = generateNetworkWattsStrogatzNew(netDim, linksPerNode, spectralRadius, rewiringProb);
end
end
