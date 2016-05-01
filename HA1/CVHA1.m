%  Gruppennummer:
%  Gruppenmitglieder:

%% Hausaufgabe 1
%  Einlesen und Konvertieren von Bildern sowie Bestimmung von 
%  Merkmalen mittels Harris-Detektor. 

%  F�r die letztendliche Abgabe bitte die Kommentare in den folgenden Zeilen
%  enfernen und sicherstellen, dass alle optionalen Parameter �ber den
%  entsprechenden Funktionsaufruf fun('var',value) modifiziert werden k�nnen.


%% Bild laden
    clear all;
    
    
    Image = imread('szene.jpg');
    IGray = rgb_to_gray(Image);
    [Fx, Fy] = sobel_xy(IGray);
    %imshow(Fx + Fy);
 

%% Harris-Merkmale berechnen
    tic;
    Merkmale = harris_detektor(IGray,'do_plot',true ,'tau', 9000, 'segment_length', 5, 'tile_size', [200 200], 'N',1, 'min_dist',50 );
    toc;
