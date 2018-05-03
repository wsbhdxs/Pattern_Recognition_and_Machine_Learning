clear;
%生成线性可分的十维数据集和对应的随机的分割平面，将数据按该平面分割为两组，L和U分别检测两组数量是否符合要求
n=160;
m=10;
%rng('shuffle'); %根据系统时间生成随机数
X=100*rand(m,n)-50;%随机生成元素值属于（-50，50）的m维数据集，共n个数据
Theta=rand(1,m);%随机生成预设分割平面系数
Theta0=rand;%随机生成预设常数
Mark=zeros(1,n);%对每个数据的分类标记
%利用预设平面对每个数据进行分类标记
for i=1:n
    if Theta*X(:,i)+Theta0>0
        Mark(1,i)=1;
    end
    if Theta*X(:,i)+Theta0<0
        Mark(1,i)=-1;
    end
end
%计算每个类别各自的总数,并检测是否有位于分割超平面上的点（根据题意不应存在）
U=0;%平面以上的数量
L=0;%平面以上的数量
for j=1:n
    if Mark(1,j)==1
        U=U+1;
    end
    if Mark(1,j)==-1
        L=L+1;
    end
    if Mark(1,j)==0
        fprintf('存在位于分割超平面上的点\n');
    end    
end
%检测样本数是否符合题目要求（训练集每类50组，测试集每类20组）
if U<70||L<70
    fprintf('样本数不符合题目要求\n');
end
%定义训练集和测试集并赋值
Train1=zeros(10,50);%第一类（平面以上）
Train2=zeros(10,50);%第二类（平面以上）
Test=zeros(10,40);%测试集
MarkT=zeros(1,40);%测试集分类（答案），分类方法仍为1上2下
j=1;
k=1;
l=1;
%从总数据集中等效随机挑取测试集（每类50组）和训练集（40组）
for i=1:160
    if Mark(1,i)==1
        if j<=50
            Train1(:,j)=X(:,i);
            j=j+1;
        end
        if j>50&&j<=70
            Test(:,l)=X(:,i);
            MarkT(1,l)=1;
            l=l+1;
            j=j+1;            
        end
    end
    if Mark(1,i)==-1
        if k<=50
            Train2(:,k)=X(:,i);
            k=k+1;
        end
        if k>50&&k<=70
            Test(:,l)=X(:,i);
            MarkT(1,l)=2;
            l=l+1;
            k=k+1;
        end
    end
end
% 开始线性分类器构建
% 构建规范化增广样本向量
for AN=1:10
ETrain=[[Train1;ones(1,50)],-[Train2;ones(1,50)]];
WF=0.5*ones(1,m+1);
a=AN/100;
aAll(AN)=a;%learning rate
for t=2:100000%迭代上限次数
    b=1;
    Up=0;
    Count=100;
    for i=1:100
        if WF*ETrain(:,i)<0
            Error(b,:)=(ETrain(:,i))';
            Up=b;            
            b=b+1;
            Count=Count-1;
        end
    end
    if Count==100
        T=t-1;
        W=WF;
        break;
    end
    ErrorAll=zeros(1,m+1);
    for b=1:Up
        ErrorAll=Error(b,:)+ErrorAll;
    end
    W=WF+a*ErrorAll;%系数，即目标模型
    WF=W;
end
WAll(AN,:)=W;
TTT(AN)=T;
%利用测试集测试模型质量
SETest=[Test;ones(1,40)];%扩充
MarkTT=zeros(1,40);%利用新模型对测试集的识别标记，仍为1上2下
for i=1:40
    if W*SETest(:,i)>0
        MarkTT(1,i)=1;
    end
    if W*SETest(:,i)<0
        MarkTT(1,i)=2;
    end   
end
Symbol=MarkT-MarkTT;%测试集分类正误标志，0为正确，不为0为错误
Rate=1-sum(abs(Symbol))/40;%测试集分类正确率
RateAll(AN)=Rate;
end