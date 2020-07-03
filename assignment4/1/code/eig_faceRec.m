function [X_mean , V, new_mat] = eig_faceRec(data)
    % data of form D*n
    X_mean = mean(data,2);
    X = data - X_mean;
    L = X' * X;
    [V , D] = eig(L);
    [~,idx]=sort(diag(D),'descend');
%     D = D(idx,idx);
    V = V(:,idx);
    
    V = X*V;
    V = normc(V);
    
    new_mat = data;
    for i=1:size(data,2)
        X_mean = mean(data(:,i));
        S = std(data(:,i));
        new_mat(:,i)=(data(:,i)-X_mean)/S;
    end
end