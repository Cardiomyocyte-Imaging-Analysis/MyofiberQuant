function [findy1] = cellEquality(lineTrace, Point1)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
equality = cellfun(@eq, lineTrace, Point1);
findy1 = find(equality);
end

