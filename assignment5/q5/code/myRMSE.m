function err = myRMSE(im_clean , im_orig)
    num = norm(im_clean - im_orig, 'fro');
    denum = norm(im_orig, 'fro');
    err = (num*num) / (denum*denum ); 
end