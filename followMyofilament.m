function [found, point1, point2] = followMyofilament(croppedImage, Y, V, locs, k, j, Area, cropImage, stdDev)
% Traces and plots a myofilament within a cell given a cell image and
% indices to begin search at
% INPUT: Y -- initial y-location
% V -- vector containing x-locations of preceding, current and
% proceding locations of line scans

% x and y are vectors with points that have been visited and also have
% maximum intensity.  This means that they are regional maxima

Mx = max(croppedImage(:));

% shuffle order of vertical search directions so that it is random and the
% search/path does not continually trend up or down
% order will always have 0 first, then a random order of -1 and 1,
% then a random order of -2 and 2
assembleSearch = [-1, 1];
shuffledAssembleSearch = assembleSearch(randperm(length(assembleSearch)));
verticalSearch = [0, shuffledAssembleSearch];
assembleSearch = [-2, 2];
shuffledAssembleSearch = assembleSearch(randperm(length(assembleSearch)));
verticalSearch = [0, -1, 1, -2, 2, -3, 3, -4, 4, -5, 5];

% loop: one search in the increasing x-direction and one search in the
% decreasing x-direction

% reset x and y to be the original coordinates given as parameters
y = Y;
x = V(k);

% do 5 rounds of searching
% set your starting coordinates to the last coordinates that were
% visited
startX = x(end);
startY = y(end);
again = true;

% for the various x heights within the range
for jj = verticalSearch
    % for each coordinate along this line
    for ii = linspace(1, 4, 4)
        
        % if the line has traced to where there has been another
        % vertical line scan done
        if 1 == nextPoint(1, ii, V(k-1:k+1), startX)
            
            % plot what has already been found
            % signal to break out of larger for loop
            % and break out of the current for loop
            break
        end
        
        % if the point has the maximum intensity
        if croppedImage(startY + jj, startX + ii) == Mx
            % add that point to the list of points that have been
            % visited
            x = [x, startX + ii];
            y = [y, startY + jj];
            % reset the initial coordinates to the current
            % coordinates
            startX = startX + ii;
            startY = startY + jj;
            % signal to break out of larger for loop
            again = false;
            % and break out of current for loop
            break
        end
    end
    % if the line has traced past where there has been another
    % vertical line scan done, break out of the larger loop
    if ~again
        break
    end
end



if length(x) > 1
    found = true;
    areaPoint1 = Area{k}(j);
    stdDev1 = stdDev{k}(j);
    point1 = peak(V(k), Y, cropImage, areaPoint1, stdDev1);
    j = locs{1, k + 1};
    areaPoint2 = Area{k+1}(y(end) == j);
    stdDev2 = stdDev{k+1}(y(end) == j);
    point2 = peak(x(end), y(end), cropImage, areaPoint2, stdDev2);
    
    
else
    found = false;
    point1 = peak(1, 1, cropImage, 1, 1);
    point2 = peak(1, 1, cropImage, 1, 1);
end
return;


end

