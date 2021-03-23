function U = getU(psi, P)
    U = zeros(size(psi));
    for i = 1 : size(psi, 2)
        val = dot(P(:, 1), psi(:, i));
        U(:, i) = P(:, 1);
        for j = 2:4
            scalprod = dot(P(:,j), psi(:, i));
            if scalprod > val
                val = scalprod;
                U(:, i) = P(:,j);
            end
        end
    end
end

