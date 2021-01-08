function [val, point] = rho_ellips(x, O, a, b)
    val = dot(x, O) + sqrt((a * x(1))^2 + (b * x(2))^2);
    point(1) = x(1) * a^2 / sqrt((x(1))^2 * a^2 + (x(2))^2 * b^2);
    point(2) = x(2) * b^2 / sqrt((x(1))^2 * a^2 + (x(2))^2 * b^2);
    point = point + O;
end

