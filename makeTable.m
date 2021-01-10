function [A] = makeTable(A, singleMyofilament)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
x = singleMyofilament.peaksX;
y = singleMyofilament.peaksY;
s = singleMyofilament.s;
s = smoothdata(s,'movmean', 4);
area = singleMyofilament.areaProfile;
[newX, newY, newA] = includeStdDev(x, y, s, area);
idx = sub2ind(size(A), newY, newX);
idx2 = sub2ind(size(A), newY, newX + 1);

A(idx) = newA;
A(idx2) = newA;

end

