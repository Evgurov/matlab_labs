function c = my_prod(x,y)
c = 0;
for i = 1:length(x)
    c = c + x(i) * y(i);
end