function [ output_args ] = plotPoints( P1 )
%PLOTPOINTS Summary of this function goes here
%   Detailed explanation goes here

    scatter3(P1(:,3), P1(:,1), P1(:,2) );
    xlabel('z')
    ylabel('x');
    zlabel('y');
    set(gca,'ZDir','reverse');
    set(gca,'YDir','reverse');
    nKP= size(P1,1);
    name = linspace(1,nKP,nKP);
    nameCell = mat2cell(name,1,ones(1,nKP));
    
    text(P1(:,3), P1(:,1), P1(:,2), nameCell)

end

