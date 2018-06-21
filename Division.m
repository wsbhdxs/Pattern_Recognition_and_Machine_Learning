function [D,IG,Da]=Division(attribute,Class)
Ha=length(attribute);
an=unique(attribute);
Lan=length(an);
if Lan==1
    Lan=2;
    an=[an,an];
end
Ea=cell(Lan-1,1);
T=zeros(Lan-1,1);
IGA=zeros(Lan-1,1);
for i=1:(Lan-1)
    T(i)=(an(i)+an(i+1))/2;
for j=1:Ha
    if attribute(j)<=T(i)
        Ea{i}(j,1)=0;
    else Ea{i}(j,1)=1;
    end
end
IGA(i)=Information_Gain(Ea{i},Class);
end
[IG,k]=max(IGA);
D=T(k);
Da=Ea{k};