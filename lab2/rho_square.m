function [val, point] = rho_square(x, O, a)
    val = dot(x, O) + abs(a/2 * x(1)) + abs(a/2 * x(2));
    if (x(1) > 0 && x(2) >= 0)
        point (1) = a/2;
        point (2) = a/2;
    elseif (x(1) <= 0 && x(2) > 0)
        point(1) = -a/2;
        point(2) = a/2;
    elseif (x(1) < 0 && x(2) <= 0)
        point(1) = -a/2;
        point(2) = -a/2;
    elseif (x(1) >= 0 && x(2) < 0)
        point(1) = a/2;
        point(2) = -a/2;
    end
    point = point + O;
end


