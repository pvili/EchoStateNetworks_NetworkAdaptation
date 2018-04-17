bins = 200;

load('C:\Users\Pau\Dropbox\30_ESN_Pau\ManuscriptReviewChanning\Code\Data\FrequencyResponses_Fig5\reservoirFreqRespMean.mat')

addpath('C:\Users\Pau\Dropbox\30_ESN_Pau\ManuscriptReviewChanning\Code\MackeyGlassTimeSeriesForecasting\seqGenerators')
seq=generateMGTSequence(10000, 1000, 17, 10);
seq = (seq-mean(seq))/std(seq);
fftMG = abs(fft(seq,bins));


load('C:\Users\Pau\Dropbox\30_ESN_Pau\ManuscriptReviewChanning\Code\LaserTimeSeriesForecasting\laserTS.mat')

winLength=3;
gaussFilter = gausswin(winLength);
gaussFilter = gaussFilter / sum(gaussFilter);
dataLaser = conv(laserTS,gaussFilter);
dataLaser = laserTS;%dataLaser(winLength:(end-winLength))';
dataLaser = (dataLaser - mean(dataLaser))/std(dataLaser);
fftLI = abs(fft(dataLaser,bins));


load('C:\Users\Pau\Dropbox\30_ESN_Pau\ManuscriptReviewChanning\Code\SpokenArabicDigitRecognition\DataSpokenArabicDigit\ArabicDigitData_preprocessed.mat')

fftSA = zeros(1,40);
for n=1:10
    for s=1:2
        for tr = 1:330
            dataCh1 = trainData{tr,s,n};
            dataCh1 = (dataCh1(1,:) -mean(dataCh1(1,:)))/std(dataCh1(1,:));
            fftSA = fftSA + abs(fft(dataCh1));
        end
    end
end
fftSA = (fftSA - mean(fftSA))/std(fftSA);


[ rhoVecMG, rhoIdxMG ] = findOptimalRhoCombination( fftMean, fftMG, 1 );
[ rhoVecLI, rhoIdxLI ] = findOptimalRhoCombination( fftMean, fftLI, 1, [2,3] );
[ rhoVecSA, rhoIdxSA ] = findOptimalRhoCombination( fftMean, fftSA, 1 );


