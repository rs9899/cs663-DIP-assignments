%% MyMainScript

tic;
%% Read Data
clear;
P = '../../1/att_faces/s';
count=1;
count2=1;
% face_tag = strings(240,1);
% original_face_tag = strings(40,1);
% result = strings(40,1);
train_mat = zeros([112*92 , 192]);
test_mat = zeros([112*92 , 128]);
test_mat2 = zeros([112*92 , 80]);
for i=1:32
    temp_D = strcat(P,int2str(i));
    D = dir(fullfile(temp_D,'*.pgm'));
    for j=1:6
        F = fullfile(temp_D,D(j).name);
        I = imread(F);
        I = im2double(I);
        train_mat(:,count) = I(:);
%         face_tag(count) = strcat('s',int2str(i));
        count=count+1;
    end
    for j=7:10
        F = fullfile(temp_D,D(j).name);
        I = imread(F);
        I = im2double(I);
        test_mat(:,count2) = I(:);
%         original_face_tag(count2) = strcat('s',int2str(i));
        count2=count2+1;
    end
end
count2 = 1;
for i=33:40
    temp_D = strcat(P,int2str(i));
    D = dir(fullfile(temp_D,'*.pgm'));
    for j=1:10
        F = fullfile(temp_D,D(j).name);
        I = imread(F);
%         I = rgb2gray(I);
        I = im2double(I);
        test_mat2(:,count2) = I(:);
%         original_face_tag(count2) = strcat('s',int2str(i));
        count2=count2+1;
    end
end

%% SVD
[M,U, ~] = svd_faceRec(train_mat);

train_mat = U' * (train_mat - M);
test_mat = U' * (test_mat - M);
test_mat2 = U' * (test_mat2 - M);

%% Parameters
threshold = 125;

%%  falseNegative
falseNegative = 0;
numTest = size(test_mat , 2);
for i=1:numTest
    dist = train_mat - test_mat(:,i);
    dist = sum(dist.^2 , 1);
    d = min(dist);
    if d > threshold
        falseNegative = falseNegative + 1;
    end
end

disp(strcat(int2str(falseNegative) , ' falseNegatives out of  ,', int2str(numTest),' images' ))
%% falsePositive

falsePositive = 0;
numTest = size(test_mat2 , 2);
for i=1:numTest
    dist = train_mat - test_mat2(:,i);
    dist = sum(dist.^2 , 1);
    d = min(dist);
    if d < threshold
        falsePositive = falsePositive + 1;
    end
end


disp(strcat(int2str(falsePositive) , ' falsePositives out of  ,', int2str(numTest),' images' ))
    

%% METHOD Explained
% In the SVD space, we take representation of images and to check if it is
% inlier or outlier, we take the nearest insample point and that the
% distance in between in that space is less than a specifed value


%% End
toc;
