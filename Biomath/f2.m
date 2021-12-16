clc; clear;
fun = @(u_t, r) r .* u_t .* exp(-r/2 * u_t .* u_t); %  u_t > 0

mesh = linspace(0, 2, 1000);

f_2 = @(u_t, r) fun(fun(u_t, r), r);

r = 2.8;

plot(mesh, f_2(mesh, r)); hold on;
plot(mesh, mesh); hold off;
legend('f^2' , 'bisector');