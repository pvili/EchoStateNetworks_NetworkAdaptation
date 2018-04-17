function [correctDigitMtx, correctSexMtx , errorTest ] = trainTestArabDigitRecognition( W, Win, trainData,testData,channels)

[ WoutSet] = fullTrainingArabDigitRecognition( W, Win, trainData, channels);


[ testDigit, testSex, errorTest] = fullTestForecastErrorArabDigitRecognition( W, Win, testData, WoutSet, channels);
%[ classificationResultSex, classificationResultDigit] = classifyFromErrors_ArabicDigit( trainingErrorVec, testErrorArray)
[correctDigitMtx, correctSexMtx] = countResults(testDigit, testSex);

end