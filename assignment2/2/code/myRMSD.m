function error = myRMSD(img,out)
% myRMSD Summary of this function goes here
%   Take an image, and filtered and find error

diff = (img - out);
diff = diff .* diff;
one_mat = zeros(size(img)) + 1;

N = sum(one_mat , 'all');
diff = diff / N;

error = sum(diff , 'all');

error = error .^ 0.5;

end

