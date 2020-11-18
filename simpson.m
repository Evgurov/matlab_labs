function integr = simpson(x,y)
    n = size(x,2);
    n = n - 1;
    if (mod(n,2) ~= 0)
        n = n - 1;
        y = y(1:end-1);
        H = x(2:end) - x(1:end-1);
    else
        H = x(2:end) - x(1:end-1);
        H(n+1) = sum(H)/size(H,2);
    end
    ylength = size(y,2);
    mask2 = ones(1, ylength);
    mask2(3:2:ylength-2) = 2;
    mask4 = ones(1, ylength);
    mask4(2:2:ylength-1) = 4;
    integr = sum(H ./ 3 .* y .* mask2 .* mask4);
end