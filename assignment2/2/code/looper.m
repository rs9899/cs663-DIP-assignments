rand('seed',42);

L = load("../data/honeyCombReal_Noisy.mat");
orig = im2double(imread("../data/honeyCombReal.png"));
nois = L.imgCorrupt;

% Parameters
space_sig = 4;
intensity_sig = 10;

% apply Filter
for space_sig = 0.4:0.05:1.0
    for intensity_sig = 4:2:20
        [out , filtr] = myBilateralFiltering(nois , space_sig , intensity_sig);
        disp("_____")
        disp(space_sig)
        disp(intensity_sig)
        disp(myRMSD(out,orig))
    end
end
        

