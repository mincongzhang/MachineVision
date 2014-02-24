function HW2_TrackingAndHomographies


LLs = HW2_Practical9c( 'll' );
LRs = HW2_Practical9c( 'lr' );
ULs = HW2_Practical9c( 'ul' );
URs = HW2_Practical9c( 'ur' );

close all;

% Load frames from the whole video into Imgs{}.
% This is really wasteful of memory, but makes subsequent rendering faster.
LoadVideoFrames

% Coordinates of the known target object (a dark square on a plane) in 3D:
XCart = [-50 -50  50  50;...
          50 -50 -50  50;...
           0   0   0   0];

% These are some approximate intrinsics for this footage.
K = [640  0    320;...
     0    512  256;
     0    0    1];

% Define 3D points of wireframe object.
XWireFrameCart = [-50 -50  50  50 -50 -50  50  50;...
                   50 -50 -50  50  50 -50 -50  50;...
                    0   0   0   0 -100 -100 -100 -100];
 
hImg = figure;
       
% ================================================
for iFrame = 1:numFrames
    xImCart = [LLs(iFrame,:)' ULs(iFrame,:)' URs(iFrame,:)' LRs(iFrame,:)'];
    xImCart = circshift( xImCart, 1);

    % To get a frame from footage 
    im = Imgs{iFrame};

    % Draw image and 2d points
    set(0,'CurrentFigure',hImg);
    set(gcf,'Color',[1 1 1]);
    imshow(im); axis off; axis image; hold on;
    plot(xImCart(1,:),xImCart(2,:),'r.','MarkerSize',15);


    %TO DO Use your routine to calculate TEst the extrinsic matrix relating the
    %plane position to the camera position.
    T = estimatePlanePose(xImCart, XCart, K);



    %TO DO Draw a wire frame cube, by projecting the vertices of a 3D cube
    %through the projective camera, and drawing lines betweeen the 
    %resulting 2d image points
    XImWireFrameCart = projectiveCamera(K,T,XWireFrameCart);
    hold on;
    
    % TO DO: Draw a wire frame cube using data XWireFrameCart. You need to
    % 1) project the vertices of a 3D cube through the projective camera;
    % 2) draw lines betweeen the resulting 2d image points.
    % Note: CONDUCT YOUR CODE FOR DRAWING XWireFrameCart HERE
    %draw lines between each pair of points
    nPoint = size(XWireFrameCart,2)
    for i = 1:nPoint
        for j = 1:nPoint
            %Plot a line between two points that have distance of 100 (is one edge of the cube)
            if  ( sum(abs(XWireFrameCart(:,i) - XWireFrameCart(:,j)))==100 ) 
            plot([XImWireFrameCart(1,i) XImWireFrameCart(1,j)],[XImWireFrameCart(2,i) XImWireFrameCart(2,j)],'g-');
            hold on;
            end
        end
    end
    hold off;
    drawnow;
    
%     Optional code to save out figure
%     pngFileName = sprintf( '%s_%.5d.png', 'myOutput', iFrame );
%     print( gcf, '-dpng', '-r80', pngFileName ); % Gives 640x480 (small) figure

    
end % End of loop over all frames.
% ================================================

% TO DO: QUESTIONS TO THINK ABOUT...

% Q: Do the results look realistic?
% If not then what factors do you think might be causing this


% TO DO: your routines for computing a homography and extracting a 
% valid rotation and translation GO HERE. Tips:
%
% - you may define functions for T and H matrices respectively.
% - you may need to turn the points into homogeneous form before any other
% computation. 
% - you may need to solve a linear system in Ah = 0 form. Write your own
% routines or using the MATLAB builtin function 'svd'. 
% - you may apply the direct linear transform (DLT) algorithm to recover the
% best homography H.
% - you may explain what & why you did in the report.


%==========================================================================
%==========================================================================

