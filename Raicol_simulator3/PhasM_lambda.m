
function [po2w]=PhasM_lambda(L,omega0,T,P1,lambda1,Lamdamin,Lambdamax,Dl,Pperiod,material)
c=2.99792458e10;
% eps0=8.854187817e-12; 

dx=10e-4;  %[cm]
dy=10e-4;  %[cm]
dz=2e-4;   %[cm]tr

% Check for the different crystal types including both PPKTP variants
C1=strcmp(material,'PPKTP-Type 0');
C2=strcmp(material,'PPKTP-Type 2');
C3=strcmp(material,'PPSLT');
C4=strcmp(material,'PPLN');

% Set deff based on crystal type
if C1==1
    deff=(15.9*1e-12)*3e4/(4*pi); % PPKTP Type 0
elseif C2==1
    deff=(2.4*1e-12)*3e4/(4*pi);  % PPKTP Type 2
elseif C3==1 
    deff=(21*1e-12)*3e4/(4*pi);   % PPSLT
elseif C4==1 
    deff=(27*1e-12)*3e4/(4*pi);   % PPLN
end

%Crystal periodic poling
Lcord=-L/2:dz:L/2; 
zz= sign(cos(2*pi.*(Lcord)./Pperiod)); %Crystal susceptibility function

MaxX=500*1e-4; MaxY=500*1e-4; %Pump matrix size
[X,Y] = meshgrid(-MaxX:dx:MaxX,-MaxY:dy:MaxY);
X2=X ;  X1=X;  Y2=Y;  Y1=Y;
    
Tam=0;
Lam=0;
for lambda1 = Lamdamin:Dl:Lambdamax;
    lambda2=lambda1/2;
    Lam=Lam+1
    
    % Update refractive index calculations to handle both PPKTP types
       if C1==1 
        n1 = nppktp_0(lambda1*1e4,T);
        n2 = nppktp_0(lambda2*1e4,T);
        n1o=n1;
    elseif C2==1   
        [n1,n1o] = nppktp_2(lambda1*1e4,T);
        [n2o,n2] = nppktp_2(lambda2*1e4,T);
    elseif C3==1  
        n1 = n_ppslt_z(lambda1*1e4,T);
        n2 = n_ppslt_z(lambda2*1e4,T);
        n1o=n1;
    elseif C4==1
        n1 = N_ppln_1_new(lambda1*1e4,T);
        n2 = N_ppln_1_new(lambda2*1e4,T);
        n1o=n1;
    end
    
    w1 = 2*pi*c/lambda1;
    k1 = 2*pi*n1/lambda1;
    k1o = 2*pi*n1o/lambda1;

    w2 = 2*pi*c/lambda2;      
    k2 = 2*pi*n2/lambda2;
    
    E2w=zeros(size(X2));
    ni_x = (X2./dx)./size(X2,2)/dx;   %scale change
    ni_y = (Y2./dy)./size(Y2,1)/dy;   %scale change
    B = ni_x.^2+ni_y.^2;
    
    % The Gaussian transfer function 
    H0=1;
    TransFact =1i*2*pi*(1/(lambda2/n2)^2-B).^0.5;
    H2=H0.*exp(TransFact*(dz)); % H is the transfer function for SH propagation
    
    TransFact1 =1i*2*pi*(1/(lambda1/n1)^2-B).^0.5;
    H1 = H0.*exp(TransFact1*(dz));% Hw is the transfer function for FH propagation
    
    TransFact1o =1i*2*pi*(1/(lambda1/n1o)^2-B).^0.5;
    H1o = H0.*exp(TransFact1o*(dz));% Hw is the transfer function for FH propagation
    

    E2out=zeros(size(X2));
    
    Y1 = Y2;   
    X1 = X2;
    Z1=L/2;  
    
    b = omega0^2*k1;
    bo= omega0^2*k1o;
    E0 = sqrt(16*P1/(c*n1*omega0^2));
    E0o = sqrt(16*P1/(c*n1o*omega0^2));
    flag=0;
    Chi = 2*Z1/b;
    Chio = 2*Z1/bo;
    TauFact = 1./(1+sqrt(-1)*Chi);
    TauFacto = 1./(1+sqrt(-1)*Chio);
    E1 = E0*TauFact.*exp(sqrt(-1)*k1*Z1).*exp(-(X1.^2+Y1.^2)/(omega0^2).*TauFact);
    E1y= E0o*TauFacto.*exp(sqrt(-1)*k1o*Z1).*exp(-(X1.^2+Y1.^2)/(omega0^2).*TauFacto);

    for z_slice=Lcord
        flag=flag+1;
        Poling_sign=zz(flag);
        dE2_dz=(2*pi*1i*w2/(c*n2))*deff.*((E1).*E1y).*Poling_sign;
        f=dE2_dz.*dz+E2out;
        
        %propagating SH
        F=fftshift(fft2(f));
        G=H2.*F;
        g1=ifft2(ifftshift(G));
        E2out=g1;

        dEw_dz = (4*pi*i*w1/(c*n1))*deff*conj((E1)).*f.*Poling_sign;
        f1 = dEw_dz.*dz+E1;

        %propagating FH
        F1= fftshift(fft2(f1));
        G1 = H1.*F1;
        g1 =ifft2(ifftshift(G1));
        E1 = g1;

        dEyw_dz = (4*pi*i*w1/(c*n1o))*deff*conj((E1y)).*f.*Poling_sign;
        f1y = dEyw_dz.*dz+E1y;

        %propagating FH
        F1y= fftshift(fft2(f1y));
        G1y = H1o.*F1y;
        g1y =ifft2(ifftshift(G1y));
        E1y = g1y;    



    end    
    
    po2w(Lam)= (n2*c)/(8*pi)*sum((abs(E2out(:)).^2))*dx*dy;
end 
end       