function [inWM ofbWM initialOutWM]=generateInOuMatrixes(netDim, inputLength, outputLength, outputFeedbackScaling)

%Input matrix
inWM = 2.0 * rand(netDim, inputLength)- 1.0;

if nargin > 2
    %Output matrix
    initialOutWM = zeros(outputLength, netDim + inputLength);

    %output feedback weight matrix has weights in columns
    ofbWM = outputFeedbackScaling * (2.0 * rand(netDim, outputLength)- 1.0);
end
end
