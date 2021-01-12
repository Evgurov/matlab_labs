function [Q, R] = qr_m(M)
    Q = M;
    n = size(M, 1);
    if (n ~= size(M, 2))
        error('Input matrix must be square-sized');
    end
    for i = 1 : n
        f = zeros(1, n);
        for j = 1 : n
            f(j) = M(j, i);
        end
        g = f;
        for j = 1 : i - 1
            e = zeros(1, n);
            for k = 1 : n
                e(k) = Q(k, j);
            end
            a = dot(f, e);
            b = dot(e, e);
            g = g - e * (a / b);
        end
        g = g / sqrt(dot(g, g));
        for j = 1 : n
            Q(j, i) = g(j);
        end
    end
    R = zeros(n, n);
    for i = 1 : n
        for j = 1 : n
            for k = 1 : n
                R(i, j) = R(i, j) + Q(k, i) * M(k, j);
            end
        end
    end
end