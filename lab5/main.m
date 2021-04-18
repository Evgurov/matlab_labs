clc;clear;

x0 = importdata('x0.txt');
x1 = importdata('x1.txt');
r1 = importdata('r1.txt');
Q = importdata('Q.txt');
A = importdata('A.txt');
B = importdata('B.txt');
P = importdata('P.txt');
p = importdata('p_norm.txt');

t0 = importdata('t0.txt');
iters = input('Enter number of iterations:');
Tmax = input('Enter maximum integration time:');
relTol = importdata('relTol.txt');
absTol = importdata('absTol.txt');
opts = odeset('RelTol', relTol, 'AbsTol', absTol, 'Events', @(t,x)aimReached(t, x, x1, r1, Q, p));

figure('Name','Phase space','NumberTitle','off');

tspan = [t0, Tmax];

drawSets(x0, x1, r1, Q, p);
hold on;
Tmin = Tmax;
for i = 1 : iters
    psi_0(1) = cos(2 * pi * i / iters);
    psi_0(2) = sin(2 * pi * i / iters);
    [t,x] = ode45(@(t, x) odefun(t, x, t0, A, B, psi_0, P) , tspan, x0, opts);
    plot(x(:, 1), x(:, 2), 'b');
    Titer = t(size(t,1));
    if Titer < Tmin
        Psi = getPsi(t, t0, A, psi_0);
        U = getU(Psi, P);
        Tmin = Titer;
        T = t;
        X = x;
    end
end

if Tmin ~= Tmax
    plot(X(:,1), X(:,2), 'r');
    hold off;
    
    figure('Name','U(t)','NumberTitle','off');
    plot (T, U(1,:));
    hold on;
    plot(T, U(2,:));
    legend('u1(t)', 'u2(t)');
    
    figure('Name','Psi(t)','NumberTitle','off');
    plot (T, Psi(1,:));
    hold on;
    plot(T, Psi(2,:));
    legend('psi1(t)', 'psi2(t)');
    
    figure('Name','X(t)','NumberTitle','off');
    plot (T, X(:,1));
    hold on;
    plot(T, X(:,2));
    legend('x1(t)', 'x2(t)');
    
    TransversalityMist = abs(fun(x1, r1, Q, p, X(size(X, 1), :), -Psi(:, size(Psi, 2))));
    
    fprintf('Optimal time is: %f \n', Tmin);
    fprintf('Mistake of transversality condition at the right end: %f \n', TransversalityMist);
    
else 
    disp('Aim set not reached');
end

hold off;

function dxdt = odefun(t, x, t0, A, B, psi_0, P)
    u = getU(getPsi(t, t0, A, psi_0), P);
    dxdt = A * x + B * u + f(t);
end

function [value,isterminal,direction] = aimReached(t, x, x1, r1, Q, p)
   value = inSet(x1, r1, Q, x, p);
   isterminal = 1;
   direction = 0;
end

function val = inSet(x1, r1, Q, x, p)
    options = optimoptions(@fminunc, 'Display', 'off');
    [x,fval,exitflag,output] = fminunc(@(y) -fun(x1, r1, Q, p, x, y), x, options);
    if exitflag ~= -3
        val = 1;
    else
        val = 0;
    end
end

function val = fun(x1, r1, Q, p, x2, x)
    val =  dot(x2, x) - dot(x1, x) - r1/2 * norm(x, p/(p - 1)) - norm(Q * x);
end