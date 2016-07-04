function [Korrespondenzen_robust] = F_ransac(Korrespondenzen,varargin)
% Diese Funktion implementiert den RANSAC-Algorithmus zur Bestimmung von
% robusten Korrespondenzpunktpaaren

%% Input parser
P = inputParser;

% Liste der optionalen Parameter
% Wahrscheinlichkeit p, ein "gutes" Consensus-Set zu finden. Muss
% Wahrscheinlichkeit sein, also zwischen 0 und 1
P.addOptional('p', 0.999, @(x)isnumeric(x) && x > 0 && x < 1)
% Allgemeine Wahrscheinlichkeit eines Ausrei�ers. Muss Wahrscheinlichkeit
% sein, also zwischen 0 und 1
P.addOptional('epsilon', 0.5, @(x)isnumeric(x) && x > 0 && x < 1);
% Die gew�hrte Toleranz, innerhalb derer ein Datenpunkt als Inlier
% angesehen wird
P.addOptional('tolerance', 0.01, @isnumeric);

% Lese den Input
P.parse(varargin{:});

% Extrahiere die Variablen aus dem Input-Parser
p           = P.Results.p;
epsilon     = P.Results.epsilon;
tolerance   = P.Results.tolerance;

% Extrahiere homogene Merkmalspunkte (Korrespondenzen sind
% Pixelkoordinaten)
if size(Korrespondenzen,1)==4
    x1_pixel = [Korrespondenzen(1:2,:);ones(1,length(Korrespondenzen))];
    x2_pixel = [Korrespondenzen(3:4,:);ones(1,length(Korrespondenzen))];
end

% Anzahl der ben�tigten Punkte
k = 8;

%**************************************************************************
% RANSAC Algorithmus
%**************************************************************************

% Berechne Anzahl der Iterationen, die ben�tigt werden, um mit einer
% Wahrscheinlichkeit p ein Set von 8 Punkten zu finden, die innerhalb einer
% gewissen Toleranz das Modell erf�llen, wenn die globale
% Wahrscheinlichkeit eines Ausrei�ers in den Daten 'epsilon' betr�gt
s = ceil(log(1-p)/log(1-(1-epsilon)^k));

%Initialisierung des Vektors e3
e3_hat = skew_matrix([0 0 1]);

% Anzahl der Korrespondenzpunkte
no_points = length(Korrespondenzen);

i = 1;
% Die Gr��e des bisher gr��ten gefundenen Consensus Sets
largest_set_size = 0;
% Die Sampson-Distanz des bisher gr��ten gefundenen Consensus Sets
largest_set_dist = Inf;

while i<=s
    i = i+1;
    % Wir w�hlen zuf�llig k Punkte aus, indem wir die Indizes permutieren
    % und die ersten k einlesen
    index = randperm(no_points,k);
    
    % Bestimme Fundamentalmatrix aus den zuf�llig gew�hlten k Punktpaaren
    F = achtpunktalgorithmus(Korrespondenzen(:,index));
    % Berechnung der Distanzen nach Sampson f�r ALLE Punkte
    dist_Sampson = sum(x2_pixel.*(F*x1_pixel)).^2 ./ (sum((e3_hat*F*x1_pixel).^2) + sum((e3_hat*F'*x2_pixel).^2));

    % Selektieren der Punkte, deren Abstand kleiner als max_dist ist (Inlier)
    current_selector = dist_Sampson < tolerance;
    dcheck           = dist_Sampson(current_selector);
    % Anzahl der Inlier und Wert der Summe der Sampson-Distanzen f�r diese Punkte
    current_set_size = numel(dcheck);
    current_set_dist = sum(dcheck);
    
    % Pr�fe, ob das aktuelle Consensus-Set gr��er ist als das bisher Gr��te.
    % Sollte die Gr��e des aktuellen Consensus-Sets ebenso gro� sein
    % wie die des aktuell Gr��ten, gilt die Sampson-Distanz als
    % ausschlaggebendes Kriterium.
    if (current_set_size > largest_set_size) || ((current_set_size == largest_set_size) && (current_set_dist < largest_set_dist))
        largest_set_dist = current_set_dist;
        largest_set_size = current_set_size;
        selector = current_selector;
    end
end

% Zur�ckgegeben werden nicht nur die k Punktpaare, sondern das gesamte
% Consensus-Set!
Korrespondenzen_robust = [x1_pixel(1:2,selector);x2_pixel(1:2,selector)];

end

function [Vhat] = skew_matrix(V)
    % Umwandlung von V in eine schiefsymmetrische Matrix
    Vhat = [0 -V(3) V(2); V(3) 0 -V(1); -V(2) V(1) 0];
end