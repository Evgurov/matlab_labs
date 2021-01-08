function drawBall(params)
    [X, Y, Z] = meshgrid(linspace(params.a, params.b, params.N), linspace(params.a, params.b, params.N), linspace(params.a, params.b, params.N));
    F = params.f(X,Y,Z); 
    surf = isosurface(X,Y,Z,F,params.isovalue);
    obj = patch(surf); 
    if(size(surf.vertices) == 0)
        error('Empty')      
    end
    view(3);
    obj.FaceColor = params.FaceColor;
    obj.EdgeColor = params.EdgeColor;
    daspect([1 1 1]);
    axis tight;
    camlight;
    lighting gouraud;
end

