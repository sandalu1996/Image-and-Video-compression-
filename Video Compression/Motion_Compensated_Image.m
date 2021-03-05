% Computes motion compensated image using the given motion vectors
% Input
% I : The reference image
% motionVect : The motion vectors
% block_size : Size of the macroblock
% Ouput
% imgComp : The motion compensated image
%

function imgComp = Motion_Compensated_Image(I, motionVect,N)
[height width] = size(I);
block_Count = 1;
for i = 1:N:height-N+1
 for j = 1:N:width-N+1

 % dy is row(vertical) index
 % dx is col(horizontal) index
 % this means we are scanning in order

 dy = motionVect(1,block_Count);
 dx = motionVect(2,block_Count);
 refBlkVer = i + dy;
 refBlkHor = j + dx;
 imageComp(i:i+N-1,j:j+N-1) = I(refBlkVer:refBlkVer+N-1,refBlkHor:refBlkHor+N-1);

 block_Count = block_Count + 1;
 end
end
imgComp = imageComp