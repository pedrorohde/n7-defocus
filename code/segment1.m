function g = segment1(f,seuils)

    g = zeros(size(f));
    for i = 1:length(seuils)
        g = g + (f > seuils(i));
    end

end