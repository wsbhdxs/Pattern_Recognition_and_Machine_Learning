clear;%�������
Omega1=[-3.9847,-3.5549,-1.2401,-0.9780,-0.7932,-2.8531,-2.7605,-3.7287,...
-3.5414,-2.2692,-3.4549,-3.0752,-3.9934, -0.9780,-1.5799,-1.4885,...
-0.7431,-0.4221,-1.1186,-2.3462,-1.0826,-3.4196,-1.3193,-0.8367,...
-0.6579,-2.9683];
Omega2=[ 2.8792, 0.7932,1.1882,3.0682,4.2532,0.3271,0.9846,2.7648,2.6588];
PO1=0.9;%Omega1�������
PO2=0.1;%Omega2�������
NO1=length(Omega1);
NO2=length(Omega2);
MOmega1=sum(Omega1)/NO1;
MOmega2=sum(Omega2)/NO2;
S2Omega1=0;
for i=1:NO1
    S2Omega1=S2Omega1+((Omega1(i)-MOmega1)^2)/(NO1-1);
end
SOmega1=S2Omega1^0.5;
S2Omega2=0;
for i=1:NO2
    S2Omega2=S2Omega2+((Omega2(i)-MOmega2)^2)/(NO2-1);
end
SOmega2=S2Omega2^0.5;
syms X;
PXO1=1/(((2*pi)^0.5)*SOmega1)*exp(-((X-MOmega1)^2)/(2*S2Omega1));
PXO2=1/(((2*pi)^0.5)*SOmega2)*exp(-((X-MOmega2)^2)/(2*S2Omega2));
PX=PO1*PXO1+PO2*PXO2;
PO1X=PXO1*PO1/PX;
PO2X=PXO2*PO2/PX;
La1O2=1;
La2O1=6;%��С����
%La2O1=1;%��С����
Ra1X=La1O2*PO2X;%a1Ϊѡ��Omega1
Ra2X=La2O1*PO1X;%a2Ϊѡ��Omega2
figure;
ezplot(PO1X,[-60,60]);
hold on;
ezplot(PO2X,[-60,60]);
legend('P(��1|X)','P(��2|X)');
title('');
figure;
ezplot(PXO1,[-8,8]);
hold on;
ezplot(PXO2,[-8,8]);
legend('P(X|��1)','P(X|��2)');
figure;
ezplot(Ra1X,[-100,100]);
hold on;
ezplot(Ra2X,[-100,100]);
legend('R(a1|X)','R(a2|X)');
BE=double(vpa(solve(PO1X-PO2X),12));
BoundryE=BE(2,1);
BR=double(vpa(solve(Ra1X-Ra2X),12));
BoundryR=BR(2,1);
% if Ra1X>Ra2X
%     Mark=1;
%     fprintf('�쳣\n');
% end
% if Ra1X<Ra2X
%     Mark=2;
%     fprintf('����\n');
% end
% if Ra1X==Ra2X
%     Mark=0;
%     fprintf('����\n');
% end