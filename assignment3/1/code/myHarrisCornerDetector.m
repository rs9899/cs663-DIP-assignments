function outCornMeas = myHarrisCornerDetector(inputImg)

GRAD_SIGMA = 1;
WT_SIGMA = 1;
K = 0.15;

maxVal = max(inputImg(:));

inpSize = size(inputImg);
edge = inpSize(1);
inputImg = inputImg/maxVal;

imgBlur = imgaussfilt(inputImg,GRAD_SIGMA);

% sobel_X1 = [1 2 1]';
% sobel_X2 = [-1 0 1];
% sobel_Y1 = [1 0 -1]';
% sobel_Y2 = [1 2 1];

[Gx Gy] = imgradientxy(imgBlur,'sobel');

Ix2 = Gx .* Gx;
Iy2 = Gy .* Gy;
IxIy = Gx .* Gy;

A11 = imgaussfilt(Ix2,WT_SIGMA);
A12 = imgaussfilt(IxIy,WT_SIGMA);
% A21 = imgaussfilt(Ix2,WT_SIGMA);
A22 = imgaussfilt(Iy2,WT_SIGMA);

sum_e = A11 + A22;
diff_e = A11 - A22;
term3 = (A12 .* A12)*4;
term2 = (diff_e .* diff_e);
term_R = sqrt(term2 + term3);
eig1 = (sum_e + term_R)/2;
eig2 = (sum_e - term_R)/2;

det = (eig1 .* eig2);
% trace = (eig1 + eig2);
trace = sum_e;
tr2 = trace .* trace;

outCornMeas = det - (K * tr2);

% outCornMeas(outCornMeas < 0) = 0;
% outCornMeas(outCornMeas > 0) = 1;

myNumOfColors = 200;
myColorScale = [ [0:1/(myNumOfColors-1):1]' , ...
[0:1/(myNumOfColors-1):1]', [0:1/(myNumOfColors-1):1]' ];

figure;
imagesc(inputImg);
colormap (myColorScale);
title('Original Image');
colormap jet;
daspect ([1 1 1]);
axis tight;
colorbar;

figure;
imagesc(Gx);
colormap (myColorScale);
title('Derivatives X');
% colormap jet;
daspect ([1 1 1]);
axis tight;
colorbar;

figure;
imagesc(Gy);
colormap (myColorScale);
title('Derivatives Y');
% colormap jet;
daspect ([1 1 1]);
axis tight;
colorbar;

figure;
imagesc(eig1);
colormap (myColorScale);
title('Max EigVal');
% colormap jet;
daspect ([1 1 1]);
axis tight;
colorbar;

figure;
imagesc(eig2);
colormap (myColorScale);
title('Min EigVal');
% colormap jet;
daspect ([1 1 1]);
axis tight;
colorbar;

figure;
imagesc(outCornMeas);
colormap (myColorScale);
title('Cornerness Measure');
% colormap jet;
daspect ([1 1 1]);
axis tight;
colorbar;

end