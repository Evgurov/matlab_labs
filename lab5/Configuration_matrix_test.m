clc; clear;
r1 = 5;
x1 = [10 4];
ConfMatrix = [2 1; 1 2];
N = 100;

Square(1, 1) = x1(1) + r1/2;
Square(2, 1) = x1(2) + r1/2;
Square(1, 2) = x1(1) - r1/2;
Square(2, 2) = x1(2) + r1/2;
Square(1, 3) = x1(1) - r1/2;
Square(2, 3) = x1(2) - r1/2;
Square(1, 4) = x1(1) + r1/2;
Square(2, 4) = x1(2) - r1/2;


Ellips(1, N) = 0;
Ellips(2, N) = 0;
for i = 1 : N
    Ellips(1, i) = cos(i * 2*pi/N);
    Ellips(2, i) = sin(i * 2*pi/N);
end

for i = 1 : N
    x(1) = Ellips(1, i);
    x(2) = Ellips(2, i); 
    x = x * ConfMatrix;
    Ellips(1, i) = x(1);
    Ellips(2, i) = x(2);
end

minIndEllips = 1;
for i = 2 : N
    if Ellips(2,i) < Ellips(2,minIndEllips) - 1e-5
        minIndEllips = i;
    else
        if Ellips(2,i) == Ellips(2,minIndEllips)
            if Ellips(1,i) < Ellips(1,minIndEllips)
                minIndEllips = i;
            end
        end
    end
end

minIndSquare = 3;

Square = circshift(Square, -minIndSquare + 1, 2);
Ellips = circshift(Ellips, -minIndEllips + 1, 2);

Square(1, 5) = Square(1,1);
Square(2, 5) = Square(2,1);
Ellips(1, N+1) = Ellips(1,1);
Ellips(2, N+1) = Ellips(2,1);

plot (Square(1,:), Square(2,:));
hold on;
plot(Ellips(1,:), Ellips(2,:));

Sum(1, 1) = Square(1, 1) + Ellips(1, 1);
Sum(2, 1) = Square(2, 1) + Ellips(2, 1);
Sum(1,N+5) = Sum(1,1);
Sum(2,N+5) = Sum(2,1);

m = 2;
n = 2;
for i = 2 : N+5
    if m <= size(Square,2)
        edge1 = Square(:, m) - Square(:, m-1);
        angle1 = getAngle(edge1);
    else 
        angle1  = 2*pi;
    end
    if n <= size(Ellips, 2)
        edge2 = Ellips(:, n) - Ellips(:, n-1);
        angle2 = getAngle(edge2);
    else 
        angle2 = 2 * pi;
    end
    if angle1 < angle2
        Sum(:,i) = Sum(:,i-1) + edge1;
        m = m + 1;
    else 
        Sum(:,i) = Sum(:,i-1) + edge2;
        n = n + 1;
    end
end

plot(Sum(1,:), Sum(2,:));
hold off;
axis equal;

function angle = getAngle(vect)
    if (abs(vect(1)) < 1e-5 && vect(2) > 0) 
        angle = pi/2;
    else
        if (abs(vect(1)) < 1e-5 && vect(2) < 0)
            angle = 3 * pi / 2;
        else
            if (abs(vect(2)) < 1e-5 && vect(1) > 0)
                angle = 0;
            else
                if (abs(vect(2)) < 1e-5 && vect(1) < 0)
                    angle = pi;
                else
                    tan = vect(2)/vect(1);
                    angle = atan(tan);
                    if vect(1) < 0
                        angle = angle + pi;
                    else
                        if vect(2) < 0
                            angle = angle + 2*pi;
                        end
                    end
                end
            end
        end
    end
end
    