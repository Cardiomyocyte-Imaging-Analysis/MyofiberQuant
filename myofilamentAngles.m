function [angle] = myofilamentAngles(peaks)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
L = length(peaks);
w = 3;
for k1 = 1:L-w+1
    dataWindow(k1,:) = k1:k1+w-1;
    angle(k1) = 180 - angleBetweenThreePoints(peaks(dataWindow(k1,:)));
end
end

