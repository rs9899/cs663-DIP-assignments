tic;

I = imread('../data/barbara256.png');

%% Original Image
figure;
imshow(I);
title('Original Image');
%% Filters with Cutoff Freq = 40
myIdealFilter('../data/barbara256.png', 40);
myGaussianFilter('../data/barbara256.png', 40);
%% Filters with Cutoff Freq = 60
myIdealFilter('../data/barbara256.png', 60);
myGaussianFilter('../data/barbara256.png', 60);
%% Filters with Cutoff Freq = 80
myIdealFilter('../data/barbara256.png', 80);
myGaussianFilter('../data/barbara256.png', 80);

%% Conclusion
% Based on the output images the Ideal lowpass filter the edges 
% we have more ringing artifact when Cutoff Freq(D) is smaller.
% This is not seen in Gaussian Filter

toc;
