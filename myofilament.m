classdef myofilament
    % contains information about a single myofilament within a cell
    
    properties
        peaks % location of peaks due to sarcomere units within a myofilament
        peaksX
        peaksY
        score
        myofilamentLength
        meanIntensity
        intensityProfile
        distance
        sarcomereLength
        centerX
        centerY
        startX
        startY
        endX
        endY
        xPath
        yPath
        fitResult
        areaProfile
        sumOfArea
        startYApprox
        endYApprox
        merged
        mergedNumber
        s
        heterogeneity
        breaks
        avgDensity
        avgS
        orientation
        lengthPercent
        lengthOfCell
    end
    
    methods
        function m = myofilament(lineTrace, image, lengthOfCell)
            %UNTITLED14 Construct an instance of this class
            %   Detailed explanation goes here
            m.peaks = lineTrace(~cellfun(@isempty,lineTrace));
            m.areaProfile = cellfun(@(p)p.area, m.peaks);
            m.sumOfArea = sum(m.areaProfile);
            m.avgDensity = mean(m.areaProfile);
            center = ceil(length(m.peaks) / 2);
            m.peaksX = cellfun(@(p)p.x, m.peaks);
            m.peaksY = cellfun(@(p)p.y, m.peaks);
            [~, col] = size(m.peaks);
            x = zeros(1, col);
            y = zeros(1, col);
            for ii = 1:col
                x(ii) = m.peaks{1, ii}.x;
                y(ii) = m.peaks{1, ii}.y;
            end
            [m.xPath, m.yPath, m.intensityProfile] = improfile(image, x, y);
            m.meanIntensity = mean(m.intensityProfile);
            m.score.Rsquared = 0;
            m.score.NumberOfPoints = length(m.peaksX);
            
            L = length(m.peaks);
            w = 3;
            for k1 = 1:L-w+1
                dataWindow(k1,:) = k1:k1+w-1;
                angle(k1) = 180 - angleBetweenThreePoints(m.peaks(dataWindow(k1,:)));
            end
            m.score.Angle = angle;
            %m.score.Angle = myofilamentAngles(m.peaks);
            m.score.maxAngle = max(m.score.Angle);
            m.centerX = m.peaks{center}.x;
            m.centerY = m.peaks{center}.y;
            m.startX = m.peaks{1}.x;
            m.startY = m.peaks{1}.y;
            m.endX = m.peaks{end}.x;
            m.endY = m.peaks{end}.y;
            m.s = cellfun(@(p)p.s, m.peaks);
            ft = fittype( 'poly2' );
            
            % Fit model to data.
            [m.fitResult, ~] = fit(m.xPath, m.yPath, ft );
%             plot(m.fitResult,m.xPath, m.yPath,'predfunc');
            y2 = m.fitResult(m.xPath);
            m.startYApprox = y2(1);
            m.endYApprox = y2(end);
            m.merged = false;
            m.breaks = 0;
            m.myofilamentLength = length(m.peaks) * 2;
            m.avgS = mean(m.s);
            m.lengthPercent = m.myofilamentLength / lengthOfCell;
            p1 = Point(m.startYApprox, m.startX);
            p2 = Point(m.endYApprox, m.endX);
            p3 = Point(m.endYApprox, m.endX - 20);
            m.orientation = (90 - angleBetweenThreePoints(p1, p2, p3))/90;
            a = m.areaProfile';
            avg = mean(a);
            m.avgDensity = avg;
            % split myofilament into ten segments
            N = length(a);
            P = 10;
            r = diff(fix(linspace(0, N, P+1)));
            C = mat2cell(a, r, 1);
            wrapper = @(x) diffFromMean(x, avg);
            % find the percent difference from the mean for each of the ten
            % segments
            h = cellfun(wrapper, C);
            % average the percent difference
            h = mean(h);
            m.heterogeneity = h;
            m.lengthOfCell = lengthOfCell;
        end
        
        function lastPeak = getLastPeak(obj)
            lastPeak = obj.peaks{end};
        end
        
        function m = setScore(m, value, type)
            m.score.(type) = m.score.(type) + value;
        end
        
        function m = setSarcomereLength(m, distance)
            m.sarcomereLength = distance;
        end
        
        function [obj,idx]=sort(obj)
            [~,idx]=sort([obj.score.Angle],'ascend');
            obj=obj(idx);
        end
        
        function m = mergeMyofilaments(m, m2, ~)
            diff = m2.startX - m.endX;
            numOfPoints = diff/2 - 1;
            if numOfPoints < 0
                numOfPoints = 0;
            end
            m.peaks = [m.peaks, m2.peaks];
            m.peaksX = [m.peaksX, linspace(m.peaksX(end) + 2, m2.peaksX(1) - 2, numOfPoints), m2.peaksX];
            m.peaksY = [m.peaksY, linspace(m.peaksY(end), m2.peaksY(1), numOfPoints), m2.peaksY];
            m.s = [m.s, linspace(m.s(end), m2.s(1), numOfPoints), m2.s];
            m.intensityProfile = [m.intensityProfile; m2.intensityProfile];
            m.meanIntensity = mean(m.intensityProfile);
            center = ceil(length(m.peaks) / 2);
            m.centerX = m.peaks{center}.x;
            m.centerY = m.peaks{center}.y;
            
            m.endX = m2.endX;
            m.endY = m2.endY;
            m.xPath = [m.xPath; (linspace(m.xPath(end) + 2, m2.xPath(1) - 2, numOfPoints))'; m2.xPath];
            m.yPath = [m.yPath; (linspace(m.yPath(end), m2.yPath(1), numOfPoints))'; m2.yPath];
            m.areaProfile = [m.areaProfile, linspace(m.areaProfile(end), m2.areaProfile(1), numOfPoints), m2.areaProfile];
            m.sumOfArea = m.sumOfArea + m2.sumOfArea;
            m.avgS = mean(m.s);
            m.myofilamentLength = m.xPath(end) - m.xPath(1);
            m.lengthPercent = m.myofilamentLength / m.lengthOfCell;
            
        end
        
        function [h, m] = getHeterogeneity(m)

        end
        
        function [percentLength, m] = getPercentLength(m, cellLength)
            m.percentLength = m.myofilamentLength / cellLength;
            percentLength = m.percentLength;
        end
        
        function [avgS, m] = getAvgWidth(m)
            m.avgS = avg(m.s);
            avgS = m.avgS;
        end
    end
end
