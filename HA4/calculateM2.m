function [ M ] = calculateM2( x1, x2, T, R )
%CALCULATEM Summary of this function goes here
%   Detailed explanation goes here
    nKP = size(x1,2);
    T = T * ones(1,nKP);
    
    diag = dot(x1,R'*x2);
    
    M = eye(nKP);
    idx = find( M == 1);
    M(idx) = diag;
    M(:,end+1) = -dot(x1,R'*T)';
    
end

