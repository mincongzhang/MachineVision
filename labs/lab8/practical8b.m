function r=practical8b

%The aim of the second part of the practical is to do the same thing but
%to calculate and match the points automatically. Here we use the Harris
%detector to find a set of points in each image.  We make a greedy initial
%matching and then use RANSAC to find the correct epipolar geometry.

%You should use this template for your code and fill in the missing 
%sections marked "TO DO"

%load in images
im1 = imread('P1010165.JPG');
im2 = imread('P1010166.JPG');

%find points in the images
% Note if you don't have the Matlab Image Processing Toolbox: you can get
% a similar gray version of the image by taking just one channel, or using 
% the mean of the 3 channels.
[im y1 x1 y2 x2] = harris(double(rgb2gray(im1)),3,1000, 3,0);
x1ImCartUnmatched = [x2';y2'];
nPoints1 = size(x1ImCartUnmatched,2);
[im y1 x1 y2 x2] = harris(double(rgb2gray(im2)),3,1000, 3,0);
x2ImCartUnmatched = [x2';y2'];
nPoints2 = size(x2ImCartUnmatched,2);
          
%close all previous plots
close all;            

%display images with marked points
figure; set(gcf,'Color',[1 1 1]);
set(gcf,'Position',[100 400 800 350]);
subplot(1,2,1); imagesc(im1); axis off; axis image; hold on;
plot(x1ImCartUnmatched(1,:),x1ImCartUnmatched(2,:),'g.','MarkerSize', 10);
subplot(1,2,2); imagesc(im2); axis off; axis image; hold on;
plot(x2ImCartUnmatched(1,:),x2ImCartUnmatched(2,:),'g.','MarkerSize', 10);

%find (nPoints1 by nPoints2) similarity matrix 
simMatrix = getSimilarityMatrix(im1, im2, x1ImCartUnmatched,x2ImCartUnmatched)

%TO DO - find an initial set of ordered point matches x1ImCart and
%x2ImCart.  One possible way to do this would be to run though each point
%in the first image - choose it's match to be a point in the image that is
%reasonably close in (x,y) position and has a high similarity value.

%TO DO - Calculate the fundamental matrix robustly using RANSAC. 
%Repeatedly choose 8 point matches randomly (use the command
%randperm to help with this).  Calculate the fundamental matrix.  Count the
%number of inliers each time.  A pair of points are inliers if each is with
%1.5 pixels of the epipolar line predicted by the other point.  Find the
%configuration with the most inliers.

%TO DO - refine the point matches - set the similarity of point pairs that
%do not obey the epipolar constraint to zero and find matches again

%TO DO - find the fundamental matrix from all of the remaining point
%matches.


%==========================================================================
%==========================================================================

%return similarity matrix based on squared difference of small square
%region around points
function simMatrix = getSimilarityMatrix(im1, im2, x1ImCart,x2ImCart);

%retrieve image sizes
[imY1 imX1 imZ1] = size(im1);
[imY2 imX2 imZ2] = size(im2);

%define radius of small region
BORDER_SIZE = 4;

%place images with larger square to avoid edge effects
im1Border = ones(imY1+BORDER_SIZE*2,imX1+BORDER_SIZE*2,3)*128;
im2Border = ones(imY2+BORDER_SIZE*2,imX2+BORDER_SIZE*2,3)*128;
im1Border(BORDER_SIZE+1:BORDER_SIZE+imY1,BORDER_SIZE+1:BORDER_SIZE+imX1,:) = im1;
im2Border(BORDER_SIZE+1:BORDER_SIZE+imY2,BORDER_SIZE+1:BORDER_SIZE+imX2,:) = im2;

%add border size values to points
x1ImCart = x1ImCart+BORDER_SIZE;
x2ImCart = x2ImCart+BORDER_SIZE;

%count the number of points
nPoints1 = size(x1ImCart,2);
nPoints2 = size(x2ImCart,2);

%define similarity matrix
simMatrix = zeros(nPoints1,nPoints2);

for (cPoint1 =1:nPoints1)
    for(cPoint2=1:nPoints2);
        %extract xy coordinates of these points
        x1 = round(x1ImCart(1,cPoint1));
        y1 = round(x1ImCart(2,cPoint1));
        x2 = round(x2ImCart(1,cPoint2));
        y2 = round(x2ImCart(2,cPoint2));
        
        %extract image regions
        reg1 = im1Border(y1-BORDER_SIZE:y1+BORDER_SIZE,x1-BORDER_SIZE:x1+BORDER_SIZE,:);
        reg2 = im2Border(y2-BORDER_SIZE:y2+BORDER_SIZE,x2-BORDER_SIZE:x2+BORDER_SIZE,:);
        
        %calculate squared difference
        simMatrix(cPoint1,cPoint2) = sum(sum(sum((double(reg1)-double(reg2)).^2)));        
    end;
end;

%reformat to maximum is 1, minimum is zero
simMatrix = simMatrix*-1;
simMatrix = simMatrix-min(min(simMatrix));
simMatrix = simMatrix*1/(max(max(simMatrix)));
    
%you could improve this routine by setting the similarity of all poin pairs
%that are in very different position in the two images to zero.

















