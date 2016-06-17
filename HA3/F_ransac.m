function [Korrespondenzen_robust] = F_ransac(Korrespondenzen,varargin)
% Diese Funktion implementiert den RANSAC-Algorithmus zur Bestimmung von
% robusten Korrespondenzpunktpaaren


P = inputParser;


P.addOptional('epsilon', 0.6, @isnumeric);
P.addOptional('p', 0.99, @isnumeric);
P.addOptional('tolerance',1500, @isnumeric);

% Gewichtung f�r das Harris-Kriterium


% Lese den Input
P.parse(varargin{:});

% Extrahiere die Variablen aus dem Input-Parser
epsilon  = P.Results.epsilon;
p        = P.Results.p;
tolerance= P.Results.tolerance;

k = 8;

s = ceil(log(1-p)/(log(1-(1-epsilon)^k)));

e = [0;0;1];
eDach = skewdec(3,e);

nKP = size(Korrespondenzen,2);
x1 = [ Korrespondenzen(1:2,:); ones(1, nKP)];
x2 = [ Korrespondenzen(3:4,:); ones(1, nKP)];

maxNRKP = 0;

for i=1:s
    idx = randperm( nKP, k);
    E = achtpunktalgorithmus(Korrespondenzen(:,idx));
    
    z = diag((x2'*E*x1).^2);
    e1 = eDach*E;
    e2 = E*eDach;
    n1 = norm(e1*x1);
    n2 = norm(x2'*e2);
    
    dSamps = z/(n1+n2);
    idx = dSamps < tolerance;
    tmpConsensus = Korrespondenzen(:,find(idx==1));  
    nRKP = size(tmpConsensus,2);
    
    if maxNRKP < nRKP
        finalE = E;
        maxNRKP = nRKP;
        consensus = tmpConsensus;
    end
    
end

Korrespondenzen_robust = consensus;

end