classdef peak
    %UNTITLED13 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        x
        y
        intensity
        boundingbox
        neighborhood
        area
        s
        xRange
        yRange
    end
    
    methods
        function p = peak(xCoordinate, yCoordinate, image, areaUnderCurve, stdDev)
            %UNTITLED13 Construct an instance of this class
            %   Detailed explanation goes here
            p.x = xCoordinate;
            p.y = yCoordinate;
            p.intensity = image(yCoordinate, xCoordinate);
            D = padarray(image,[8 8],0,'both');
            p.neighborhood = D(yCoordinate + 8 - 8: yCoordinate + 8 + 8,...
                    xCoordinate + 8 - 8 : xCoordinate + 8 + 8);
            p.area = areaUnderCurve;
            if isempty(p.area)
                p.area = 0;
            end
            p.s = stdDev;
            if isempty(p.s)
                p.s = 0;
            end
            p.yRange = round(p.y - 1.5*stdDev : p.y + 1.5*stdDev);
            p.xRange = ones(1, length(p.yRange))*p.x;
        end
        
        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.x + inputArg;
        end
        
        function equality = eq(obj, obj2)
            if isempty(obj2) || isempty(obj)
                equality = false;
            elseif isa(obj2, 'peak') &&  isa(obj, 'peak')
                equality = obj.x == obj2.x && obj.y == obj2.y;
            else
                equality = false;
            end
        end
        
    end
end

