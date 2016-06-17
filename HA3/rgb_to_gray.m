function [Gray_image] = rgb_to_gray(Image)
% Diese Funktion soll ein RGB-Bild in ein Graustufenbild umwandeln. Falls
% das Bild bereits in Graustufen vorliegt, soll es direkt zur�ckgegeben werden.

Image = double(Image);

% �berpr�fe, ob das Bild tats�chlich drei Kan�le hat
if(size(Image,3)~=3)
    Gray_image=Image;
    return;
end
% Umwandlung nach ITU-Formel
Gray_image = 0.299*Image(:,:,1)+0.587*Image(:,:,2)+0.114*Image(:,:,3);
Gray_image = uint8(Gray_image);

end
