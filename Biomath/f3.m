clc; clear;
fun = @(u_t, r) r .* u_t .* exp(-r/2 * u_t .* u_t); %  u_t > 0

mesh = linspace(0, 2, 1000);

f_3 = @(u_t, r) fun(fun(fun(u_t, r),r),r);

r = 4.720;

plot(mesh, f_3(mesh, r)); hold on;
plot(mesh, mesh); hold off;
legend('f^3' , 'bisector');
