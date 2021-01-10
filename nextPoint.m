function next = nextPoint(forward, ii, V, startX)

% next: has the algorithm passed the next point where a vertical slice was
% made?
next = false;

% if the algorithm is tracing forward and the x coordinate is greater than
% the x coordinate of the next vertical slice
if forward == 1 && startX + ii > V(3)
    next = true;
% if the algorithm is tracing backwards and the x coordinate is less than
% the x coordinate of the previous vertical slice
elseif forward == -1 && startX + ii < V(1)
    next = true;
end
    
end
