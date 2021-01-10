clc;clear;

m1 = 4e24;
m2 = 4e24;
x0 = [1e5 0 0 1e4 0 0 -1e5 0 0 -1e4 0 0];

Xmin = -3*10^5;
Xmax = 3*10^5;
Ymin = -3*10^5;
Ymax = 3*10^5;
Zmin = -3*10^5;
Zmax = 3*10^5;

t0 = 20;

F = figure;
A = axes(F);
[t,x] = ode45(@(t,x) star_system(t, x, m1, m2), [0 t0], x0);

X = zeros(size(x,1),3);
Y = zeros(size(x,1),1);
for i = 1:size(x,1)
    X(i,1) = 1;
    X(i,2) = x(i,1);
    X(i,3) = x(i,3);
    Y(i) = x(i,5);
end
b = (X'*X)^(-1)*X'*Y;
[X,Y] = meshgrid(linspace(Xmin,Xmax, 10), linspace(Ymin, Ymax, 10));
Z = b(1) + b(2)*X + b(3)*Y;
surf(A,X,Y,Z, 'FaceAlpha',0.2);
hold on;
P1 = plot3(A, x(1,1), x(1,3), x(1,5),'o', 'MarkerSize', 15, 'MarkerEdgeColor', 'black', 'MarkerFaceColor', 'yellow');
hold on;
P2 = plot3(A, x(1,7), x(1,9), x(1,11), 'o', 'MarkerSize', 7, 'MarkerEdgeColor', 'black', 'MarkerFaceColor', 'blue');
axis ([Xmin, Xmax, Ymin, Ymax, Zmin, Zmax])

for i = 2:length(t)
    P1.XData = x(i,1);
    P1.YData = x(i,3);
    P1.ZData = x(i,5);
    P2.XData = x(i,7);
    P2.YData = x(i,9);
    P2.ZData = x(i,11);
    pause(0.06);
end
hold off;

function dx = star_system(t, x, m1, m2)
    G = 6.67e-11;
    dx = zeros(12,1);
    x1 = [x(1); x(3); x(5)];
    v1 = [x(2); x(4); x(6)];
    x2 = [x(7); x(9); x(11)];
    v2 = [x(8); x(10); x(12)];
    eql = G*(x2 - x1)/(norm(x1-x2)^3);
    dx(1:2:5) = v1;
    dx(2:2:6) = eql*m2;
    dx(7:2:11) = v2;
    dx(8:2:12) = -eql*m1;
end


