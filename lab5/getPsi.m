function psi = getPsi(t, t0, A, psi_0)
    psi = zeros(2, size(t,1));
    for i = 1 : size(t,1)
        psi(:,i) = expm(-(t(i) - t0) * A') * psi_0';
    end
end