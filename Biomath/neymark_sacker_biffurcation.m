clc;clear;

fun = @(u_1, u_2, r) r .* u_1 .* exp(-r/2 * u_2 .* u_2);

drawArrow = @(x,y) quiver(x(1), y(1), x(2)-x(1), y(2)-y(1), 'AutoScale', 'off', 'Color', 'k');

u_0 = [0.5; 0.5];
r = 1.6587;
u = u_0;
plot(u_0(1), u_0(2), '.', 'color', 'b'); hold on;
for i = 1:1000
    new_u(1) = fun(u(1), u(2), r);
    new_u(2) = u(1);
%    drawArrow([u(1), new_u(1)], [u(2), new_u(2)]);
    plot(new_u(1), new_u(2), '.', 'color', 'b');
    u = new_u;
end
axis('equal');
hold off;