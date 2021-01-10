function [avgForRegion] = regionalAvg(regionalMyofilaments)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
sumOfArea = sum(cellfun(@(p)p.sumOfArea, regionalMyofilaments(~cellfun(@isempty, regionalMyofilaments))));
totalPeaks = sum(cellfun(@(p)p.myofilamentLength, regionalMyofilaments(~cellfun(@isempty, regionalMyofilaments)))) / 2;
avgForRegion = sumOfArea / totalPeaks;
end

