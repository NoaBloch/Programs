% Sellmiere
% nz for SLT according to Bruner's article "Optics Letters" Vol.
% 28 N.3 2003
% lamda in microns, T in Celsius degrees
function ne=n_ppslt_z(lamda,T)

A=4.502483;
B=0.007294 ;
C=0.185087;
D=-0.02357;
E=0.073423;
F=0.199595;
G=0.001;
H=7.99724;
b=3.483933e-8*(T+273.15)^2;
c=1.607839e-8*(T+273.15)^2;

ne2=A+(B+b)/(lamda^2-(C+c)^2)+E/(lamda^2-F^2)+G/(lamda^2-H^2)+D*lamda^2;
ne=sqrt(ne2);


