function [X_mean , V , new_mat] = svd_faceRec(train_mat)
    % train_mat of form D*n
    new_mat = train_mat;
    for i=1:size(train_mat,2)
        X_mean = mean(train_mat(:,i));
        S = std(train_mat(:,i));
        new_mat(:,i)=(train_mat(:,i)-X_mean);
    end
%     X_mean = mean(train_mat,2);
%     X_std = std(train_mat,0,2);
%     new_mat = (train_mat - X_mean) ./ X_std;

    [V,~,~] = svd(new_mat,'econ');

end