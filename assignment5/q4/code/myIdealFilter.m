function [] = myIdealFilter(I, D)
   Img = imread(I);
   [m,n] = size(Img);
   
   % zero padding the image
   zeroPadImg = zeros(2*m, 2*n);
   for i=1:2*m
        for j=1:2*n
            if(i>m/2 && i<=m*1.5 && j>n/2 && j<=n*1.5)
                zeroPadImg(i,j) = Img(i-m/2,j-n/2);
            else
                zeroPadImg(i,j) = 0;
            end
        end
   end
    
   % making the filter
   H = zeros(2*m,2*n);
   for i=1:2*m
     for j=1:2*n
         if((i-m)*(i-m) + (j-n)*(j-n) <= D*D) 
             H(i,j) = 1;
         else
             H(i,j) = 0;
         end    
     end
   end
    figure;
    imagesc(log(H+1));
    daspect([1 1 1]);
    ti=sprintf('Ideal low pass filter for cuttoff Freq D=%f',D );
    title(ti);
    colorbar;
    colormap gray;
   
   % applying the filter 
   F = fftshift(fft2(zeroPadImg));
   R = F.*H;
   
   filteredImg = real(ifft2(ifftshift(R)));
   result = filteredImg(m/2:m*1.5,n/2:n*1.5);
   figure;
   imagesc(result);
   daspect([1 1 1]);
   ti=sprintf('Ideal low pass filtered Image with Cutoff freq D=%f',D);
   title(ti);
   colorbar;
   colormap gray;

end