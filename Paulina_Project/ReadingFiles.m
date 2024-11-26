clear all;
close all;

M=csvread('Book4.csv');


figure; 
plot(M); 
figure;
plot(diff(M),'r.'); 
Zvec=0;
for ii=1:2:round(length(M))-2;
    Zvec=[Zvec, ones(1,round(1000*(M(ii+1)-M(ii))))];
    Zvec=[Zvec, -ones(1,round(1000*(M(ii+2)-M(ii+1))))];
end 
Zvec=padarray(Zvec,[0,1000000]);


ZZ=fftshift(fft(Zvec));
%ZV1=(M(end-6));
ZV1=length(Zvec)/1000;
ZV=-pi*1000:(2*pi/ZV1):pi*1000;
CC=abs(length(ZZ)-length(ZV));
figure;
plot(ZV(1:end-1).*1e6,abs(ZZ).^2,'b.-');
xlabel('\Delta K [1/m]');
title('Paulina KOU two SPDC processes TYPE2');
