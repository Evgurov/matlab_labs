function compareInterp(x,xx,f)
   method = ["nearest", "linear", "spline", "pchip"];
   for i = 1:4
    vx = interp1(xx, f(xx), x, method(i));
    subplot(2, 2, i);
    plot(xx, f(xx), 'o');
    hold on
    plot(x, vx, 'r:.');
    plot(x, f(x), '.');
    hold off
    title(method(i) + ' interpolation');
    legend('sample points', 'interpolated values', 'real values');
   end
end