function r=practical8a

% This project explores the geometry of two cameras.  The goal of this part
% is to take a set of matching points from two images of the same scene,
% and calculate the fundamental matrix, plot epipolar lines, find epipoles,
% find the rotation and translation between the cameras, and estimate the 3D
% positions of the points.  The aim of the second part of the practical
% (optional) is to do the same thing but to calculate and match the points
% automatically.

%You should use this template for your code and fill in the missing 
%sections marked "TO DO"

%load in images
im1 = imread('P1010165.JPG');
im2 = imread('P1010166.JPG');

%define matching pairs of points in pixels.
x1ImCart = [166.89  95.12 151.65 412.17 336.47 621.08 243.57 567.50 106.42 576.34 596.01 329.10 ;...
             65.91 138.29 295.68 283.72 437.12 293.02 262.47 465.68 417.20 430.48  53.95 241.89];
            
x2ImCart = [162.96  20.90  91.19 333.03 187.04 592.08 204.24 383.17   3.69 440.19 571.92 261.26 ;...
             36.69 109.07 261.81 274.43 423.84 310.95 236.58 504.20 370.72 464.35  22.74 222.63];
          
%close all previous plots
close all;            

%display images with marked points
figure; set(gcf,'Color',[1 1 1]);
set(gcf,'Position',[100 400 800 350]);
subplot(1,2,1); imagesc(im1); axis off; axis image; hold on;
plot(x1ImCart(1,:),x1ImCart(2,:),'g.','MarkerSize', 10);
subplot(1,2,2); imagesc(im2); axis off; axis image; hold on;
plot(x2ImCart(1,:),x2ImCart(2,:),'g.','MarkerSize', 10);

%calculate fundamental matrix
%TO DO:  fill in this routine (calcFundamentalMatrix() is further below)
F = calcFundamentalMatrix(x1ImCart,x2ImCart);

