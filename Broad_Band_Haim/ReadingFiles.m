clear all;
close all;

M=csvread('Haim2.csv');


figure; 
plot(M); 
figure;
plot(diff(M),'r.'); 
Zvec=0;
for ii=1:2:round(length(M))-2;
    Zvec=[Zvec, ones(1,round(100*(M(ii+1)-M(ii))))];
    Zvec=[Zvec, -ones(1,round(100*(M(ii+2)-M(ii+1))))];
end 
Zvec=padarray(Zvec,[0,10000000]);


ZZ=fftshift(fft(Zvec));
%ZV1=(M(end-6));
ZV1=length(Zvec)/100;
ZV=-pi*100:(2*pi/ZV1):pi*100;
figure;
CC=abs(length(ZZ)-length(ZV));
figure;
hold on;
plot(ZV(1:end-1).*1e6,abs(ZZ).^2,'b.-');
xlabel('\Delta K [1/m]');
title('Haim.csv');
