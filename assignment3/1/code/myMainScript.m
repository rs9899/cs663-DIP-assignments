%% MyMainScript

tic;

%% Read Image
data = load('../data/boat.mat');
boat = data.imageOrig;
toc;
%% Detect Corners
tic;
myHarrisCornerDetector(boat);
toc;

% Other Details
% 
% Parameter Values:
% 1) K = 0.15
% 2) Sigma for Gaussian smoothing (Gradient) = 1
% 3) Sigma for gaussian of weights in patch (Struct Tensor) = 1  