clc
clear
close all

%%
%load image and ground truth image
load('RGB_posteriorApple.mat')
posteriorApple = uint8(posteriorApple.*255);
posteriorApple = (posteriorApple > 180);
figure,imshow(posteriorApple)

GT = imread('testApples/Bbr98ad4z0A-ctgXo3gdwu8-original.png');
GT = rgb2gray(GT);
GT = double(GT)/255;
figure,imshow(GT)

%%
%calculate ROC
[TPR, FPR] = my_roc( GT,posteriorApple )

X = [0:0.1:1];
Y = [0:0.1:1];
figure,plot(X,Y);title('ROC curve');xlabel('False Positive Rate (FPR)'); ylabel('True Positive Rate (TPR)');
hold on;
plot(FPR,TPR,'r*','MarkerSize',10);