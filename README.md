# JPEG_Compression
在matlab里实现JPEG的压缩
## JPEG压缩的基本流程
！graphe/1.png
##
%% 编码
% Run Length
    %The DC coefficient of the 2D-DCT (discrete cosine transform) of an 8 x 8 image block,
    %represents the average value of the samples within the 8 x 8 block.
    %矩阵最左上角的是采样平均值 跟FFT一样 被称为 此矩阵的DC值 此矩阵剩余的值被称为AC值
    %采用 Run Length Encoding (sur les zéros)
    %从矩阵左上角的DC值开始蛇形读取值，因为低频信号集中在左上角
    %编码写法为 (x1,y1)B1(x2,y2)B2...
    %其中B1表示非0数的二进制编码 如 -4->011
    %x1指的是B1所指的数之前有多少个0
    %y1指的是B1二进制编码的长度
    
%Codage entropiaue (Huffman)
    %将之前Run Length 码中的(x,y)部分再次编码，B部分不动