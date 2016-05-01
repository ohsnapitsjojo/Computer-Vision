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
    defaultTau = 11000;
    defaultPlot = false;
    defaultMinDist = 50;
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

    if size(tileSize) == [1 1]
        rowDist = tileSize;
        colDist = tileSize;
    elseif size(tileSize) == [1 2]
        rowDist = tileSize(1);
        colDist = tileSize(2);
    else 
        error('Please give the tile size in correct format');
    end
%% Harris Detektor

    %Reihe und Zeilen auslesen
    nRows = size(Image,1);
    nCols = size(Image,2);

    % Gradientenberechnung mithilfe des Sobelfilters
    [fx, fy ] = sobel_xy(Image);
    
    %Berechnung der Elemente, die notwendig f�r die Berechnung der Harris-Matrix sind
    fx2 = double(fx.^2);
    fy2 = double(fy.^2);
    fxy = double(fx.*fy); 
    
    % Berechnung einer Hilfsmatrix um die Harris-Matrix mithilfe von
    % Faltung zu errechnen
    f = fspecial('gaussian', segmentLength, 0.5);    
    
    % R�nder werden durch Spiegelung behandelt, hierzu muss die
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
    
    % Resizing, da die ebenfalls Harris-Matrizen f�r die Spiegelungen
    % berechnet wurden
    G11 = G11(1+mirrorRange*2:end-mirrorRange*2, 1+mirrorRange*2:end-mirrorRange*2);
    G12 = G12(1+mirrorRange*2:end-mirrorRange*2, 1+mirrorRange*2:end-mirrorRange*2);
    G22 = G22(1+mirrorRange*2:end-mirrorRange*2, 1+mirrorRange*2:end-mirrorRange*2);
    
    % Response wird berechnet
    H = (G11.*G22-G12.*G12) - k*(G11+G22).^2;

    % Kanten werden anhand der Response detektiert und ausgefiltert
    featureMatrix = H > tau;
    featureMatrix = H.*featureMatrix;
    
    % Featurevector wird nach Gr��e des Responses sortiert um anschlie�end
    % Nachbarn mit der Distanz<minDist zu entfernen
    [r,c,v] = find(featureMatrix);
    Merkmale = [r,c,v];
    Merkmale = sortrows(Merkmale,-3);
    
    [C,R] = meshgrid(1:nCols, 1:nRows);
    
    i = 1;
    
    % Nahe Nachbarn werden mithilfe einer Maske entfernt, die Maske ist ein
    % Kreis mit 1er um den gew�nschten Punkt mit r = minDist. Diese wird im
    % Anschluss negierte und mit dem AND Operator auf die Feauture Matrix
    % angewendet um die Nachbarn zu entfernen.
    % Es wird angefangen  die Nachbarn der Feature mit dem gr��ten Response
    % zu entfernen.
    while 1

        mask = sqrt((R-Merkmale(i,1)).^2 + (C-Merkmale(i,2)).^2) < minDist;
        mask(Merkmale(i,1),Merkmale(i,2)) = 0;
        
        featureMatrix = featureMatrix & ~mask;
        featureMatrix = featureMatrix.*H;
        
        [r,c,v] = find(featureMatrix);
        Merkmale = [r,c,v];
        Merkmale = sortrows(Merkmale,-3);
        
        if size(Merkmale,1) == i
            break
        end
         i = i + 1;
    end
    
    % Feature Matrix wird in Zellen unterteilt um anschlie�end nur N
    % Features in einer Zelle zu erreichen. Die schw�chsten Feature werden
    % zuerst entfernt
    
    row_vector = [rowDist*ones(1, floor(size(featureMatrix,1)/rowDist)), mod(size(featureMatrix,1), rowDist)];
    col_vector = [colDist*ones(1, floor(size(featureMatrix,2)/colDist)), mod(size(featureMatrix,2), colDist)];
    
    featureCells = mat2cell(featureMatrix, row_vector, col_vector);
    
    for i=1:size(featureCells,1)
        for j=1:size(featureCells,2)

            nFeature = length(find(featureCells{i,j}~=0));
            if nFeature>N
                nDeleteFeature = nFeature-N;
                for k=1:nDeleteFeature
                    [rs, cs] = find(featureCells{i,j} == min(featureCells{i,j}(featureCells{i,j}>0 )));
                    featureCells{i,j}(rs(1),cs(1)) = 0;
                end
            end
        end
    end
    
    featureMatrix = cell2mat(featureCells);
    
    [r,c] = find(featureMatrix);
    Merkmale = [r,c]';

    disp([num2str(length(Merkmale)),' Features found.']);
    
    % Plot
    if plot == true
        imshow(Image);
        hold on;
        scatter(Merkmale(2,:), Merkmale(1,:), 'xy');
    end
end