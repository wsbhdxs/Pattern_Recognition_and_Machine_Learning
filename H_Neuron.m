function [e,b]=H_Neuron(x,v,Gamma,w,g)
%wΪ����Ԫ�����Ȩ����
%vΪ����Ԫ������Ȩ����
%gΪ��һ�㣨����㣩���ݶȾ���
xe=[x,-1];
ve=[v;Gamma];
if size(g,1)==1
    g=g';
end
%Sigmoid
b=1/(1+exp(-xe*ve));
e=b*(1-b)*(w*g);
%˫������
% b=tanh(xe*ve);
% e=1/(cosh(x*v))^2*(w*g);