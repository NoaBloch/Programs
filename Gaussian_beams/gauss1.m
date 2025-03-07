% gaussian beam
clear all;
% calculation of matrix elements for gaussian beam
format short;
 %find waist and z0
lambda=1.0475;
 w0=180*10^(-6);
% n=n_ppslt_z(lambda,100) 
n=1 ;
lambda=lambda*10^(-6);
z0=pi*w0^2*n/lambda

q1=i*z0;
x=sym('x');
length1=sym('l1');
f1=sym('f1');
length2=sym('l2');
f2=sym('f2');
length3=sym('l3');


mat1=[1,length1;0,1];
mat2=[1,0;-1/f1,1];
mat3=[1,length2;0,1];
mat4=[1,0;-1/f2,1];
mat5=[1,length3;0,1];

z01=sym('z01');

summat=mat5*mat4*mat3*mat2*mat1;
summat=subs(summat,'l1',16*2.54*10^(-2));
summat=subs(summat,'f1',400*10^(-3));
summat=subs(summat,'l2',49*2.54*10^(-2));
summat=subs(summat,'f2',100*10^(-3));
% summat=subs(summat,'l3',6*2.54*10^(-2));



a=summat(1,1);
% a=simplify(a);
b=summat(1,2);
% b=simplify(b);
c=summat(2,1);
% c=simplify(c);
d=summat(2,2);
% d=simplify(d);


% x=6*2.54*10^(-2)-7285330138024585/72057594037927936;
q2=(a*q1+b)/(c*q1+d)
rq2=real(q2)
equ='rq2=0'
equ=subs(equ,'rq2',rq2)
x=solve(equ)

%length till degem



