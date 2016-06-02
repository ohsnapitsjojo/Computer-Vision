%  Gruppennummer: 15
%  Gruppenmitglieder: Johannes Truong Le, Bernhard Birkner, Tuan Duong
%  Quang, Sebastian Betz, Huaijiang Zhu

%% Hausaufgabe 1
%  Einlesen und Konvertieren von Bildern sowie Bestimmung von 
%  Merkmalen mittels Harris-Detektor. 

%  Für die letztendliche Abgabe bitte die Kommentare in den folgenden Zeilen
%  enfernen und sicherstellen, dass alle optionalen Parameter über den
%  entsprechenden Funktionsaufruf fun('var',value) modifiziert werden können.


%% Bild laden
    clear all;
    
    
    Image = imread('szene.jpg');
    IGray = rgb_to_gray(Image);
    [Fx, Fy] = sobel_xy(IGray);
 

%% Harris-Merkmale berechnen
    tic;
    Merkmale = harris_detektor(IGray,'do_plot',true ,'tau', 9500, 'segment_length', 5, 'tile_size', [200 200], 'N',10, 'min_dist',50 );
    toc;
