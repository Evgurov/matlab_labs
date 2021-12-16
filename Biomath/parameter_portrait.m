clc; clear;
b = 1;
g1 = @(a) (a .* b - 1) .* (a .* b - 1) ./ (4 .* a .* b);

a = linspace(0, 10, 100);

hold on;
ax = gca;
ax.XAxisLocation = 'origin'; ax.YAxisLocation = 'origin'; ax.Box = "off";
ax.XLabel.Interpreter = 'latex'; ax.YLabel.Interpreter = 'latex';
ax.XLabel.String = '$\alpha$'; ax.YLabel.String = '$\gamma$';

plot(a, g1(a));
xline(1/b, 'r');

text(0.2 , 0.1, 'I', 'FontSize',16);
text(0.5 , 1, 'II', 'FontSize',16);
text(7 , 0.5, 'III', 'FontSize',16);
text(3 , 1.5, 'IV', 'FontSize',16);

legend('$\frac{(\alpha \beta - 1)^2}{4 \alpha \beta}$', '$\alpha = \frac{1}{\beta}$', 'Interpreter','latex');
hold off;