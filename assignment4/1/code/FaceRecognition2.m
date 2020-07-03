function FaceRecognition2()
% Mode ==  --> SVD

    P = '../../CroppedYale/';
    l = ls('../../CroppedYale/yaleB*');
    numFac = length(l);
    count=1;
    count2=1;
    face_tag = strings(numFac * 40,1);
    original_face_tag = strings(numFac * 24,1);
    size_img = 192*168;
    train_mat = zeros([size_img , numFac * 40]);
    test_mat = zeros([size_img , numFac * 24]);
    
    for i=1:numFac
        temp_D = strcat(P,l(i,:));
        tp = strcat(temp_D , '/*.pgm');
        numImg = length(ls(tp));
        D = dir(fullfile(temp_D,'*.pgm'));
        for j=1:40
            F = fullfile(temp_D,D(j).name);
            I = imread(F);
            I = im2double(I);
            train_mat(:,count) = I(:);
            face_tag(count) = strcat('s',int2str(i));
            count=count+1;
        end
        for j=41:numImg
            F = fullfile(temp_D,D(j).name);
            I = imread(F);
            I = im2double(I);
            test_mat(:,count2) = I(:);
            original_face_tag(count2) = strcat('s',int2str(i));
            count2=count2+1;
        end
    end
    train_mat = train_mat(:,1:count-1);
    test_mat = test_mat(:,1:count2-1);
    

    [M,U, ~] = Econsvd_faceRec(train_mat);
      
    k_list = [1 2 3 5 10 15 20 30 50 60 65 75 100 200 300 500 1000];
    out1 = [];
    for i = 1:length(k_list)
        k = k_list(i);
        Uk = U(:,1:k);
        
        coef = Uk' * (train_mat - M);
        
        test = test_mat - M;
        testCoeff = Uk' * test;
        
        score = 0;
        numTest = size(test_mat , 2);
        for j = 1:numTest
            dist = coef - testCoeff(:,j);
            dist = sum(dist.^2 , 1); 
            [~,labl] = min(dist);
            if strcmp(face_tag(labl) , original_face_tag(j))
                score = score + 1;
            end
        end
        out1 = [out1 score*100.0/numTest];             %#ok<AGROW>
    end
    figure, plot(k_list, out1);
    xlabel('k');
    ylabel('Recognition rate in %');
    title('Recognition rates for different k (Yale dataset)');
    
    out2 = [];
    for i = 1:length(k_list)
        k = k_list(i);
        Uk = U(:,4:k);
        
        coef = Uk' * (train_mat - M);
        
        test = test_mat - M;
        testCoeff = Uk' * test;
        
        score = 0;
        numTest = size(test_mat , 2);
        for j = 1:numTest
            dist = coef - testCoeff(:,j);
            dist = sum(dist.^2 , 1); 
            [~,labl] = min(dist);
            if strcmp(face_tag(labl) , original_face_tag(j))
                score = score + 1;
            end
        end
        out2 = [out2 score*100.0/numTest];        %#ok<AGROW>     
    end
    figure, plot(k_list, out2);
    xlabel('k');
    ylabel('Recognition rate in %');
    title('Recognition rates [After removing top 3 eigenvector](Yale dataset)');
%     disp("Recognintion rates")
%     disp(out1)
%     disp(out2)
      
end