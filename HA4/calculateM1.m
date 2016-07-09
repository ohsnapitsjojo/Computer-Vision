function [ M ] = calculateM1( x1, x2, T, R )
%CALCULATEM Summary of this function goes here
%   Berechne M für Lambda 1
    nKP = size(x1,2);
    M = zeros(3*nKP, nKP+1);
    
    for i = 1:nKP
        
        idxL = (i-1)*3 + 1;
        idxU = idxL+2;
        x1_ = x1(:,i);
        x2_ = x2(:,i);
        [E, L] = calcMElement(x1_,x2_,T,R,1);
        M(idxL:idxU,i) =  E;
        M(idxL:idxU,end) = L;
        
    end
    
   
end

