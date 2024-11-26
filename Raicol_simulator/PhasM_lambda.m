
function [po2w]=PhasM_lambda(L,omega0,T,P1,lambda1,Lamdamin,Lambdamax,Dl,Pperiod,material)




c=2.99792458e10;
% eps0=8.854187817e-12; 

 dx=10e-4;  %[cm]
 dy=10e-4;  %[cm]
 dz=2e-4;   %[cm]tr
 %L=0.02;
 %omega0=70*1e-4;
 
    
          C1=strcmp(material,'PPKTP');
               C2=strcmp(material,'PPSLT');
                     C3=strcmp(material,'PPLN');
                     
 if C1==1
 deff=(15.9*1e-12)*3e4/(4*pi); 
 end
 
 if C2==1 
 deff=(21*1e-12)*3e4/(4*pi); 
 end
   
 if C3==1 
 deff=(27*1e-12)*3e4/(4*pi); 
 end
 
%   if material=='PPLN'  
%  deff=(27*1e-12)*3e4/(4*pi); 
%   end 
%   
 %ppktp d33
 %T=35;  %Temp scan in celsius 
 %lambda1=1.030*1e-4;%Pump wavelength
 %lvec=(1.063:0.0001 :1.065).*1e-4;  %Can be scanned in wavelength 
 %P1 =10000*1e7; % 1Watt = 1e7 erg/s  Pump power in Watt

 
      
%Crystal periodic poling
%load('matlabz.mat');

%Pperiod=3.1*1e-04;
 %Pperiod=24.72*1e-4; %Pperiod of periodic poling
%Pperiod=0.12e-5;

 Lcord=-L/2:dz:L/2; 
 zz= sign(cos(2*pi.*(Lcord)./Pperiod)); %Crystal susceptibility function
 
 
 
 MaxX=500*1e-4; MaxY=500*1e-4; %Pump matrix size
 [X,Y] = meshgrid(-MaxX:dx:MaxX,-MaxY:dy:MaxY);
 X2=X ;  X1=X;  Y2=Y;  Y1=Y;
       
     
            Tam=0;
            Lam=0;
           % lambda1v=0.843*1e-4:0.00005*1e-4:0.847*1e-4;
         for lambda1 = Lamdamin:Dl:Lambdamax;
                         lambda2=lambda1/2;

            Lam=Lam+1
            
       
          C1=strcmp(material,'PPKTP');
               C2=strcmp(material,'PPSLT');
                     C3=strcmp(material,'PPLN');

        if C1==1; 
 n1 =n_ktp_5g(lambda1*1e4)+dn_dtz(T,lambda1*1e4); 
 n2 =n_ktp_5g(lambda2*1e4)+dn_dtz(T,lambda2*1e4);
        end
          
            
        if C2==1;  
  n1 = n_ppslt_z(lambda1*1e4,T);
  n2 =n_ppslt_z(lambda2*1e4,T);
        end
           
%             
%         
        if C3==1; 
  n1 = N_ppln_1_new(lambda1*1e4,T);
  n2 = N_ppln_1_new(lambda2*1e4,T);
        end
        
        
        
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
        f1 = dEw_dz.*dz+E1;;% the added contribution of every slab to the generated field

        
        
        %propagating FH
        F1= fftshift(fft2(f1));
        G1 = H1.*F1;
        g1 =ifft2(ifftshift(G1));
        E1 = g1;% the propagated FH
         
         
       
    end    
    
     %  po1w(Lam)= (n1*c)/(8*pi)*sum((abs(E1(:)).^2))*dx*dy;
       po2w(Lam)= (n2*c)/(8*pi)*sum((abs(E2out(:)).^2))*dx*dy;
       

         end 
       
% figure;       
% plot((Lamdamin:Dl:Lambdamax)*1e7,po2w./1e7);
% title('SH power [W] V.s Wavelength');
% xlabel('Wavelength [nm]')
% ylabel('SH power [W]');

       