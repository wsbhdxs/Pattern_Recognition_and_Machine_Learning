clear;
%���ɷ�����̬�ֲ�����ά���ݼ�
%��һ��
Mu1 = [-2,3];%ƽ��ֵ
SIGMA1 = [2,0.5;0.5,3];%Э�������
Omega1 = mvnrnd(Mu1,SIGMA1,1000);%����1000������ƽ��ֵΪMu1��Э�������ΪSIGMA1����̬�ֲ����������
%�ڶ���
Mu2 = [5,-3];
SIGMA2 = [6,1.4,;1.4,3];
Omega2 = mvnrnd(Mu2,SIGMA2,1100);
%������
Mu3 = [18,-2];
SIGMA3 = [3,0.1;0.1,0.2];
Omega3 = mvnrnd(Mu3,SIGMA3,1000);
%ÿ����������
PO1=0.2;%Omega1�������
PO2=0.3;%Omega2�������
PO3=0.5;%Omega3
%��ʼ��Ҷ˹�������Ĺ���
%��������ֵ
MO1=mean(Omega1);
MO2=mean(Omega2);
MO3=mean(Omega3);
%������Э�������
SO1=cov(Omega1);
SO2=cov(Omega2);
SO3=cov(Omega3);
%���б�Ҷ˹������ظ��ʼ���
xl=-90;%x�����������
xu=120;%x�����������
yl=-90;
yu=90;
xg=1;%������������ԽС�����ͼԽ��ȷ������ʱ�䶸��
yg=1;
[a,b]=meshgrid(xl:xg:xu,yl:yg:yu);%�ռ�����a��b��cΪ������
%����x��y��z����ڵ���
xL=(xu-xl)/xg+1;
yL=(yu-yl)/yg+1;
%�������
PXO1=zeros(yL,xL);%P(X|��1)
PXO2=zeros(yL,xL);%ע��x��y�Ƿ��ģ�meshgrid�������ص㣩
PXO3=zeros(yL,xL);
PX=zeros(yL,xL);%P(X)
PO1X=zeros(yL,xL);%P(��1|X)
PO2X=zeros(yL,xL);
PO3X=zeros(yL,xL);
Ra1X=zeros(yL,xL);%�ж�a1���ж�Ϊ��һ�ࣩ�ķ���
Ra2X=zeros(yL,xL);
Ra3X=zeros(yL,xL);
%����������
for i=1:yL
    for j=1:xL
            X=[a(i,j),b(i,j)];%��������
            PXO1(i,j)=1/(((2*pi)^1.5)*(abs(det(SO1)))^0.5)*exp(-1/2*(X-MO1)*((SO1)^(-1))*((X-MO1)'));%��ϵĸ�˹���ʷֲ���ʽ
            PXO2(i,j)=1/(((2*pi)^1.5)*(abs(det(SO2)))^0.5)*exp(-1/2*(X-MO2)*((SO2)^(-1))*((X-MO2)'));
            PXO3(i,j)=1/(((2*pi)^1.5)*(abs(det(SO3)))^0.5)*exp(-1/2*(X-MO3)*((SO3)^(-1))*((X-MO3)'));
            PX(i,j)=PO1*PXO1(i,j)+PO2*PXO2(i,j)+PO3*PXO3(i,j);
            PO1X(i,j)=PXO1(i,j)*PO1/PX(i,j);
            PO2X(i,j)=PXO2(i,j)*PO2/PX(i,j);
            PO3X(i,j)=PXO3(i,j)*PO3/PX(i,j);
            L=[0,4,3;8,0,2;1,6,0];%���վ���
            Ra1X(i,j)=L(2,1)*PO2X(i,j)+L(3,1)*PO3X(i,j);%a1Ϊѡ��Omega1
            Ra2X(i,j)=L(1,2)*PO1X(i,j)+L(3,2)*PO3X(i,j);
            Ra3X(i,j)=L(2,3)*PO2X(i,j)+L(1,3)*PO1X(i,j);
    end
end
R=zeros(yL,xL);%��С����ѡ��
E=zeros(yL,xL);%��С����ѡ��
for i=1:yL
    for j=1:xL
            if min([Ra1X(i,j),Ra2X(i,j),Ra3X(i,j)])==Ra1X(i,j)
                R(i,j)=1;
            end
            if min([Ra1X(i,j),Ra2X(i,j),Ra3X(i,j)])==Ra2X(i,j)
                R(i,j)=2;
            end
            if min([Ra1X(i,j),Ra2X(i,j),Ra3X(i,j)])==Ra3X(i,j)
                R(i,j)=3;
            end
            if max([PO1X(i,j),PO2X(i,j),PO3X(i,j)])==PO1X(i,j)
                E(i,j)=1;
            end
            if max([PO1X(i,j),PO2X(i,j),PO3X(i,j)])==PO2X(i,j)
                E(i,j)=2;
            end
            if max([PO1X(i,j),PO2X(i,j),PO3X(i,j)])==PO3X(i,j)
                E(i,j)=3;
            end
    end
end
%��ʼ��ͼ
mesh(a,b,PO1X);%��PO2X�ĳɱ�ĺ������Ǳ��ͼ����ʾ��Χ����xl��xu��yl��yu����ʾ���ȵ���xg��yg
axis([-90 120 -90 90]);
view(3)