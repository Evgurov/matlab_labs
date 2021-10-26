clear; clc;

t1 = 0;
t2 = 3.3;
N = 4;
alpha = 1;

reachsetdyn(t1, t2, N, alpha, '');

function [X, Y, Sx, Sy] = reachset(T, alpha, whole)
    [X, Y, Sx1, Sy1, NewSx1, NewSy1, switches1] = createSide(1, alpha, 1e-8, 1e-8, T);
    if (whole == 1)
        [X2, Y2, Sx2, Sy2, NewSx2, NewSy2, switches2] = createSide(-1, alpha, 1e-8, 1e-8, T);
        X = cat(2, X, X2);
        Y = cat(2, Y, Y2);
        X(end + 1) = X(1);
        Y(end + 1) = Y(1);
        if switches2 
            Sx1 = cat(1, Sx1, NewSx2');
            Sy1 = cat(1, Sy1, NewSy2');
        end
        if switches1
            Sx2 = cat(1, Sx2, NewSx1');
            Sy2 = cat(1, Sy2, NewSy1');
        end
        Sx = cat(1, flip(Sx1), Sx2);
        Sy = cat(1, flip(Sy1), Sy2);
    end
end

function [X, Y, Sx, Sy, NewSx, NewSy, additional_switches] = createSide(n, alpha, absTol, relTol, T)
    options = odeset('Events', @zeroX, 'RelTol',relTol,'AbsTol',absTol);

    NewSx = 0;
    NewSy = 0;
    
    additional_switches = 0;
    
    t0 = 0;
    x0 = [0, 0];
    f1 = @(t, x) system1(t, x, n * alpha);
    [t1, x1] = ode45(f1, [t0 T], x0, options);
    N = size(t1, 1);
    Sx = x1(:, 1);
    Sy = x1(:, 2);
    
    options = odeset('RelTol',relTol,'AbsTol',absTol, 'Events', @zeroPsi);

    i = 2;
    tau = t1(i);
    x01 = [x1(i, 1); x1(i, 2); sign(x1(i, 2)); 0];
    signum = n;
    while(tau < T)
        [t, x] = ode45(@(t, x) system2(t, x, alpha, -signum), [tau T], x01, options);
        tau = t(end);
        signum = -signum;
        x01 = [x(end,1); x(end,2); x(end,3); 0];
        if (tau < T)
            if (additional_switches == 0)
                additional_switches = 1;
                NewSx = x01(1);
                NewSy = x01(2);
            else 
                NewSx(end + 1) = x01(1);
                NewSy(end + 1) = x01(2);
            end
        end
    end
    X = x(end, 1);
    Y = x(end, 2);
    
    for i = 3 : N-1
        tau = t1(i);
        x01 = [x1(i, 1); x1(i, 2); sign(x1(i, 2)); 0];
        signum = n;
        while(tau < T)
            [t, x] = ode45(@(t, x) system2(t, x, alpha, -signum), [tau T], x01, options);
            tau = t(end);
            signum = -signum;
            x01 = [x(end,1); x(end,2); x(end,3); 0];
            if (tau < T)
                if (additional_switches == 0)
                    additional_switches = 1;
                    NewSx = x01(1);
                    NewSy = x01(2);
                else 
                    NewSx(end + 1) = x01(1);
                    NewSy(end + 1) = x01(2);  
                end
            end
        end
        X(size(X, 2) + 1) = x(end, 1);
        Y(size(Y, 2) + 1) = x(end, 2);
    end
end

function reachsetdyn(t1, t2, N, alpha, filename)
    showTrace = 0;
    showCaption = 1;
    whole = 1;
    showLegend = 1;
    
    if (showTrace == 1)
        showLegend = 0;
    end
    
    xMin = -2;
    xMax = 2;
    yMin = -2;
    yMax = 2;
    
    fig = figure();
    l1 = plot(0, 0);
    l1.Color = 'red';
    hold on;
    l2 = plot(0, 0);
    l2.Color = 'black';
    if (showLegend == 1)
        legend('the edge of feasible set', 'switch line');
    end
    h = (t2 - t1) / N;
    axis([xMin xMax yMin yMax]);
    xlabel('x_1');
    ylabel('x_2');
    if (filename ~= ' ')
        fig.Visible = 'off';
        filename = strcat(filename, '.avi');
        myVideo = VideoWriter(filename);
        myVideo.FrameRate = 10;
        open(myVideo)
        for i = 1 : N
            [X, Y, Sx, Sy] = reachset(t1 + h * i, alpha, whole);
            l1.XData = X;
            l1.YData = Y;
            l2.XData = Sx;
            l2.YData = Sy;
            if (showCaption == 1)
                t = strcat('T = ', num2str(t1 + h * i));
                title(t);
            end
            pause(0.1);
            frame = getframe(gcf);
            writeVideo(myVideo, frame);
        end
        close(myVideo);
    else
        for i = 1 : N
            [X, Y, Sx, Sy] = reachset(t1 + h * i, alpha, whole);
            pause(0.1);
            l1.XData = X;
            l1.YData = Y;
            l2.XData = Sx;
            l2.YData = Sy;
            if (showCaption == 1)
                t = strcat('T = ', num2str(t1 + h * i));
                title(t);
            end
        end
    end
end

function dxdt = system1(t, x, u)
    dxdt = zeros(2,1);
    dxdt(1) = x(2);
    dxdt(2) = u - x(2) - 5 * x(1)^5 - x(1) * sin(x(1)^3);
end

function dxdt = system2(t, x, alpha, n)
    dxdt = zeros(4,1);
    dxdt(1) = x(2);
    dxdt(2) = n * alpha - x(2) - 5 * x(1)^5 - x(1) * sin(x(1)^3);
    dxdt(3) = x(4)*(25*x(1)^4 + sin(x(1)^3) + 3*x(1)^3*cos(x(1)^3));
    dxdt(4) = -x(3) + x(4);
end

function [value,isterminal,direction] = zeroX(t,x)
    value = x(2);
    isterminal = 1;
    direction = 0;
end

function [value,isterminal,direction] = zeroPsi(t,x)
    value = x(4);
    isterminal = 1;
    direction = 0;
end