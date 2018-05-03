clear;
%生成服从正态分布的三维数据集
%第一类
Mu1 = [-2,3,-1];%平均值
SIGMA1 = [2,0.5,1.2;0.5,3,1;1.2,1,4];%协方差矩阵
Omega1 = mvnrnd(Mu1,SIGMA1,1000);%生成1000个满足平均值为Mu1，协方差矩阵为SIGMA1的正态分布的随机向量
%第二类
Mu2 = [5,-3,2];
SIGMA2 = [6,1.4,0.5;1.4,3,0.3;0.5,0.3,5];
Omega2 = mvnrnd(Mu2,SIGMA2,1100);
%第三类
Mu3 = [18,-2,0];
SIGMA3 = [3,0.1,0.05;0.1,0.2,0;0.05,0,1];
Omega3 = mvnrnd(Mu3,SIGMA3,1000);
%第四类
Mu4 = [10,-4,1];
SIGMA4 = [18,3,6;3,15,10;6,10,20];
Omega4 = mvnrnd(Mu4,SIGMA4,1200);
%每类的先验概率
PO1=0.2;%Omega1先验概率
PO2=0.3;%Omega2先验概率
PO3=0.4;%Omega3
PO4=0.1;%Omega4
%开始贝叶斯分类器的构建
%求样本均值
MO1=mean(Omega1);
MO2=mean(Omega2);
MO3=mean(Omega3);
MO4=mean(Omega4);
%求样本协方差矩阵
SO1=cov(Omega1);
SO2=cov(Omega2);
SO3=cov(Omega3);
SO4=cov(Omega4);
%符号化，但是solve无法输出向量解，因此用途不明，若能求向量解则有潜力求解决策面，启用该功能需修改下方分类部分
% syms a b c;%定义自变量（符号运算）
%遍历各采样点并记录采样结果，若想启用需修改下方分类部分
% a=0;
% b=0;
% c=0;
% for a=-5:1:20
%     for b=-6:1:5
%         for c=-2:1:3
% R=zeros(1872,14);
%遍历段代码暂停
%进行贝叶斯分类相关概率计算
xl=-20;%x坐标采样下限
xu=40;%x坐标采样上限
yl=-15;
yu=15;
zl=-10;
zu=10;
xg=1;%网格采样间隔，越小后面的图越精确但计算时间陡增
yg=1;
zg=1;
[a,b,c]=meshgrid(xl:xg:xu,yl:yg:yu,zl:zg:zu);%空间网格，a，b，c为三坐标
%网格x，y，z方向节点数
xL=(xu-xl)/xg+1;
yL=(yu-yl)/yg+1;
zL=(zu-zl)/zg+1;
%定义各量
PXO1=zeros(yL,xL,zL);%P(X|ω1)
PXO2=zeros(yL,xL,zL);%注意x和y是反的（meshgrid函数的特点）
PXO3=zeros(yL,xL,zL);
PXO4=zeros(yL,xL,zL);
PX=zeros(yL,xL,zL);%P(X)
PO1X=zeros(yL,xL,zL);%P(ω1|X)
PO2X=zeros(yL,xL,zL);
PO3X=zeros(yL,xL,zL);
PO4X=zeros(yL,xL,zL);
Ra1X=zeros(yL,xL,zL);%行动a1（判断为第一类）的风险
Ra2X=zeros(yL,xL,zL);
Ra3X=zeros(yL,xL,zL);
Ra4X=zeros(yL,xL,zL);
%遍历采样点
for i=1:yL
    for j=1:xL
        for k=1:zL
            X=[a(i,j,k),b(i,j,k),c(i,j,k)];%采样向量
            PXO1(i,j,k)=1/(((2*pi)^1.5)*(abs(det(SO1)))^0.5)*exp(-1/2*(X-MO1)*((SO1)^(-1))*((X-MO1)'));%拟合的高斯概率分布公式
            PXO2(i,j,k)=1/(((2*pi)^1.5)*(abs(det(SO2)))^0.5)*exp(-1/2*(X-MO2)*((SO2)^(-1))*((X-MO2)'));
            PXO3(i,j,k)=1/(((2*pi)^1.5)*(abs(det(SO3)))^0.5)*exp(-1/2*(X-MO3)*((SO3)^(-1))*((X-MO3)'));
            PXO4(i,j,k)=1/(((2*pi)^1.5)*(abs(det(SO4)))^0.5)*exp(-1/2*(X-MO4)*((SO4)^(-1))*((X-MO4)'));
            PX(i,j,k)=PO1*PXO1(i,j,k)+PO2*PXO2(i,j,k)+PO3*PXO3(i,j,k)+PO4*PXO4(i,j,k);
            PO1X(i,j,k)=PXO1(i,j,k)*PO1/PX(i,j,k);
            PO2X(i,j,k)=PXO2(i,j,k)*PO2/PX(i,j,k);
            PO3X(i,j,k)=PXO3(i,j,k)*PO3/PX(i,j,k);
            PO4X(i,j,k)=PXO4(i,j,k)*PO4/PX(i,j,k);
            L=[0,4,3,9;8,0,2,1;1,6,0,4;9,5,7,0];%风险矩阵
            Ra1X(i,j,k)=L(2,1)*PO2X(i,j,k)+L(3,1)*PO3X(i,j,k)+L(4,1)*PO4X(i,j,k);%a1为选择Omega1
            Ra2X(i,j,k)=L(1,2)*PO1X(i,j,k)+L(3,2)*PO3X(i,j,k)+L(4,2)*PO4X(i,j,k);
            Ra3X(i,j,k)=L(2,3)*PO2X(i,j,k)+L(1,3)*PO1X(i,j,k)+L(4,3)*PO4X(i,j,k);
            Ra4X(i,j,k)=L(2,4)*PO2X(i,j,k)+L(3,4)*PO3X(i,j,k)+L(1,4)*PO1X(i,j,k);
        end
    end
end
R=zeros(yL,xL,zL);%最小风险选择
E=zeros(yL,xL,zL);%最小错误选择
for i=1:yL
    for j=1:xL
        for k=1:zL
            if min([Ra1X(i,j,k),Ra2X(i,j,k),Ra3X(i,j,k),Ra4X(i,j,k)])==Ra1X(i,j,k)
                R(i,j,k)=1;
            end
            if min([Ra1X(i,j,k),Ra2X(i,j,k),Ra3X(i,j,k),Ra4X(i,j,k)])==Ra2X(i,j,k)
                R(i,j,k)=2;
            end
            if min([Ra1X(i,j,k),Ra2X(i,j,k),Ra3X(i,j,k),Ra4X(i,j,k)])==Ra3X(i,j,k)
                R(i,j,k)=3;
            end
            if min([Ra1X(i,j,k),Ra2X(i,j,k),Ra3X(i,j,k),Ra4X(i,j,k)])==Ra4X(i,j,k)
                R(i,j,k)=4;
            end
            if max([PO1X(i,j,k),PO2X(i,j,k),PO3X(i,j,k),PO4X(i,j,k)])==PO1X(i,j,k)
                E(i,j,k)=1;
            end
            if max([PO1X(i,j,k),PO2X(i,j,k),PO3X(i,j,k),PO4X(i,j,k)])==PO2X(i,j,k)
                E(i,j,k)=2;
            end
            if max([PO1X(i,j,k),PO2X(i,j,k),PO3X(i,j,k),PO4X(i,j,k)])==PO3X(i,j,k)
                E(i,j,k)=3;
            end
            if max([PO1X(i,j,k),PO2X(i,j,k),PO3X(i,j,k),PO4X(i,j,k)])==PO4X(i,j,k)
                E(i,j,k)=4;
            end
        end
    end
end
%（遍历段继续）采样并记录采样结果
% R(i,1)=a;
% R(i,2)=b;
% R(i,3)=c;
% % R(i,4)=d;
% R(i,5)=Ra1X;
% R(i,6)=Ra2X;
% R(i,7)=Ra3X;
% R(i,8)=Ra4X;
% if max([Ra1X,Ra2X,Ra3X,Ra4X])==Ra1X
%     R(i,9)=1;
% end
% if max([Ra1X,Ra2X,Ra3X,Ra4X])==Ra2X
%     R(i,9)=2;
% end
% if max([Ra1X,Ra2X,Ra3X,Ra4X])==Ra3X
%     R(i,9)=3;
% end
% if max([Ra1X,Ra2X,Ra3X,Ra4X])==Ra4X
%     R(i,9)=4;
% end
% R(i,10)=PO1X;
% R(i,11)=PO2X;
% R(i,12)=PO3X;
% R(i,13)=PO4X;
% if max([PO1X,PO2X,PO3X,PO4X])==PO1X
%     R(i,14)=1;
% end
% if max([PO1X,PO2X,PO3X,PO4X])==PO2X
%     R(i,14)=2;
% end
% if max([PO1X,PO2X,PO3X,PO4X])==PO3X
%     R(i,14)=3;
% end
% if max([PO1X,PO2X,PO3X,PO4X])==PO4X
%     R(i,14)=4;
% end
% i=i+1;
%             end
%         end
% end
%开始画图
%包络图
h3=figure(1);
set(h3,'name','定值包络立体图','MenuBar','none','ToolBar','none')
fw=2;                                                                                                   %%此值为最外层包络面取值
fv=isosurface(a,b,c,R,fw);
p=patch(fv);
set(p,'facecolor','b','edgecolor','none');
patch(isocaps(a,b,c,R,fw), 'FaceColor','interp','EdgeColor','none');
colorbar;
alpha(0.75)
colormap('jet');
box on;
daspect([1,1,1]);
view(3);
set(gca,'color',[0.9,0.9,0.9]);
camlight;
camproj perspective;
lighting phong;
axis equal;
grid on;
title(['最外层表面的值为： ' , num2str(fw)]);
%后验概率和风险函数
for j=1:2
    for i=1:5
        RaiX=['Ra',num2str(i),'X'];
        POiX=['PO',num2str(i),'X'];
        if j==1
            V=RaiX;
            if i==5
                V='R';
            end
        end
        if j==2
            V=POiX;
            if i==5
                V='E';
            end
        end
        figure('NumberTitle','off','Name',V);
        for sx=xl:10:xu;
            for sy=yl:5:yu;
                for sz=zl:10:zu;
                    slice(a,b,c,eval(V),sx,sy,sz);%eval为将括号内的字符串转换为程序能识别的变量或函数等
                    hold on
                    colorbar
                    alpha(0.2)
                    xlabel('x');ylabel('y');zlabel('z')
                    shading interp
                end
            end
        end
    end
end
%画类条件概率分布图
for i=1:4
    if i==1
        sx=-2;sy=3;sz=-1;
    end
    if i==2
        sx=5;sy=-3;sz=2;
    end
    if i==3
        sx=18;sy=-2;sz=0;
    end
    if i==4
        sx=10;sy=-4;sz=1;
    end
    PXOi=['PXO',num2str(i)];
    figure('NumberTitle','off','Name',PXOi);
    slice(a,b,c,eval(PXOi),sx,sy,sz);
    hold on
    colorbar
    alpha(0.2)
    xlabel('x');ylabel('y');zlabel('z')
    shading interp
end
%遍历所有切面（切面沿x轴运动）
%figure;
% for sx=xl:xg:xu;
% slice(a,b,c,E,sx,[],[]);%[]表示无此方向的切面
% colorbar
% alpha(0.9)
% xlabel('x');ylabel('y');zlabel('z')
% shading interp
% filename=['C:\Users\pc\Desktop\学习\大三下学期\模式识别与机器学习\实验\输出\实验二\Stage2\大范围\扫略\针对最小错误率选择的关于x坐标的扫略\sx_',num2str(sx-xl),'.jpg'];
% saveas(gcf,filename);%保存当前窗口图片
% end