clear;
fid=fopen('Iris Dataset\iris.data');
C=textscan(fid, '%f%f%f%f%s','delimiter',',');
fclose(fid);%ʹ��textscan������ȡ�ļ������Cϸ�����飬ÿ�������д��ÿ�е�����
attributes=[C{1,1},C{1,2},C{1,3},C{1,4}];
Class=zeros(150,1);
Class(strcmp(C{1,5},'Iris-setosa')) = 1;
Class(strcmp(C{1,5},'Iris-versicolor')) = 2;
Class(strcmp(C{1,5},'Iris-virginica')) = 3;
%��ɢ�����
ClassPD=[Class,zeros(size(Class))];
ClassPD(Class(:,1)==2,2)=1;
ClassPD(Class(:,1)==2,1)=0;
ClassPD(Class(:,1)==3,1)=0;
%��ȡ���Լ���ѵ����
R(1:17,1)=randperm(50,17);
R(18:34,1)=50+randperm(50,17);
R(35:51,1)=100+randperm(50,17);
R=unique(R);
Ta=attributes(R,:);
TC=ClassPD(R,:);
attributes(R,:)=[];
RC=(1:150)';
RC(R)=[];
ClassD=ClassPD(RC,:);
%���
NI=4;%�������Ԫ��Ŀ
NH=4;%������Ԫ��Ŀ
NH0=4;
NO=2;%�������Ԫ��Ŀ
n=0.1;%ѧϰ��
E=zeros(2500);
ET=zeros(2500);
[NS,~]=size(attributes);
v=rand(NH0,NH);
v0=rand(NI,NH0);
w=rand(NH,NO);
Theta=rand(1,NO);%�������ֵ
Gamma=rand(1,NH);%������ֵ
Gamma0=rand(1,NH0);%������ֵ
ys=zeros(1,NO);
ysE=zeros(NS,NO);
ysET=zeros(NS,NO);
g=zeros(NO,1);
b=zeros(1,NH);
b0=zeros(1,NH0);
bE=zeros(1,NH);
bE0=zeros(1,NH0);
bET=zeros(1,NH);
bET0=zeros(1,NH0);
e=zeros(1,NH);
e0=zeros(1,NH0);
d_v=zeros(NH0,NH);
d_v0=zeros(NI,NH0);
d_w=zeros(NH,NO);
d_Theta=zeros(1,NO);%�������ֵ
d_Gamma=zeros(1,NH);%������ֵ
d_Gamma0=zeros(1,NH0);%������ֵ
%O=randperm(150);
%ѵ��
for t=1:2500
for a=1:NS
    x=attributes(a,:);
    y=ClassD(a,:);
for h=1:NH0
[~,b0(h)]=H_Neuron(x,v0(:,h),Gamma0(h),[],[]);
end
for h=1:NH
[~,b(h)]=H_Neuron(b0,v(:,h),Gamma(h),[],[]);
end
for j=1:NO
[ys(j),g(j)]=O_Neuron(w(:,j),Theta(j),b,y(j));
end
for h=1:NH
[e(h),~]=H_Neuron(b0,v(:,h),Gamma(h),w(h,:),g);
end
for h=1:NH0
[e0(h),~]=H_Neuron(x,v0(:,h),Gamma0(h),v(h,:),e);
end
for h=1:NH
for j=1:NO
    d_w(h,j)=n*g(j)*b(h);
end
end
for j=1:NO
    d_Theta(j)=-n*g(j);
end
for h=1:NH
    for i=1:NH0
    d_v(i,h)=n*e(h)*x(i);
    end
end
for h=1:NH
    d_Gamma(h)=-n*e(h);
end
for h=1:NH0
    for i=1:NI
    d_v0(i,h)=n*e0(h)*x(i);
    end
end
for h=1:NH0
    d_Gamma0(h)=-n*e0(h);
end
w=w+d_w;
Theta=Theta+d_Theta;
v=v+d_v;
Gamma=Gamma+d_Gamma;
v0=v0+d_v0;
Gamma0=Gamma0+d_Gamma0;
end
for a=1:NS
    x=attributes(a,:);
    y=ClassD(a,:);    
for h=1:NH0
[~,bE0(h)]=H_Neuron(x,v0(:,h),Gamma0(h),[],[]);
end
for h=1:NH
[~,bE(h)]=H_Neuron(bE0,v(:,h),Gamma(h),[],[]);
end
for j=1:NO
[ysE(a,j),~]=O_Neuron(w(:,j),Theta(j),bE,y(j));
end
E(t)=E(t)+sum((ysE(a,:)-ClassD(a,:)).*(ysE(a,:)-ClassD(a,:)));
end
%����
for a=1:length(R)
    x=Ta(a,:);    
for h=1:NH0
[~,bET0(h)]=H_Neuron(x,v0(:,h),Gamma0(h),[],[]);
end
for h=1:NH
[~,bET(h)]=H_Neuron(bET0,v(:,h),Gamma(h),[],[]);
end
for j=1:NO
[ysET(a,j),~]=O_Neuron(w(:,j),Theta(j),bET,[]);
end
ET(t)=ET(t)+sum((ysET(a,:)-TC(a,:)).*(ysET(a,:)-TC(a,:)));
end
% if E(t)<=0.3
%     break;
% end
end
tt=1:t;
plot(tt,E);
hold on;
plot(tt,ET);
legend('ѵ�����ۻ�����','���Լ��ۻ�����');
Y=3*ones(length(RC),1);
Y(ysE(:,1)>10*ysE(:,2))=1;
Y(ysE(:,2)>10*ysE(:,1))=2;
Error=sum((Y-Class(RC,:))~=0);
Rate=100*(1-Error/length(RC));
YT=3*ones(length(R),1);
YT(ysET(:,1)>10*ysET(:,2))=1;
YT(ysET(:,2)>10*ysET(:,1))=2;
ErrorT=sum((YT-Class(R,:))~=0);
RateT=100*(1-ErrorT/length(R));