%for each point in first image, draw epipolar line in second image
nPoint = size(x1ImCart,2);
l1 = zeros(nPoint,3); 
l2 = zeros(nPoint,3);
distPointLine = zeros(nPoint,2);
for (cPoint = 1:nPoint)
    %get epipolar line in first image for point in second image
    %TO DO: fill in this routine further below
    l1(cPoint,:) = getEpipolarLine(F,x2ImCart(:,cPoint));
    %get epipolar line in second image for point in first image
    l2(cPoint,:) = getEpipolarLine(F',x1ImCart(:,cPoint));
    %draw these epipolar lines - I have written a routine drawLine to help
    %you with this.  You should take a look at how it works though.
    subplot(1,2,1); drawLine(l1(cPoint,:),size(im1,2),size(im1,1),'r-');  
    subplot(1,2,2); drawLine(l2(cPoint,:),size(im2,2),size(im2,1),'r-');
    %check how well points fit by calculating distance from point to line
    %TO DO: fill in the calcDistPointLine routine used here, located further below
    distPointLine(cPoint,1) = calcDistPointLine(l1(cPoint,:),x1ImCart(:,cPoint));
    distPointLine(cPoint,2) = calcDistPointLine(l2(cPoint,:),x2ImCart(:,cPoint));
end;

%display distances between points and lines
distPointLine
     

%TO DO: calculate position of epipoles e1 and e2 in first and second image
e1 = calcEpipole(F)

e2 = calcEpipole(F')

%TO DO: calculate position of first epipoles using a second
%method to check that the above result is correct - get two epipolar lines
%in the first image and find where they meet by taking the cross product in
%homogeneous coordinates and then converting back to Cartesian.  You can do
%this in each image and check that the epipoles you calculated above were
%correct.

% An Oracle has given you this information:
%define the intrinsic matrices for camera 1 and camera 2
K1 = [ 640   0 320;...
         0 640 256;...
         0   0   1];
     
K2 = [ 640   0 320;...
         0 640 256;...
         0   0   1];

     
%TO DO calculate the essential matrix E from the fundamental matrix
%(replace this)
E = K1'*F*K2;

%TO DO recover one of the four possible configurations of rotation and 
%translation from the essential matrix (fill in routine)
[R t] = recoverRotationTranslation(E)

%for each point
X = zeros(3,nPoint);
for (cPoint = 1:nPoint)
    %calculate 3D position of point in image
    %TO DO fill in routine
    X(:,cPoint) = recover3D(x1ImCart(:,cPoint),x2ImCart(:,cPoint),K1,K2,R,t);
end;

% Check: if you project a world-point into one camera or the other, should
% be within ~10 pixels of the detections in x1ImCart or x2ImCart. Why
% aren't they closer? Several reasons: This relative pose of Camera2 from 
% Camera1 is an initialization, possible thanks to the closed-form solution
% to the algebraic error function. Would be wise to now proceed with a
% non-linear optimization of the geometric error function. Also, the
% intrinsics matrices may not be accurate guesses - better to work with
% real calibrated cameras! Finally, it is usually safest to pre-scale the
% coefficients before computing F, since they have grossly different means and
% variances. If pre-scaling to compute F, must also post-scale to compensate.

%TO DO check that all of the points are in front of the cameras (Z is positive).
%if not then recalculate the rotation and translation in one of the
%remaining configurations.

%well done - you have now completed this part of the practical.  You can
%now move to part b (optional).


%==========================================================================
%==========================================================================

%goal of function is to calculate fundamental matrix using linear algorithm
%from two corresponding sets of image points.
function F = calcFundamentalMatrix(x1ImCart,x2ImCart);

%replace this
F = randn(3,3);

%TO DO 
%for each of the N points form one row of the N by 9 matrix, A
x2ImCart(1,:)
x1ImCart(1,:)

%each cloumn for A
A1 = x2ImCart(1,:).*x1ImCart(1,:); A1 = A1';

A2 = x2ImCart(1,:).*x1ImCart(2,:);A2 = A2';

A3 = x2ImCart(1,:)';

A4 = x2ImCart(2,:).*x1ImCart(1,:);A4 = A4';

A5 = x2ImCart(2,:).*x1ImCart(2,:);A5 = A5';

A6 = x2ImCart(2,:)';

A7 = x1ImCart(1,:)';

A8 = x1ImCart(2,:)';

A9 = ones(12,1);

A = [A1 A2 A3 A4 A5 A6 A7 A8 A9];

%TO DO 
%solve system Af = 0 with constraint that f'f = 1;
[U,S,V] = svd(A);
f = V(:,end);

%TO DO
%reshape elements of f into 3 x 3 matrix F. Beware - by default matlab will
%reshape into the columns first, not the rows.  One way to deal with this
%is to reshape and then take the transpose.
[m n] = size(f);
F = reshape(f,sqrt(m),sqrt(m))';

%TO DO
%The F you have recovered should be rank 2, but it probably isn't due to 
%small effects of noise etc.  To enforce this constraint,
%take SVD U,L,V of F, set smallest singular value (i.e. L(3,3)) to zero and
%multiply back out F = U*L*V';
[U,L,V] = svd(F);
L(3,3)=0;
F = U*L*V';


%==========================================================================
%==========================================================================

%goal of function is to retreive equation of epipolar line in first
%camera given a point in the second camear
function l = getEpipolarLine(F,x2);

%replace this
x2 = [x2; 1];
l = x2'*F;

%TO DO 
%calculate 1x3 vector l that represents line.


%==========================================================================
%==========================================================================

%goal of function is to retreive the position e of the epipole in image
%coordinates from the Fundamental matrix F.
function e = calcEpipole(F);

%replace this
e = [320;320;1];

%TO DO 
% calculate the 3x1 point e describing position of epipole 
% by finding null space of F
[U,L,V] = svd(F);
e=null(F);

%TO DO
% convert back to Cartesian coordinates
e=e/e(3);

%==========================================================================
%==========================================================================

%goal of function is to calculate Euclidean distance from a point to a line
function d = calcDistPointLine(l,xCart);

%replace this
%d = randn(1,1);

%TO DO 
%calculate distance from 2d point to 2d line (do some googling if you don't
%know how!).
a = l(1); b = l(2); c = l(3);
x = xCart(1); y = xCart(2);
d = (a*x+b*y+c)/sqrt(a^2+b^2);


%==========================================================================
%==========================================================================

%Goal of routine is to calculate rotation and 
%translation from the essential matrix 
function [R t] = recoverRotationTranslation(E)

%replace this
R = eye(3); t = [10 0 0];

%TO DO define matrix W (possibly substitute for inv(W))
W = [0 -1 0;1 0 0;0 0 1];

%TO DO take SVD of essential matrix
[U,S,V] = svd(E);

%TO DO Replace two largest singular values (in S matrix) by their average.
average = (S(1,1)+S(2,2))/2;
S(1,1)=average;
S(2,2)=average;
L=S;

%TO DO calculate R
R = U*inv(W)*V';

%TO DO calculte tCross
tCross = U*L*W*U';

%TO DO retrieve t by reading out the entries tCross
t = [-tCross(2,3),tCross(1,3),-tCross(1,2)];

%TO DO normalize length of t (possibly flip sign)
t=t./norm(t);


%==========================================================================
%==========================================================================

%Goal of routine is to calculate 3D point corresponding to 
%points x1 and x2 given camera calibration data.
function X= recover3D(x1ImCart,x2ImCart,K1,K2,R,t);

%replace this
X = [0; 0 ; 300];

%convert points to homogeneous representation x1ImHom, x2ImHom
x1ImHom = [x1ImCart; ones(1,size(x1ImCart,2))];
x2ImHom = [x2ImCart; ones(1,size(x2ImCart,2))];

%convert points to normalized camera coordinates x1CamHom x2CamHom
x1CamHom = inv(K1)*x1ImHom;
x2CamHom = inv(K2)*x2ImHom;

%Reformulate system of equations into format A*X = b:
%A will contain coefficients based on rotation, b on translation
%Per camera, calculate the two constraints for Ch 14's "Reconstruction" (Inferring 3D world points).
%Note, each camera has its own intrinsics and extrinsics. 
a11 = [R(3,1)*x1CamHom(1)-R(1,1),R(3,2)*x1CamHom(1)-R(1,2),R(3,3)*x1CamHom(1)-R(1,3)];
a21 = [R(3,1)*x1CamHom(2)-R(1,1),R(3,2)*x1CamHom(2)-R(1,2),R(3,3)*x1CamHom(2)-R(1,3)];
b1 = [t(1)-t(3)*x1CamHom(1),t(2)-t(3)*x1CamHom(2)];

a12 = [R(3,1)*x2CamHom(1)-R(1,1),R(3,2)*x2CamHom(1)-R(1,2),R(3,3)*x2CamHom(1)-R(1,3)];
a22 = [R(3,1)*x2CamHom(2)-R(1,1),R(3,2)*x2CamHom(2)-R(1,2),R(3,3)*x2CamHom(2)-R(1,3)];
b2 = [t(1)-t(3)*x2CamHom(1),t(2)-t(3)*x2CamHom(2)];

A = [a11;a21;a12;a22];
b = [b1;b2];

%solve this system of equations using "inv"
W = inv(A'*A)*A'*b;

%These are now points in World space, though that easily converts to
%Camera1's coordinate frame.

%Optional: could also calculate 3d position relative to the second camera.





