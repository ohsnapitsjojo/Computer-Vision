function [EF] = achtpunktalgorithmus(Korrespondenzen,K)
% Diese Funktion berechnet die Essentielle Matrix oder Fundamentalmatrix
% mittels 8-Punkt-Algorithmus, je nachdem, ob die Kalibrierungsmatrix 'K'
% vorliegt oder nicht


% Erg�nze die Korrespondenzen zu homogenen Koordinaten
x1 = [Korrespondenzen(1:2,:);ones(1,size(Korrespondenzen,2))];
x2 = [Korrespondenzen(3:4,:);ones(1,size(Korrespondenzen,2))];

% Falls eine Kalibrierungsmatrix gegeben ist, soll die Funktion die
% Essentielle Matrix sch�tzen. Hierzu m�ssen die Koordinaten kalibriert
% werden. Falls die Funktion die Fundamentalmatrix sch�tzen soll, wird
% dieser Schritt �bersprungen und x1 und x2 bezeichnen im Folgenden
% Pixelkoordinaten.
if(nargin>1)
    x1 = K\x1;
    x2 = K\x2;
end

% Berechnung des Kroneckerprodukts zwischen x1 und x2
% Erstes Produkt kron(x1,ones(3,1)) erzeugt Matrix der Form :
% x11 x12 ...
% x11 x12 ...
% x11 x12 ...
% y11 y12 ...
% y11 y12 ...
% y11 y12 ...
% z11 z12 ...
% z11 z12 ...
% z11 z12 ...
% Zweites Element kron(ones(3,1),x2) erzeugt Matrix der Form :
% x11 x12 ...
% y11 y12 ...
% z11 z12 ...
% x11 x12 ...
% y11 y12 ...
% z11 z12 ...
% x11 x12 ...
% y11 y12 ...
% z11 z12 ...

% Elementweise multipliziert und anschlie�end transponiert ergeben die Produkte genau die Matrix A
A = (kron(x1,ones(3,1)).*kron(ones(3,1),x2))';

% Singul�rwertzerlegung der Matrix A, um G zu berechnen
[~,~,V] = svd(A);

% Erste Sch�tzung ist der neunte rechtsseitige Singul�rvektor.
% (Singul�rvektor zum kleinsten Singul�rwert)
% Unstacking ergibt G.
G = reshape(V(:,end),3,3);

% 2. Singul�rwertzerlegung
[U,S,V] = svd(G);

% Unterscheide nach Essentieller Matrix oder Fundamentalmatrix
if(nargin>1)
    % Auf Grund der Skalierungsinvarianz der Sch�tzung wird statt
    % sigma=1/2(sigma1+sigma2) einfach sigma=1 gew�hlt. EF ist die Essentielle
    % Matrix
    EF = U * diag([1,1,0]) * V';
else
    % Setze den dritten Singul�rwert zu null
    S(3,3) = 0;
    EF = U * S * V';
end
end