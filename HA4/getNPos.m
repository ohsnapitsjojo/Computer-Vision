function [ nPos ] = getNPos( l1, l2 )
%GETNPOS Summary of this function goes here
%   Detailed explanation goes here
    nL1 = sum(l1 > 0);
    nL2 = sum(l2 > 0);
    
    nPos = nL1 + nL2;

end

