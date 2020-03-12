addpath('..')






figure(1)
specRad = 1;
netDim = 1000;
connectivity = 0.01;
subplot(1,3,1)
W = generateReservoirNetworkTopologies(netDim, connectivity, specRad, 'c', 0);
eigVals = eig(full(W));
plot(real(eigVals), imag(eigVals),'.')

subplot(1,3,2)
specRad = 1;
netDim = 200;
connectivity = 0.04;
WC=createNetworkWithCycles(netDim, connectivity, specRad, 1, 3, 's') ;
eigVals = eig(full(WC));
plot(real(eigVals), imag(eigVals),'.b')
hold on
WC=createNetworkWithCycles(netDim, connectivity, specRad, -1, 3, 's') ;
eigVals = eig(full(WC));
plot(real(eigVals), imag(eigVals),'.r')
hold off

subplot(1,3,3)
specRad = 1;
netDim = 200;
connectivity = 0.02;
WC=createNetworkWithCycles(netDim, connectivity, specRad, 1, 4, 's') ;
eigVals = eigs((WC),netDim);
plot(real(eigVals), imag(eigVals),'.b')
hold on
WC=createNetworkWithCycles(netDim, connectivity, specRad, -1, 4, 's') ;
eigVals = eigs((WC),netDim);
plot(real(eigVals), imag(eigVals),'.r')
hold off
