function viewPossible(points, V, L)
    x = linspace(-10,10,100);
    y = linspace(-10,10,100);
    [X, Y] = meshgrid(x,y);
    N = size(points, 1);
    Z = zeros(size(X));
    for i = 1:N
        station_coord = points(i, :);
        Zi = ones(size(Y)) .* V ./ (1 + sqrt((X - station_coord(1)).^2 + (Y - station_coord(2)).^2));
        Z = Z + Zi;
    end
    M = contourf(X, Y, Z, [L, L],'b');
    hold on;
    plot(points(:, 1), points(:, 2), 'p', 'MarkerFaceColor', 'red', 'MarkerSize', 10);
    hold off;
    if size(M, 2) == M(2, 1) + 1
        disp('the area is simply-connected');
    else 
        disp('the area is not simply-connected');
    end
end