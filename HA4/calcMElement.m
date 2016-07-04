function [ E, L ] = calcMElement(  x1, x2, T, R, modus )
%CALCMELEMENT Summary of this function goes here
%   Detailed explanation goes here

    x2Hat = [0,-x2(3),x2(2);x2(3),0,-x2(1);-x2(2),x2(1),0];
    x1Hat = [0,-x1(3),x1(2);x1(3),0,-x1(1);-x1(2),x1(1),0];

    if modus == 1
        E = x2Hat*R*x1
        L = x2Hat*T;
       
    end
    
    if modus == 2
        E =x1Hat*R'*x2;
        L = -x1Hat*R'*T;

end

