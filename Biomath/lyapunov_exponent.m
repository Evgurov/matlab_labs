clc; clear;

fun = @(u_t, r) r .* u_t .* exp(-r/2 * u_t .* u_t); %  u_t > 0

df = @(u_t, r)  r * exp(-r/2 * u_t .* u_t) .* (ones(size(u_t)) - r * u_t .* u_t);%  u_t > 0

u_0 = 1;
r_min = 0;
r_max = 6;
r_mesh = linspace(r_min, r_max, 10000);
trajectory_size = 1000;
trajectory = zeros(trajectory_size, 1);
for i = 1 : length(r_mesh)
   r = r_mesh(i);
   trajectory(1) = df(u_0, r);
   u = u_0;
   new_u = 0;
   h = u_0;
   for j = 1 : trajectory_size - 1
       new_u = fun(u, r);
       trajectory(j+1) = df(new_u, r);
       h = h + log(abs((trajectory(j+1))));
       u = new_u;
   end
   h = h / trajectory_size;
   plot(r, h, 'marker', '.', 'markersize' , 1, 'color', 'b'); hold on;
end
plot(r_mesh, zeros(size(r_mesh)), 'color', '#EDB120');
hold off;