function [attributes2,Class2,height,Mark]=Brunch(attributes1,Class1,LastEV,LastM)
IG1=Information_Gain(attributes1,Class1);
[~,E]=max(IG1);
Ia1=Rtabulate(attributes1(:,E));
[height,~]=size(Ia1);
attributes2=cell(height,1);
Class2=cell(height,1);
for i=1:height
attributes2{i}=attributes1(attributes1(:,E)==Ia1(i,1),:);
Class2{i}=Class1(attributes1(:,E)==Ia1(i,1),:);
end
Mark=zeros(height,5);
for i=1:height
if Class2{i}==Class2{i}(1,1)*ones(size(Class2{i}))
    Mark(i,:)=[0,0,E,Ia1(i,1),Class2{i}(1,1)];
else Mark(i,:)=[0,0,E,Ia1(i,1),0];
end
if isempty(LastEV)==0
    Mark(i,2)=LastEV;
end
if isempty(LastM)==0
Mark(i,1)=LastM;
end
end