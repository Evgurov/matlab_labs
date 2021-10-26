clc;clear;
u_min = importdata('u_min.txt');
k = importdata('k.txt');
T = importdata('T.txt');
eps = importdata('eps.txt');
L = importdata('L.txt');
mist = importdata('mist.txt');

type_of_confines = input('Enter type of confines:');
iters_0 = input('Enter number of iterations for psi_0^0 = 0 case:');
iters_1 = input('Enter number of iterations for psi_0^0 < 0 case:');

relTol = importdata('relTol.txt');
absTol = importdata('absTol.txt');
opts1 = odeset('RelTol', relTol, 'AbsTol', absTol, 'Event', @(t,x)psi_creterion(t,x));
opts2 = odeset('RelTol', relTol, 'AbsTol', absTol);

tspan = [0, T];

func_val = 0;
func_val_min = 10e6; %!!!!!!!!!!!
U_min = 0;
X_min = 0;
Psi_min = 0;
T_min = 0;
aim_reached = 0;

if (type_of_confines == 1)
figure('Name','Phase space_0','NumberTitle','off');
xlabel('x1');
ylabel('x2');
draw_sets(eps, L);
hold on;
%%%%%%%%%%% psi_0^0 = 0, psi_2^0 < 0 %%%%%%%%%%%%%%%%%%%%%%%%%%%
psi_0(1) = 0;
for i = 1 : iters_0
    psi_0(2) = cos(pi + i * pi / (iters_0 + 1));
    psi_0(3) = sin(pi + i * pi / (iters_0 + 1));
    x0 = [0, -eps, psi_0(3)];
    [t,x,te] = ode45(@(t, x) odefun_0(t, x, u_min, k, psi_0) , tspan, x0, opts1);
    if isempty(te)
        if (abs(x(size(x, 1), 1) - L) < mist) && (abs(x(size(x, 1), 2)) < eps)
            aim_reached = 1;
%            plot(x(:, 1), x(:, 2), 'r');
            U = zeros(size(x,1),2);
            Psi = zeros(size(x,1),2);
            for q = 1 : size(x,1)
                U(q,1) = u_min;
                U(q,2) = get_u_2(x(q,:), k);
                Psi(q,1) = psi_0(2);
                Psi(q,2) = x(q,3);
            end
            func_val = count_fun(U);
            if func_val < func_val_min
                func_val_min = func_val;
                U_min = U;
                X_min = x;
                Psi_min = Psi;
                T_min = t;
            end
        else 
%            plot(x(:, 1), x(:, 2), 'b');
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%% psi_0 = 0, psi_2^0 = 0 %%%%%%%%%%%%%%%%%%%%%%%%%%%%
psi_0(1) = 0;
psi_0(3) = 0;
psi_0_1 = [-1, 1];
for j = 1:2
    psi_0(2) = psi_0_1(j);
    for i = 1 : (iters_0 + 1)
        x0 = [0, -eps + (i - 1) * (2 * eps / iters_0), psi_0(3)];
        [t,x,te] = ode45(@(t, x) odefun_0(t, x, u_min, k, psi_0) , tspan, x0, opts1);
        if isempty(te) || te
            if (abs(x(size(x, 1), 1) - L) < mist) && (abs(x(size(x, 1), 2)) < eps)
                aim_reached = 1;
%                plot(x(:, 1), x(:, 2), 'r');
                U = zeros(size(x,1),2);
                Psi = zeros(size(x,1),2);
                for q = 1 : size(x,1)
                    U(q,1) = u_min;
                    U(q,2) = get_u_2(x(q,:), k);
                    Psi(q,1) = psi_0(1);
                    Psi(q,2) = x(q,3);
                end
                func_val = count_fun(U);
                if func_val < func_val_min
                    func_val_min = func_val;
                    U_min = U;
                    X_min = x;
                    Psi_min = Psi;
                    T_min = t;
                end
            else 
%                plot(x(:, 1), x(:, 2), 'b');
            end
        end
    end
end
hold off;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure('Name','Phase space_1','NumberTitle','off');
xlabel('x1');
ylabel('x2');
draw_sets(eps, L);
hold on;
%%%%%%%%%% psi_0^0 < 0, psi_2^0 > 0 %%%%%%%%%%%%%%%%%%%%%%%%%
for j = 1 : iters_1
    psi_0(1) = sin(-j * (pi/2) / iters_1);
    for i = 1 : iters_1
        psi_0(2) = cos(i * pi / (iters_1 + 1));
        psi_0(3) = sin(i * pi / (iters_1 + 1));
        x0 = [0, eps, psi_0(3)];
        [t,x,te] = ode45(@(t, x) odefun(t, x, u_min, k, psi_0, type_of_confines) , tspan, x0, opts2);
        if (abs(x(size(x, 1), 1) - L) < mist) && (abs(x(size(x, 1), 2)) < eps)
            aim_reached = 1;
%            plot(x(:, 1), x(:, 2), 'r');
            U = zeros(size(x,1),2);
            Psi = zeros(size(x,1),2);
            for q = 1 : size(x,1)
                U(q,1) = get_u_1(x(q,:), u_min, psi_0, type_of_confines);
                U(q,2) = get_u_2(x(q,:), k);
                Psi(q,1) = psi_0(1);
                Psi(q,2) = x(q,3);
            end
            func_val = count_fun(U);
            if func_val < func_val_min
                func_val_min = func_val;
                U_min = U;
                X_min = x;
                Psi_min = Psi;
                T_min = t;
            end
        else
            if (x(size(x,1),1) < L)
