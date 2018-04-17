function [intWM ]= generateNetworkWattsStrogatz(netDim, linksPerNode, spectralRadius, rewiringProb,  weigthDistribution, weightParam)
%generates the reservoir matrix (the inner network).

if length(linksPerNode)>2
    disp('Links per node has more than 2D!!');
end

if length(linksPerNode)==1
    if mod(linksPerNode,2) ~= 0
        disp('Links per node should be a 2*x integer!!');
    end
end

if nargin < 6
    weigthDistribution = 'u';
    weightParam = 1; 
end

A = zeros(netDim);
deg = zeros(netDim,2);
circNet = 0;
if length(linksPerNode)==1
    deg = ones(size(deg))*floor(linksPerNode/2);
elseif length(linksPerNode)==2
    
    circNet = 1;
    deg(:,1) = ones(netDim,1)*linksPerNode(1);
    deg(:,2) = ones(netDim,1)*linksPerNode(2);
end

totalEdgeCount = sum(sum(deg));
edgesPerNode = totalEdgeCount/netDim;
I = zeros(totalEdgeCount,1);
J = zeros(totalEdgeCount,1);
for i=1:netDim
    for j=1:deg(i,1)
        idx = (i-1)*edgesPerNode+j;
        I(idx) = mod(i-j-1,netDim)+1;
        J(idx) = i;
        %a=mod(i-j-1,netDim)+1;
        %A(a,i) = 1;
    end
    for j=1:deg(i,2)
        idx = (i-1)*edgesPerNode+j+deg(i,1);
        I(idx) = mod(i+j-1,netDim)+1;
        J(idx) = i;
        %b = mod(i+j-1,netDim)+1;
        %A(b,i) = 1;
    end
end

% This was thought for fully described matrices
% if rewiringProb ~=0
%     B = zeros(netDim);
%     for i = 1:netDim
%         num = 0;
%         for j = 1:netDim
%             if A(i,j) == 1
%                 if rand > rewiringProb
%                     B(i,j) = 1;
%                     num = num + 1;
%                 end
%             end
%         end
%         B(i,randsample(find(B(i,:)==0),deg(i,2)-num))=1;
%         if sum(B(i,:)) ~= deg(i,2)
%             disp('rewire degree error!!')
%         end
%     end
% else
%     B=A;
% end

if weigthDistribution == 'p'
    V = powerLawDistribution(totalEdgeCount, 1, 1, -weightParam);
    B = sparse(I, J, V);
    %temp = powerLawDistribution(netDim, netDim, 1, -weightParam);
    %B = temp.*B;
else 
    V = randn(totalEdgeCount, 1);
    B = sparse(I, J, V);
    %B = (rand(netDim)*2.0-1.0).*B;
end


%B = sparse(B);
try
    if circNet == 1
        maxval = max(abs(eig(full(B))));
        intWM = B/maxval*spectralRadius;
    else
        maxval = max(abs(eigs(B,1)));
        intWM = B/maxval*spectralRadius;
    end
    
catch
    try 
        if circNet == 1
            maxval = max(abs(eig(full(B))));
            intWM = B/maxval*spectralRadius;
        else
            maxval = max(abs(eigs(B,1)));
            intWM = B/maxval*spectralRadius;
        end
    catch
        intWM = generateNetworkWattsStrogatz(netDim, linksPerNode, spectralRadius, rewiringProb,  weigthDistribution, weightParam);
    end
end
