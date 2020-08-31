function [f_sv_blur] = SV_blur(carte_defocus,f_init,maxN)
    carte_norm = (carte_defocus-min(carte_defocus(:)))./(max(carte_defocus(:))-min(carte_defocus(:)));
    
    f_sv_blur = zeros(size(f_init));
    f_extend = zeros(size(f_init,1)+maxN-1,size(f_init,2)+maxN-1);
    f_extend(ceil(maxN/2):size(f_init,1)+floor(maxN/2), ceil(maxN/2):size(f_init,2)+floor(maxN/2)) = f_init;
    N = numel(f_init);
    for i = 1:N
        % m,n en fonction de la carte
        sigma = 1;
        
        m = round(maxN*carte_norm(N));
        m = m+1-mod(m,2);
        
        [Gx1, Gx2] = meshgrid(linspace(-1,1,m),linspace(-1,1,m));
        H = exp(-(Gx1.^2+Gx2.^2)/(2*sigma^2));
        
        [x,y] = ind2sub(size(f_init),i);
        
        patch = f_extend(x-(m-1)/2+floor(maxN/2):x+(m-1)/2+floor(maxN/2),y-(m-1)/2+floor(maxN/2):y+(m-1)/2+floor(maxN/2)).*H;
        
        f_sv_blur(i) = sum(patch(:));
        
        
    end

% f_sv_blur = (f_sv_blur-min(f_sv_blur(:)))./(max(f_sv_blur(:))-min(f_sv_blur(:)));
f_sv_blur = f_sv_blur./max(f_sv_blur(:));
end 