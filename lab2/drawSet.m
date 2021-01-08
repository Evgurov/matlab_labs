function drawSet(figure, center, a, b, N)
    inside_points(1,N+1) = 0;
    inside_points(2,N+1) = 0;
    outside_points(1,N+1) = 0;
    outside_points(2,N+1) = 0;
    flag = 0;
    for i = 1:N+1
        l(1) = cos(i * 2*pi/N);
        l(2) = sin(i * 2*pi/N);
        switch (figure)
            case 'ellips'
                [val, point] = rho_ellips(l, center, a, b);
            case 'square'
                [val, point] = rho_square(l, center, a);
            case 'rhombus'
                [val, point] = rho_rhombus(l, center, a);
        end
        inside_points(1,i) = point(1);
        inside_points(2,i) = point(2);
        
        if (abs(l(2)) < 0.00001)
            outside_points(1, i-1) = point(1);
            outside_points(2, i-1) = f1(point(1));
            flag = 1;
        else
            f2 = @(x) -l(1)/l(2) * x   + val/l(2);
            if (flag == 1)
                outside_points(1, i-1) = outside_points(1, i-2);
                outside_points(2, i-1) = f2(outside_points(1, i-2));
                flag = 0;
            else
                if (i > 1)
                    outside_points(1, i-1) = fzero(@(x)f2(x) - f1(x), center(1) - a - 5);
                    outside_points(2,i-1) = f2(outside_points(1,i-1));
                end
            end
            f1 = @(x) f2(x);
        end
    end
    outside_points(1, N+1) = outside_points(1,1);
    outside_points(2, N+1) = outside_points(2,1);
    plot(outside_points(1,:), outside_points(2,:));
    hold on;
    plot (inside_points(1,:), inside_points(2,:));
    axis equal;
end

