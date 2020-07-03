function [U,S,V] = MySVD(A)
    % Used Eigs instead of EIG and the optimisation
    % Done only for real case -- not used conjugate transpose ..
    [m,n] = size(A);
    sm = min(m,n);
    [U,D] = eigs(A*A', sm);
    S = sqrt(abs(D));
    V = normc(A' * U);
end

