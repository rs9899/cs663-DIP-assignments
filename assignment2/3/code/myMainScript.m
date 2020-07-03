tic;
%% BarBara
I = load('../data/barbara.mat');
H = I.imageOrig;
param = 12.0;
myPatchBasedFiltering(H,H,0,param,1);
rmsd1 = myPatchBasedFiltering(H,H,0,0.9 * param,0);
rmsd2 = myPatchBasedFiltering(H,H,0,1.1 * param,0);
disp("Error at 0.9 * sigma")
disp(rmsd1)
disp("Error at 1.1 * sigma")
disp(rmsd2)


%% Grass
Grass = imread('../data/grass.png');
G = load('../data/grassNoisy.mat');
Grass_Noisy = G.imgCorrupt;
param = 26.0;
myPatchBasedFiltering(Grass,Grass_Noisy,1, param, 1);
rmsd1 = myPatchBasedFiltering(Grass,Grass_Noisy,1, 0.9 * param, 0);
rmsd2 = myPatchBasedFiltering(Grass,Grass_Noisy,1, 1.1 * param, 0);
disp("Error at 0.9 * sigma")
disp(rmsd1)
disp("Error at 1.1 * sigma")
disp(rmsd2)

%% Honey
param = 29.0;
I2 = load('../data/honeyCombReal_Noisy.mat');
H_noisy = I2.imgCorrupt;
H = imread('../data/honeyCombReal.png');
myPatchBasedFiltering(H,H_noisy,1, param, 1);
rmsd1 = myPatchBasedFiltering(H,H_noisy,1, 0.9 * param, 0);
rmsd2 = myPatchBasedFiltering(H,H_noisy,1, 1.1 * param, 0);
disp("Error at 0.9 * sigma")
disp(rmsd1)
disp("Error at 1.1 * sigma")
disp(rmsd2)
toc;