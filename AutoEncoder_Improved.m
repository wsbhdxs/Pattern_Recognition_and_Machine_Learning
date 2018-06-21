clear ;
fid=fopen('Iris Dataset\iris.data');
C=textscan(fid, '%f%f%f%f%s','delimiter',',');
fclose(fid);%使用textscan函数读取文件，输出C细胞数组，每个数组中存放每列的数据
attributes=[C{1,1},C{1,2},C{1,3},C{1,4}];
Class=zeros(150,1);
Class(strcmp(C{1,5},'Iris-setosa')) = 1;
Class(strcmp(C{1,5},'Iris-versicolor')) = 2;
Class(strcmp(C{1,5},'Iris-virginica')) = 3;
%归一化属性值

for i=1:4
 attributes(:,i)=1/(1+exp(-(attributes(:,i)-mean(attributes(:,i)))));
end

% for i=1:4
%  attributes(:,i)=(attributes(:,i)-min(attributes(:,i)))/(max(attributes(:,i))-min(attributes(:,i)));
% end

%提取测试集和训练集
R(1:17,1)=randperm(50,17);
R(18:34,1)=50+randperm(50,17);
R(35:51,1)=100+randperm(50,17);
R=unique(R);
Ta=attributes(R,:);
attributes(R,:)=[];
RC=(1:150)';
RC(R)=[];
%完成
NI=4;%输入层神经元数目
NH=3;%隐层神经元数目
NO=4;%输出层神经元数目
n=0.1;%学习率
tmax=2000;
[NS,~]=size(attributes);
v=rand(NI,NH);
w=rand(NH,NO);
Theta=rand(1,NO);%输出层阈值
Gamma=rand(1,NH);%隐层阈值
ys=zeros(1,NO);
ysE=zeros(NS,NO);
ysET=zeros(NS,NO);
g=zeros(NO,1);
b=zeros(1,NH);
bE=zeros(1,NH);
bET=zeros(1,NH);
e=zeros(1,NH);
d_v=zeros(NI,NH);
d_w=zeros(NH,NO);
d_Theta=zeros(1,NO);%输出层阈值
d_Gamma=zeros(1,NH);%隐层阈值
E=zeros(1,tmax);
ET=zeros(1,tmax);
%O=randperm(150);
%训练
for t=1:tmax
for a=1:NS
    x=attributes(a,:);
    y=attributes(a,:);
for h=1:NH
[~,b(h)]=H_Neuron(x,v(:,h),Gamma(h),[],[]);
end
for j=1:NO
[ys(j),g(j)]=O_Neuron(w(:,j),Theta(j),b,y(j));
end
for h=1:NH
[e(h),~]=H_Neuron(x,v(:,h),Gamma(h),w(h,:),g);
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
    for i=1:NI
    d_v(i,h)=n*e(h)*x(i);
    end
end
for h=1:NH
    d_Gamma(h)=-n*e(h);
end
w=w+d_w;
Theta=Theta+d_Theta;
v=v+d_v;
Gamma=Gamma+d_Gamma;
end
for a=1:NS
    x=attributes(a,:);
    y=attributes(a,:);
for h=1:NH
[~,bE(h)]=H_Neuron(x,v(:,h),Gamma(h),[],[]);
end
for j=1:NO
[ysE(a,j),~]=O_Neuron(w(:,j),Theta(j),bE,y(j));
end
E(t)=E(t)+1/NS*0.5*sum((ysE(a,:)-y).*(ysE(a,:)-y));
end
% if E(t)<=0.3
%     break;
% end
%测试
for a=1:length(R)
    x=Ta(a,:);
for h=1:NH
[~,bET(h)]=H_Neuron(x,v(:,h),Gamma(h),[],[]);
end
for j=1:NO
[ysET(a,j),~]=O_Neuron(w(:,j),Theta(j),bET,[]);
end
ET(t)=ET(t)+1/length(R)*0.5*sum((ysET(a,:)-Ta(a,:)).*(ysET(a,:)-Ta(a,:)));
end
end
figure;
t=1000:tmax;
plot(t,E(t));
hold on;
plot(t,ET(t));
legend('训练集累积错误','测试集累积错误');