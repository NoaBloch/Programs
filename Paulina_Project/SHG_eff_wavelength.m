%clear all;
close all;

       c=3e8;

       dx=20e-6;
       dy=20e-6;
       dz=1e-6;
       L=3e-3;
       
       
       omega0=50e-6;
       MaxX=200e-6; MaxY=200e-6;
       [X,Y] = meshgrid(-MaxX:dx:MaxX,-MaxY:dy:MaxY);
       X2=X ;  X1=X;  Y2=Y;  Y1=Y;
       
     
       deff=14.9e-12*3e4/(4*pi); %ppktp d33
       T=40;  %cels6
       P1=1e7;
         Pperiod=2.4691e-05;
          Lcord=dz:dz:Pperiod*1019; 
          zz=sign(sin(2*pi.*Lcord./Pperiod));
         zz=[zz,zz];
%zz=Zvec;        
         lam=0;
        
         for lambda1 = (0.9:0.005:1.6).*1e-6;
             tic
             lam=lam+1;
         lambda2=lambda1/2;
       
            n1 =n_ktp_5g(lambda1*1e6)+dn_dtz(T,lambda1*1e6);
            n2 =n_ktp_5g(lambda2*1e6)+dn_dtz(T,lambda2*1e6);
            w1 = 2*pi*c/lambda1;
            k1=  2*pi*n1/lambda1;
                    
            w2 = 2*pi*c/lambda2;      
            k2 = 2*pi*n2/lambda2;
            
 % zz=[zz,zz];
       
           E2w=zeros(size(X2));
%           E2_L = zeros(size(Z2));          
           ni_x = (X2./dx)./size(X2,2)/dx;   %scale change
           ni_y = (Y2./dy)./size(Y2,1)/dy;   %scale change
           B = ni_x.^2+ni_y.^2;
 
 
 % The Gaussian transfer function 
 %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
          H0=1; 
          TransFact =i*2*pi*((n2/lambda2)^2-B).^0.5;
          H2=H0.*exp(TransFact*(dz)); % H2 is the transfer function for SH propagation
          E2out=zeros(size(X2));
          

   
        Y1 = Y2;   
        X1 = X2 ;
        Z1 = 3e-3;
        
   %_________________________________________________________
   
   
            b = omega0^2*k1;
            %~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
            
            %Electric field coefficients
            E0 = sqrt(16*P1/(c*n1*omega0^2));
            %~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 

E1out=[];

       flag=0;
       flag1=0;
    for  z_slice=(-230000:10:230000).*dz/100; 
      
        flag=flag+1;
       xi=2*z_slice/b ;                             
       tau=1/(1+sqrt(-1)*xi);
       
       
        E1 = (E0*tau)*exp(sqrt(-1)*k1*z_slice).*exp(-(X1.^2+Y1.^2)./(omega0^2).*tau);
%       E1 = -(E0*tau)^2.*exp(sqrt(-1)*k1*z_slice).*exp(-2*Msq./(omega0^2).*tau);

        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    %   E1out= [E1out; E1(100,:)];
      
        Poling_sign=zz(flag);
        dE2_dz=(2*pi*i*w2/(c*n2))*deff*E1.^2.*Poling_sign;
        
        
      %  flag1=1000;
%                if flag>4130;
%                    flag1=flag1-1
% Poling_sign=zz(flag1);
%                 dE2_dz=(2*pi*i*w2/(c*n2))*deff*E1.^2.*Poling_sign;
%                end
        
        %the added contribution of every slab to the generated field
        f2=dE2_dz*dz+E2out;
        
        %propagating SH
        
        F2=fftshift(fft2(f2));
        G2=H2.*F2;
        E2out=ifft2(ifftshift(G2));
      
        
%     end
%    toc
    
    
    end     
       po2w(lam)= n2*c/(8*pi)*sum(abs(E2out(:)).^2)*dx*dy;
     toc       
         end 
       
       


       