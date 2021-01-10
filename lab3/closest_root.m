clear;clc;
f = @(x) fun(x);
abscissa = linspace(-2, 2, 10000);
ordinate = zeros(1, length(abscissa));
for i = 1:length(abscissa)
    if abscissa(i) == 0
        ordinate(i) = 0;
    else
        ordinate(i) = fzero(f, abscissa(i));
        if sign(ordinate(i)) ~= sign(abscissa(i))
            ordinate(i) = ordinate(i) * (-1);
        end
        if (ordinate(i) < 0)    
            n = -round(1 / (pi * (ordinate(i))^2));
        else 
            n = round(1 / (pi * (ordinate(i))^2));
        end
        dist = abs(ordinate(i) - abscissa(i));
        if n < 0
            while abs(-(1 / sqrt(-((n + 1) * pi))) - abscissa(i)) < dist && n ~= 0
                dist = abs(-(1 / sqrt(-((n + 1) * pi))) - abscissa(i));
                n = n + 1;
            end
            while abs(-(1 / sqrt(-((n - 1) * pi))) - abscissa(i)) < dist
                dist = abs(-(1 / sqrt(-((n - 1) * pi))) - abscissa(i));
                n = n - 1;
            end
            ordinate(i) = -(1 / sqrt(-(n * pi)));
        else
            while abs(1 / sqrt((n + 1) * pi) - abscissa(i)) < dist
                dist = abs(1 / sqrt((n + 1) * pi) - abscissa(i));
                n = n + 1;
            end
            while abs(1 / sqrt((n - 1) * pi) - abscissa(i)) < dist && n ~= 0
                dist = abs(1 / sqrt((n - 1) * pi) - abscissa(i));
                n = n - 1;
            end
            ordinate(i) = 1 / sqrt(n * pi);
        end
    end
end    
plot(abscissa, ordinate);

function val = fun(x)
    if x == 0
        val = 0;
    else
        val = sqrt(abs(x)) .* sin(1 ./ x.^2);
    end
end