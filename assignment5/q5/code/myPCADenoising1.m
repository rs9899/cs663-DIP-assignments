function [im_clean] = myPCADenoising1(im_noisy)
    % pca_1
    % referred to https://elib.uni-stuttgart.de/bitstream/11682/9924/1/Bachelorarbeit_FangBao.pdf
    pat = 7;
    sigma = 20;

    [n1,n2] = size(im_noisy);
    N = (n1 - pat + 1) * (n2 - pat + 1);
    P = zeros(pat*pat,N);
    for j=1:pat
        for i = 1:pat
            each_point = im_noisy(i : i + (n1 - pat) , j:j+(n2 - pat));
            P(7 * (j-1) + i , :) = each_point(:);
        end
    end
    % mean operation might be helpful == 

    [V,~] = eig(P*P');
    alpha = P' * V;
    alpha_2 = alpha .* alpha;
    a_j_2 = max(0,mean(alpha_2,1) - sigma*sigma ) ;

    divider = 1 + ((sigma*sigma) ./ a_j_2);

    alpha_denoised = alpha ./ divider;
    P_clean = V * alpha_denoised';

    im_clean = zeros(size(im_noisy));
    repeat_count = zeros(size(im_noisy));
    for j=1:pat
        for i = 1:pat
            im_clean(i : i + (n1 - pat) , j:j+(n2 - pat)) = ...
                reshape(P_clean(7 * (j-1) + i , :) , (n1 - pat+1) , (n2 - pat+1)) ...
                + im_clean(i : i + (n1 - pat) , j:j+(n2 - pat)) ;
            repeat_count(i : i + (n1 - pat) , j:j+(n2 - pat)) = ...
                repeat_count(i : i + (n1 - pat) , j:j+(n2 - pat)) + 1;
        end
    end

    im_clean = im_clean ./ repeat_count;

end

