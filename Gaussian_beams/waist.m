

%Theoretical waist calculation ///  
%new waist projecion setup 24/6/06
%************************************************
 
 clear all;
 n=1
 lambda=1.0475*10^(-6);
 w0=(180/2)*10^(-6);
 z0=pi*w0^2*n/lambda;

 
%  wz=w0*sqrt(1+(z/z0)^2)
 
 %ssssssssssssssssssssssssssssssssssssssssssssss
 
 q1=i*z0
 mat1=[1,16*2.54*10^(-2);0,1]
 mat111=mat1(1,1);
 mat112=mat1(1,2)
 mat121=mat1(2,1);
 mat122=mat1(2,2);

 q2=(q1* mat111+mat112)/(q1*mat121+mat122)
 
%ssssssssssssssssssssssssssssssssssssssssssssss
f1=400*10^(-3)
mat2=[1,0;-1/f1,1];
 mat211=mat2(1,1);
 mat212=mat2(1,2)
 mat221=mat2(2,1);
 mat222=mat2(2,2);

 q3=(q2* mat211+mat212)/(q2*mat221+mat222)
%sssssssssssssssssssssssssssssssssssssssssssssss

 mat3=[1,46*2.54*10^(-2);0,1]
 mat311=mat3(1,1);
 mat312=mat3(1,2)
 mat321=mat3(2,1);
 mat322=mat3(2,2);

 q4=(q3* mat311+mat312)/(q3*mat321+mat322)
 
%sssssssssssssssssssssssssssssssssssssssssssssssss

f2=200*10^(-3)
mat4=[1,0;-1/f2,1];
 mat411=mat4(1,1);
 mat412=mat4(1,2)
 mat421=mat4(2,1);
 mat422=mat4(2,2);

 q5=(q4* mat411+mat412)/(q4*mat421+mat422)
 
 %sssssssssssssssssssssssssssssssssssssssssssssssssssss
%  x=0.10205820024978460192532952551387; in the waist
x=0.201;
 mat5=[1,x;0,1]
 mat511=mat5(1,1);
 mat512=mat5(1,2)
 mat521=mat5(2,1);
 mat522=mat5(2,2);

 q6=(q5* mat511+mat512)/(q5*mat521+mat522)
 z0=imag(q6)

 
 
 %waist
 w=sqrt(lambda* z0/(pi*n))
 
 %waist calculation;


w =[ 21    22    30    33    34    38    45    53    55    57    58    60    67    68    70].*1e-6;

z=[0,500,1000,1300,1600,1900,2100,2400,2700,3000,3300,3600,3900,4100,4400]*1e-6;

wz=22*1e-6.*sqrt(1+(z./0.00158563467354).^2);

plot(z,w,'ro');
hold on;
plot(z,wz);
 
