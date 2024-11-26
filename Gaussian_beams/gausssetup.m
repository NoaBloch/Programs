% gaussian beam
clear all;
% calculation of matrix elements for gaussian beam-setup alon 
format short;
 %find waist and z0
lambda=(780)/2;
 w0=380e-6;
% n=n_ppslt_z(lambda,100) 
n=1 ;
lambda=lambda*1e-6;
z0=pi*w0^2*n/lambda

q1=i*z0;
x=sym('x');
length1=sym('l1');
f1=sym('f1');
length2=sym('l2');

mat1=[1,length1;0,1];
mat2=[1,0;-1/f1,1];
mat3=[1,length2;0,1];


summat=mat3*mat2*mat1;


summat=subs(summat,'l1',122.9*10^(-2));
summat=subs(summat,'f1',60*10^(-3));
 summat=subs(summat,'l2',6.4*10^(-2));


a=summat(1,1);
% a=simplify(a);
b=summat(1,2);
% b=simplify(b);
c=summat(2,1);
% c=simplify(c);
d=summat(2,2);
% d=simplify(d);

q2=(a*q1+b)/(c*q1+d)

z02=imag(q2)
waist=sqrt(z02*lambda/pi)




