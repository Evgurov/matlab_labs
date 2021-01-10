function [xmin, fmin] = Newton_min(f, grad, gessian, x_start, eps)
    area = 10;
    if length(x_start) == 2
        [X, Y] = meshgrid(linspace(x_start(1) - area, x_start(2) + area, 1000), linspace(x_start(1) - area, x_start(2) + area, 1000));
        Z = zeros(size(X));
        for i = 1:size(X, 1)
            for j = 1:size(X, 2)
                Z(i, j) = f([X(i, j), Y(i, j)]);
            end
        end
    end
%    surf(X,Y,Z);
    xi = x_start;
    xi_next = xi - inv(gessian(xi)) * grad(xi);
    if length(x_start) == 2 
        hold on;
        contour(X, Y, Z, [f(xi), f(xi)], 'b');
        plot(xi(1), xi(2), 'o', 'MarkerIndices', 1, 'MarkerEdgeColor', 'black', 'MarkerFaceColor', 'green', 'MarkerSize', 10);
    end
    while f(xi) - f(xi_next) > eps
        xi = xi_next;
        if length(x_start) == 2
            plot(xi(1), xi(2), 'o', 'MarkerIndices', 1, 'MarkerEdgeColor', 'black', 'MarkerFaceColor', 'red', 'MarkerSize', 5);
            contour(X, Y, Z, [f(xi), f(xi)], 'b');
        end
        xi_next = xi - inv(gessian(xi)) * grad(xi);
    end
    if length(x_start) == 2 
        hold off;
    end
    xmin = xi;
    fmin = f(xi);
    if length(x_start) == 2
        axis([x_start(1) - area, x_start(1) + area, x_start(2) - area, x_start(2) + area, -area, area]);
    end
end

