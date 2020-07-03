function outImg = myNotchFilt()

R=10;
R2 = R*R;

file = load('../data/image_low_frequency_noise.mat');
I = file.Z;
figure('Name','Orig Img');
title('Original Image');
imagesc(I);


II = zeros(2*size(I));
II(129:384,129:384) = I;


fim2 = fftshift(fft2(II));
absfim2 = log(abs(fim2)+1);
figure('Name','Freq Domain');
imshow(absfim2,[-1,18]);

outImg = absfim2;

H = ones(size(II));
cx=256;
cy=256;
f1x=278;
f1y=268;
f2x=237;
f2y=248;

a=meshgrid(1:512,1);
d1x=a(:)-f1x;
d1y=a(:)-f1y;
d2x=a(:)-f2x;
d2y=a(:)-f2y;
d1x = d1x .* d1x;
d1y = d1y .* d1y;
d2x = d2x .* d2x;
d2y = d2y .* d2y;

for i=1:512
    for j=1:512
        if (d1x(i) + d1y(j)<= R2) || (d2x(i) + d2y(j) <= R2)
            H(i,j) = 0;
        end
    end
end

fim2=fim2.*H;
absfim2 = log(abs(fim2)+1);
figure('Name','Freq Domain');
title('Freq Domain');
imshow(absfim2,[-1,18]);

ifft=real(ifft2(ifftshift(fim2)));
ifft=ifft(129:384,129:384);
figure('Name','Restored Image');
title('Restored Image');
imagesc(ifft);

end
