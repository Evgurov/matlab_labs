function drawSets(x0, x1, r1, ConfMatrix, p)

N = 50;
eps = 1e-6;

% Square(1, 1) = x1(1) + r1/2;
% Square(2, 1) = x1(2) + r1/2;
% Square(1, 2) = x1(1) - r1/2;
% Square(2, 2) = x1(2) + r1/2;
% Square(1, 3) = x1(1) - r1/2;
% Square(2, 3) = x1(2) - r1/2;
% Square(1, 4) = x1(1) + r1/2;
% Square(2, 4) = x1(2) - r1/2;

PBall(1, N) = 0;
PBall(2, N) = 0;
for i = 1 : N
    x(1) = cos(i * 2*pi/N);
    x(2) = sin(i * 2*pi/N);
    while (norm(x, p) < 1)
        x = x * (1 + eps);
    end
    x = x * r1/2;
    x = x + x1;
    PBall(:, i) = x;
end

Ellips(1, N) = 0;
Ellips(2, N) = 0;
for i = 1 : N
    Ellips(1, i) = cos(i * 2*pi/N);
    Ellips(2, i) = sin(i * 2*pi/N);
end

for i = 1 : N
    x = Ellips(:,i);
    x = ConfMatrix * x;
    Ellips(:, i) = x;
end

minIndPBall = 1;
for i = 2 : N
    if PBall(2,i) < PBall(2,minIndPBall)
        minIndPBall = i;
    else
        if PBall(2,i) == PBall(2,minIndPBall)
            if PBall(1,i) < PBall(1,minIndPBall)
                minIndPBall = i;
            end
        end
    end
end

minIndEllips = 1;
for i = 2 : N
    if Ellips(2,i) < Ellips(2,minIndEllips)
        minIndEllips = i;
    else
        if Ellips(2,i) == Ellips(2,minIndEllips)
            if Ellips(1,i) < Ellips(1,minIndEllips)
                minIndEllips = i;
            end
        end
    end
end


% minIndSquare = 3;

% Square = circshift(Square, -minIndSquare + 1, 2);

PBall = circshift(PBall, -minIndPBall + 1, 2);
Ellips = circshift(Ellips, -minIndEllips + 1, 2);

% Square(1, 5) = Square(1,1);
% Square(2, 5) = Square(2,1);

PBall(1, N+1) = PBall(1,1);
PBall(2, N+1) = PBall(2,1);
Ellips(1, N+1) = Ellips(1,1);
Ellips(2, N+1) = Ellips(2,1);

% plot (Square(1,:), Square(2,:));
% hold on;
% plot(Ellips(1,:), Ellips(2,:));

% Sum(1, 1) = Square(1, 1) + Ellips(1, 1);
% Sum(2, 1) = Square(2, 1) + Ellips(2, 1);

Sum(1, 1) = PBall(1, 1) + Ellips(1, 1);
Sum(2, 1) = PBall(2, 1) + Ellips(2, 1);
Sum(1, 2 * N + 1) = Sum(1,1);
Sum(2, 2 * N + 1) = Sum(2,1);

m = 2;
n = 2;
for i = 2 : 2 * N + 1
    if m <= size(PBall,2)
        edge1 = PBall(:, m) - PBall(:, m-1);
        angle1 = getAngle(edge1);
    else
        angle1  = 2 * pi;
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

plot(x0(1), x0(2), 'o');
hold on;
plot(Sum(1,:), Sum(2,:));
hold off;
axis equal;

function angle = getAngle(vect)
%     if (abs(vect(1)) < 1e-5 && vect(2) > 0) 
%         angle = pi/2;
%     else
%         if (abs(vect(1)) < 1e-5 && vect(2) < 0)
%             angle = 3 * pi / 2;
%         else
%             if (abs(vect(2)) < 1e-5 && vect(1) > 0)
%                 angle = 0;
%             else
%                 if (abs(vect(2)) < 1e-5 && vect(1) < 0)
%                     angle = pi;
%                 else
                    tan = vect(2)/vect(1);
                    angle = atan(tan);
                    if vect(1) < 0
                        angle = angle + pi;
                    else
                        if vect(2) < 0
                            angle = angle + 2*pi;
                        end
                    end
%                 end
%             end
%         end
%     end
end

end

