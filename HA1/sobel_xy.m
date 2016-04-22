function [Fx,Fy] = sobel_xy(Image)
% In dieser Funktion soll das Sobel-Filter implementiert werden, welches
% ein Graustufenbild einliest und den Bildgradienten in x- sowie in
% y-Richtung zur�ckgibt.

    if size(Image,3) ~= 1
        error('The input image is not a gray-scaled image. Please use a gray-scaled image in order to use this method.')
        return
    end
    
    sx = [1, 0, -1;
          2, 0, -2;
          1, 0, -1];
    sy = [1, 2, 1;
          0, 0, 0;
          -1, -2, -1];
          
    Fx = uint8(conv2(double(sx), double(Image)));
    Fy = uint8(conv2(double(sy), double(Image)));
end

