clc;
clear;
close all;

%%
%read test image and ground truth.
Iapples = cell(3,1);
Iapples{1} = 'apples/Apples_by_kightp_Pat_Knight_flickr.jpg';
Iapples{2} = 'apples/ApplesAndPears_by_srqpix_ClydeRobinson.jpg';
Iapples{3} = 'apples/bobbing-for-apples.jpg';

IapplesMasks = cell(3,1);
IapplesMasks{1} = 'apples/Apples_by_kightp_Pat_Knight_flickr.png';
IapplesMasks{2} = 'apples/ApplesAndPears_by_srqpix_ClydeRobinson.png';
IapplesMasks{3} = 'apples/bobbing-for-apples.png';

%%
%load in training data - contains two variables each of size d x (m x n)
%Each column contains RGB values from one pixel in training data
CellDataApple = cell(3,1);
CellDataNonApple = cell(3,1);
for i = 1:3
        [m n d] = size(imread(Iapples{i}));
        CellDataApple{i} = zeros(d,m*n);
        CellDataNonApple{i} = zeros(d,m*n);
        IM = double(imread(Iapples{i}));
        IM = rgb2ycbcr(IM);
        GT = double(imread(IapplesMasks{i})) / 255;
        Apple = uint8(IM.*GT);
        NonApple = uint8(IM.*(1-GT));
        
        figure; 
        subplot(1,2,1); imshow(Apple);
        subplot(1,2,2); imshow(NonApple); 
       
    for x = 1:m
        for y = 1:n
            for z = 1:d
                CellDataApple{i}(z,x*y) = Apple(x,y,z);
                CellDataNonApple{i}(z,x*y) = NonApple(x,y,z);
            end
        end
    end
end

DataApple =  [CellDataApple{1} CellDataApple{2} CellDataApple{3}];
DataNonApple = [CellDataNonApple{1} CellDataNonApple{2} CellDataNonApple{3}];
DataApple(:,find(sum(DataApple)==0)) = [];
DataNonApple(:,find(sum(DataNonApple)==0)) = [];
