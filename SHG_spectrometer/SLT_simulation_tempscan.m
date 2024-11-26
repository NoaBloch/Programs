clear all;
close all;

%Simulation of PPSLT SH efficiency curves based on BPM
%Written by Noa Bloch Noa.Bloch@Raicol.com
%Published 23/05/2024

c=2.99792458e10;
% eps0=8.854187817e-12; 

 dx=10e-4;  %[cm]
 dy=10e-4;  %[cm]
 dz=2e-4;   %[cm]
 L=3;
 omega0=37e-4;
 deff=(26.1e-12)*3e4/(4*pi); %ppslt d33
 Tvec=48:0.5:58;  %Temp scan in celsius 
 lambda1=1.064e-4;%Pump wavelength
 %lvec=(1.063:0.0001 :1.065).*1e-4;  %Can be scanned in wavelength 
 P1 = 1*1e7; % 1Watt = 1e7 erg/s  Pump power in Watt

 
      
%Crystal periodic poling
%load('matlabz.mat');

%Pperiod=8.9462*1e-04;
 Pperiod=7.98e-4; %Pperiod of periodic poling
%Pperiod=0.12e-5;

 Lcord=-L/2:dz:L/2; 
 zz= sign(cos(2*pi.*(Lcord)./Pperiod)); %Crystal susceptibility function
 
 
 
 MaxX=500e-4; MaxY=500e-4; %Pump matrix size
 [X,Y] = meshgrid(-MaxX:dx:MaxX,-MaxY:dy:MaxY);
 X2=X ;  X1=X;  Y2=Y;  Y1=Y;
       
     
            Tam=0;
            lam=0;
            lambda1=1.064e-4;
            lambda2=lambda1/2;
         for T =Tvec;
             
            Tam=Tam+1
            
       
             n1 = n_ppslt_z(lambda1*1e4,T);
           %   n1 =n_ktp_5g(lambda1*1e4)+dn_dtz(T,lambda1*1e4);
             n2 =n_ppslt_z(lambda2*1e4,T);
            
           %n2 =n_ktp_5g(lambda2*1e4)+dn_dtz(T,lambda2*1e4);
           w1 = 2*pi*c/lambda1;
           k1=  2*pi*n1/lambda1;
                    
           w2 = 2*pi*c/lambda2;      
           k2 = 2*pi*n2/lambda2;
  
       
           E2w=zeros(size(X2));
           ni_x = (X2./dx)./size(X2,2)/dx;   %scale change
           ni_y = (Y2./dy)./size(Y2,1)/dy;   %scale change
           B = ni_x.^2+ni_y.^2;
 
 
 % The Gaussian transfer function 
 %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
         H0=1;
         TransFact =1i*2*pi*(1/(lambda2/n2)^2-B).^0.5;
         H2=H0.*exp(TransFact*(dz)); % H is the transfer function for SH propagation
       
         TransFact1 =1i*2*pi*(1/(lambda1/n1)^2-B).^0.5;
         H1 = H0.*exp(TransFact1*(dz));% Hw is the transfer function for FH propagation
   

        E2out=zeros(size(X2));
        
   
        Y1 = Y2;   
        X1 = X2 ;
        Z1=L/2;  
   
    
        b = omega0^2*k1;
        E0 = sqrt(16*P1/(c*n1*omega0^2));
 

        
        flag=0;
        Chi = 2*Z1/b;
        TauFact = 1./(1+sqrt(-1)*Chi);
        E1 = E0*TauFact.*exp(sqrt(-1)*k1*Z1).*exp(-(X1.^2+Y1.^2)/(omega0^2).*TauFact);
 
     E1s={};
    for  z_slice=Lcord; 
      
        flag=flag+1;
      
        Poling_sign=zz(flag);
        dE2_dz=(2*pi*1i*w2/(c*n2))*deff.*E1.^2.*Poling_sign;
        f=dE2_dz.*dz+E2out; % the added contribution of every slab to the generated field
       
        %propagating SH
        F=fftshift(fft2(f));
        G=H2.*F;
        g1=ifft2(ifftshift(G));
        E2out=g1; % the propagated SH
   
        dEw_dz = (4*pi*i*w1/(c*n1))*deff*conj(E1).*f.*Poling_sign;
        f1 = dEw_dz.*dz+E1;% the added contribution of every slab to the generated field

        
        
        %propagating FH
        F1= fftshift(fft2(f1));
        G1 = H1.*F1;
        g1 =ifft2(ifftshift(G1));
        E1 = g1;% the propagated FH
         
       
       
    end    
    
       po1w(Tam)= (n1*c)/(8*pi)*sum((abs(E1(:)).^2))*dx*dy;
       po2w(Tam)= (n2*c)/(8*pi)*sum((abs(E2out(:)).^2))*dx*dy;
       

         end 
       
figure;       
plot(Tvec,po2w./1e7);
title('SH power [W] V.s Wavelength');
xlabel('Wavelength [nm]')
ylabel('SH power [W]');

       