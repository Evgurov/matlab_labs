%%
clc;clear;
f1 = @(x) sin(ones(size(x)) - x).*x;
f2 = @(x) sin(x.^2)./x;
x = linspace(0, 5, 1000);
%%
y = f1(x);
plot (x, y);
hold on;
[global_max, glob_max_ind] = max(y);
plot(x(glob_max_ind),  global_max, '*');
minMask = islocalmin(y);
plot(x(minMask), y(minMask), '*');
closest_min_ind = 0;
i = glob_max_ind;
dist = size(x,2);
while i < size(x,2)
    if (minMask(i) == 1)
        closest_min_ind = i;
        dist = i - glob_max_ind;
        i = size(x,2);
    else 
        i = i + 1;
    end
end
i = glob_max_ind;
while i > 0
    if (minMask(i) == 1)
        if ((glob_max_ind - i) < dist)
            closest_min_ind = i;
            i = 0;
        else
            i = 0;
        end
    else
        i = i - 1;
    end
end
if (closest_min_ind < glob_max_ind)
    comet(fliplr(x(closest_min_ind : glob_max_ind)), fliplr(y(closest_min_ind : glob_max_ind)));
else
    comet(x(glob_max_ind : closest_min_ind), y(glob_max_ind : closest_min_ind));
end
hold off;