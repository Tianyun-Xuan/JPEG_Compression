clear all;
close all;
clc;
%% 初始化
load lena512;
load quant;
imdct=zeros(512,512);
lena=lena512-128;%[0,255]->[-128,127]
alpha=5;%调节感知能力
quant=alpha*quant;%模拟人眼的量化矩阵
%JPEG 压缩流程：DCT2->量化->曲线阅读->编码->压缩码

%% 二维离散余弦变换 DCT2
%一方面，从图像处理的整体流程而言，变换后便于后续处理；
%另一方面，从编码的角度而言，变换后使图像信息集中，在数学上体现为描述关键信息的系数变少，相应的，所需存储空间降低，达到降低视频体积的目的。
for l=1:64
    for c=1:64
        imdct(1+(l-1)*8:l*8,1+(c-1)*8:c*8)=dct2(lena(1+(l-1)*8:l*8,1+(c-1)*8:c*8));
    end
end
% figure
% imshow(imdct,[0 255])

%% 量化 Quantification
%高频率的信息更难被眼睛捕捉 用quant矩阵模拟眼睛的感知能力 对矩阵进行分块(8x8)量化
for l=1:64
    for c=1:64
        imquant(1+(l-1)*8:l*8,1+(c-1)*8:c*8)=round((imdct(1+(l-1)*8:l*8,1+(c-1)*8:c*8))./quant);
    end
end
% figure
% imshow(imquant,[0 255])
nombrezeros=(512*512-nnz(imquant));
pourcentzeros=100*nombrezeros/(512*512);
%量化效果可以用 0值的占比来进行衡量


%% 解压缩
for l=1:64
    for c=1:64
        decomp(1+(l-1)*8:l*8,1+(c-1)*8:c*8)=idct2((imquant(1+(l-1)*8:l*8,1+(c-1)*8:c*8)).*quant);
    end
end
decomp=decomp+128;
% figure;
% subplot(1,2,1);
% imshow(lena512,[0,255]);
% subplot(1,2,2);
% imshow(decomp,[0,255]);



%% 评估图像质量
%图像的质量 则用 le Peak Signal to Noise Ratio 值来显现
image_psnr=psnr(lena512,decomp,255);% A，ref,peakval

% 用循环
MSE=0;
for i=1:512
    for j=1:512
        MSE=MSE+(decomp(i,j)-lena512(i,j))^2;
    end
end
MSE=MSE/(512*512);
% 用immse() 
mse=immse(decomp,lena512);
% PSNR 的定义：最大像素容量(puissance)/均方误差
C_psnr=10*log10(255^2/MSE);




