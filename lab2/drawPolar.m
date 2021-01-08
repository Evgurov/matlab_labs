function drawPolar(rho)
x = linspace(-2,2,21);
y = linspace(-2,2,21);
load('funfile', 'f2');
fun(size(x,2),size(y,2)) = 0;
for i = 1 : size(x,2)
    for j = 1 : size(y,2)
        fun(i,j) = f2([x(i),y(j)]);
    end
end
contour(x,y,fun,[0 0],'b');
z(size(x,2),size(y,2)) = 0;
for i = 1 : size(x,2)
    for j = 1 : size(y,2)
        supp = rho([x(i),y(j)]);
        z(i,j) = supp(1);
    end
end
hold on
contour(x,y,z,[1 1],'r');
legend('set', 'set polar');
axis equal;
hold off;
end

