function integr = rectangles(X,Y)
    X = X(2:end) - X(1:end-1);
    Y = Y(1:end-1);
    integr = sum(X.*Y);
end