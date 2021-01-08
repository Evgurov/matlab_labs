function convergenceFunc(fn, f, a, b, n, convType)
    x = linspace(a,b,100);
    for i = 1:n
        plot(x, fn(x,i), x, f(x));
        if (convType == "uniform")
            Rfi = max(abs(fn(x,i) - f(x)));
            title(['max|f(x) - fi(x)| = ', num2str(Rfi)]);
        end
        if (convType == "mean square")
            Rfi = sqrt(trapz(x,(abs(f(x) - fn(x,i))).^2));
            title(['integr(sqrt((fn(x) - f(x))^2) = ', num2str(Rfi)]);
        end
        legend('fn(x)', 'f(x)','Location','northwest');
        axis ([0 1 -1 1]);
        pause(0.5);
    end
end

