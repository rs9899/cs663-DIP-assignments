function outMask = myMaskGenerator(inputImg)

inpSize = size(inputImg);
outMask = im2double(inputImg(:,:,1)*0);

whichImg=1;
subImgInd = [1 inpSize(1) ; 1 inpSize(2) ; 1 inpSize(3)];

%% Distinguish by Colour and Correlation

if(inpSize(1)<300)
    whichImg = 0;
    len1 = uint16(inpSize(2) / 3) ;
    len2 = uint16(inpSize(2) / 3) ;
    wth1 = uint16(inpSize(1) / 5) ;
    wth2 = uint16(inpSize(1) / 6) ;
else
    len1 = uint16(inpSize(2) / 5) ;
    len2 = uint16(inpSize(2) / 3.5) ;
    wth1 = uint16(inpSize(1) / 9) ;
    wth2 = uint16(inpSize(1) / 9) ;
end
     
subImgInd(1,:) = [wth1 (inpSize(1)-wth2)];
subImgInd(2,:) = [len1 (inpSize(2)-len2)];
subImg =inputImg(subImgInd(1,1):subImgInd(1,2), ...
                 subImgInd(2,1):subImgInd(2,2), ...
                 subImgInd(3,1):subImgInd(3,2));

%% Distinguish by Location

if(whichImg == 1)
    subImg = im2double(subImg);
    subImg = subImg./255 ;
    
    ssImg = subImg(:,:,1).*subImg(:,:,1) + ...
            subImg(:,:,2).*subImg(:,:,2) + ...
            subImg(:,:,3).*subImg(:,:,3)*0;
    
    ssImg = ssImg > 0.000013;
    comb = 25;
    nnbr=4;
else
    subImg = im2double(subImg);
    subImg = subImg / 255 ;
    
    ssImg = subImg(:,:,1).*subImg(:,:,1) + ...
            subImg(:,:,2).*subImg(:,:,2)*0 + ...
            subImg(:,:,3).*subImg(:,:,3);
    ssImg = ssImg > 0.0000158;
    comb = 30;
    nnbr = 4;
end

ssImg = reshape(ssImg,[(subImgInd(1,2)-subImgInd(1,1) + 1), ...
                        (subImgInd(2,2)-subImgInd(2,1) + 1)]);

ssSize = size(ssImg);
    
%% Fill up Empty Spaces

% Change 20 to 5 for faster output
for t=1:20
    ssImg2 = ssImg*0;
    for r=1:ssSize(1)
        for c=1:ssSize(2)
            if(ssImg(r,c) == 0)
                
                r1 = max(r-comb,1);
                r2 = min(r+comb,ssSize(1));
                c1 = max(c-comb,1);
                c2 = min(c+comb,ssSize(2));
                
                r11 = max(r-1,1);
                r22 = min(r+1,ssSize(1));
                c11 = max(c-1,1);
                c22 = min(c+1,ssSize(2));

                subMat = ssImg(r11:r22,c11:c22);
                nbr = sum(subMat(:));
                med = mode(subMat(:));
                if(nbr > nnbr | med == 1)
                    ssImg2(r,c) = 1;
                else
                    closT = max(max(ssImg(r1:r,c))) + ...
                    max(max(ssImg(r:r2,c))) + ...
                    max(max(ssImg(r,c1:c))) + ...
                    max(max(ssImg(r,c:c2))) ;
                    if(closT==4)
                        ssImg2(r,c) = 1;
                    end    
                end
            end
        end
    end
    ssImg = ssImg + ssImg2;
end


if(whichImg == 1)
    comb = 80;
    ssImg2 = ssImg*0;
    for r=1:ssSize(1)
        for c=(430-len1):ssSize(2)
            if(ssImg(r,c) == 0)
                r1 = max(r-comb,1);
                r2 = min(r+comb,ssSize(1));
                c1 = max(c-comb,1);
                c2 = min(c+comb,ssSize(2));

                closT = max(max(ssImg(r1:r,c))) + ...
                max(max(ssImg(r:r2,c))) + ...
                max(max(ssImg(r,c1:c))) + ...
                max(max(ssImg(r,c:c2))) ;
                if(closT==4)
                    ssImg2(r,c) = 1;
                end    
            end
        end
    end
    ssImg = ssImg + ssImg2;
end

outMask(subImgInd(1,1):subImgInd(1,2), ...
             subImgInd(2,1):subImgInd(2,2)) = ssImg;         
    
myNumOfColors = 200;
myColorScale = [ [0:1/(myNumOfColors-1):1]' , ...
[0:1/(myNumOfColors-1):1]', [0:1/(myNumOfColors-1):1]' ];

f1=figure('visible','Off');
imagesc(outMask);
colormap (myColorScale);
colormap jet;
daspect ([1 1 1]);
axis tight;
colorbar;
saveas(f1,'Mask','jpeg');

f2=figure('visible','Off');
imagesc(uint8(outMask).*inputImg);
colormap (myColorScale);
colormap jet;
daspect ([1 1 1]);
axis tight;
colorbar;
saveas(f2,'Foreground','jpeg');

outMask1 = outMask + 1;
outMask1(outMask1==2) = 0;

f3=figure('visible','Off');
imagesc(uint8(outMask1).*inputImg);
colormap (myColorScale);
colormap jet;
daspect ([1 1 1]);
axis tight;
colorbar;
saveas(f3,'Background','jpeg');


figure('Name','Q1(a)');
colormap (myColorScale);
colormap jet;
daspect ([1 1 1]);
axis tight;
colorbar;
montage({imread('Mask.jpg') , ...
    imread('Foreground.jpg') , ...
    imread('Background.jpg')})

end