%goal of function is to project points in XCart through projective camera
%defined by intrinsic matrix K and extrinsic matrix T.
function xImCart = projectiveCamera(K,T,XCart);

%replace this
xImCart = [];

%TO DO convert Cartesian 3d points XCart to homogeneous coordinates XHom
XHom = [XCart;ones(1,size(XCart,2))];


%TO DO apply extrinsic matrix to XHom to move to frame of reference of
%camera
xCamHom = T*XHom;

%TO DO project points into normalized camera coordinates xCamHom by (achieved by
%removing fourth row)
%Because K is 3x3 matrix
xCamHom(4,:) = [];

%TO DO move points to image coordinates xImHom by applying intrinsic matrix
xImHom = K*xCamHom;

%TO DO convert points back to Cartesian coordinates xImCart
xImCart = xImHom(1:2,:)./repmat(xImHom(3,:),2,1);


%==========================================================================
%==========================================================================

function T = estimatePlanePose(xImCart,XCart,K)


%Convert Cartesian image points xImCart to homogeneous representation
xImHom = [xImCart;ones(1,size(xImCart,2))];

%Convert image co-ordinates xImHom to normalized camera coordinates
xCamHom = inv(K)*xImHom;

%Estimate homography H mapping homogeneous (x,y)
%coordinates of positions in real world to xCamHom.  Use the routine you wrote for
%Practical 1B.
H = calcBestHomography(XCart, xCamHom);

%Estimate first two columns of rotation matrix R from the first two
%columns of H using the SVD
R = H(:,1:2);
[U,S,V] = svd(R);
R_hat = U*[1,0;0,1;0,0]*V';

%Estimate the third column of the rotation matrix by taking the cross
%product of the first two columns
R_hat = [R_hat cross(R_hat(:,1),R_hat(:,2))];

%Check that the determinant of the rotation matrix is positive - if
%not then multiply last column by -1.
if(det(R_hat)<=0)
    R_hat(end,:) = -1*R_hat(:,end); 
end

%Estimate the translation t by finding the appropriate scaling factor k
%and applying it to the third colulmn of H
k = sum(sum(R_hat(:,1:2)./H(:,1:2)));
t = k.*H(:,4); %fourth column
t = t/6; %take the average ratio

%Check whether t_z is negative - if it is then multiply t by -1 and
%the first two columns of R by -1.
t_z = t(end);
if (t_z<0)
    t = -1*t;
    R_hat(:,1:2) = -1*R_hat(:,1:2);
end

%assemble transformation into matrix form
T  = [R_hat t;0 0 0 1];


%==========================================================================
function H = calcBestHomography(pts1Cart, pts2Cart)

%should apply direct linear transform (DLT) algorithm to calculate best
%homography that maps the points in pts1Cart to their corresonding matchin in 
%pts2Cart

%first turn points to homogeneous
pts1Hom = [pts1Cart; ones(1,size(pts1Cart,2))];
pts2Hom = [pts2Cart; ones(1,size(pts2Cart,2))];

%then construct A matrix
[m n] = size(pts1Hom);
pts1Hom = pts1Hom';
pts2Hom = pts2Hom';
Y = pts2Hom(:,2);
X = pts2Hom(:,1);
A1 = zeros(n*2,4);
A2 = zeros(n*2,4);
A3 = zeros(n*2,4);
for i = 1:n
    A1(2*i-1,:) = pts1Hom(i,:);
    A2(2*i,:) = pts1Hom(i,:);
    A3(2*i-1,:) = -X(i)*pts1Hom(i,:);
    A3(2*i,:) = -Y(i)*pts1Hom(i,:);
end
A = [A1 A2 A3];

%solve Ah = 0 by calling
%h = solveAXEqualsZero(A); (you have to write this routine too - see below)
h = solveAXEqualsZero(A);

%reshape h into the matrix H
H = reshape(h,4,3)';


%==========================================================================
function x = solveAXEqualsZero(A);
[U,S,V] = svd(A);
x = V(:,end);