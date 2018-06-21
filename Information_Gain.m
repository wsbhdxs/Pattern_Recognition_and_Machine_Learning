function [IG]=Information_Gain(attributes,Class)
EnC=Entropy_of_All(Class);
[~,Na]=size(attributes);
En=zeros(Na,1);
for i=1:Na
    [En(i),~,~]=Entropy_of_A(i,attributes,Class);
end
IG=zeros(Na,1);
for i=1:Na
    IG(i)=EnC-En(i);
end