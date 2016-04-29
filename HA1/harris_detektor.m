function  [Merkmale] = harris_detektor(Image,varargin) 
% In dieser Funktion soll der Harris-Detektor implementiert werden, der
% Merkmalspunkte aus dem Bild extrahiert

    % Falls das Bild kein Graustufenbild ist, so wird die Funktion
    % unterbrochen
    if size(Image,3) ~= 1
        error('The input image is not a gray-scaled image. Please provide a gray-scaled image in order to use this method.')
        return
    end
%% Input parser
    P = inputParser;

    defaultSegmentLength = 5;
    defaultK = 0.05;
    defaultTau = 9000;
    defaultPlot = false;
    defaultMinDist = 10;
    defaultTileSize = [200 200];
    defaultN = 5;
    
    % Liste der notwendigen Parameter
    % Ein Bild als Input ist zwingend notwendig
    P.addRequired('Bild', @(x)isnumeric(x));
    % List der optionalen Parameter
    P.addOptional('segment_length', defaultSegmentLength, @(x) x > 1 && mod(x,2));
    P.addOptional('k', defaultK, @(x)isnumeric(x));
    P.addOptional('tau', defaultTau, @(x)isnumeric(x)); 
    P.addOptional('do_plot', defaultPlot, @(x)islogical(x));
    P.addOptional('min_dist', defaultMinDist, @(x)isnumeric(x)); 
    P.addOptional('tile_size', defaultTileSize, @(x)isnumeric(x)); 
    P.addOptional('N', defaultN, @(x)isnumeric(x)); 
    
    % Parsen der Eingabewerte
    P.parse(Image,varargin{:});
    
    % Laden der Werte des Input Parsers in Variablen
    Image = P.Results.Bild;
    segmentLength = P.Results.segment_length; 
    k = P.Results.k;
    tau = P.Results.tau;
    plot = P.Results.do_plot;
    minDist = P.Results.min_dist;
    tileSize = P.Results.tile_size;
    N = P.Results.N;
    
%% Harris Detektor

    %Reihe und Zeilen auslesen
    nRows = size(Image,1);
    nCols = size(Image,2);

    % Gradientenberechnung mithilfe des Sobelfilters
    [fx, fy ] = sobel_xy(Image);
    
    %Berechnung der Elemente, die notwendig für die Berechnung der Harris-Matrix sind
    fx2 = double(fx.^2);
    fy2 = double(fy.^2);
    fxy = double(fx.*fy); 
    
    % Berechnung einer Hilfsmatrix um die Harris-Matrix mithilfe von
    % Faltung zu errechnen
    f = fspecial('gaussian', segmentLength, 0.5);    
    
    % Ränder werden durch Spiegelung behandelt, hierzu muss die
    % Spiegelweite berechnet werden
    mirrorRange = (segmentLength-1)/2;
    
    % Spiegelung der Elemente am Rand
    fx2 = padarray(fx2,[mirrorRange mirrorRange],'circular'); 
    fy2 = padarray(fy2,[mirrorRange mirrorRange],'circular'); 
    fxy = padarray(fxy,[mirrorRange mirrorRange],'circular'); 
    
    % Berechnung der Elemente der Harris-Matrix
    G11 = conv2(f,fx2);
    G12 = conv2(f,fxy);
    G22 = conv2(f,fy2);
    
    % Resizing, da die ebenfalls Harris-Matrizen für die Spiegelungen
    % berechnet wurden
    G11 = G11(1+mirrorRange*2:end-mirrorRange*2, 1+mirrorRange*2:end-mirrorRange*2);
    G12 = G12(1+mirrorRange*2:end-mirrorRange*2, 1+mirrorRange*2:end-mirrorRange*2);
    G22 = G22(1+mirrorRange*2:end-mirrorRange*2, 1+mirrorRange*2:end-mirrorRange*2);
    
    % Referenzwert wird berechnet
    H = (G11.*G22-G12.*G12) - k*(G11+G22).^2;

    % Kanten werden anhand der Response detektiert und ausgefiltert
    featureMatrix = H > tau;
    featureMatrix = H.*featureMatrix;
    
    [r,c,v] = find(featureMatrix);
    Merkmale = [r,c,v];
    Merkmale = sortrows(Merkmale,-3);
    
    [R,C] = meshgrid(1:nCols, 1:nRows);
    
    
    for i=1:size(Merkmale,1)
     
        mask = sqrt((R-Merkmale(i,1)).^2 + (C-Merkmale(i,2)).^2) < minDist;
        featureMatrix = featureMatrix & mask;

        [r,c,v] = find(featureMatrix);
        Merkmale = [r,c,v];
        Merkmale = sortrows(Merkmale,-3);
        
        if size(Merkmale,1) == i
            break
        end
    end
    
    Merkmale(:,3) = [];
    Merkmale = Merkmale';
    
    % Plot
    if plot == true
        imshow(Image);
        hold on;
        scatter(Merkmale(2,:), Merkmale(1,:));
    end
end