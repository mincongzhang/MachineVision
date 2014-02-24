
load('RGB_Est.mat');
%define priors for whether the pixel is apple or non apple
priorApple = 0.3;
priorNonApple = 0.7;

%run through the pixels in the test image and classify them as being apple or
%non apple
%im = imread('testApples/Bbr98ad4z0A-ctgXo3gdwu8-original.jpg');
im = imread('testApples/test2.jpg');
[imY, imX imZ] = size(im);

posteriorApple = zeros(imY,imX);
for (cY = 1:imY); 
    fprintf('Processing Row %d\n',cY);     
    for (cX = 1:imX);          
        %extract this pixel data
        thisPixelData = squeeze(double(im(cY,cX,:))./255);%RGB
        %calculate likelihood of this data given apple model
        likeApple = getMixGaussLike(thisPixelData,AppleEst); %EVERY TIME 000000000000000
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