%                plot(x(:, 1), x(:, 2), 'b');
            end
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%% psi_0^0 < 0, psi_2^0 < 0 %%%%%%%%%%%%%%%%%%%%%%%%%
for j = 1 : iters_1
    psi_0(1) = sin(-j * (pi/2) / iters_1);
    for i = 1 : iters_1
        psi_0(2) = cos(pi + i * pi / (iters_1 + 1));
        psi_0(3) = sin(pi + i * pi / (iters_1 + 1));
        x0 = [0, -eps, psi_0(3)];
        [t,x,te] = ode45(@(t, x) odefun(t, x, u_min, k, psi_0, type_of_confines) , tspan, x0, opts2);
        if (abs(x(size(x, 1), 1) - L) < mist) && (abs(x(size(x, 1), 2)) < eps)
            aim_reached = 1;
%            plot(x(:, 1), x(:, 2), 'r');
            U = zeros(size(x,1),2);
            Psi = zeros(size(x,1),2);
            for q = 1 : size(x,1)
                U(q,1) = get_u_1(x(q,:), u_min, psi_0, type_of_confines);
                U(q,2) = get_u_2(x(q,:), k);
                Psi(q,1) = psi_0(2);
                Psi(q,2) = x(q,3);
            end
            func_val = count_fun(U);
            if func_val < func_val_min
                func_val_min = func_val;
                U_min = U;
                X_min = x;
                Psi_min = Psi;
                T_min = t;
            end
        else
            if (x(size(x,1),1) < L)
%                plot(x(:, 1), x(:, 2), 'b');
            end
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%% psi_0^0 < 0, psi_2^0 = 0 %%%%%%%%%%%%%%%%%%%%%%%%%
psi_0(3) = 0;
for i = 1 : iters_1
    psi_0(2) = cos(pi + i * pi / (iters_1 + 1));
    psi_0(1) = sin(pi + i * pi / (iters_1 + 1));
    for j = 1 : (iters_0 + 1)
        x0 = [0, -eps + (j - 1) * (2 * eps / iters_0), psi_0(3)];
        [t,x,te] = ode45(@(t, x) odefun(t, x, u_min, k, psi_0, type_of_confines) , tspan, x0, opts2);
        if (abs(x(size(x, 1), 1) - L) < mist) && (abs(x(size(x, 1), 2)) < eps)
            aim_reached = 1;
%            plot(x(:, 1), x(:, 2), 'r');
            U = zeros(size(x,1),2);
            Psi = zeros(size(x,1),2);
            for q = 1 : size(x,1)
                U(q,1) = get_u_1(x(q,:), u_min, psi_0, type_of_confines);
                U(q,2) = get_u_2(x(q,:), k);
                Psi(q,1) = psi_0(2);
                Psi(q,2) = x(q,3);
            end
            func_val = count_fun(U);
            if func_val < func_val_min
                func_val_min = func_val;
                U_min = U;
                X_min = x;
                Psi_min = Psi;
                T_min = t;
            end
        else 
            if (x(size(x,1),1) < L)
%                plot(x(:, 1), x(:, 2), 'b');
            end
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if (aim_reached)
    plot(X_min(:,1), X_min(:,2), 'b');
    hold off;
    
    figure('Name','U(t)','NumberTitle','off');
    plot (T_min, U_min(:,1));
    hold on;
    plot(T_min, U_min(:,2));
    legend('u1(t)', 'u2(t)');
    
    figure('Name','Psi(t)','NumberTitle','off');
    plot (T_min, Psi_min(:,1));
    hold on;
    plot(T_min, Psi_min(:,2));
    legend('psi1(t)', 'psi2(t)');
    
    figure('Name','X(t)','NumberTitle','off');
    plot (T_min, X_min(:,1));
    hold on;
    plot(T_min, X_min(:,2));
    legend('x1(t)', 'x2(t)');
end

function dxdt = odefun_0(t, x, u_min, k, psi_0)
    u_2 = get_u_2(x, k);
    dxdt = zeros(3,1);
    dxdt(1) = x(2);
    dxdt(2) = u_min - x(2)*(1 + u_2);
    dxdt(3) = x(3) * (1 + u_2) - psi_0(2);
end

function dxdt = odefun(t, x, u_min, k, psi_0, type_of_confines)
    u_1 = get_u_1(x, u_min, psi_0, type_of_confines);
    u_2 = get_u_2(x, k);
    dxdt = zeros(3,1);
    dxdt(1) = x(2);
    dxdt(2) = u_1 - x(2)*(1 + u_2);
    dxdt(3) = x(3) * (1 + u_2) - psi_0(2);
end

function u_1 = get_u_1(x, u_min, psi_0, type_of_confines)
    switch type_of_confines
        case 1
            if (-x(3) / (2 * psi_0(1))) < u_min
                u_1 = u_min;
            else 
                u_1 = -x(3) / (2 * psi_0(1));
            end
        case 2
            u_1 = -x(3) / (2 * psi_0(1));
    end
end

function u_2 = get_u_2(x, k)
    if (x(2) * x(3) > 0)
        u_2 = -k;
    else
        if (x(2) * x(3) < 0)
            u_2 = k;
        else
            u_2 = 0;
        end
    end
end

function fun_val = count_fun(U)
    fun_val = trapz(U(:, 1));
end

function [value,isterminal,direction] = psi_creterion(t,x)
   value = x(3) - 1e-5;
   isterminal = 1;
   direction = 0;
end

function draw_sets(eps, L)
    line([0 0], [-eps eps], 'Color', '#EDB120');
    line([L L], [-eps eps], 'Color', '#EDB120');
end