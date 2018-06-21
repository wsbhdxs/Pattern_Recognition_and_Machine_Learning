function [e,b]=H_Neuron(x,v,Gamma,w,g)
%w为该神经元的输出权矩阵
%v为该神经元的输入权矩阵
%g为下一层（输出层）的梯度矩阵
xe=[x,-1];
ve=[v;Gamma];
if size(g,1)==1
    g=g';
end
%Sigmoid
b=1/(1+exp(-xe*ve));
e=b*(1-b)*(w*g);
%双曲正切
% b=tanh(xe*ve);
% e=1/(cosh(x*v))^2*(w*g);