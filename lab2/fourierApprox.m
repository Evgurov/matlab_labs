function fourierApprox(f, a, b, n, meth)
    x = linspace(a, b, 1000);
    ps = zeros(size(x));
    switch (meth)
        case 'trig'
            grid = linspace(-pi, pi, 1000);
            c = zeros(1,2*n - 1);
            for k = 1 : (2*n - 1)
                gk = getFunc(k, meth);
                c(k) = 1/pi * trapz(grid, f(grid).*gk(grid));
%                c(k) = 1/pi * integral(@(x) f(x).*gk(x), -pi, pi);
            end
            c(1) = c(1)/2;
            for j = 1 : 2 : (2*n - 1)
                for i = 1 : j
                    gi = getFunc(i, meth);
                    ps = ps + c(i) * gi(x);
                end
                plot (x, ps, x, f(x));
                axis([a, b, -2, 2]);
                legend('partial sum of trigonometric Fourier series', 'approximated finction');
                title(['n = ', num2str((j+1)/2)]);
                pause(0.1);
                ps = zeros(size(x));
            end
        case 'cheb'
            c = zeros(1,n);
            for k = 1 : n
                gk = getFunc(k, meth);
                c(k) = 2/pi * integral(@(x) f(x).*gk(x)./sqrt(ones(size(x)) - x.^2), -1, 1);
            end
            c(1) = c(1)/2;
            for j = 1 : n
                for i = 1 : j
                    gi = getFunc(i, meth);
                    ps = ps + c(i) * gi(x);
                end
                plot (x, ps, x, f(x));
                axis([a, b, -2, 2]);
                legend('partial sum of Chebyshev Fourier series', 'approximated finction');
                title(['n = ', num2str(j)]);
                pause(0.1);
                ps = zeros(size(x));
            end
        case 'lag'
            c = zeros(1,n);
            for k = 1 : n
                gk = getFunc(k, meth);
                c(k) = integral(@(x) f(x).*gk(x).*exp(-x), 0, inf);
            end
            for j = 1 : n
                for i = 1 : j
                    gi = getFunc(i, meth);
                    ps = ps + c(i) * gi(x);
                end
                plot (x, ps, x, f(x));
                axis([a, b, -2, 2]);
                legend('partial sum of Laguerre Fourier series', 'approximated finction');
                title(['n = ', num2str(j)]);
                pause(0.1);
                ps = zeros(size(x));
           end
    end
end

