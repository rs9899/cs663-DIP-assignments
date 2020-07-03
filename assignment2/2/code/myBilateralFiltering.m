function [filterOut , filterBIL] = myBilateralFiltering(img,space_sig,intensity_sig)
% myBilateralFiltering Summary of this function goes here
%   Take an image, and apply the filter
% kernel size = 2 sigma 'just to keep it small'
 % img assumed 2d. In other case apply filter seperately

l = 4;
% kernel_size = ceil(max(l * space_sig , l * intensity_sig));
kernel_size = ceil(l * space_sig);


filterBIL = fspecial('gaussian' , [2 * kernel_size - 1 , 2 * kernel_size - 1 ] , space_sig );
filterOut = zeros(size(img));

image_padding = zeros(size(img) + 2 * kernel_size);

image_padding(kernel_size + 1 : kernel_size + size(img,1) , kernel_size + 1 : kernel_size + size(img,2)) = img;

for x = 1:size(img,1)
    for y = 1:size(img,2)
        slice = image_padding(kernel_size + (x - (kernel_size-1)) : kernel_size + (x + (kernel_size-1)) , kernel_size + (y - (kernel_size-1)) : kernel_size + (y + (kernel_size-1)));
%         intensity_kernel = slice - img(x,y);
%         intensity_kernel = intensity_kernel .* intensity_kernel;
%         intensity_kernel = exp( - intensity_kernel );
%         intensity_kernel = intensity_kernel / (2 * intensity_sig * intensity_sig);
        intensity_kernel = gaussmf(slice,[intensity_sig img(x,y)]);
        gaussioSpacialKernel = intensity_kernel .* filterBIL;
        
        appliedpatch = slice .* gaussioSpacialKernel;
        num = sum(appliedpatch , 'all');
        denom = sum(gaussioSpacialKernel , 'all');
        filterOut(x,y) = num / denom;
    end
end

end

