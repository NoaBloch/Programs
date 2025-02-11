%Calculate refractive index of KTP along z axis
%   lambda in microns, T in Celsius.
%   dn/dT is According to Fisher and Arie, Applied Optics 42, 6661 (2003)
%   Sellmier according to K. Fradkin, A. Arie, A. Skliar, and G. Rosenman, Tunable midinfrared source by difference frequency generation in bulk periodically poled KTiOPO4, Appl. Phys. Lett. 74, 914916 (1999). 
%   All calculations here are for type-0 -> z signal, z idler, z pump
function[n]=nppktp_0(lambda1,T)

%calculate Selllmeier
A=2.127246810298;
B=1.184312171943;
C=0.051485232676;
D=0.009689556913;
E=0.660296369063;
F=100.005073661931;

lambda_p = lambda1; %Pump wavelength in microns

n_p=(A+B./(1-C./lambda_p.^2)+E./(1-F./lambda_p.^2)-D.*lambda_p.^2).^0.5; %Index of refraction at the pump before applying temperature

%calculate change from temperature
a0=9.9587e-6;
a1=9.9288e-6;
a2=-8.9603e-6;
a3=4.101e-6;
b0=-1.1882e-8;
b1=10.459e-8;
b2=-9.8136e-8;
b3=3.1481e-8;

%T = 35 %Temperature in Celsius

dn_p=(a0+a1./lambda_p+a2./lambda_p.^2+a3./lambda_p.^3).*(T-25)+ (b0+b1./lambda_p+b2./lambda_p.^2+b3./lambda_p.^3).*(T-25).^2;

n_p=n_p+dn_p; %Index of refraction at the pump wavelength and the set temperature

n=n_p; 
% 
% k_p = 2.*pi.*n_p./lambda_p;
% k_s = 2.*pi.*n_s./lambda_s;
% k_i = 2.*pi.*n_i./lambda_i;
% 
% k_p-k_s-k_i
% 
% disp('The period in microns:')
% 
% P = abs(2.*pi./(-k_s-k_i+k_p))