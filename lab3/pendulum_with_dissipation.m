clear;clc;
l = 9.81;
a = 0.1;
t0 = 10;
F = figure;
A = axes(F);
options = odeset('Events', @zero_reached);
[t,x] = ode45(@(t,x) pendulum(t, x, a), [0 t0], [2 0], options);
y = l * ones(size(x,1),1) - sqrt((l * ones(size(x,1), 1)).^2 - (x(:,1)).^2);
P = plot(A, x(1,1), y(1), 'ob');
for i = 2:length(t)
    P.XData = x(i,1);
    P.YData = y(i);
    axis ([-5,5,-1,5])
    pause(0.06);
end

while isvalid(F)
    [t,x] = ode45(@(t,x) pendulum(t, x, a),[0 t0], [0 -x(i,2)], options);
    y = l * ones(size(x,1),1) - sqrt((l * ones(size(x,1), 1)).^2 - (x(:,1)).^2);
    for i = 1:length(t)
        P.XData = x(i,1);
        P.YData = y(i);
        axis ([-5,5,-1,5])
        pause(0.06);
    end
end

function dxdt = pendulum(t, x, a)
    dxdt = zeros(2,1);
    dxdt(1) = x(2);
    dxdt(2) = -sin(x(1)) - a*x(2);
end

function [value, isterminal, direction] = zero_reached(t, x)
    value = x(1);
    isterminal = 1;   
    direction = 0;   
end