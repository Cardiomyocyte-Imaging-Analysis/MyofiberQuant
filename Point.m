classdef Point
    % Contains paired x and y value.  Also compares equality
    
    properties
        x
        y
    end
    
    methods
        function P = Point(y, x)
            P.x = x;
            P.y = y;
        end
        
        function equal = eq(P, b)
            equal = (b.x == P.x) && (b.y == P.y);
        end
        
        function neighbors = inNeighborhood(P, b)
            radius = 5;
            neighbors = (abs(P.x - b.x) <= radius) && (abs(P.y - b.y) <= radius);
        end
        
        function Ydist = Ydistance(P, b)
            Ydist = abs(P.y - b.y);
        end
        
    end
    
end

