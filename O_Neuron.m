function [ys,g]=O_Neuron(w,Theta,b,y)
be=[b,-1];
we=[w;Theta];
%Sigmoid
ys=1/(1+exp(-be*we));
g=ys*(1-ys)*(y-ys);
%Ë«ÇúÕýÇÐ
% ys=tanh(be*we);
% g=1/(cosh(b*w))^2*(y-ys);