clc;clear;

fun = @(u_1, u_2, r) r .* u_1 .* exp(-r/2 * u_2 .* u_2);

u_0 = [1.5, 1.5];

r_min = 0;
r_max = 7;

mesh = linspace(r_min, r_max, 1000);

for j = 1 : length(mesh)
    r = mesh(j);
    u = u_0;
    for i = 1 : 100
        new_f = fun(u(1), u(2), r);
        u(2) = u(1);
        u(1) = new_f;
    end
    for i = 1 :50
        new_f = fun(u(1), u(2), r);
        u(2) = u(1);
        u(1) = new_f;
        plot(r, u(1), '.', 'color', 'b', 'markersize', 1); hold on;
    end
end
hold off;
axis([0 r_max 0 1.8]);