addpath('..')
netDim = 1000;
connectivity = 0.05;
spectralRadius = 1;

gridSize = 40;
repet = 200;

ERDeg = [10, 50, 100];
SFGam = [4, 3, 2.5];
RRDeg = [10, 50, 100];
PLBet = [4, 3, 2.2];

tic
toc
%eigDens_ER = zeros(gridSize, gridSize, length(ERDeg));
eigDens_ER = zeros(gridSize, length(ERDeg));
i=1;
for deg = ERDeg
    connectivity_ER = deg/netDim;
    eigDens_ER(:,i) = eigenvalueDensityGrid(gridSize, repet, netDim,...
        connectivity_ER, 'e', 0, 'n', 0);
    i=i+1;
end
toc

%eigDens_SF = zeros(gridSize, gridSize, length(SFGam));
eigDens_SF = zeros(gridSize, length(SFGam));
i=1;
for gamma = SFGam
    eigDens_SF(:,i) = eigenvalueDensityGrid(gridSize, repet, netDim,...
        connectivity, 's', gamma, 'n', 0);
    i=i+1;
end
toc

%eigDens_RR = zeros(gridSize, gridSize, length(RRDeg));
eigDens_RR = zeros(gridSize, length(RRDeg));
i=1;
for deg = RRDeg
    connectivity_RR = deg/netDim;
    eigDens_RR(:,i)  = eigenvalueDensityGrid(gridSize, repet, netDim,...
        connectivity_RR, 'r', 0, 'n', 0);
    i=i+1;
end
toc

%eigDens_PL = zeros(gridSize, gridSize, length(PLBet));
eigDens_PL = zeros(gridSize, length(PLBet));
i=1;
for beta = PLBet
    eigDens_PL(:,i) = eigenvalueDensityGrid(gridSize, repet, netDim,...
        connectivity, 'e', 0, 'p', beta);
    i=i+1;
end
toc

save('eigenvalueDensititesRadius.mat', 'eigDens_ER', 'eigDens_SF', 'eigDens_PL', 'eigDens_RR',...
    'ERDeg', 'RRDeg', 'PLBet', 'SFGam', 'gridSize', 'repet', 'netDim', 'connectivity');

% figure(1)
% for i = 1:3
%     subplot(4,3,i)
%     heatmap(eigDens_ER(i));
%     
