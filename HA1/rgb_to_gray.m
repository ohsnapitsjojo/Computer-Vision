function [Gray_image] = rgb_to_gray(Image)
% Diese Funktion soll ein RGB-Bild in ein Graustufenbild umwandeln. Falls
% das Bild bereits in Graustufen vorliegt, soll es direkt zur�ckgegeben werden.

    if size(Image,3) == 1
        Gray_image = Image;
        return
    end

    red = Image(:,:,1); % Red channel
    green = Image(:,:,2); % Green channel
    blue = Image(:,:,3); % Blue channel
    
    Gray_image =  0.299*red + 0.587*green + 0.114*blue;

end
