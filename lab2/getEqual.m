function getEqual(f, g, t0, t1, N)
    length = 1000;
    eps = 0.01;
    t = linspace(t0, t1, length);
    x = f(t);
    y = g(t);
    plot(x, y);    
    axis equal
    xlabel('X')
    ylabel('Y')
    uni_par = linspace(t0, t1, N);
    uni_dist_points(:, 1) = x(1 : N-1);
    uni_dist_points(N, 1) = x(length);
    uni_dist_points(1 : N-1, 2) = y(1 : N-1);
    uni_dist_points(N, 2) = y(length);
    point_nums(N) = length;
    for i = 1 : N-1
        point_nums(i) = i;
    end
    point_dists_matrix = squareform(pdist(uni_dist_points));
    for i = 1 : N-1
        point_dists_vector(i) = point_dists_matrix(i,i+1);
    end
    while ((max(point_dists_vector) - min(point_dists_vector)) > eps)
        
        [max_dist, max_ind] = max(point_dists_vector);
        if (max_ind == 1)
            eps = max_dist;
        end
        uni_dist_points(max_ind, 1) = x(point_nums(max_ind) + 1);
        uni_dist_points(max_ind, 2) = y(point_nums(max_ind) + 1);
        point_nums(max_ind) = point_nums(max_ind) + 1;
        
        point_dists_matrix = squareform(pdist(uni_dist_points));
        for i = 1 : N-1
            point_dists_vector(i) = point_dists_matrix(i,i+1);
        end
    end
    hold on;
    plot(uni_dist_points(:,1), uni_dist_points(:,2), 'o');
    plot(f(uni_par), g(uni_par), '*');
    legend('function', 'point of equal distance', 'point of equal parametrisation');
    hold off;
    
    uni_par_points(:,1) = f(uni_par);
    uni_par_points(:,2) = g(uni_par);
    
    point_par_dists_matrix = squareform(pdist(uni_par_points));
    for i = 1 : N-1
        point_par_dists_vector(i) = point_par_dists_matrix(i,i+1);
    end
    
    mean_uni_dist = sum(point_dists_vector)/size(point_dists_vector,2)
    mean_uni_par_dist = sum(point_par_dists_vector)/size(point_par_dists_vector,2)
end

