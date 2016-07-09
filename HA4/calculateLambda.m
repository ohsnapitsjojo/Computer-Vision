function [ lambda1, lambda2 ] = calculateLambda(x1, x2, T, R  )
%CALCULATELAMBDA Summary of this function goes here
%   Berechne Lambda mit dieser Funktion

    % Berechne beide M Matrizen, für Lambda 1 und 2
    M1 = calculateM1(x1,x2,T,R);
    M2 = calculateM2(x1,x2,T,R);
    nKP = size(x1,2);

    % Lösung ist der rechtsseitige Vektor der SVD Zerlegung
    [~,~,V1] = svd(M1);
    [~,~,V2] = svd(M2);

    lambda1 = V1(:,end);
    lambda2 = V2(:,end);
    
    % Normierung von Lambda 
    lambda1 = lambda1/lambda1(end);
    lambda2 = lambda2/lambda2(end);
    
    % Wegschneiden der Normierungskonstante
    lambda1 = lambda1(1:nKP);
    lambda2 = lambda2(1:nKP);

    
end

