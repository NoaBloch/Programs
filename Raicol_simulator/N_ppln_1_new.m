% N_PPLN_1.M
% sellmeier equation for according to "A temperature-dependent dispersion equation for congruently grown LiNbO3"
% Optical & Quantum Electronics / vol. 16, p.373
% lambda in microns
% no according to first article
function no=n_ppln_1_new(lambda,T)
A1=4.9048;
A2=0.11775;
A3=0.21802;
A4=0.027153;
B1=2.2314e-8;
B2=-2.9671e-8;
B3=2.1429e-8;
F=(T-24.5)*(T+24.5+546);
no=sqrt(A1+(A2+B1*F)./(lambda.^2-(A3+B2*F).^2)+B3*F-A4*lambda.^2);
%no=sqrt(A1+A2./(lambda.^2-A3.^2)-A4*lambda.^2);
