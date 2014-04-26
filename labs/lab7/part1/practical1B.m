function practical1B

%the aim of the second part of practical 1 is to use the homography routine
%that you established in the first part of the practical.  We are going to
%make a panorama of several images that are related by a homography.  I
%provide 3 images (one of which is has a large surrounding region) and a
%matching set of points between these images.

%close all open figures
close all;

%load in the required data
load('PracticalData','im1','im2','im3','pts1','pts2','pts3','pts1b');
%im1 is center image with grey background
%im2 is left image 
%pts1 and pts2 are matching points between image1 and image2
%im3 is right image
%pts1b and pts3 are matching points between image 1 and image 3

%show images and points
% figure; set(gcf,'Color',[1 1 1]);image(uint8(im1));axis off;hold on;axis image;
% plot(pts1(1,:),pts1(2,:),'r.'); 
% plot(pts1b(1,:),pts1b(2,:),'m.');
% figure; set(gcf,'Color',[1 1 1]);image(uint8(im2));axis off;hold on;axis image;
% plot(pts2(1,:),pts2(2,:),'r.'); 
% figure; set(gcf,'Color',[1 1 1]);image(uint8(im3));axis off;hold on;axis image;
% plot(pts3(1,:),pts3(2,:),'m.'); 

%****TO DO**** 
%calculate homography from pts1 to pts2
HEst12 = calcBestHomography(pts1, pts2);

%calculate homography from pts1b to pts3
HEst13 = calcBestHomography(pts1b, pts3);

%****TO DO**** 
%for every pixel in image 1
    %transform this pixel position with your homography to find where it 
    %is in the coordinates of image 2
    %if it the transformed position is within the boundary of image 2 then 
        %copy pixel colour from image 2 pixel to current position in image 1 
        %draw new image1 (use drawnow to force it to draw)
    %end
%end;

%
% [m1,n1,~]=size(im1);
% [m2,n2,~]=size(im2);
% [m3,n3,~]=size(im3);
% for i = 1:m1
%     for j = 1:n1
%         
%         pts1Hom=[j i 1]';
%         %apply homography to points
%         pts2EstHom = HEst12*pts1Hom;
%         pts3EstHom = HEst13*pts1Hom;
%         
%         %convert back to Cartesian
%         pts2EstCart = pts2EstHom(1:2,:)./repmat(pts2EstHom(3,:),2,1);
%         pts2EstCart = round(pts2EstCart);
%         pts3EstCart = pts3EstHom(1:2,:)./repmat(pts3EstHom(3,:),2,1);
%         pts3EstCart = round(pts3EstCart);
%         
%         if (pts2EstCart(2)<=m2&& pts2EstCart(2)> 0 && pts2EstCart(1)<=n2&& pts2EstCart(1)> 0)            
%             im1(i,j,:)=im2(pts2EstCart(2),pts2EstCart(1),:);            
%         end
%         if (pts3EstCart(2)<=m3&& pts3EstCart(2)> 0 && pts3EstCart(1)<=n3&& pts3EstCart(1)> 0)            
%             im1(i,j,:)=im3(pts3EstCart(2),pts3EstCart(1),:);            
%         end
%         
%     end
% end

%A much faster way
[m1,n1,~]=size(im1);
[m2,n2,~]=size(im2);
[m3,n3,~]=size(im3);

[row col] = find(im1>0); 
nPixel = length(row);
pts1Hom = [col';row';ones(1,nPixel)];

%apply homography to points
pts2EstHom = HEst12*pts1Hom;
pts3EstHom = HEst13*pts1Hom;
        
%convert back to Cartesian
pts2EstCart = pts2EstHom(1:2,:)./repmat(pts2EstHom(3,:),2,1);
pts2EstCart = round(pts2EstCart);
pts3EstCart = pts3EstHom(1:2,:)./repmat(pts3EstHom(3,:),2,1);
pts3EstCart = round(pts3EstCart);

for i= 1:nPixel
    if (pts2EstCart(2,i)<=m2&& pts2EstCart(2,i)> 0 && pts2EstCart(1,i)<=n2&& pts2EstCart(1,i)> 0)            
        im1(row(i),col(i),:)=im2(pts2EstCart(2,i),pts2EstCart(1,i),:);            
    end
    if (pts3EstCart(2,i)<=m3&& pts3EstCart(2,i)> 0 && pts3EstCart(1,i)<=n3&& pts3EstCart(1,i)> 0)            
        im1(row(i),col(i),:)=im3(pts3EstCart(2,i),pts3EstCart(1,i),:);            
    end
end
figure;imshow(uint8(im1));
%****TO DO****
%repeat the above process mapping image 3 to image 1.




%==========================================================================
function H = calcBestHomography(pts1Cart, pts2Cart)

%should apply direct linear transform (DLT) algorithm to calculate best
%homography that maps the points in pts1Cart to their corresonding matchin in 
%pts2Cart

%****TO DO ****: replace this
%H = eye(3);

%**** TO DO ****;
%first turn points to homogeneous
pts1Hom = [pts1Cart; ones(1,size(pts1Cart,2))];
pts2Hom = [pts2Cart; ones(1,size(pts2Cart,2))];
%then construct A matrix which should be (10 x 9) in size
A = zeros(10,9);
[m n] = size(pts1Hom);
pts1Hom = pts1Hom';
pts2Hom = pts2Hom';
Y = pts2Hom(:,2);
X = pts2Hom(:,1);
A1 = zeros(n*2,3);
A2 = zeros(n*2,3);
A3 = zeros(n*2,3);
for i = 1:n
    A1(2*i,:) = pts1Hom(i,:);
    A2(2*i-1,:) = -pts1Hom(i,:);
    A3(2*i-1,:) = Y(i)*pts1Hom(i,:);
    A3(2*i,:) = -X(i)*pts1Hom(i,:);
end
A = [A1 A2 A3];

%solve Ah = 0 by calling
%h = solveAXEqualsZero(A); (you have to write this routine too - see below)
h = solveAXEqualsZero(A);

%reshape h into the matrix H
H = reshape(h,3,3)';

%Beware - when you reshape the (9x1) vector x to the (3x3) shape of a homography, you must make
%sure that it is reshaped with the values going first into the rows.  This
%is not the way that the matlab command reshape works - it goes columns
%first.  In order to resolve this, you can reshape and then take the
%transpose


%==========================================================================
function x = solveAXEqualsZero(A);

%****TO DO **** Write this routine 
[U,S,V] = svd(A);
x = V(:,end);