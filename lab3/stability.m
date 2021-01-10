clc;clear;

t0 = 3;
T1 = linspace(0, 2*pi, 20);
figure('Name','1-st system');
subplot(1,2,1);
hold on;
for i = T1
    [t, x] = ode45(@(t, x) syst1(t,x), [0 t0], [sin(i); cos(i)]);
    Vmax = max(V1(x(:,1),x(:,2)));
    for j = 1:(length(x)-1)
        Vcur = V1(x(j,1),x(j,2));
        col = Vcur/Vmax;
        quiver(x(j, 1), x(j, 2), x(j+1, 1) - x(j, 1), x(j+1, 2) - x(j, 2), 'MaxHeadSize', 5, 'Color', [col 0 1-col]);
    end
end
grid on;
axis equal;
axis ([-3,3,-3,3]);
title('Phase curves');
subplot(1,2,2);
[X,Y] = meshgrid(linspace(-100,100,100), linspace(-10,10,100));
Z = V1(X,Y);
contour(X,Y,Z,20);
title('Isolines of Lyapunov function');
hold off;

figure('Name', '2-nd system');
T2 = linspace(0, pi/2, 20);
subplot(1,2,1);
hold on;
for i = T2
    [t, x] = ode45(@(t, x) syst2(t,x), [0 t0], [1-sin(i); 1-cos(i)]);
    Vmax = max(V2(x(:,1),x(:,2)));
    for j = 1:(length(x)-1)
        Vcur = V2(x(j,1),x(j,2));
        col = Vcur/Vmax;
        quiver(x(j, 1), x(j, 2), x(j+1, 1) - x(j, 1), x(j+1, 2) - x(j, 2), 'MaxHeadSize', 5, 'Color', [col 0 1-col]);
    end
end
grid on;
axis equal;
axis ([-3,3,-3,3]);
title('Phase curves');
subplot(1,2,2);
[X,Y] = meshgrid(linspace(-10,10,10), linspace(-10,10,100));
Z = V2(X,Y);
contour(X,Y,Z,20);
title('Isolines of Lyapunov function');
hold off;

function val = V1(x,y)
    val = (x + y).^2 + 1/2 * y.^4;
end

function dxdt = syst1(t,x)
    dxdt = zeros(2,1);
    dxdt(1) = 2*x(2) - x(1) - x(2)^3;
    dxdt(2) = x(1) - 2*x(2);
end

function val = V2(x,y)
    val = x.*y;
end

function dxdt = syst2(t,x)
    dxdt = zeros(2,1);
    dxdt(1) = x(1)*x(2) - x(1)^3 + x(2)^3;
    dxdt(2) = x(1)^2 - x(2)^3;
end