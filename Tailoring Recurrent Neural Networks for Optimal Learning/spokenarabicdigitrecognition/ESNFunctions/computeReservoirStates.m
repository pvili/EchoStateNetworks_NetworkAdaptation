function [reservoirTS, finalInternalState] = computeReservoirStates(intWM, inWM, data)


x = zeros(length(intWM),1);
sizeTS = size(data);

reservoirTS =  zeros(length(intWM) + sizeTS(1), length(data)-1);

for t = 1:length(data)-1 
    u = data(:,t); 
    x = tanh( inWM*[1;u] + intWM*x );
    reservoirTS(:,t) = [u;x];
end
u = data(:,t); 
x = tanh( inWM*[1;u]  + intWM*x );
finalInternalState = x;


end