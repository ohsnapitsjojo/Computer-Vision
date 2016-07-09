function [ R ] = getR( w )
%GETR Summary of this function goes here
%   Berechne R

    R = [cos(w), -sin(w), 0;
         sin(w), cos(w),0;
         0,0,1];

end

