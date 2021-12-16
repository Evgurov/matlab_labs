clc;clear;

fig1 = figure('name', 'orbit', 'NumberTitle','off');

fun = @(u_t, r) r .* u_t .* exp(-r/2 * u_t .* u_t); %  u_t > 0

biss = @(u) u;

drawArrow = @(x,y) quiver(x(1), y(1), x(2)-x(1), y(2)-y(1), 'AutoScale', 'off', 'Color', 'k');

u_0 = 0.5;

r = 1.1;

u = u_0;

mesh = linspace(0, u_0 + 1, 1000);
f = 0;

plot(mesh, fun(mesh, r), 'b'); hold on;
plot(mesh, biss(mesh), 'r');
for i = 1 : 100
    new_f = fun(u, r);
    drawArrow([u, u], [f, new_f]);
    drawArrow([u, new_f], [new_f, new_f]);
    u = new_f;
    f = new_f;
end
hold off;
axis([0 u_0 + 0.5 0 u_0 + 1]);
legend('f(u,r)', 'bisector');