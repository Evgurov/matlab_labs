function [val, point] = rho_rhombus(x, O, d)
    val = dot(x,O) + d/2*max(abs(x(1)), abs(x(2)));
    if (abs(x(2)) > abs(x(1)) && x(2) > 0)
        point(1) = 0;
        point(2) = d/2;
    elseif (abs(x(1)) >= abs(x(2)) && x(1) < 0)
        point(1) = -d/2;
        point(2) = 0;
    elseif (abs(x(2)) > abs(x(1)) && x(2) < 0)
        point(1) = 0;
        point(2) = -d/2;
    elseif (abs(x(1)) >= abs(x(2)) && x(1) > 0)
        point(1) = d/2;
        point(2) = 0;
    end
    point = point + O;
end

