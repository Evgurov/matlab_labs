%%
clc;clear;
f = @(x, y, t) 4 * sin(2 * t * pi * x) .* cos(t * 2 * pi * y);
x = linspace(-1,1,100);
y = linspace(-1,1,100);
[X, Y] = meshgrid(x, y);
paramvals = linspace(-1,1,50);
%%
nFrames = size(paramvals, 2);
mov(1:nFrames) = struct('cdata', [], 'colormap', []);
for i = 1:nFrames
    Z = f(X, Y, paramvals(i));
    localmin_1 = islocalmin(Z,1);
    localmin = islocalmin(Z.*localmin_1,2);
    localmax_1 = islocalmax(Z,1);
    localmax = islocalmax(Z.*localmax_1,2);
    surf(X, Y, Z);
    axis([-1 1 -1 1 -5 5]);
    Xmin = X(localmin);
    Ymin = Y(localmin);
    Zmin = Z(localmin);
    hold on;
    plot3(Xmin, Ymin, Zmin, 'o', 'MarkerSize', 10, 'MarkerEdgeColor', 'black', 'MarkerFaceColor', 'red');
    Xmax = X(localmax);
    Ymax = Y(localmax);
    Zmax = Z(localmax);
    plot3(Xmax, Ymax, Zmax, 'o', 'MarkerSize', 10, 'MarkerEdgeColor', 'black', 'MarkerFaceColor', 'green');
    mov(i) = getframe();
    hold off;
    pause(0.1);
end
%%
movie(mov);
%%
t0 = paramvals(3);
level = 1;
Z = f(X, Y, t0);
contour(X, Y, Z, level);
%%
v = VideoWriter('filevideo1.avi');
v.FrameRate = 3;
open(v);
for i = 1 : nFrames
    writeVideo(v, mov(i));
end
close(v);
save('filevideo1.mat', 'mov');
load('filevideo1.mat', '-mat');