I=imread('download.jpg');
Gray_I= rgb2gray(I); %converted into gray scaled image
Gray_I = im2double(Gray_I); 
%imshow(itg)
imhist(Gray_I);hold on;
%% 

%representing discrete cosine transform using 8 by 8 blocks
B = blkproc(Gray_I,[8 8],'dct2');
B = ceil(B*1000);
%% 

%% 

%quantization values for each quality level
q_low = 8;
q_medium = 16;
q_high = 8;

%performing quantization
Blow = B/(2*q_low);
Blow = ceil(Blow);
%% 

%calculate frequency and its probability for each quantized value
[glow,~,intensity_val] = grp2idx(Blow(:));
Frequency = accumarray(glow,1);
probability = Frequency./(225*225);
T = table(intensity_val ,Frequency,probability);
%% 

%perform huffman coding
dict=huffmandict(intensity_val,probability);
encode_I = huffmanenco(Blow(:),dict);
%% 

%perform huffman decoding
decode_I = huffmandeco(encode_I,dict);
re_img = reshape(decode_I,[225 225]); %reshaping the image


%% 

%dequantization
Blow2 = re_img*q_low*2;
Blow2 = Blow2/1000;

I_decoded = blkproc(Blow2,[8 8],'idct2'); %performing inverse dct
imshow(Gray_I),figure,imshow(I_decoded);
%% 

imhist(I_decoded);
%% 

%perform run length coding
[d, c ] = my_RLE(Blow(:));
%% 
decode_I2 = rl_dec(d,c);
re_img2 = reshape(decode_I2,[225 225]);
imshow(re_img2);
%% 
%dequantization
Blow3 = re_img2*q_medium*2;
Blow3 = Blow3/1000;

I_decoded2 = blkproc(Blow2,[8 8],'idct2'); %performing inverse dct
imshow(Gray_I),figure,imshow(I_decoded2);
