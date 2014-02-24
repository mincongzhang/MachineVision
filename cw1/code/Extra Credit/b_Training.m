
clc
clear
close all


load('Data_AppleNonApple.mat');
DataApple = double(DataApple)/255;
DataNonApple = double(DataNonApple)/255;

%define number of extimate gaussian
nGaussEst = 3;

%define number of E-M Iteration
nIter = 2;

%fit MoG model for apple data
AppleEst = fitMoGModel(DataApple,nGaussEst,nIter);

%fit MoG model for non-apple data
NonAppleEst = fitMoGModel(DataNonApple,nGaussEst,nIter);

