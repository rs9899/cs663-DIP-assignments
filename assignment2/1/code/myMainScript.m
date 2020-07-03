%% MyMainScript

tic;

%% Read Images
bird = imread('../data/bird.jpg');
flower = imread('../data/flower.jpg');

toc;
%% Generate Masks
bmask = myMaskGenerator(bird);
fmask = myMaskGenerator(flower);

toc;
%% Smoothen Flower
sflower = mySpatiallyVaryingKernel(flower,fmask,20);
%% Smoothen Bird
sbird = mySpatiallyVaryingKernel(bird,bmask,40);

toc;

%% Other Details
% Code takes ~5min
% 
% All Images Attached
% 
% 1(a)
% 
% The Mask is generated as follows:
% 
% 1) The image is rectangularly cropped so that the foreground is considered (values tuned manually)
% 2) For Bird:
% 	The sum of square of Red and Green components is large for bird part of the image and small 	for the sea
%    For Flower:
% 	The sum of square of Blue and Red components is large for flower(violet and yellow) part of the image and small background(green)
% 
% 3) Fill up the image inside the boundary created (if multiple points around a pixel are 1 then make that pixel to be 1)
% 
% 	The methods used here:
% 		Pixel along the axes (above,below,left,right) of the current pixel
% 		Number of pixels as 1 in 8-neighbourhood
% 		Median of pixels in a small window around the current pixel
