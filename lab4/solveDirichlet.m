function solution =  solveDirichlet(fHandle,xiHandle,etaHandle,mu,N,M)
    dx = 1/N;
    dy = 1/M;
    
    x_grid = linspace(0,1-dx,N);
    y_grid = linspace(0,1-dy,M);
    
    %creating matrix of f_i,j with first line and column filled with zeroes
    [X,Y] =  meshgrid(y_grid,x_grid);
    f = fHandle(X,Y);
    for k = 1 : N
        f(k,1)=0;
    end
    for l = 1 : M
        f(1,l)=0;
    end

    xi = zeros(1,M);
    for q = 1 : M
        xi(q) = xiHandle(y_grid(q));
    end
    
    eta = zeros(1,N);
    for q = 1 : N
        eta(q) = etaHandle(x_grid(q));
    end
    
    %vectors of coefficients of FT for Xi and Eta functions
    alpha = ifft(xi);
    beta = ifft(eta);
    
    %matrix with c_p,q coefficients
    C = zeros(N,M);
    for p = 1 : N
        for q = 1 : M
            C(p,q) = -4*(sin(pi * (p - 1)/N))^2/(dx^2) - 4*(sin(pi*(q - 1)/M))^2 / (dy^2) - mu;
        end
    end
    
    %matrix which is the 2D IFT for f(matrix with f_i,j coefficients from 1 to N and from 1 to M) 
    Dmat = ifft2(f);
    
    %system to find f_0,j , f_i,0 and f_0,0 coefficients
    system_matrix = zeros(N + M - 1, N + M - 1);
    
    %alpha(beta) - D_alpha(D_beta)
    system_vector = zeros(1, N + M - 1);
    
    %p-th line of system
    for p = 1 : N
        D = 0;
        for q = 1 : M
            D = D + (1/C(p,q)) * Dmat(p,q);
        end
        system_vector(p) = beta(p) - D; 
        
        inv_c_vec = zeros(1, M);
        for i = 1 : M
            inv_c_vec(i) = 1 / C(p, i);
        end
        
        %coefficient standing by f_0,0
        system_matrix(p, 1) = sum(inv_c_vec) / (M*N);
        
        %coefficient standing by f_0,j
        A = ifft(inv_c_vec)/N;
        for l = 2 : M
            system_matrix(p, l) = A(l);
        end
        
        %coefficient standing by f_i,0
        for k = 2 : N
            system_matrix(p, k + M - 1) = (sum(inv_c_vec) / (M*N)) * exp((2 * pi * 1j * (k - 1) *(p - 1))/N);
        end
    end

    %(q + N - 1)-th line of system
    for q = 2 : M
        D = 0;
        for p = 1 : N
            D = D + (1/C(p,q)) * Dmat(p,q);
        end
        system_vector(q + N - 1) = alpha(q) - D; 
        
        inv_c_vec = zeros(1,N);
        for i = 1 : N
            inv_c_vec(i) = 1/C(i,q);
        end
        
        %coefficient standing by f_0,0
        system_matrix(q + N - 1, 1) = sum(inv_c_vec) / (M*N);
        
        %coefficient standing by f_0,j
        for l = 2 : M
            system_matrix(q + N - 1, l) = (sum(inv_c_vec) / (M*N)) * exp(( 2 * pi * 1j * (l - 1) * (q - 1))/M);
        end
        
        B = ifft(inv_c_vec)/M;
        
        %coefficient standing by f_i,0
        for k = 2 : N
            system_matrix(q + N - 1, M + k - 1)=B(k);
        end
    end
    
    %solve linear system
    f_NM = bicg(system_matrix, system_vector', 1e-7, 1000);
    
    %fill 1-st line and first column with founded coefficients
    for l = 1 : M 
        f(1, l) = f_NM(l);
    end
    for k = 2 : N
        f(k, 1) = f_NM(M + k - 1);
    end
    
    %now we finally can find b_pq and a_pq
    b_pq = ifft2(f);
    a_pq = b_pq./C;
    solution = real(fft2 (a_pq));
end

