
clear all;
close all;



%https://refractiveindex.info/?shelf=main&book=LiNbO3&page=Zelmon-o
%Pump%dn/d? = -0.033746 µm-1 n = 2.2108
%SHdn/d? = -0.13911 µm-1 n = 2.2580
c=3*1e8;
tau=90*1e-15;
lambda1=1.56e-6;
lambda2=lambda1/2;
n1=2.2108;
n2=2.2580;
dn1=-0.033746/(1e-6)
dn2= -0.13911/(1e-6)
vg1=c/(n1-lambda1*dn1);
vg2=c/(n2-lambda2*dn2);

Leff=2*tau*abs((1/vg1-1/vg2)^-1)
%******************************************
%Optimal Focusing


k1=2*pi*n1/lambda1
w0=10e-6;
b=w0.^2*k1;
xi=Leff/b

%********************************************
%Optical damage
P=3400/(pi*10e-4.^2)






