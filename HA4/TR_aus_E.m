function [T1,R1,T2,R2] = TR_aus_E(E)
% In dieser Funktion sollen die moeglichen euklidischen Transformationen
% aus der Essentiellen Matrix extrahiert werden

corrM = [1,0,0;0,1,0;0,0,-1];

[U,S,V] = svd(E);

wP = pi/2;
wM = -pi/2;

if det(U) < 0
   U = U*corrM; 
end
   
if det(V) < 0
   V = V*corrM; 
end
    
RZ_plus = getR(wP);
RZ_minus = getR(wM);


R1 = U*RZ_plus'*V';
T1Hat = U*RZ_plus*S*U';
R2 = U*RZ_minus'*V';
T2Hat = U*RZ_minus*S*U';

T1 = [T1Hat(3,2);T1Hat(1,3);T1Hat(2,1)];
T2 = [T2Hat(3,2);T2Hat(1,3);T2Hat(2,1)];    

end