function [arrayData] = extractArrayBlock(fullDataset,sexId, digitId)

sizeDataSet = size(fullDataset);
arrayData = cell(sizeDataSet(1),length(sexId), length(digitId));

for i = 1:sizeDataSet
    arrayData{i}=fullDataset{i,sexId,digitId};
    
end