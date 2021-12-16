clc;clear;

fig2 = figure('name', 'bifurcation diagram', 'NumberTitle','off');

fun = @(u_t, r) r .* u_t .* exp(-r/2 * u_t .* u_t); %  u_t > 0

u_0 = 1.5;

r_min = 0;
r_max = 7;

mesh = linspace(r_min, r_max, 1000);

for j = 1 : length(mesh)
    r = mesh(j);
    u = u_0;
    for i = 1 : 1000
        new_f = fun(u, r);
        u = new_f;
    end
    for i = 1 : 20
        new_f = fun(u, r);
        u = new_f;
        plot(r, u, '.', 'color', 'b', 'markersize', 1); hold on;
    end
end
hold off;
axis([0 r_max 0 1.8]);