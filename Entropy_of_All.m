function [En]=Entropy_of_All(Class)
IC=Rtabulate(Class);
[height,~]=size(IC);
En=0;
for i=1:height
    En=En-0.01*IC(i,3)*log2(0.01*IC(i,3));
end