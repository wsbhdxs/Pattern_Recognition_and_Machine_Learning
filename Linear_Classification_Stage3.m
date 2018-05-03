clear;
%�������Կɷֵ�ʮά���ݼ��Ͷ�Ӧ������ķָ�ƽ�棬�����ݰ���ƽ��ָ�Ϊ���飬L��U�ֱ������������Ƿ����Ҫ��
n=160;
m=10;
%rng('shuffle'); %����ϵͳʱ�����������
X=100*rand(m,n)-50;%�������Ԫ��ֵ���ڣ�-50��50����mά���ݼ�����n������
Theta=rand(1,m);%�������Ԥ��ָ�ƽ��ϵ��
Theta0=rand;%�������Ԥ�賣��
Mark=zeros(1,n);%��ÿ�����ݵķ�����
%����Ԥ��ƽ���ÿ�����ݽ��з�����
for i=1:n
    if Theta*X(:,i)+Theta0>0
        Mark(1,i)=1;
    end
    if Theta*X(:,i)+Theta0<0
        Mark(1,i)=-1;
    end
end
%����ÿ�������Ե�����,������Ƿ���λ�ڷָƽ���ϵĵ㣨�������ⲻӦ���ڣ�
U=0;%ƽ�����ϵ�����
L=0;%ƽ�����ϵ�����
for j=1:n
    if Mark(1,j)==1
        U=U+1;
    end
    if Mark(1,j)==-1
        L=L+1;
    end
    if Mark(1,j)==0
        fprintf('����λ�ڷָƽ���ϵĵ�\n');
    end    
end
%����������Ƿ������ĿҪ��ѵ����ÿ��50�飬���Լ�ÿ��20�飩
if U<70||L<70
    fprintf('��������������ĿҪ��\n');
end
%����ѵ�����Ͳ��Լ�����ֵ
Train1=zeros(10,50);%��һ�ࣨƽ�����ϣ�
Train2=zeros(10,50);%�ڶ��ࣨƽ�����ϣ�
Test=zeros(10,40);%���Լ�
MarkT=zeros(1,40);%���Լ����ࣨ�𰸣������෽����Ϊ1��2��
j=1;
k=1;
l=1;
%�������ݼ��е�Ч�����ȡ���Լ���ÿ��50�飩��ѵ������40�飩
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
% ��ʼ���Է���������
% �����淶��������������
for AN=1:10
ETrain=[[Train1;ones(1,50)],-[Train2;ones(1,50)]];
WF=0.5*ones(1,m+1);
a=AN/100;
aAll(AN)=a;%learning rate
for t=2:100000%�������޴���
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
    W=WF+a*ErrorAll;%ϵ������Ŀ��ģ��
    WF=W;
end
WAll(AN,:)=W;
TTT(AN)=T;
%���ò��Լ�����ģ������
SETest=[Test;ones(1,40)];%����
MarkTT=zeros(1,40);%������ģ�ͶԲ��Լ���ʶ���ǣ���Ϊ1��2��
for i=1:40
    if W*SETest(:,i)>0
        MarkTT(1,i)=1;
    end
    if W*SETest(:,i)<0
        MarkTT(1,i)=2;
    end   
end
Symbol=MarkT-MarkTT;%���Լ����������־��0Ϊ��ȷ����Ϊ0Ϊ����
Rate=1-sum(abs(Symbol))/40;%���Լ�������ȷ��
RateAll(AN)=Rate;
end