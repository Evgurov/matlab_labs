function drawManyBalls(alphas, colors, edges)
    numOfBalls = size(alphas, 2);    
    f = @(x, y, z, i) (abs(x).^alphas(i)+abs(y).^alphas(i)+abs(z).^alphas(i)).^(1./alphas(i));
    a = -1;
    b = 1;
    N = 20;
    [X,Y,Z] = meshgrid(linspace(a,b,N), linspace(a,b,N), linspace(a,b,N));
    for i = 1:numOfBalls
        F = f(X,Y,Z,i);
        surf = isosurface(X,Y,Z,F,1);
        if(size(surf.vertices) == 0)
            error('Empty')
        end
        p = patch(surf);
        p.FaceColor = colors(i);
        p.EdgeColor = edges(i);
    end
    daspect([1 1 1]);
    view(3);
    axis tight;
    camlight;
    lighting gouraud;
end
