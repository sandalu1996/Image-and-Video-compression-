%% 
f1 = imread('cat1.jpg');
f2 = imread('cat2.jpg');
f1= rgb2gray(f1); %converted into gray scaled image
f1 = im2double(f1);
f1 = imresize(f1, [100 130]);
f2= rgb2gray(f2); 
f2 = im2double(f2);
f2 = imresize(f2, [100 130]);
%% 
[Motion_vector,residue] = motionVector(f1,f2,8); %Calculating Motion vector
%% 

S = size(residue);
%% 
B = blkproc(residue,[8 8],'dct2');
B = ceil(B*1000);

%% 

%quantization values for each quality level
q_low = 32;
q_medium = 8;
q_high = 8;

%performing quantization
Blow = B/(2*q_medium);
Blow = ceil(Blow);
%% 

%calculate frequency and its probability for each quantized value
[glow,~,intensity_val] = grp2idx(Blow(:));
Frequency = accumarray(glow,1);
probability = Frequency./(S(1)*S(2));
T = table(intensity_val ,Frequency,probability);
%% 

%perform huffman coding
dict=huffmandict(intensity_val,probability);
encode_I = huffmanenco(Blow(:),dict);

%% 
[d,c] = my_RLE(Blow(:));

%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Transmision%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 
compensated_img = Motion_Compensated_Image(f1,Motion_vector,8);


%% 
decode_I = huffmandeco(encode_I,dict);
re_img = reshape(decode_I,[S(1) S(2)]); %reshaping the image

%% 
re_img = RLE_dec(d,c);
re_img = reshape(re_img,[S(1) S(2)]);

%% 

%dequantization
Blow2 = re_img*q_medium*2;
Blow2 = Blow2/1000;

I_decoded = blkproc(Blow2,[8 8],'idct2'); %performing inverse dct

%% 
I_decode_dash = I_decoded(1:96,1:128);
%Residue_dash = Residue(1:96,1:128);
%% 
compensated_img = im2double(compensated_img);
%Residue_dash = im2double(Residue_dash);
Recontruct_img = compensated_img + I_decode_dash;
%Recontruct_img2 = compensated_img + Residue_dash;

