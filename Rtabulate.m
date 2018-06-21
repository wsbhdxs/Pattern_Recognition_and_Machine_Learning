function [t]=Rtabulate(x)
t=tabulate(x);
t(t(:,2)==0,:)=[];