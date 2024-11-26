clear all;
close all;

     
     
       dz=0.01e-6;
       L=3e-3;
       
   
          Pperiod=1.2e-6;
          Lcord=-L/2:dz:L/2; 
          zz=sign(cos(2*pi.*Lcord./Pperiod));
          
          
zz=padarray(zz,[0,1000000]);
   

      
ZZ=fftshift(fft(zz));
ZV1=length(ZZ)-1;
ZV=-pi:2*pi/ZV1:pi;
figure;
plot(ZV./(0.01e-6),abs(ZZ),'b.-');
xlabel('\Delta K [1/m]');
title('QPM orders');

lambda1=0.829*1e-6;
lambda2=lambda1/2;
 
          T=30;
 
       lambdap=1e-6;
       lambdai=1e-6;
         
           [np,n1,ni]=ktpzyz(lambdap.*1e6,lambda1.*1e6,lambdai.*1e6,T)    
           k1=  2*pi*n1/lambda1; 
           [np,n2,ni]=ktpzyz(lambdap.*1e6,lambda2.*1e6,lambdai.*1e6,T) 
           k2=  2*pi*n2/lambda2;
           
 
dk1=-k2-2*k1
Pperiod=2*pi/dk1
1.2e-6/(Pperiod)


