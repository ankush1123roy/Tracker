function [model] = trainingClassifier(Positive,Negative)
addpath '/home/ankush/Folder/McLearning/Assignment/Assignment_3rd/libsvm-3.13/matlab'
[MPos,NPos,KPos]= size(Positive);
[MNeg,NNeg,KNeg]= size(Negative);
posTrain = [];
negTrain = [];
for i = 1:KPos
  [image, descrips, locs] = sift(255*(Positive(:,:,i)));
  posTrain = cat(1,posTrain,descrips);
end
for i = 1:KNeg
  [image, descrips, locs] = sift(255*(Negative(:,:,i)));
  negTrain = cat(1,negTrain,descrips);
end
TRAIN = [posTrain;negTrain];
labelP = ones(size(posTrain,1),1);
labelN = -ones(size(negTrain,1),1);
label = [labelP;labelN];
model = svmtrain2(label,TRAIN,'-c 100 -t 2 -g 0.02');
end
