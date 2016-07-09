function [ output_args ] = plotCamera( camCorners, name )
%PLOTCAMERA Summary of this function goes here
%   Plote Camera mit Text
    plot3(camCorners(3,:), camCorners(1,:), camCorners(2,:));
    text(camCorners(3), camCorners(1), camCorners(2) ,name)

end

