%% MyMainScript

clear;
img = imread("../data/flower.png");

% Optimal Parameters c=2.0, s=100, neighbours=20, lr=0.5
tic;
% good
myMeanShiftSeg(img, 2.0, 100, 20, 0.5);
toc;

%% c=0.2, s=150, neighbours=40, lr=2.5
% tic;
% myMeanShiftSeg(img, 2.5, 100, 20, 0.4);
% toc;