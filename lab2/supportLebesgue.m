function rho = supportLebesgue(f)
    function [c,ceq] = constr(x)
        c = f(x);
        ceq = [];
    end
    nonlcon = @constr;
    scalar_prod =@(x,l) x(1)*l(1) + x(2)*l(2);
    point = @(l) fmincon(@(x) -dot(x,l), [0 0] , [], [], [], [], [], [], nonlcon);
    rho = @(l) [scalar_prod(point(l), l), point(l)];
end

