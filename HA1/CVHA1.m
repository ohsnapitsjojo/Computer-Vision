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
    Merkmale = harris_detektor(IGray,'do_plot',false ,'tau', 8000000, 'segment_length', 5 );
    toc;
