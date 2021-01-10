function [lineTrace, Myofilaments] = traceMyofilaments(V, locs, A, stdDev, focusedCell, cropImage, lengthOfCell)
% returns a matrix with the coordinates of each peak within a myofilament
% outlined
% INPUT: V -- vector containin glocations at which vertical line scans were
% performed
% locs -- location of each peak within a vertical line scan
% focusedCell -- image within which the myofilaments will be traced
% OUTPUT: lineTrace -- matrix which contains the points within each
% myofilament.  Every odd numbered row represents the x coordinates of a
% myofilament trace and the even numbered row with the row value one
% greater represents the corresponding y coordinates.  Each pair of rows
% represents a complete myofilament trace

lineTrace = {};
[~, col] = size(locs);
Myofilaments = [];
for z = 2:length(V)
   focusedCell(locs{z}, V(z)) = max(focusedCell(:)); 
end
for k = 2:col - 2
    for j = 1:length(locs{k})

        pointExists = false;
        % initialize search vectors with peaks found from V
        y = locs{k}(j);
        % trace myofilament corresponding with the jth peak in locs which is
        % representative of the jth myofilament from the top of the image
        [next, point1, point2] = followMyofilament(focusedCell, y, V, locs, k, j, A, cropImage, stdDev);

        if next
            if ~isempty(lineTrace)
                Point1 = cell(size(lineTrace));
                Point1(:) = {point1};
                findy1 = cellEquality(lineTrace, Point1);
            else
                lineTrace = {point1};
                findy1 = 1;
            end
           
            for index = 1:length(findy1)
                if lineTrace{findy1(index)}.x == point1.x
                    pointExists = true;
                    [row, ~] = size(lineTrace);
                    if (findy1(index) + row) > numel(lineTrace)
                        [r, ~] = ind2sub(size(lineTrace), findy1(index));
                        lineTrace{r, end + 1} = point2;
                    else
                        lineTrace{findy1(index) + row} = point2;
                    end
                    break
                end
            end
            if ~pointExists
                lineTrace{end + 1, 1} = point1;
                lineTrace{end, 2} = point2;
            end
        end
    end
end

[row, ~] = size(lineTrace);
count = 1;
for ii = 1:row
    line = lineTrace(ii, :);
    rowPeaks = line(~cellfun(@isempty,line));
    if length(rowPeaks) > 2
        Myofilaments{count} = myofilament(rowPeaks, cropImage, lengthOfCell);
        count = count + 1;
    end
end
end
