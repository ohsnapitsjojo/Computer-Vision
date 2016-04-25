function [Fx,Fy] = sobel_xy(Image)
% In dieser Funktion soll das Sobel-Filter implementiert werden, welches
% ein Graustufenbild einliest und den Bildgradienten in x- sowie in
% y-Richtung zurückgibt.

    % Falls das Bild kein Graustufenbild ist, so wird die Funktion
    % unterbrochen
    if size(Image,3) ~= 1
        error('The input image is not a gray-scaled image. Please use a gray-scaled image in order to use this method.')
        return
    end
    
    % Matrizen des Sobel-Filter
    sx = [1, 0, -1;
          2, 0, -2;
          1, 0, -1];
    sy = [1, 2, 1;
          0, 0, 0;
          -1, -2, -1];
    
    % Randbehandlung erfolgt mittels Spiegelung des Bilder am Rand
    Image = padarray(Image,[1 1],'circular'); 
          
    % Sobel-Filterung durch Faltung
    Fx = uint8(conv2(double(sx), double(Image),'full'));
    Fy = uint8(conv2(double(sy), double(Image),'full'));
    
    % Resizen, da die Spiegelung ebenfalls gefiltert wurde und nun
    % abgeschnitten werden muss
    Fx = Fx(3:end-2, 3:end-2);
    Fy = Fy(3:end-2, 3:end-2);
end

