function [ mse, predictedSignal, StartTime] = predictSignalUnivariate(signal, forecastingSteps, W, Win, trainFraction, initFraction, stdCoeff)

% we normalize to improve reservoir perf

if nargin < 1
    disp( 'Error in predictSignalSimple: No input'); 
    exit;
end

if nargin<7
    stdCoeff=1;
end

sigSize=size(signal);
if sigSize(2)<sigSize(1)
    signal=signal';
end

avgSignal = sum(signal)/length(signal);
stdSignal = std(signal);

data = (signal-avgSignal)/stdSignal*stdCoeff;

if nargin < 7
    initFraction = 0.1;
end
if nargin < 6 
    trainFraction = 0.5;
end
if initFraction+trainFraction>1
    disp( 'Fraction too large, we use default values'); 
    initFraction = 0.1;
    trainFraction = 0.5;
end
if nargin <3
    addpath('..\networkCreation');
    W = generateReservoirNetwork(1000, 0.2, 0.9);
end
resSize = length(W);
if nargin < 5
    Win = (rand(resSize,1+1)-0.5) .* 1; 
end
if nargin < 2
    forecastingSteps = 1;
end

%convert fractions of data used into actual lengths
initLen = floor(initFraction * length(signal)); 
trainLen = floor(trainFraction * length(signal));
testLen = length(signal) - initLen - trainLen - forecastingSteps;


inSize = 1; outSize = 1; 

X = zeros(1+inSize+resSize,trainLen-initLen); %The reservoir states
% set the corresponding target matrix directly 
Yt = data(initLen+2:trainLen+1); 
% run the reservoir with the data and collect X 
x = zeros(resSize,1); 
for t = 1:trainLen 
    u = data(t); 
    x = tanh( Win*[1;u] + W*x );
    if t > initLen
        X(:,t-initLen) = [1;u;x];
    end
end % train the output 

X_T = X'; 
%Wout = Yt*X_T * inv(X*X_T + reg*eye(1+inSize+resSize)); 
Wout = Yt*pinv(X); 
furtherOutput = data(initLen+2+forecastingSteps:trainLen+1+forecastingSteps); 
Wout_further = furtherOutput * pinv(X); %Easy linear-regression training

Y = zeros(outSize,testLen); 
Y_further = zeros(outSize,testLen);
u = data(trainLen+1); 
for t = 1:testLen 
    x = tanh( Win*[1;u] + W*x ); 
    y = Wout*[1;u;x]; 
    Y(:,t) = y; 
    y_further = Wout_further * [1;u;x]; 
    Y_further(:,t) = y_further;
    u = data(trainLen+t+1);
end

data=data/stdCoeff;
Y_further=Y_further/stdCoeff;

mse = sum((data(trainLen+2+forecastingSteps:trainLen+testLen+1+forecastingSteps)-Y_further(1,1:testLen)).^2)./testLen; 

predictedSignal = (Y_further(1,1:testLen))*stdSignal+avgSignal;
StartTime = trainLen+2+forecastingSteps;
end