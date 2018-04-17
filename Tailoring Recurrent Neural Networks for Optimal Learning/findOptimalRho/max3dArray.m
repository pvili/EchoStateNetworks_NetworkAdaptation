function [ maxVal, Idx ] = max3dArray( M )

 N=size(M);
 if length(N)<3
    error(' Input 3D array');
 end

 [a,t]=max(M(:));
 maxVal=a;
 index1=ceil(t/(N(1)*N(2)));

 %Now we find the slice that contains the Max
 Temp=M(:,:,index1);

 [index2,index3]=find(Temp==max(Temp(:)));

 Idx=[index2;index3;index1]';
end

