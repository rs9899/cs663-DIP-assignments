function myMeanShiftSeg(img, colour_kernel, space_kernel, num_neighbour, lr)
%myMeanShiftSeg Summary of this function goes here
%   The Main Function

img2 = double(img);
maxIntensity = max(img2,[],'all');
img2 = img2 / maxIntensity;
img = img2;

% figure;
% imshow(img2,[]);
max_iter = 25;
% max_clstr = 20;
% num_neighbour = 20;
% colour_kernel = 0.9;
% space_kernel = 10;
% lr = 1;
k_grid = [colour_kernel,colour_kernel,colour_kernel,space_kernel,space_kernel];
% 2 sigma square
k_grid = 2 * k_grid .* k_grid;

%% Function


[len, wid, chan] = size(img2);


img_mod = img2;
img_mod(:,:,chan+1) = meshgrid(1:len,1:wid)';
img_mod(:,:,chan+2) = meshgrid(1:wid,1:len);
% color and x,y cordiante
num_feat = chan+2;

img_lin = reshape(img_mod , [len*wid , num_feat]);
%% Loop
for lp = 1: max_iter
    neighbour_list = knnsearch(img_lin,img_lin,'k',num_neighbour);
    neighbour_weight = zeros(size(neighbour_list));
    grad = zeros(size(img_lin));

    for nbr = 1:num_neighbour
        feat_nbr = img_lin(neighbour_list(:,nbr) , :);
        feat_nbr = feat_nbr - img_lin;
        feat_nbr = -1 * (feat_nbr .* feat_nbr);
        feat_nbr = feat_nbr ./ k_grid;
        feat_nbr = exp(feat_nbr);
        neighbour_weight(:,nbr) = prod(feat_nbr,2);
        grad = grad + (img_lin(neighbour_list(:,nbr) , :) .* neighbour_weight(:,nbr)); 
    end

    normCons = sum(neighbour_weight,2);
    grad = grad ./ normCons;

    img_lin = img_lin + lr * (grad - img_lin);
    img2 = reshape(img_lin ,[len, wid , num_feat]);
    img2 = img2(:,:,1:3);
    
    
%     pause;
end

disp("Tuned Params")
disp("colour_kernel")
disp(colour_kernel)
disp("space_kernel")
disp(space_kernel)
disp("Number of neighbours")
disp(num_neighbour)
disp("Learning Rate")
disp(lr)
figure;
c_map = [min(img,[],'all'),max(img,[],'all')];
subplot(1,2,1), imshow(img,c_map), title("Original")
subplot(1,2,2), imshow(img2,c_map), title("Segmented")
% for each pixel
% pxl = 233;
% neighbour = neighbour_list(pxl,:);
% 
% feat_n = img_lin(neighbour,:);
% x_i = img_lin(pxl,:);
% 
% feat_diff = feat_n - x_i;
% 
% %% evaluating the kernel fnction
% 
% space_membership = gaussmf(feat_n(:,chan+1) , [space_kernel,x_i(chan+1)]) .* ...
%     gaussmf(feat_n(:,chan+2) , [space_kernel,x_i(chan+2)]) ;
% colour_membership = space_membership;
% for i = 1:chan
%     colour_memership = colour_memership .* gaussmf(feat_n(:,i) , [colour_kernel,x_i(i)]);
% end
    
%% gradient
% grad = sum over all neighbour(intensity * membership) / sum(membership) - x 


%% gaussmf(slice,[intensity_sig img(x,y)])
% 
% outputArg1 = img;
% outputArg2 = param;
end

