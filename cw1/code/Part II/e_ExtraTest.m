clc;
close all;
clear;
%==========================================================================
%extra test-image
%==========================================================================

%%
%get ground truth mask
%I1 = imread('testOtherApples/extra1.jpg');
%GT1 = roipoly(I1); % get logical pixel of ground truth image
% I2 = imread('testOtherApples/extra2.jpg');
% GT2 = roipoly(I2); % get logical pixel of ground truth image
load('extra_groundtruth1.mat')
load('extra_groundtruth2.mat')

%%
load('RGB_Est.mat');
%define priors for whether the pixel is apple or non apple
priorApple = 0.5;
priorNonApple = 0.5;

%run through the pixels in the test image and classify them as being apple or
%non apple
im = imread('testOtherApples/extra1.jpg');
%im = imread('testApples/test.jpg');
[imY, imX imZ] = size(im);

posteriorApple = zeros(imY,imX);
for (cY = 1:imY); 
    fprintf('Processing Row %d\n',cY);     
    for (cX = 1:imX);          
        %extract this pixel data
        thisPixelData = squeeze(double(im(cY,cX,:))./255);%RGB
        %calculate likelihood of this data given apple model
        likeApple = getMixGaussLike(thisPixelData,AppleEst); 
        %calculate likelihood of this data given non apple model
        likeNonApple = getMixGaussLike(thisPixelData,NonAppleEst);
        %calculate posterior probability from likelihoods and 
        %priors using BAYES rule.         
        posteriorApple(cY,cX) = likeApple*priorApple/(likeApple*priorApple+likeNonApple*priorNonApple);
    end;
end;

%draw skin posterior
clims = [0, 1];
figure,imagesc(posteriorApple, clims); colormap(gray); axis off; axis image;


posteriorApple = uint8(posteriorApple.*255);
posteriorApple1 = (posteriorApple > 150);
figure,imshow(posteriorApple1)

%%
load('RGB_Est.mat');
%define priors for whether the pixel is apple or non apple
priorApple = 0.5;
priorNonApple = 0.5;

%run through the pixels in the test image and classify them as being apple or
%non apple
im = imread('testOtherApples/extra2.jpg');
%im = imread('testApples/test.jpg');
[imY, imX imZ] = size(im);

posteriorApple = zeros(imY,imX);
for (cY = 1:imY); 
    fprintf('Processing Row %d\n',cY);     
    for (cX = 1:imX);          
        %extract this pixel data
        thisPixelData = squeeze(double(im(cY,cX,:))./255);%RGB
        %calculate likelihood of this data given apple model
        likeApple = getMixGaussLike(thisPixelData,AppleEst); 
        %calculate likelihood of this data given non apple model
        likeNonApple = getMixGaussLike(thisPixelData,NonAppleEst);
        %calculate posterior probability from likelihoods and 
        %priors using BAYES rule.         
        posteriorApple(cY,cX) = likeApple*priorApple/(likeApple*priorApple+likeNonApple*priorNonApple);
    end;
end;

%draw skin posterior
clims = [0, 1];
figure,imagesc(posteriorApple, clims); colormap(gray); axis off; axis image;


posteriorApple = uint8(posteriorApple.*255);
posteriorApple2 = (posteriorApple > 150);
figure,imshow(posteriorApple2)

%%
%calculate ROC

[TPR1, FPR1] = my_roc( GT1,posteriorApple1 )

X = [0:0.1:1];
Y = [0:0.1:1];
figure,plot(X,Y);title('ROC curve');xlabel('False Positive Rate (FPR)'); ylabel('True Positive Rate (TPR)');
hold on;
plot(FPR1,TPR1,'r*','MarkerSize',10);
text(FPR1,TPR1,'first extra test-image')

[TPR2, FPR2] = my_roc( GT2,posteriorApple2 )
plot(FPR2,TPR2,'ro','MarkerSize',10);
text(FPR2,TPR2,'second extra test-image')
