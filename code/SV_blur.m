% reblurring function
% reblur amount is proportional to defocus map

function [f_sv_blur] = SV_blur(carte_defocus,f_init)
    carte_norm = (carte_defocus-min(carte_defocus(:)))./(max(carte_defocus(:))-min(carte_defocus(:)));
    
    f_sv_blur = zeros(size(f_init));
    f_extend = zeros(size(f_init,1)+8,size(f_init,2)+8);
    f_extend(5:size(f_init,1)+4, 5:size(f_init,2)+4) = f_init;
    N = numel(f_init);
    for i = 1:N
        
        sigma = 2;
        
        % gaussian filter size proportional to defocus level
        m = round(9*carte_norm(N));
        m = m+1-mod(m,2);
        
        % gaussian filter
        [Gx1, Gx2] = meshgrid(linspace(-1,1,m),linspace(-1,1,m));
        H = exp(-(Gx1.^2+Gx2.^2)/(2*sigma^2));
        
        [x,y] = ind2sub(size(f_init),i);
        
        % "convolution"
        patch = f_extend(x-(m-1)/2+4:x+(m-1)/2+4,y-(m-1)/2+4:y+(m-1)/2+4).*H;
        
        f_sv_blur(i) = sum(patch(:));
        
        
    end

% output normalization
f_sv_blur = (f_sv_blur-min(f_sv_blur(:)))./(max(f_sv_blur(:))-min(f_sv_blur(:)));
end 