clc; clear;
M = rand(3) * 5;
[Qc, Rc] = qr_c(M)
[Qm, Rm] = qr_m(M)
[Q, R] = qr(M)
%% mistake
clc; clear;
maxsize = 60;
C_mist = zeros(maxsize);
M_mist = zeros(maxsize);
MM_mist = zeros(maxsize);
Grid = linspace(1, maxsize, maxsize);
for i = 1:maxsize
    M = rand(i) * 10;
    [Qc, Rc] = qr_c(M);
    [Qm, Rm] = qr_m(M);
    [Q, R] = qr(M);
    C_mist(i) = norm(M - Qc * Rc);
    M_mist(i) = norm(M - Qm * Rm);
    MM_mist(i) = norm(M - Q * R);
end
ax1 = subplot (3,1,1);
plot(Grid, C_mist);
ax1.Title.String = 'qr(c++) function';
ax1.XLabel.String = 'size';
ax1.YLabel.String = 'mistake';

ax2 = subplot (3,1,2);
plot(Grid, M_mist);
ax2.Title.String = 'qr(m) function';
ax2.XLabel.String = 'size';
ax2.YLabel.String = 'mistake';

ax3 = subplot (3,1,3);
plot(Grid, MM_mist);
ax3.Title.String = 'qr function';
ax3.XLabel.String = 'size';
ax3.YLabel.String = 'mistake';
%% time
clc;clear;
maxsize = 100;
C_mist = zeros(maxsize);
M_mist = zeros(maxsize);
MM_mist = zeros(maxsize);
Grid = linspace(1, maxsize, maxsize);
for i = 1:maxsize
    M = rand(i) * 10;
    tic;
    [Qc, Rc] = qr_c(M);
    C_time(i) = toc;
    tic;
    [Qm, Rm] = qr_m(M);
    M_time(i) = toc;
    tic;
    [Q, R] = qr(M);
    MM_time(i) = toc;
end
ax1 = subplot (3,1,1);
plot(Grid, C_time);
ax1.Title.String = 'qr(c++) function';
ax1.XLabel.String = 'size';
ax1.YLabel.String = 'time(seconds)';

ax2 = subplot (3,1,2);
plot(Grid, M_time);
ax2.Title.String = 'qr(m) function';
ax2.XLabel.String = 'size';
ax2.YLabel.String = 'time(seconds)';

ax3 = subplot (3,1,3);
plot(Grid, MM_time);
ax3.Title.String = 'qr function';
ax3.XLabel.String = 'size';
ax3.YLabel.String = 'time(seconds)';
%% approx
clc;
degree = 2;

coefs_c = polyfit(Grid, C_time, degree);
coefs_m = polyfit(Grid, M_time, degree);
coefs_mm = polyfit(Grid, MM_time, degree);

ax1 = subplot (3,1,1);
hold on;
plot(Grid, C_time, 'b');
plot(Grid, polyval(coefs_c, Grid), 'r');
hold off;
ax1.Title.String = 'qr(c++) function';
ax1.XLabel.String = 'size';
ax1.YLabel.String = 'time(seconds)';
legend('original execution time', 'approximated execution time');

ax2 = subplot (3,1,2);
hold on;
plot(Grid, M_time, 'b');
plot(Grid, polyval(coefs_m, Grid), 'r');
hold off;
ax2.Title.String = 'qr(m) function';
ax2.XLabel.String = 'size';
ax2.YLabel.String = 'time(seconds)';
legend('original execution time', 'approximated execution time', 'Location','northwest');

ax3 = subplot (3,1,3);
hold on;
plot(Grid, MM_time, 'b');
plot(Grid, polyval(coefs_mm, Grid), 'r');
hold off;
ax3.Title.String = 'qr function';
ax3.XLabel.String = 'size';
ax3.YLabel.String = 'time(seconds)';
legend('original execution time', 'approximated execution time', 'Location','northwest');