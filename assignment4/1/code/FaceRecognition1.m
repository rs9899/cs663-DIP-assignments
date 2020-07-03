function FaceRecognition1(mode)
% Mode == 0 --> SVD
% Mode == 1 --> EIGen
    P = '../att_faces/s';
    count=1;
    count2=1;
    kVals = [1, 2, 3, 5, 10, 15, 20, 30, 50, 75, 100, 150, 170];
    recogRate = [];
    face_tag = strings(240,1);
    original_face_tag = strings(40,1);
    result = strings(40,1);
    train_mat = zeros([112*92 , 192]);
	test_mat = zeros([112*92 , 128]);

    for i=1:32
        temp_D = strcat(P,int2str(i));
        D = dir(fullfile(temp_D,'*.pgm'));
        for j=1:6
            F = fullfile(temp_D,D(j).name);
            I = imread(F);
    %         I = rgb2gray(I);
            I = im2double(I);
            train_mat(:,count) = I(:);
            face_tag(count) = strcat('s',int2str(i));
            count=count+1;
        end
        for j=7:10
            F = fullfile(temp_D,D(j).name);
            I = imread(F);
    %         I = rgb2gray(I);
            I = im2double(I);
            test_mat(:,count2) = I(:);
            original_face_tag(count2) = strcat('s',int2str(i));
            count2=count2+1;
        end
    end

%     for i=1:size(train_mat,2)
%         M = mean(train_mat(:,i));
%         S = std(train_mat(:,i));
%         new_mat(:,i)=(train_mat(:,i)-M)/S;
%     end
% 
%     [U,sigma,V] = svd(new_mat);

    %% Mode 0 => SVD Face Recognition
    if mode == 0
        [M,U, new_mat] = svd_faceRec(train_mat);
    end
    %% Mode 1 => Eig Face Recognition
    if mode == 1
        [M,U, new_mat] = eig_faceRec(train_mat);
    end
 
    for k = kVals
        count2 = 1;
        for i=1:size(test_mat,2)
            I=test_mat(:,i);
            new_I = (I-mean(I));
            vk = U(:,1:k);
            Idash = vk'*new_I;
            Ip = vk*Idash;
            for j=1:size(new_mat,2)
                dist(j)=norm(new_mat(:,j)-Ip);
            end
            [~,ans] = min(dist);
            result(count2)=face_tag(ans);
            count2=count2+1;
        end
        score = 0;
        for i=1:32
            if strcmp(result(i),original_face_tag(i))
                score=score+1;
            end
        end
        
        %% Accuracy
        recogRate = [recogRate, 100*score/40];
    end

    figure;
    if mode
        plot(1:length(kVals), recogRate, '-o');
        title('Recognition rate vs. k Using eig function');
    else
        plot(1:length(kVals), recogRate, '-o');
        title('Recognition rate vs. k Using svd function');
    end

end