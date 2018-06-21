function [attributes2,Class2,height,Mark,DP]=Brunch_Continuous(attributes1,Class1,LastEV,LastM)
[~,Wa]=size(attributes1);
D=zeros(Wa,1);
IG1=zeros(Wa,1);
Da=cell(Wa,1);
for i=1:Wa
    [D(i),IG1(i),Da{i}]=Division(attributes1(:,i),Class1);
end
[~,E]=max(IG1);
Ia1=Rtabulate(Da{E});
DP=D(E);
[height,~]=size(Ia1);
attributes2=cell(height,1);
Class2=cell(height,1);
for i=1:height
attributes2{i}=attributes1(Da{E}==Ia1(i,1),:);
Class2{i}=Class1(Da{E}==Ia1(i,1),:);
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