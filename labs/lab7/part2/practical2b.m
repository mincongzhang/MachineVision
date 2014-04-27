function practical2b

%The goal of this part of the practical is to take a real image containing
%a planar black square and figure out the transformation between the square
%and the camera.  We will then draw a wire-frame cube with it's base
%corners at the corner of the square.  You should use this
%template for your code and fill in the missing sections marked "TO DO"

%load in image 
im = imread('test104.jpg');

%define points on image
xImCart = [  140.3464  212.1129  346.3065  298.1344   247.9962;...
             308.9825  236.7646  255.4416  340.7335   281.5895];
         
%define 3D points of plane
XCart = [-50 -50  50  50 0 ;...
          50 -50 -50  50 0;...
           0   0   0   0 0];

%We assume that the intrinsic camera matrix K is known and has values
K = [640  0    320;...
     0    640  240;
     0    0    1];

%draw image and 2d points
figure; set(gcf,'Color',[1 1 1]);
imshow(im); axis off; axis image; hold on;
plot(xImCart(1,:),xImCart(2,:),'r.','MarkerSize',10);
       
%TO DO Use your routine to calculate TEst, the extrinsic matrix relating the
%plane position to the camera position.
TEst = estimatePlanePose(xImCart,XCart,K);
xImCart = projectiveCamera(K,TEst,XCart)

%define 3D points of plane
XWireFrameCart = [-50 -50  50  50 -50 -50  50  50;...
                   50 -50 -50  50  50 -50 -50  50;...
                    0   0   0   0 -100 -100 -100 -100];
                
XImWireFrameCart = projectiveCamera(K,TEst,XWireFrameCart);

%TO DO Draw a wire frame cube, by projecting the vertices of a 3D cube
%through the projective camera and drawing lines betweeen the resulting 2d image
%points

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
end;



%QUESTIONS TO THINK ABOUT...

%Do the results look realistic?
%If not, then what factors do you think might be causing this?
%estimating error 
%Shading? shadow


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