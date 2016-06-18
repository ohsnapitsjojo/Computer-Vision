function [EF] = achtpunktalgorithmus(Korrespondenzen, K)
% Diese Funktion berechnet die Essentielle Matrix oder Fundamentalmatrix
% mittels 8-Punkt-Algorithmus, je nachdem, ob die Kalibrierungsmatrix 'K'
% vorliegt oder nicht
    nKP = size(Korrespondenzen,2);

    x1 = [ Korrespondenzen(1:2,:); ones(1, nKP)];
    x2 = [ Korrespondenzen(3:4,:); ones(1, nKP)];
    
    A = kron(x1,x2)';

    
    for i=1:nKP
        idx = (i-1)*nKP+i;
        A(i,:) = A(idx,:);
    end
    
    A = A(1:nKP,:);
    
    [U,S,V] = svd(A); 
    
    G = V(:,9);
    G = reshape(G, [3,3]);
    [UG,SG,VG] =svd(G);

    EF = UG*[1,0,0;0,1,0;0,0,0]*VG';
    
if nargin == 2
 %  EF = UG*[SG(1,1),0,0;0,SG(2,2),0;0,0,0]*VG';

     iK = inv(K);
     EF = iK'*EF*iK;
end

end