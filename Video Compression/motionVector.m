%% 
%f1: anchor frame; f2: target frame, fp: predicted image;
%mvx,mvy: store the MV image
%widthxheight: image size; N: block size, R: search range

function [vector,residue] = motionVector(f1,f2,N)
S = size(f1);
height = S(1);
width = S(2);
%N = 8;
%R = -50:50;
vectors = zeros(2,floor(height/N)*floor(width/N));
blk_count = 1;
%% 


for i=1:N:height-N+1
for j=1:N:width-N+1 %for every block in the anchor frame 

MAD_min=256*N*N;
mvx=0;
mvy=0;

for k= 1:1:height-N+1
for l= 1:1:width-N+1 %for every search candidate
refBlkVer = i + k; % row/Vert co-ordinate for ref block
refBlkHor = j + l; % col/Horizontal co-ordinate
if ( refBlkVer < 1 || refBlkVer+N-1 > height || refBlkHor < 1 || refBlkHor+N-1 > width)
continue;
end
MAD=sum(sum(abs(f1(i:i+N-1,j:j+N-1)-f2(i+k:i+k+N-1,j+l:j+l+N-1))));
% calculate MAD for this candidate
if MAD<MAD_min
MAD_min=MAD;dy=k;dx=l;
end;
end;
end;
fp(i:i+N-1,j:j+N-1)= f2(i+dy:i+dy+N-1,j+dx:j+dx+N-1); 
%put the best matching block in the predicted image
vectors(1,blk_count) = dy; % row co-ordinate for the vector
vectors(2,blk_count) = dx; % col co-ordinate for the vector
blk_count = blk_count+1;
end;
end;
vector = vectors;
S2 = size(fp);
residue = f2(1:S2(1),1:S2(2)) - fp;