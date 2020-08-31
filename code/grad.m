function G = grad(f,std1)
    
    
    std2 = std1.^2;
    w = (2*ceil(2* std1))+1;
    [x,y] = meshgrid(-w:w);
    gx = -(x./(2*pi*std2.^2)).*exp(-(x.^2 + y.^2)./(2*std2));
    gy = -(y./(2*pi*std2.^2)).*exp(-(x.^2 + y.^2)./(2*std2));
    
    dx1 = imfilter(f, gx, 'replicate','conv','same');%[1, 0, -1]);
    dx2 = imfilter(f, gy, 'replicate','conv','same');%[1; 0; -1]);
    G = sqrt(dx1.^2 + dx2.^2);

end