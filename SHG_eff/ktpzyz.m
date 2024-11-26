function [n_p_y,n_s_z,n_i_y]=ktpzyz(lambda_p,lambda_s,lambda_i,T) 

%Calculate refracqw76tive index of KTP along z axis
%   lambda in microns, T in Celsius.
%   dn/dT is According to Fisher and Arie, Applied Optics 42, 6661 (2003)
%   All calculations here are for type-2 -> z signal, y idler, y pump

%calculate Selllmeier - Fradkin z axis 

A=2.127246810298;
B=1.184312171943;
C=0.051485232676;
D=0.009689556913;
E=0.660296369063;
F=100.005073661931;

% lambda_p = 0.405;
% lambda_s = 0.81;
% lambda_i = 1./(1./lambda_p - 1./lambda_s);

n_p_y=sqrt(2.09930 + 0.922683./(1 - 0.0467695*lambda_p.^-2) - 0.0138404*lambda_p.^2); % Sellmeier for Y
n_s_z=(A+B./(1-C./lambda_s.^2)+E./(1-F./lambda_s.^2)-D.*lambda_s.^2).^0.5; % Sellmeier for Z
n_i_y=sqrt(2.09930 + 0.922683./(1 - 0.0467695*lambda_i.^-2) - 0.0138404*lambda_i.^2); % Sellmeier for Y

%calculate change from temperature - Z axis
a0_z=9.9587e-6;
a1_z=9.9288e-6;
a2_z=-8.9603e-6;
a3_z=4.101e-6;
b0_z=-1.1882e-8;
b1_z=10.459e-8;
b2_z=-9.8136e-8;
b3_z=3.1481e-8;

%calculate change from temperature - Y axis
a0_y=6.2897e-6;
a1_y=6.3061e-6;
a2_y=-6.0629e-6;
a3_y=2.6486e-6;
b0_y=-0.14445e-8;
b1_y=2.2244e-8;
b2_y=-3.5770e-8;
b3_y=1.3470e-8;


dn_p=(a0_y+a1_y./lambda_p+a2_y./lambda_p.^2+a3_y./lambda_p.^3).*(T-25)+ (b0_y+b1_y./lambda_p+b2_y./lambda_p.^2+b3_y./lambda_p.^3).*(T-25).^2;
dn_s=(a0_z+a1_z./lambda_s+a2_z./lambda_s.^2+a3_z./lambda_s.^3).*(T-25)+ (b0_z+b1_z./lambda_s+b2_z./lambda_s.^2+b3_z./lambda_s.^3).*(T-25).^2;
dn_i=(a0_y+a1_y./lambda_i+a2_y./lambda_i.^2+a3_y./lambda_i.^3).*(T-25)+ (b0_y+b1_y./lambda_i+b2_y./lambda_i.^2+b3_y./lambda_i.^3).*(T-25).^2;

n_p_y=n_p_y+dn_p;
n_s_z=n_s_z+dn_s;
n_i_y=n_i_y+dn_i;

k_p = 2.*pi.*n_p_y./lambda_p;
k_s = 2.*pi.*n_s_z./lambda_s;
k_i = 2.*pi.*n_i_y./lambda_i;

disp('The period in microns:')

P = abs(2.*pi./(-k_s-k_i+k_p));