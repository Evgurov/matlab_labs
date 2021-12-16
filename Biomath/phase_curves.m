clc; clear;
a = 0.1;
b = 1;
g = 0.1;
maxt = 10;
grid_x = linspace(0, 3, 15);
grid_y = linspace(0, 3, 15);
T = linspace(0, maxt, 1000);
u_3 = (1 + a * b + sqrt((a*b - 1)*(a*b - 1) - 4*a*b*g))/(2*a);
v_3 = (1 - a * b - sqrt((a*b - 1)*(a*b - 1) - 4*a*b*g))/2;
u_4 = (1 + a * b - sqrt((a*b - 1)*(a*b - 1) - 4*a*b*g))/(2*a);
v_4 = (1 - a * b + sqrt((a*b - 1)*(a*b - 1) - 4*a*b*g))/2;

for i = 2 : length(grid_y)
    for k = 2 : length(grid_x)
        [t, x] = ode45(@(t, x) system(t,x,a,b,g), T , [grid_x(k); grid_y(i)]);
        plot(x(:, 1), x(:, 2), 'b'); hold on;
        quiver(x(1, 1), x(1, 2), x(2, 1) - x(1, 1), x(2, 2) - x(1, 2), 'MaxHeadSize', 1, 'Color', 'b');
    end
end
plot(0, 0, 'marker', '.', 'color', 'r', 'markersize', 15);
plot( 1/a, 0, 'marker', '.', 'color', 'r', 'markersize', 15);
plot(u_3, v_3, 'marker', '.', 'color', 'r', 'markersize', 15); 
plot(u_4, v_4, 'marker', '.', 'color', 'r', 'markersize', 15);
hold off;
axis([0 3 0 3]);

function dxdt = system(t,x,a,b,g)
    dxdt = zeros(2,1);
    dxdt(1) = x(1) .* ( ones(size(x(1))) - a * x(1) - x(2));
    dxdt(2) = -b * x(2) + (x(1) .* x(2) .* x(2)) ./ (g * ones(size(x(1))) + x(2));
end