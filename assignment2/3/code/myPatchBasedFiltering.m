function rmsd = myPatchBasedFiltering(Img1,Img2,corrupt, h_param , displ)
if corrupt
   I0 = double(Img1);
   [X,Y] = size(I0);
   I1 = double(Img2)*256;
   ResImage = double(zeros(X,Y));
else
   I0 = Img1;
    [X,Y] = size(I0);
    I1 = zeros(X,Y);
    ResImage = double(zeros(X,Y));

    rand('seed' , 0);
     range = max(max(I0))-min(min(I0));
     for i=1:X
         for j=1:Y
             x = normrnd(0,0.05*range);
             I1(i,j) = I0(i,j) + x;    
         end
     end 
end    

patch = zeros(9,9);
for i=1:9
    for j=1:9
        d = (i-5)*(i-5)+(j-5)*(j-5);
        patch(i,j) = exp(-d);
    end
end

patchStore = double(zeros(9,9,X,Y)); 
for i=1:X
     for j=1:Y
         for k=-4:4
             for l=-4:4
                  if(i+k < 1 || j+l < 1 || j+l > Y || i+k > X) 
                       patchStore(k+5,l+5,i,j) = -1;
                  else
                       patchStore(k+5,l+5,i,j) = I1(i+k,j+l);
                  end    
              end
         end  
     end    
 end

rmsd=0.0;
for i=1:X  
    for j=1:Y
        lx = max(1,j-8);
        rx = min(X,j+8);
        uy = max(1,i-8);
        dy = min(Y,i+8);
        window = I1(uy:dy,lx:rx);
        weight = window;
        tempPatch = zeros(9,9);
        for k=-4:4
            for l=-4:4
                if(i+k < 1 || i+k > Y || j+l < 1 || j+l > X) 
                    tempPatch(k+5,l+5)=-1;
                else
                    tempPatch(k+5,l+5) = I1(i+k,j+l);
                end    
            end
        end    

        for p=uy:dy
            for q=lx:rx
                patchNew = patchStore(:,:,p,q); 
                temp = 0.0;
                for a=1:9
                    for b=1:9
                        if(patchNew(a,b) == -1 || tempPatch(a,b) == -1) 
                            continue;
                        else
                            diff = abs(patchNew(a,b)-tempPatch(a,b));
                            temp = temp + (patch(a,b)*patch(a,b))*(diff*diff);
                        end 
                    end
                end    

                weight(p-uy+1,q-lx+1) = double(exp(-1.0*temp/(h_param*h_param)));  
               
            end    
        end

        tot = sum(sum(weight));
        weight = weight/tot;
        ResImage(i,j) = sum(sum(window.*weight));
        rmsd=rmsd+(I0(i,j)-ResImage(i,j))*(I0(i,j)-ResImage(i,j));
    end
end

rmsd = rmsd/(X*Y*1.0);
rmsd = sqrt(double(rmsd));
if displ == 1

    disp("Optimal Parameters")
    disp("Sigma")
    disp(h_param)
    disp("Best Error");
    disp(rmsd);


    colormap = [min(I0(:)) max(I0(:))];
    figure;
    subplot(1,2,1), imshow(I0,colormap) , title("Original")
    subplot(1,2,2), imshow(I1,colormap) , title("Noisy")

    figure;
    subplot(1,2,1), imshow(ResImage ,colormap) , title("Corrected")
    subplot(1,2,2), imshow(patch , []),  title("Mask");
end
end
