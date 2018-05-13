
clear;
load('arabicDigitRecognitionTests_Cycles.mat');
M11 = correctDigitMtx(1,:,:,:,1);
M12 = correctDigitMtx(1,:,:,:,2);
M13 = correctDigitMtx(1,:,:,:,3);
M21 = correctDigitMtx(2,:,:,:,1);
M22 = correctDigitMtx(2,:,:,:,2);
M23 = correctDigitMtx(2,:,:,:,3);

m11 = zeros(21,1);
std11 = zeros(21,1);
for i = 1:21
    tmpm = zeros(2000,1);
    flag = 1;
    for j = 1:10
        for k = 1:200
            tmpm(flag) = M11(1,j,k,i);
            flag = flag + 1;
        end
    end
    tmpm = 1.0 - tmpm;
    m11(i) = median(tmpm);
    std11(i) = std(tmpm);
end

m12 = zeros(21,1);
std12 = zeros(21,1);
for i = 1:21
    tmpm = zeros(2000,1);
    flag = 1;
    for j = 1:10
        for k = 1:200
            tmpm(flag) = M12(1,j,k,i);
            flag = flag + 1;
        end
    end
    tmpm = 1.0 - tmpm;
    m12(i) = median(tmpm);
    std12(i) = std(tmpm);
end

m13 = zeros(21,1);
std13 = zeros(21,1);
for i = 1:21
    tmpm = zeros(2000,1);
    flag = 1;
    for j = 1:10
        for k = 1:200
            tmpm(flag) = M13(1,j,k,i);
            flag = flag + 1;
        end
    end
    tmpm = 1.0 - tmpm;
    m13(i) = median(tmpm);
    std13(i) = std(tmpm);
end

m21 = zeros(21,1);
std21 = zeros(21,1);
for i = 1:21
    tmpm = zeros(2000,1);
    flag = 1;
    for j = 1:10
        for k = 1:200
            tmpm(flag) = M21(1,j,k,i);
            flag = flag + 1;
        end
    end
    tmpm = 1.0 - tmpm;
    m21(i) = median(tmpm);
    std21(i) = std(tmpm);
end

m22 = zeros(21,1);
std22 = zeros(21,1);
for i = 1:21
    tmpm = zeros(2000,1);
    flag = 1;
    for j = 1:10
        for k = 1:200
            tmpm(flag) = M22(1,j,k,i);
            flag = flag + 1;
        end
    end
    tmpm = 1.0 - tmpm;
    m22(i) = median(tmpm);
    std22(i) = std(tmpm);
end

m23 = zeros(21,1);
std23 = zeros(21,1);
for i = 1:21
    tmpm = zeros(2000,1);
    flag = 1;
    for j = 1:10
        for k = 1:200
            tmpm(flag) = M23(1,j,k,i);
            flag = flag + 1;
        end
    end
    tmpm = 1.0 - tmpm;
    m23(i) = median(tmpm);
    std23(i) = std(tmpm);
end
