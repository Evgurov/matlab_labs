clc; clear;
a = sym('a');
b = sym('b');
g = sym('g');
u3 = (1 + a*b + sqrt((a*b - 1)*(a*b - 1) - 4*a*b*g))/(2*a);
v3 = (1 - a*b - sqrt((a*b - 1)*(a*b - 1) - 4*a*b*g))/2;
u4 = (1 + a*b - sqrt((a*b - 1)*(a*b - 1) - 4*a*b*g))/(2*a);
v4 = (1 - a*b + sqrt((a*b - 1)*(a*b - 1) - 4*a*b*g))/2;
j3_11 = 1 - 2*a*u3 - v3;
j3_12 = -u3;
j3_21 = v3*v3/(g+v3);
j3_22 = -b + (2*u3*v3*(g + v3) - u3*v3*v3)/((g + v3) * (g + v3));
J3 = [j3_11, j3_12; j3_21, j3_22];
lambda = eig(J3)