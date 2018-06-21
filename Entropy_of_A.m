function [En,Ens,s]=Entropy_of_A(n,attributes,Class)
Ia=Rtabulate(attributes(:,n));
[height,~]=size(Ia);
Ens=zeros(1,height);
s=cell(1,height);
[hC,~]=size(Class);
for i=1:height
    k=1;
for j=1:hC
    if attributes(j,n)==Ia(i,1)
        T1C(k)=Class(j);
        k=k+1;
    end
end
s{i}=Rtabulate(T1C);
[hs,~]=size(s{i});
for j=1:hs
    if s{i}(j,3)~=0
     Ens(1,i)=Ens(1,i)-0.01*s{i}(j,3)*log2(0.01*s{i}(j,3));
    end
end
end
En=0;
for i=1:height
    En=En+0.01*Ia(i,3)*Ens(1,i);
end