function [locs, A, s, focusedCell] = verticalLineScanPeaks(V, focusedCell)
%conducts intensity profiles across the length of the cell to find peaks
%and the area underneath each peak
% INPUT: V -- vector containing locations where intensity profiles should
% be taken along the x axis
% focusedCell -- image where intensity profiles are taken
% OUTPUT: locs -- locations where peaks are, arranged by their
% x-coordiante, which corresponds to the locations in V
% A -- the approximate area underneath each peak, corresponding to the peak
% location in locs
% s -- the width of the myofilament at that point, corresponding to the
% peak loations in locs
% focusedCell -- image with locations of peaks set equal to the maximum
% intensity of focusedCell, for easy identification later

warning('off', 'MATLAB:polyshape:repairedBySimplify');
A = [];
locs = [];
for z = 2:length(V) - 1 % parfor???
    
    [locs{z}, A{z}, s{z}] = calcAreaForMyofilament(z, V, focusedCell);
    focusedCell(locs{z}, V(z)) = max(focusedCell(:));
end         
end

