function [] = crossPowerSpectrum(I,J,noisy)
    I1 = fft2(I);
    J1 = fft2(J);
    
    CrossSpectrum = (I1.*conj(J1)) ./ (abs(I1).*abs(J1));
    Reverse = ifft2(CrossSpectrum);
    LogMagnitude = log(1+abs(CrossSpectrum));
    
    if noisy==1
        figure;
        imagesc(LogMagnitude);
        colorbar;
        title('Log magnitude of Cross Power Spectrum With Noise');
        colormap gray;
    else
        figure;
        imagesc(LogMagnitude);
        colorbar;
        title('Log magnitude of Cross Power Spectrum Without Noise');
        colormap gray;
    end

    if noisy==1
        figure;
        imshow(real(Reverse)); 
        title('Final Result with Noise');
        colorbar;
        colormap gray;
    else
        figure;
        imshow(real(Reverse)); 
        title('Final Result without Noise');
        colorbar;
        colormap gray;
    end

end