%set directory containing files
cd('oppChal')

%Set maximum number of rows to import from each file:
maxRows = 1000

% Training datasets
load('S1-ADL1.dat')
load('S1-ADL2.dat')
load('S1-ADL3.dat')

load('S2-ADL1.dat')
load('S2-ADL2.dat')
load('S2-ADL3.dat')

load('S3-ADL1.dat')
load('S3-ADL2.dat')
load('S3-ADL3.dat')

trainingX = [S1_ADL1;S1_ADL2;S1_ADL3;  S2_ADL1;S2_ADL2;S2_ADL3; S3_ADL1;S3_ADL2;S3_ADL3];
trainingData = trainingX(1:maxRows,2:114);
trainingLabels = trainingX(1:maxRows,116);

%Validation sets
load('S1-ADL4.dat')
load('S1-ADL5.dat')

valX = [S1_ADL4;S1_ADL5];
valData = valX(1:maxRows,2:114);
valLabels = valX(1:maxRows,116);

% Testing datasets
load('S2-ADL4.dat')
load('S2-ADL5.dat')

load('S3-ADL4.dat')
load('S3-ADL5.dat')

testingX = [S2_ADL4;S2_ADL5; S3_ADL4;S3_ADL5];
testingData = testingX(1:maxRows,2:114);
testingLabels = testingX(1:maxRows,116);

%Normalize all these matrices (subtract mean and divide by std)
cd('..')
trainingData = normalizeMatrix(trainingData);
valData = normalizeMatrix(valData);
testingData = normalizeMatrix(testingData);
cd('oppChal')

size(testingData)
size(testingLabels)

%Make rolling windows from data matrices:
cd('..')
disp('making rolling windows for testing data')
[testingData,testingLabels] = rollingWindows(testingData,testingLabels, 15, 30);
disp('making rolling windows for validation data')
[valData,valLabels] = rollingWindows(valData,valLabels, 15, 30);
disp('making rolling windows for training data')
[trainingData,trainingLabels] = rollingWindows(trainingData, trainingLabels, 15, 30);

save('SMALLtrainingData.mat', 'trainingData')
save('SMALLtrainingLabels.mat', 'trainingLabels')

save('SMALLtestingData.mat', 'testingData')
save('SMALLtestingLabels.mat', 'testingLabels')

save('SMALLvalData.mat', 'valData')
save('SMALLvalLabels.mat', 'valLabels')

%Now create Torch-readable versions of these files...
system('th SMALLshaneMatFiles2torch.lua')