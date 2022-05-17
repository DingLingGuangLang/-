%% Introduction
% This file is intended to reconstruct a photo with multiple 
% other photos.
% Prepared by DingLingGuangLang.
%% Read Images and Decrease Resolution
InputPath = 'D:\SUN-Matlab\screen shots\';
OutputPath = 'D:\SUN-Matlab\';
Inputlist = dir([InputPath,'*.jpg']);
ratio = 10; % De-resolve ratio. m/ratio and n/ratio must be integers.
Image_deresolve = cell(1,length(Inputlist));
Image_deresolve_meanval = zeros(1,length(Inputlist));
for i = 1:length(Inputlist)
    Name = Inputlist(i).name;
    Image = imread([InputPath,Name]);
    Image = rgb2gray(Image);
    [m,n] = size(Image);
    Image = Image(:,floor((n-m)/2):n-floor((n-m)/2)-1);
    Image_small = zeros(m/ratio,m/ratio);
    for j = 1:m/ratio
        for k = 1:m/ratio
            part = Image(j*ratio-ratio+1:j*ratio,k*ratio-ratio+1:k*ratio,1);
            Image_small(j,k) = mean(part,'all');
        end
    end
    Image_deresolve{i} = uint8(Image_small);
    Image_deresolve_meanval(i) = mean(Image_small,'all');
end
[Image_deresolve_meanval,ind] = sort(Image_deresolve_meanval,'ascend');
Image_deresolve = Image_deresolve(ind);
%% Plot Decreased Resolution Images
figure(1)
for i = 1:8
    subplot(2,4,i)
    imshow(Image_deresolve{length(Inputlist)/2+i})
    mat = cell2mat(Image_deresolve(length(Inputlist)/2+i));
    title(['Mean Brightness: ',num2str(mean(mat,'all'))])
end
%% Read Image to be Reconstructed
Rani = imread('Rani.jpg');
[m,n,~] = size(Rani);
Rani_deresolve = Rani(1:5:m,1:5:n,:);
Rani_gray = rgb2gray(Rani_deresolve);
%% Plot Gray-Scale Image and Histogram
figure(2)
subplot(1,2,1)
imshow(Rani_gray)
title('Gray-scale Photo')
subplot(1,2,2)
histogram(Rani_gray,Image_deresolve_meanval)
title('Bins')
%% Reconstruct Gray-Scale Image
Rani_gray = double(Rani_gray);
[m,n] = size(Rani_gray);
Reconstruct = cell(m,n);
for i = 1:m
    for j = 1:n
        [~,ind] = min(abs(Image_deresolve_meanval-Rani_gray(i,j)));
        Reconstruct(i,j) = Image_deresolve(ind);
    end
end
Reconstruct = cell2mat(Reconstruct);
%% Color the Small Images According to The Big Image Pixels
[p,q] = size(Reconstruct);
Reconstruct_color = zeros(p,q,3);
ii = 1;
for i = 1:p/m:p-p/m
    jj = 1;
    for j = 1:q/n:q-q/n
        for k = 1:3
        Reconstruct_color(i:i+p/m-1,j:j+q/n-1,k) = Reconstruct(i:i+p/m-1,j:j+q/n-1)+Rani_deresolve(ii,jj,k);
        end
        jj = jj+1;
    end
    ii = ii+1;
end
for i = 1:3
    Reconstruct_color(:,:,i) = Reconstruct_color(:,:,i)./max(max(Reconstruct_color(:,:,i)))*255;
end
Reconstruct_color = uint8(Reconstruct_color);
%% Plot Reconstructed Gray-Scale and Colored Images
figure(3)
subplot(1,2,1)
imshow(Reconstruct)
title('Gray-scale Reconstructed Photo')

subplot(1,2,2)
imshow(Reconstruct_color)
title('Colored Reconstructed Photo')

%% Save Images
imwrite(Reconstruct,'RaniReconstruct.jpg')
imwrite(Reconstruct_color,'RaniReconstructColor.jpg')
