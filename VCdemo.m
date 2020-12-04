clear all;
close all;
clc;
%% ��ʼ��
load lena512;
load quant;
imdct=zeros(512,512);
lena=lena512-128;%[0,255]->[-128,127]
alpha=5;%���ڸ�֪����
quant=alpha*quant;%ģ�����۵���������
%JPEG ѹ�����̣�DCT2->����->�����Ķ�->����->ѹ����

%% ��ά��ɢ���ұ任 DCT2
%һ���棬��ͼ������������̶��ԣ��任����ں�������
%��һ���棬�ӱ���ĽǶȶ��ԣ��任��ʹͼ����Ϣ���У�����ѧ������Ϊ�����ؼ���Ϣ��ϵ�����٣���Ӧ�ģ�����洢�ռ併�ͣ��ﵽ������Ƶ�����Ŀ�ġ�
for l=1:64
    for c=1:64
        imdct(1+(l-1)*8:l*8,1+(c-1)*8:c*8)=dct2(lena(1+(l-1)*8:l*8,1+(c-1)*8:c*8));
    end
end
% figure
% imshow(imdct,[0 255])

%% ���� Quantification
%��Ƶ�ʵ���Ϣ���ѱ��۾���׽ ��quant����ģ���۾��ĸ�֪���� �Ծ�����зֿ�(8x8)����
for l=1:64
    for c=1:64
        imquant(1+(l-1)*8:l*8,1+(c-1)*8:c*8)=round((imdct(1+(l-1)*8:l*8,1+(c-1)*8:c*8))./quant);
    end
end
% figure
% imshow(imquant,[0 255])
nombrezeros=(512*512-nnz(imquant));
pourcentzeros=100*nombrezeros/(512*512);
%����Ч�������� 0ֵ��ռ�������к���


%% ��ѹ��
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



%% ����ͼ������
%ͼ������� ���� le Peak Signal to Noise Ratio ֵ������
image_psnr=psnr(lena512,decomp,255);% A��ref,peakval

% ��ѭ��
MSE=0;
for i=1:512
    for j=1:512
        MSE=MSE+(decomp(i,j)-lena512(i,j))^2;
    end
end
MSE=MSE/(512*512);
% ��immse() 
mse=immse(decomp,lena512);
% PSNR �Ķ��壺�����������(puissance)/�������
C_psnr=10*log10(255^2/MSE);




