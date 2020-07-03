tic;

A1 = reshape(1:63 , [9,7]);
[u1,s1,v1] = MySVD(A1);

u1*s1*v1' %#ok<*NOPTS>

A2 = reshape(1:63 , [7,9]);
[u2,s2,v2] = MySVD(A2);

u2*s2*v2'

