function res = plotFT(hFigure, fHandle, fFTHandle, step, inpLimVec, outLimVec)
 
    res = struct('nPoints', [], 'step', [], 'inpLimVec', inpLimVec, 'outLimVec', outLimVec);
 
    a = inpLimVec(1);
    b = inpLimVec(2);
    T = b - a;
    n = floor(T / step) + 1;
    step = T / (n - 1);
    
    offset = floor(inpLimVec(1) / step) + 1;
 
    res.nPoints = n;
    res.step = step;
 
    tVec = linspace(inpLimVec(1), inpLimVec(2), n);
 
    func = circshift(fHandle(tVec), offset);
 
    fourier = step * fft(func);
    
    new_step = (2 * pi) / T;
    
    c = outLimVec(1);
    d = outLimVec(2);
    
    new_T = new_step * (n-1);
    
    left = -new_T;
    right = new_T;
    
    counter = 2;
    while c < left || d > right
        left = left - new_T;
        right = right + new_T;
        counter = counter + 2;
    end
    
    trans_grid = left : new_step : right;
    funcTrans = [fourier(1), repmat(fourier(2:end), 1, counter)];
 
    SPlotInfo = get(hFigure,'UserData');
 
    if isempty(SPlotInfo)
        clf(hFigure);
       
        axRe = subplot(2,1,1);
        set(axRe,'XLim', outLimVec);
        axRe.Title.String = 'Real part';
        axRe.XLabel.String = 'h';
        axRe.YLabel.String = 'Re F(h)';
 
        axIm = subplot(2, 1, 2);
        set(axIm, 'XLim', res.outLimVec);
        axIm.Title.String = 'Imaginary part';
        axIm.XLabel.String = 'h';
        axIm.YLabel.String = 'Im F(h)';
 
        SPlotInfo = struct('axRe', axRe, 'axIm', axIm);
    end
 
    if ~isempty(outLimVec)
        set(SPlotInfo.axRe, 'XLim', res.outLimVec);
        set(SPlotInfo.axIm, 'XLim', res.outLimVec);
    end
 
    set(hFigure, 'UserData', SPlotInfo);
 
    hFigure.CurrentAxes = SPlotInfo.axRe;
    hFigure.CurrentAxes.NextPlot = 'replacechildren';
    plot(trans_grid, real(funcTrans), 'b');
    legend('Re F(h)');
    
 
    if ~isempty(fFTHandle)
        hFigure.CurrentAxes.NextPlot = 'add';
        plot(trans_grid, real(fFTHandle(trans_grid)), 'r');
        legend('Re F(h)', 'Re analytical FT');
    end   
 
    hFigure.CurrentAxes = SPlotInfo.axIm;
    hFigure.CurrentAxes.NextPlot = 'replacechildren';
    p1 = plot(trans_grid, imag(funcTrans),'b');
    legend('Im F(h)');
 
    if ~isempty(fFTHandle)
        hFigure.CurrentAxes.NextPlot = 'add';
        p2 = plot(trans_grid, imag(fFTHandle(trans_grid)), 'r');
        offset_1 = imag(fFTHandle(trans_grid + (2 * pi / step) * ones(size(trans_grid))));
        offset_2 = imag(fFTHandle(trans_grid - (2 * pi / step) * ones(size(trans_grid))));
        offset_3 = imag(fFTHandle(trans_grid + (4 * pi / step) * ones(size(trans_grid))));
        offset_4 = imag(fFTHandle(trans_grid - (4 * pi / step) * ones(size(trans_grid))));
        plot(trans_grid, offset_1, 'r');
        plot(trans_grid, offset_2, 'r');
        plot(trans_grid, offset_3, 'r');
        plot(trans_grid, offset_4, 'r');
        p3 = plot(trans_grid, imag(fFTHandle(trans_grid)) + offset_1 + offset_2 + offset_3 + offset_4, 'g');
        legend([p1 p2 p3], {'Im F(h)', 'Im analytical FT', 'Sum of analytical FT'});
    end   
end
