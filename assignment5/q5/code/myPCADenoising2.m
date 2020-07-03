function [im_clean] = myPCADenoising2(im_noisy)
    K = 200;
    sigma = 20;
    % srch = 31;
    srch = 15;
    pat = 7;
    [n1,n2] = size(im_noisy);
    N = (n1 - pat + 1) * (n2 - pat + 1);
    P = zeros(pat*pat,N);
    for j=1:pat
        for i = 1:pat
            each_point = im_noisy(i : i + (n1 - pat) , j:j+(n2 - pat));
            P(7 * (j-1) + i , :) = each_point(:);
        end
    end

    P_clean = P;
    for i = 1:N
        cur_patch = P(:,i);
        x = mod(i,int16(n1-pat+1));
        y = idivide(i,int16(n1-pat+1))+1;

        x_l = max(1,x-15);
        x_r = min(x+15 , n1 - pat + 1);
        y_l = max(1,y-15);
        y_r = min(y+15 , n2 - pat + 1);

        P_ref = zeros(pat*pat , (x_r - x_l + 1)*(y_r - y_l + 1) );
        idx = 0;
        for x_j = x_l:x_r
            for y_j = y_l:y_r
                idx = idx + 1;
                P_ref(:,idx) = P(: , (n1-pat+1) * (y_j - 1) + x_j);
            end
        end
        neighbour = knnsearch(P_ref', cur_patch',  'k', K);
        P_ref = P_ref(:,neighbour);

        [V,~] = eig(P_ref*P_ref');
        alpha = P_ref' * V;
        alpha_2 = alpha .* alpha;
        a_j_2 = max(0,mean(alpha_2,1) - sigma*sigma ) ;

        divider = 1 + ((sigma*sigma) ./ a_j_2);

        alpha_patch = cur_patch'*V;
        alpha_denoised = alpha_patch ./ divider;
        P_clean(:,i) = V * alpha_denoised';

    end

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

