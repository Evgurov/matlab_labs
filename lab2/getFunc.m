function fn = getFunc(n, meth)
    switch(meth)
        case 'trig'
            if (n == 1)
                fn = @(x) ones(size(x));
            elseif (mod(n,2) == 0)
                fn = @(x) cos((n/2) * x);
            else 
                fn = @(x) sin((n-1)/2 * x);
            end
        case 'cheb'
            fn = @(x) cos((n-1) * acos(x));
        case 'lag'
            if (n == 1)
                fn = @(x) ones(size(x));
            elseif (n == 2)
                fn = @(x) ones(size(x)) - x;
            else 
                L1 = getFunc(n-1, 'lag');
                L2 = getFunc(n-2, 'lag');
                fn = @(x) 1/(n-1) * (((2*n - 3) * ones(size(x)) - x) .* L1(x) - (n-2) * L2(x));
            end
        otherwise
            error('no such method');
    end
end

