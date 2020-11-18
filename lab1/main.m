%% 1
a = 0;
b = 2 * pi;
n = 1000;
f = @(x) abs(x).*sin(2.*(x.^2)+1);
Net = linspace(a,b,n);
FunNet = f(Net);

hold on
plot(Net, FunNet);
xlabel("x");
ylabel("f(x)");

maxMask = islocalmax(FunNet);
minMask = islocalmin(FunNet);

plot(Net(maxMask), FunNet(maxMask), 'r*');
plot(Net(minMask), FunNet(minMask), 'g*');
%% 2
n = input('Enter n:');
if ~isprime(n)
    disp('N is not primary');
end
%2.1
X = 1:n;
X = X((mod(X,2) == 1) & (mod(X,7) == 0))
%2.2
x = ones(1,n);
y = 2:n+1;
X = y'*x
%2.3
B = 1:(n+1)*(n+1);
B = reshape(B,[n+1,n+1]);
B = B'
D = B(:,n:n+1);
c = reshape(B',[1,(n+1) * (n+1)]);
%% 3
d = 0.001;
m = 5;
Xnorm = randn(13,7) * sqrt(d) + m

diagonal = diag(Xnorm);
maxdiag = max(diagonal);
mindiag = min(diagonal);
if abs(maxdiag) < abs(mindiag)
    maxabs = mindiag
else 
    maxabs = maxdiag
end
prodOfColumns = prod(Xnorm);
sumOfColumns = sum(Xnorm);
relationVect = prodOfColumns ./ sumOfColumns;
maxRelation = max(relationVect)
SortedX = sortrows(Xnorm, 'descend')
%% 4
%4.1
n = 6;
A = zeros(2*n+1);
edgeVect = zeros(1,2*n+1);
edgeVect([1 2:2:end-1 end]) = 5;
A(1,:) = edgeVect;
A(:,1) = edgeVect';
A(end,:) = edgeVect;
A(:,end) = edgeVect';
A(n:n+2, n:n+2) = 10;
A(n+1,n+1) = -5
%4.2
A = ones(2*n+1) * 5;
A (1, 3:2:end-2) = 0;
A (2*n+1, 3:2:end-2) = 0;
A (3:2:end-2, 1) = 0;
A (3:2:end-2, 2*n+1) = 0;
A(2:end-1, 2:end-1) = 0;
A(n:n+2, n:n+2) = 10;
A(n+1, n+1) = -5
%4.3
x = ones(1,2*n+1) * 5;
x(3:2:end-2) = 0;
y = zeros(1, 2*n+1);
z = y;
z([1 2*n+1]) = 5;
w = z;
w(n:n+2) = 10;
q = w;
q(n+1) = -5;
q([1 2*n+1]) = 0;
A = x;
for i = 1:(n-2)/2
    A = cat(1,A,z);
    A = cat(1,A,y);
end
A = cat(1,A,w);
A = cat(1,A,q);
A = cat(1,A,w);
for i = 1:(n-2)/2
    A = cat (1,A,y);
    A = cat (1,A,z);
end
A = cat(1,A,x)
%% 5
n = 10;
Coord = randi(10,2,n);
A = Coord(1,:)'* Coord(2,:)- Coord(2,:)' * Coord(1,:)
%% 6
n = 3;
m = 4;
a = randi([-10, 10], 1, n)
b = randi([-10, 10], 1, m)
maxdiff = max(max(a) - min(b),max(b) - min(a))
%% 7
n = 4;
m = 5;
X = randi (2,n,m) - 1

[elems, indeces] = min(~X);
indeces
%% 8
n = 10;
k = 3;
Coord = randi(10,n,k) - 5
G = Coord * Coord';
xiMatr = repmat(diag(G), 1, n);
xjMatr = repmat(diag(G)', n, 1);
DistMatr = sqrt(xiMatr - 2*G + xjMatr)
%% 9
reps = 10000;
tics = 50;
times = zeros(1,reps);
for n = 1:reps
    x = randi(10, 1, n);
    y = randi(10, 1, n);
    tic;
    for i = 1:tics
        prod = my_prod(x,y);
    end
    elapsedTime = toc/tics;
    times(n) = elapsedTime;
end
plot(times,'b');
hold on
for n = 1:reps
    x = randi(10, 1, n);
    y = randi(10, 1, n);
    tic;
    for i = 1:tics
        prod = x*y';
    end
    elapsedTime = toc/tics;
    times(n) = elapsedTime;
end
plot(times,'g');
for n = 1:reps
    x = randi(10, 1, n);
    y = randi(10, 1, n);
    tic;
    for i = 1:tics
        prod = dot(x,y);
    end
    elapsedTime = toc/tics;
    times(n) = elapsedTime;
end
plot(times,'r');
hold off
legend('my prod', 'x*y^t', 'dot(x,y)');
%% 10
A = [1 2 3; 4 5 6; 7 8 9];
B = [1 2 3; 7 8 9; 5 6 8];
n = 3;
rowAinB = zeros(n,1);
for i = 1:n
    AinB = ismember(A,B(i,:));
    rowSumAinB = sum(AinB, 2);
    rowAinB = rowAinB + ismember(rowSumAinB, 3);
end
rowAinB
%% 11
a = 5;
d = 0.5;
n = 100;
b = 1;
x = randn(1,n) * sqrt(d) + a;
num = length(x(abs(x-a) > b));
prob = num/n
c = d/b^2
%% 12
delta = 0.01;
a = -10;
b = 10;
nint(1) = 0;
for i = 2:(b-a)/delta
    x = a:delta:a + i*delta;
    y = cos(x.^2);
    rectUint(i+1) = rectangles(x,y);
    simpUint(i+1) = simpson(x,y);
end
plot(x,rectUint, 'r');
hold on
plot(x,simpUint, 'b');
hold off
legend('rectangles antiderivative', 'simpson antiderivative');

h1 = 0.0001;
h2 = 0.1;
dh = 0.001;

H = h1:dh:h2;
for i = 1:(h2-h1)/dh + 1
    h = H(i);
    xh = a:h:b;
    xh2 = a:h/2:b;
    yh = sin(xh);
    yh2 = sin(xh2);
    deltaIntRect(i) = rectangles(xh, yh) - rectangles(xh2, yh2);
    deltaIntTrap(i) = trapz(xh, yh) - trapz(xh2, yh2);
    deltaIntSim(i) = simpson(xh, yh) - simpson(xh2, yh2);
end

plot(H, deltaIntTrap, 'b');
hold on
plot(H, deltaIntRect, 'g');
plot(H , deltaIntSim, 'r');
hold off
legend('trapezes', 'rectangles', 'simpson');

tic
intrec = rectangles(xh,yh);
toc
tic
intsim = simpson(xh,yh);
toc
%% 13
f = @(x) sin(x) .* x;
df = @(x) cos(x) .*x + sin(x);
x0 = 1;
h1 = -8;
h2 = -1;
n = 1000;

H = logspace(h1, h2, n)
rightdif =@ (h) (f(x0 + h) - f(x0)) ./ h;
centraldif =@ (h) (f(x0 + h) - f(x0 - h)) ./ (2 * h);
deltaCentr = abs(centraldif(H) - df(x0));
deltaRight = abs(rightdif(H) - df(x0));

loglog(H , deltaRight, 'b');
hold on
loglog(H, deltaCentr , 'r');
hold off
legend('right derivative', 'central derivative');