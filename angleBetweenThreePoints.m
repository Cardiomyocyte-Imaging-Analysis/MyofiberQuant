function [ deg ] = angleBetweenThreePoints(point1, point2, point3)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

if nargin == 1
    point2 = point1{2};
    point3 = point1{3};
    point1 = point1{1};

end
dx1 = point2.x - point1.x;
dx2 = point3.x - point2.x;
dy1 = point2.y - point1.y;
dy2 = point3.y - point2.y;

dotProduct = dx1*dx2 + dy1*dy2;

magdxdy1 = sqrt((dx1)^2 + (dy1)^2);
magdxdy2 = sqrt((dx2)^2 + (dy2)^2);

cosRad = dotProduct / (magdxdy1*magdxdy2);
rad = acos(cosRad);
deg = rad2deg(rad);
deg = 180 - deg;

if point1.x == 1 || point2.x == 1 || point3.x == 1
    deg = 1000;
end

if point1.y < point3.y
    deg = abs(deg);
else
    deg = -abs(deg);
end
    


end

