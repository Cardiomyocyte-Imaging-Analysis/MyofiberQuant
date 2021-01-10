function [newX, newY, newArea] = includeStdDev(x, y, s, a)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here
a = smoothdata(a, 'movmean', 3);
newX = [];
newY = [];
newArea = [];
y = smoothdata(y, 'movmean', 2);
for ii = 1:length(x)
    yRange = round(y(ii) - s(ii) : y(ii) + s(ii));
    newY = [newY, yRange];
    newX = [newX, ones(1, length(yRange))*x(ii)];
    newArea = [newArea, ones(1, length(yRange))*a(ii)];
end
newArea;
newArea = smoothdata(newArea, 'movmean');

