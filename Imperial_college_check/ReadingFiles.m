clear all;
close all;

M=csvread('Design_F_R.csv');


% figure; 
% plot(M); 
% figure;
% plot(diff(M),'r.'); 
 Zvec=0;
for ii=1:2:round(length(M))-1;
    Zvec=[Zvec, ones(1,round((M(ii))))];
    Zvec=[Zvec, -ones(1,round((M(ii+1))))];
 
end 

Zvec=padarray(Zvec,[0,100000]);
ZZ=fftshift(fft(Zvec))./length(Zvec);
%ZV1=(M(end-6));
ZV1=length(Zvec);
ZV=-pi:(2*pi/ZV1):pi;
figure;
CC=abs(length(ZZ)-length(ZV));
figure;
hold on;
plot(ZV(1:end-1).*1e6,abs(ZZ).^2,'b.-');
xlabel('\Delta K [1/m]');
title('Final_Design_APPKTP.csv');
