figure
load('eigenvalueDensititesRadius.mat')
binEdges = 0:1/gridSize:1;
binCenters = 0.5*(binEdges(2:end) + binEdges(1:end-1));
areaPerBin = pi*(binEdges(2:end).^2 - binEdges(1:end-1).^2)';

subplot(2,2,1)
h(1) = semilogy(binCenters, eigDens_ER(:,1)./areaPerBin, 'linewidth',2);
hold on
h(2) = semilogy(binCenters, eigDens_ER(:,2)./areaPerBin, 'linewidth',2);
h(3) = semilogy(binCenters, eigDens_ER(:,3)./areaPerBin, 'linewidth',2);
hold off
set(gca,'YLim',[0.01 10])
title('|\lambda| density for ER','FontSize',14)
legend(h(1:3), '<k>=10', '<k>=50', '<k>=100')
xlabel('|\lambda_n|','FontSize',14)
ylabel('density','FontSize',14)

subplot(2,2,2)
h(1) = semilogy(binCenters, eigDens_SF(:,1)./areaPerBin, 'linewidth',2);
hold on
h(2) = semilogy(binCenters, eigDens_SF(:,2)./areaPerBin, 'linewidth',2);
h(3) = semilogy(binCenters, eigDens_SF(:,3)./areaPerBin, 'linewidth',2);
hold off
set(gca,'YLim',[0.01 10])
title('|\lambda| density for SF','FontSize',14)
legend(h(1:3), '\gamma=4', '\gamma=3', '\gamma=2')
xlabel('|\lambda_n|','FontSize',14)
ylabel('density','FontSize',14)

subplot(2,2,3)
h(1) = semilogy(binCenters, eigDens_RR(:,1)./areaPerBin, 'linewidth',2);
hold on
h(2) = semilogy(binCenters, eigDens_RR(:,2)./areaPerBin, 'linewidth',2);
h(3) = semilogy(binCenters, eigDens_RR(:,3)./areaPerBin, 'linewidth',2);
hold off
set(gca,'YLim',[0.01 10])
title('|\lambda| density for RR','FontSize',14)
legend(h(1:3), '<k>=10', '<k>=50', '<k>=100')
xlabel('|\lambda_n|','FontSize',14)
ylabel('density','FontSize',14)

subplot(2,2,4)
h(1) = semilogy(binCenters, eigDens_PL(:,1)./areaPerBin, 'linewidth',2);
hold on
h(2) = semilogy(binCenters, eigDens_PL(:,2)./areaPerBin, 'linewidth',2);
h(3) = semilogy(binCenters, eigDens_PL(:,3)./areaPerBin, 'linewidth',2);
hold off
set(gca,'YLim',[0.01 10])
title('|\lambda| density for ER with PL','FontSize',14)
legend(h(1:3), '\beta=4', '\beta=3', '\beta=2.2')
xlabel('|\lambda_n|','FontSize',14)
ylabel('density','FontSize',14)

% figure
% load('eigenvalueDensitites.mat')
% 
% subplot(4,3,1)
% HeatMap(eigDens_ER(:,:,1)');
% title('ER <k>=10')
% 
% subplot(4,3,2)
% HeatMap(eigDens_ER(:,:,2)');
% title('ER <k>=50')
% 
% subplot(4,3,3)
% HeatMap(eigDens_ER(:,:,3)');
% title('ER <k>=100')
% 
% subplot(4,3,4)
% HeatMap(eigDens_SF(:,:,1)');
% title('SF \gamma=4')
% 
% subplot(4,3,5)
% HeatMap(eigDens_SF(:,:,2)');
% title('SF \gamma=3')
% 
% subplot(4,3,6)
% HeatMap(eigDens_SF(:,:,3)');
% title('SF \gamma=2.5')
% 
% subplot(4,3,7)
% HeatMap(eigDens_RR(:,:,1)');
% title('RR <k>=10')
% 
% subplot(4,3,8)
% HeatMap(eigDens_RR(:,:,2)');
% title('RR <k>=50')
% 
% subplot(4,3,9)
% HeatMap(eigDens_RR(:,:,3)');
% title('RR <k>=100')
% 
