function outImg = mySpatiallyVaryingKernel(inpImage, inpMask,dThres)

inpImage = double(inpImage);
inpImage = inpImage / 255;

inpSize = size(inpMask);
dThres = uint16(dThres);

gridX = double( [-1*double(dThres) : 1 : double(dThres)]);
gridX = gridX .* gridX;

gridr = double(zeros(1,2*dThres+1)) + 1;
gridc = double(zeros(2*dThres+1,1)) + 1;

distRef = sqrt((gridX' * gridr) + (gridc * gridX));

minDistMat = double(zeros(inpSize(1),inpSize(2)));

myNumOfColors = 200;
myColorScale = [ [0:1/(myNumOfColors-1):1]' , ...
[0:1/(myNumOfColors-1):1]', [0:1/(myNumOfColors-1):1]' ];

%% Compute r

for r=1:inpSize(1)    
    for c=1:inpSize(2)
        
        r1 = max(r-dThres,1);
        r2 = min(r+dThres,inpSize(1));
        c1 = max(c-dThres,1);
        c2 = min(c+dThres,inpSize(2));
                
        distRef1 =  distRef((dThres+1)-(r-r1) : (dThres+1)+(r2-r), ...
                           (dThres+1)-(c-c1) : (dThres+1)+(c2-c));
            
        subMask = inpMask(r1:r2,c1:c2);
        if (sum(sum(subMask)) == 0)
            minDistMat(r,c) = dThres;
        else
            distRef1 = distRef1 + 1;
            distMat = distRef1 .* subMask;
            distMat(distMat == 0) = inf;
            minDist1 = min(distMat(:)) - 1;
            minDistMat(r,c) = min(minDist1,dThres);
            
        end
    end
end

f1=figure('visible','off');
h = surf(flip(minDistMat));
set(h,'LineStyle','none');
saveas(f1,'jet','jpeg');

f1=figure('visible','off');
contour(flip(minDistMat));
saveas(f1,'contour','jpeg');
  
figure('Name','Q1(b)');
colormap (myColorScale);
colormap jet;
daspect ([1 1 1]);
axis tight;
colorbar;
montage({imread('jet.jpg'),imread('contour.jpg')})

outImg = inpImage;
for r=1:inpSize(1)    
    for c=1:inpSize(2)
        
        r1 = max(r-dThres,1);
        r2 = min(r+dThres,inpSize(1));
        c1 = max(c-dThres,1);
        c2 = min(c+dThres,inpSize(2));
                
        distRef1 =  distRef((dThres+1)-(r-r1) : (dThres+1)+(r2-r), ...
                           (dThres+1)-(c-c1) : (dThres+1)+(c2-c));
            
        validMat = distRef1 <= minDistMat(r,c);
        disc =  validMat / sum(validMat(:));
        
        outImg(r,c,:) = sum(sum(disc .* inpImage(r1:r2,c1:c2,:)));
    end
end

%% Discs

distRatios = [0.2 0.4 0.6 0.8 1.0];
dists = distRatios*double(dThres);

for i=1:5
    validMat = distRef <= dists(i);
    disc =  validMat / sum(validMat(:));
    
    f1=figure('visible','Off');
    imagesc(disc);
    colormap (myColorScale);
    colormap jet;
    daspect ([1 1 1]);
    axis tight;
    colorbar;
    saveas(f1,num2str(i),'jpeg');
    

end

figure('Name','Q1(c)');
colormap (myColorScale);
colormap jet;
daspect ([1 1 1]);
axis tight;
colorbar;
montage({imread('1.jpg') ,imread('2.jpg') , ...
    imread('3.jpg') ,imread('4.jpg') ,imread('5.jpg')})

%% Output

f1=figure('visible','Off');
imagesc(inpImage);
colormap (myColorScale);
colormap jet;
daspect ([1 1 1]);
axis tight;
colorbar;
saveas(f1,'inpI','jpeg');
             
f1=figure('visible','Off');
imagesc(outImg);
colormap (myColorScale);
colormap jet;
daspect ([1 1 1]);
axis tight;
colorbar;
saveas(f1,'outI','jpeg');

figure('Name','Q1(d)');
colormap (myColorScale);
colormap jet;
daspect ([1 1 1]);
axis tight;
colorbar;
montage({imread('inpI.jpg') , ...
    imread('outI.jpg')})

    
end