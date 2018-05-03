clear;
%生成服从正态分布的三维数据集
%第一类
Mu1 = [-2,3];%平均值
SIGMA1 = [2,0.5;0.5,3];%协方差矩阵
Omega1 = mvnrnd(Mu1,SIGMA1,1000);%生成1000个满足平均值为Mu1，协方差矩阵为SIGMA1的正态分布的随机向量
%第二类
Mu2 = [5,-3];
SIGMA2 = [6,1.4,;1.4,3];
Omega2 = mvnrnd(Mu2,SIGMA2,1100);
%第三类
Mu3 = [18,-2];
SIGMA3 = [3,0.1;0.1,0.2];
Omega3 = mvnrnd(Mu3,SIGMA3,1000);
%每类的先验概率
PO1=0.2;%Omega1先验概率
PO2=0.3;%Omega2先验概率
PO3=0.5;%Omega3
%开始贝叶斯分类器的构建
%求样本均值
MO1=mean(Omega1);
MO2=mean(Omega2);
MO3=mean(Omega3);
%求样本协方差矩阵
SO1=cov(Omega1);
SO2=cov(Omega2);
SO3=cov(Omega3);
%进行贝叶斯分类相关概率计算
xl=-90;%x坐标采样下限
xu=120;%x坐标采样上限
yl=-90;
yu=90;
xg=1;%网格采样间隔，越小后面的图越精确但计算时间陡增
yg=1;
[a,b]=meshgrid(xl:xg:xu,yl:yg:yu);%空间网格，a，b，c为三坐标
%网格x，y，z方向节点数
xL=(xu-xl)/xg+1;
yL=(yu-yl)/yg+1;
%定义各量
PXO1=zeros(yL,xL);%P(X|ω1)
PXO2=zeros(yL,xL);%注意x和y是反的（meshgrid函数的特点）
PXO3=zeros(yL,xL);
PX=zeros(yL,xL);%P(X)
PO1X=zeros(yL,xL);%P(ω1|X)
PO2X=zeros(yL,xL);
PO3X=zeros(yL,xL);
Ra1X=zeros(yL,xL);%行动a1（判断为第一类）的风险
Ra2X=zeros(yL,xL);
Ra3X=zeros(yL,xL);
%遍历采样点
for i=1:yL
    for j=1:xL
            X=[a(i,j),b(i,j)];%采样向量
            PXO1(i,j)=1/(((2*pi)^1.5)*(abs(det(SO1)))^0.5)*exp(-1/2*(X-MO1)*((SO1)^(-1))*((X-MO1)'));%拟合的高斯概率分布公式
            PXO2(i,j)=1/(((2*pi)^1.5)*(abs(det(SO2)))^0.5)*exp(-1/2*(X-MO2)*((SO2)^(-1))*((X-MO2)'));
            PXO3(i,j)=1/(((2*pi)^1.5)*(abs(det(SO3)))^0.5)*exp(-1/2*(X-MO3)*((SO3)^(-1))*((X-MO3)'));
            PX(i,j)=PO1*PXO1(i,j)+PO2*PXO2(i,j)+PO3*PXO3(i,j);
            PO1X(i,j)=PXO1(i,j)*PO1/PX(i,j);
            PO2X(i,j)=PXO2(i,j)*PO2/PX(i,j);
            PO3X(i,j)=PXO3(i,j)*PO3/PX(i,j);
            L=[0,4,3;8,0,2;1,6,0];%风险矩阵
            Ra1X(i,j)=L(2,1)*PO2X(i,j)+L(3,1)*PO3X(i,j);%a1为选择Omega1
            Ra2X(i,j)=L(1,2)*PO1X(i,j)+L(3,2)*PO3X(i,j);
            Ra3X(i,j)=L(2,3)*PO2X(i,j)+L(1,3)*PO1X(i,j);
    end
end
R=zeros(yL,xL);%最小风险选择
E=zeros(yL,xL);%最小错误选择
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
%开始画图
mesh(a,b,PO1X);%把PO2X改成别的函数就是别的图，显示范围调节xl，xu，yl，yu，显示精度调节xg，yg
axis([-90 120 -90 90]);
view(3)