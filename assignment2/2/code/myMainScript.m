%% MyMainScript
clear;
clc;
tic;
%% Your code here
rand('seed',42);

%% BARBARA IMAGE
bar = load("../data/barbara.mat");
orig = bar.imageOrig;
nois = NoiseAdder(orig);

% Parameters
space_sig = 1.4;
intensity_sig = 10;


% apply Filter

[out , filtr] = myBilateralFiltering(nois , space_sig , intensity_sig);

colormap = [min(orig(:)) max(orig(:))];
figure;
subplot(1,2,1), imshow(orig,colormap) , title("Original")
subplot(1,2,2), imshow(nois,colormap) , title("Noisy")

figure;
subplot(1,2,1), imshow(out ,colormap) , title("Filtered")
subplot(1,2,2), imshow(filtr , []),  title("Filter");


opterror = myRMSD(orig,out);
disp("Optimal Parameters")
disp("Spatial Sigma")
disp(space_sig)
disp("Intensity Sigma")
disp(intensity_sig)
disp("Best Error");
disp(opterror);

opterror_a = myRMSD(orig,myBilateralFiltering(nois , 0.9*space_sig , 1.0*intensity_sig));
disp("0.9 * space , 1 * intensity")
disp(opterror_a);

opterror_b = myRMSD(orig,myBilateralFiltering(nois , 1.1*space_sig , 1.0*intensity_sig));
disp("1.1 * space , 1 * intensity")
disp(opterror_b);

opterror_c = myRMSD(orig,myBilateralFiltering(nois , space_sig , 0.9*intensity_sig));
disp("1 * space , 0.9 * intensity")
disp(opterror_c);

opterror_d = myRMSD(orig,myBilateralFiltering(nois , space_sig , 1.1*intensity_sig));
disp("1 * space , 1.1 * intensity")
disp(opterror_d);
% 
%% Grass

L = load("../data/grassNoisy.mat");
orig = im2double(imread("../data/grass.png"));
nois = L.imgCorrupt;

% Parameters
space_sig = 0.6;
intensity_sig = 6;

% apply Filter

[out , filtr] = myBilateralFiltering(nois , space_sig , intensity_sig);

colormap = [min(orig(:)) max(orig(:))];
figure;
subplot(1,2,1), imshow(orig,colormap) , title("Original")
subplot(1,2,2), imshow(nois,colormap) , title("Noisy")

figure;
subplot(1,2,1), imshow(out ,colormap) , title("Filtered")
subplot(1,2,2), imshow(filtr , []),  title("Filter");



opterror = myRMSD(orig,out);
disp("Optimal Parameters")
disp("Spatial Sigma")
disp(space_sig)
disp("Intensity Sigma")
disp(intensity_sig)
disp("Best Error");
disp(opterror);

opterror_a = myRMSD(orig,myBilateralFiltering(nois , 0.9*space_sig , 1.0*intensity_sig));
disp("0.9 * space , 1 * intensity")
disp(opterror_a);

opterror_b = myRMSD(orig,myBilateralFiltering(nois , 1.1*space_sig , 1.0*intensity_sig));
disp("1.1 * space , 1 * intensity")
disp(opterror_b);

opterror_c = myRMSD(orig,myBilateralFiltering(nois , space_sig , 0.9*intensity_sig));
disp("1 * space , 0.9 * intensity")
disp(opterror_c);

opterror_d = myRMSD(orig,myBilateralFiltering(nois , space_sig , 1.1*intensity_sig));
disp("1 * space , 1.1 * intensity")
disp(opterror_d);

%% honey

L = load("../data/honeyCombReal_Noisy.mat");
orig = im2double(imread("../data/honeyCombReal.png"));
nois = L.imgCorrupt;

% Parameters
space_sig = 0.6;
intensity_sig = 6;

% apply Filter

[out , filtr] = myBilateralFiltering(nois , space_sig , intensity_sig);

colormap = [min(orig(:)) max(orig(:))];
figure;
subplot(1,2,1), imshow(orig,colormap) , title("Original")
subplot(1,2,2), imshow(nois,colormap) , title("Noisy")

figure;
subplot(1,2,1), imshow(out ,colormap) , title("Filtered")
subplot(1,2,2), imshow(filtr , []),  title("Filter");



opterror = myRMSD(orig,out);
disp("Optimal Parameters")
disp("Spatial Sigma")
disp(space_sig)
disp("Intensity Sigma")
disp(intensity_sig)
disp("Best Error");
disp(opterror);

opterror_a = myRMSD(orig,myBilateralFiltering(nois , 0.9*space_sig , 1.0*intensity_sig));
disp("0.9 * space , 1 * intensity")
disp(opterror_a);

opterror_b = myRMSD(orig,myBilateralFiltering(nois , 1.1*space_sig , 1.0*intensity_sig));
disp("1.1 * space , 1 * intensity")
disp(opterror_b);

opterror_c = myRMSD(orig,myBilateralFiltering(nois , space_sig , 0.9*intensity_sig));
disp("1 * space , 0.9 * intensity")
disp(opterror_c);

opterror_d = myRMSD(orig,myBilateralFiltering(nois , space_sig , 1.1*intensity_sig));
disp("1 * space , 1.1 * intensity")
disp(opterror_d);


toc;
