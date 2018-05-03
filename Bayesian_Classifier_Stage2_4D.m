clear;
%生成服从正态分布的四维数据集
Mu1 = [-2,3,-1,0];
SIGMA1 = [2,0.5,1.2,0.1;0.5,3,1,0.2;1.2,1,4,0.7;0.1,0.2,0.7,3];
Omega1 = mvnrnd(Mu1,SIGMA1,1000);
Mu2 = [5,-3,2,-6];
SIGMA2 = [6,1.4,0.5,1;1.4,3,0.3,1.6;0.5,0.3,5,0.8;1,1.6,0.8,2];
Omega2 = mvnrnd(Mu2,SIGMA2,1100);
Mu3 = [18,-2,0,-9];
SIGMA3 = [3,0.1,0.05,0;0.1,0.2,0,0.02;0.05,0,1,0;0,0.02,0,4];
Omega3 = mvnrnd(Mu3,SIGMA3,1000);
Mu4 = [10,-4,1,-20];
SIGMA4 = [18,3,6,2;3,15,10,9;6,10,20,5;2,9,5,12];
Omega4 = mvnrnd(Mu4,SIGMA4,1200);
PO1=0.2;%Omega1先验概率
PO2=0.3;%Omega2先验概率
PO3=0.4;
PO4=0.1;
%开始贝叶斯分类器的构建
MO1=mean(Omega1);
MO2=mean(Omega2);
MO3=mean(Omega3);
MO4=mean(Omega4);
SO1=cov(Omega1);
SO2=cov(Omega2);
SO3=cov(Omega3);
SO4=cov(Omega4);
syms a b c d;
% a=0;
% b=0;
% c=0;
% d=0;
% i=1;
% R=zeros(50544,14);
% for a=-5:1:20
%     for b=-6:1:5
%         for c=-2:1:3
%             for d=-23:1:3
X=[a,b,c,d];
PXO1=1/(((2*pi)^2)*(abs(det(SO1)))^0.5)*exp(-1/2*(X-MO1)*((SO1)^(-1))*((X-MO1)'));
PXO2=1/(((2*pi)^2)*(abs(det(SO2)))^0.5)*exp(-1/2*(X-MO2)*((SO2)^(-1))*((X-MO2)'));
PXO3=1/(((2*pi)^2)*(abs(det(SO3)))^0.5)*exp(-1/2*(X-MO3)*((SO3)^(-1))*((X-MO3)'));
PXO4=1/(((2*pi)^2)*(abs(det(SO4)))^0.5)*exp(-1/2*(X-MO4)*((SO4)^(-1))*((X-MO4)'));
PX=PO1*PXO1+PO2*PXO2+PO3*PXO3+PO4*PXO4;
PO1X=PXO1*PO1/PX;
PO2X=PXO2*PO2/PX;
PO3X=PXO3*PO3/PX;
PO4X=PXO4*PO4/PX;
L=[0,4,3,9;8,0,2,1;1,6,0,4;9,5,7,0];
Ra1X=L(2,1)*PO2X+L(3,1)*PO3X+L(4,1)*PO4X;%a1为选择Omega1
Ra2X=L(1,2)*PO1X+L(3,2)*PO3X+L(4,2)*PO4X;
Ra3X=L(2,3)*PO2X+L(1,3)*PO1X+L(4,3)*PO4X;
Ra4X=L(2,4)*PO2X+L(3,4)*PO3X+L(1,4)*PO1X;
% R(i,1)=a;
% R(i,2)=b;
% R(i,3)=c;
% R(i,4)=d;
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
%     end
% end