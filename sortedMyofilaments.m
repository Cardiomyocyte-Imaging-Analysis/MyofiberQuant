classdef sortedMyofilaments
    % A sorted structure of all the possible myofilaments within a cell.
    % The myofilaments are sorted into four categories which are determined
    % by the vertical separation of the myofilaments

    
    properties
        order
        myofilaments
        myofilamentsByRegion
        myofilamentsMerged
        count
        peaksX
        avgDensity
        heterogeneity
        region1Avg
        region2Avg
        region3Avg
        region1Density
        region2Density
        region3Density
        ninetyFifthPercentileIntensity
        calibration
        fiftiethPercentileIntensity
        lengthOfCell
        region1Avgb
        region2Avgb
        region3Avgb
        minY
        rowDifference
        sRanking
        filename
        avgOrientation
        weightedOrientation
        reconstructedImage
        totalDensity
        myofilamentArea
        numberOfMeasurements
        rowSum
        peripheryIndex1
        medSarcomereLength
        peripheryRatio
        cellNumber
        peripheryIndex2
    end
    
    methods
        function sM = sortedMyofilaments(myofilaments, lengthOfCell)
            %INPUT: myofilaments is an array of all the myofilaments
            %within a cell, not in any particular order.
            sM.lengthOfCell = lengthOfCell;
            myofilaments = myofilaments(~cellfun(@isempty, myofilaments));
            myofilamentLength = cellfun(@(p)p.score.NumberOfPoints, myofilaments);
            myofilaments = myofilaments(myofilamentLength > 5);
            startX = cellfun(@(x)x.startX, myofilaments);
            [~,sortIdx] = sort(startX);
            
            sM.myofilaments = myofilaments(sortIdx);
%             sM.myofilaments = sM.myofilaments(Angle < 50);
%             sM.order = sortIdx(Angle <  50);
            rangeY = cellfun(@(x)x.startY, sM.myofilaments);
            [maxY, ~] = max(rangeY);
            [minY, ~] = min(rangeY);
            rowDifference = round((maxY - minY) / 3);
            sM.minY = minY;
            sM.rowDifference = rowDifference;
            sM.calibration = 0;
            
            
            if isempty(sM.myofilaments)
                myofilamentsByRegion(1:3, 1) = 6;
                myofilamentsByRegion(1:3, :) = [];
            end
            
            % sort myofilaments into four different equally spaced
            % categories based on the position of the first point within a
            % myofilament
            
            count = 1;
            
            % Merge myofilament segments that are part of the same
            % myofilament
            for ii = 1:length(sM.myofilaments)
                endY = sM.myofilaments{ii}.endYApprox;
                endX = sM.myofilaments{ii}.endX;
%                 ci  = confint(sM.myofilaments{ii}.fitResult, 0.1);
%                 ft = fittype( 'poly2' );
%                 opts = fitoptions( 'Method', 'LinearLeastSquares' );
%                 opts.Lower = [ci(1, 1), ci(1, 2), sM.myofilaments{ii}.fitResult.p3-3];
%                 opts.Upper = [ci(2, 1), ci(2, 2), sM.myofilaments{ii}.fitResult.p3+3];
%                 subplot(2, 1, 1); hold on; % plot(sM.myofilaments{ii}.xPath, sM.myofilaments{ii}.yPath);
%                 plot(sM.myofilaments{ii}.fitResult, sM.myofilaments{ii}.xPath, sM.myofilaments{ii}.yPath);
                
                
                
                for jj = 1:length(sM.myofilaments)
                    %[fit2, gof] = fit( sM.myofilaments{jj}.xPath, sM.myofilaments{jj}.yPath, ft, opts);
                    if ~isempty(sM.myofilaments{jj})
                        startY = sM.myofilaments{jj}.startYApprox;
                        startX = sM.myofilaments{jj}.startX;
                        %gof.rsquare > 0.8 ||%
                        if ( (startX - endX < 10 && startX - endX > 0 && abs(startY - endY) < 4))  && ii ~= jj
                            %                         if gof.rsquare > 0.8
                            %                             plot(fit2, sM.myofilaments{jj}.xPath, sM.myofilaments{jj}.yPath);
                            %                         end
                            if sM.myofilaments{ii}.merged && sM.myofilaments{jj}.merged
                                sM.myofilamentsMerged{sM.myofilaments{ii}.mergedNumber} = mergeMyofilaments(sM.myofilamentsMerged{count-1}, sM.myofilamentsMerged{sM.myofilaments{jj}.mergedNumber});
                                sM.myofilaments{sM.myofilaments{jj}.mergedNumber} = [];
                                sM.myofilaments{jj}.mergedNumber = sM.myofilaments{ii}.mergedNumber;
                            elseif sM.myofilaments{jj}.merged
                                sM.myofilamentsMerged{sM.myofilaments{jj}.mergedNumber} = mergeMyofilaments(sM.myofilaments{ii}, sM.myofilamentsMerged{sM.myofilaments{jj}.mergedNumber});
                                sM.myofilaments{ii}.mergedNumber = sM.myofilaments{jj}.mergedNumber;
                                sM.myofilaments{ii}.merged = true;
                            elseif sM.myofilaments{ii}.merged
                                sM.myofilamentsMerged{sM.myofilaments{ii}.mergedNumber} = mergeMyofilaments(sM.myofilaments{jj}, sM.myofilamentsMerged{sM.myofilaments{ii}.mergedNumber});
                                sM.myofilaments{jj}.mergedNumber = sM.myofilaments{ii}.mergedNumber;
                                sM.myofilaments{jj}.merged = true;
                            else
                                sM.myofilamentsMerged{count} = mergeMyofilaments(sM.myofilaments{ii}, sM.myofilaments{jj}, sM.lengthOfCell);
                                sM.myofilaments{ii}.mergedNumber = count;
                                sM.myofilaments{ii}.merged = true;
                                sM.myofilaments{jj}.mergedNumber = count;
                                sM.myofilaments{jj}.merged = true;
                                count = count + 1;
                            end
                            %subplot(2, 1, 2); hold on; plot(sM.myofilamentsMerged{sM.myofilaments{ii}.mergedNumber}.xPath, sM.myofilamentsMerged{sM.myofilaments{ii}.mergedNumber}.yPath, 'r', 'LineWidth', 0.75);
                            break;
                        end
                    end
                end
                if ~sM.myofilaments{ii}.merged
                   sM.myofilamentsMerged{count} = sM.myofilaments{ii};
                   count = count + 1;
                end
            end

            orientation = cellfun(@ (p) p.orientation, sM.myofilamentsMerged);
            density = cellfun( @ (p) p.avgDensity, sM.myofilamentsMerged);
            density = density / max(density);
            weightedOrientation = orientation .* density;
            sM.weightedOrientation = mean(weightedOrientation);
            sM.avgOrientation = mean(orientation);
            
            
            count = struct('row1PeakIntensityProfile', 1, 'row2PeakIntensityProfile', 1, 'row3PeakIntensityProfile', 1);
            totalArea = sum(cellfun(@(p)p.sumOfArea, sM.myofilamentsMerged));
            totalPeaks = sum(cellfun(@(p)p.myofilamentLength, sM.myofilamentsMerged)) / 2;
            avgIntensity = totalArea / totalPeaks;
            myofilamentDensity = cellfun(@(p)p.avgDensity, sM.myofilamentsMerged);
            sM.avgDensity = mean(myofilamentDensity);
            sM.heterogeneity = diffFromMeanSM(myofilamentDensity, avgIntensity);
            areaProfile = cell2mat(cellfun(@(p)p.areaProfile, sM.myofilamentsMerged, 'UniformOutput',false));
            sM.ninetyFifthPercentileIntensity = prctile(areaProfile, 95);
            sM.fiftiethPercentileIntensity = prctile(areaProfile, 50);
            
            
            
            for ii = 1:length(sM.myofilamentsMerged)
                if sM.myofilamentsMerged{ii}.centerY < minY + rowDifference
                    myofilamentsByRegion{1, count.row1PeakIntensityProfile} = sM.myofilamentsMerged{ii};
                    count.row1PeakIntensityProfile = count.row1PeakIntensityProfile + 1;
                elseif sM.myofilamentsMerged{ii}.centerY < minY + 2*rowDifference
                    myofilamentsByRegion{2, count.row2PeakIntensityProfile} = sM.myofilamentsMerged{ii};
                    count.row2PeakIntensityProfile = count.row2PeakIntensityProfile + 1;
                else
                    myofilamentsByRegion{3, count.row3PeakIntensityProfile} = sM.myofilamentsMerged{ii};
                    count.row3PeakIntensityProfile = count.row3PeakIntensityProfile + 1;
                end
            end
            sM.peaksX.row1PeakIntensityProfile = [1];
            sM.peaksX.row2PeakIntensityProfile = [1];
            sM.peaksX.row3PeakIntensityProfile = [1];
            
            if ~isempty(myofilamentsByRegion)
                for ii = 1:3
                    M = myofilamentsByRegion(ii, :);
                    M1 = M(~cellfun(@isempty, M));
                    rowStartX = cellfun(@(x)x.startX, M1);
                    [~,sortIdx] = sort(rowStartX);
                    myofilamentsByRegion(ii, 1:max(sortIdx)) = M1(sortIdx);
                    ROWS = ['row1PeakIntensityProfile'; 'row2PeakIntensityProfile'; 'row3PeakIntensityProfile'];
                    for jj = 1:max(sortIdx)
                        row = ROWS(ii, :);
                        sM.peaksX.(row) = [sM.peaksX.(row), myofilamentsByRegion{ii,jj}.peaksX];
                        sM.peaksX.(row) = sort(sM.peaksX.(row));
                    end
                end
            end
            sM.sRanking = cellfun(@(p) p.avgS, sM.myofilamentsMerged);
            sM.myofilamentsByRegion = myofilamentsByRegion;
%             for ii = 1:numel(myofilamentsByRegion)
%                 if ~isempty(myofilamentsByRegion{ii})
%                     hold on;
%                     plot(myofilamentsByRegion{ii}.xPath, myofilamentsByRegion{ii}.yPath, 'r', 'LineWidth', 0.75);
%                     ft = fittype( 'poly2' );
%                     
%                     % Fit model to data.
%                     [fitresult, ~] = fit(myofilamentsByRegion{ii}.xPath, myofilamentsByRegion{ii}.yPath, ft );
%                     y2 = fitresult(myofilamentsByRegion{ii}.xPath);
%                     plot(myofilamentsByRegion{ii}.xPath, y2, 'b');
%                 end
%             end
            
            sM.region1Avg = regionalAvg(sM.myofilamentsByRegion(1, :));
            sM.region2Avg = regionalAvg(sM.myofilamentsByRegion(2, :));
            sM.region3Avg = regionalAvg(sM.myofilamentsByRegion(3, :));
            % extract area profile for each myofilament
            % divide by total area
            
            region1 = sM.myofilamentsByRegion(1, :);
            region2 = sM.myofilamentsByRegion(2, :);
            region3 = sM.myofilamentsByRegion(3, :);
            sM.region1Density = sum(cellfun(@(p) p.sumOfArea, region1(~cellfun(@isempty, sM.myofilamentsByRegion(1, :)))) / (rowDifference * lengthOfCell));
            sM.region2Density = sum(cellfun(@(p) p.sumOfArea, region2(~cellfun(@isempty, sM.myofilamentsByRegion(2, :)))) / (rowDifference * lengthOfCell));
            sM.region3Density = sum(cellfun(@(p) p.sumOfArea, region3(~cellfun(@isempty, sM.myofilamentsByRegion(3, :)))) / (rowDifference * lengthOfCell));
            
        end
        
        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
        
        function sM = calibrateMyofilament(sM, calibration)
            % region_Avg = avg of myofilaments by  region
            % region_Density = total sum of all of the profiles
            % region_Avgb = density by region, regardless of where center
            % of myofilament is
            sM.calibration = calibration;
            sM.avgDensity = sM.avgDensity / calibration;
            sM.region1Avg = sM.region1Avg / calibration;
            sM.region2Avg = sM.region2Avg / calibration;
            sM.region3Avg = sM.region3Avg / calibration;
            sM.region1Density = sM.region1Density / calibration;
            sM.region2Density = sM.region2Density / calibration;
            sM.region3Density = sM.region3Density / calibration;
            sM.region1Avgb = sM.region1Avgb / calibration;
            sM.region2Avgb = sM.region2Avgb / calibration;
            sM.region3Avgb = sM.region3Avgb / calibration;
        end
        
        function sM = addMyofilamentArea(sM)
            nonzero = sM.reconstructedImage ~= 0;
            sM.myofilamentArea = sum(nonzero(:));
        end
        function sM = regionalDensity(sM, A)
            sM.reconstructedImage = A;
            nonzero = A ~= 0;
            a = find(sum(nonzero, 2));
            cellHeight = a(end) - a(1);
            a = find(sum(nonzero, 1));
            cellWidth  = a(end) - a(1);
            sM.totalDensity = sum(nonzero(:))/(cellHeight * cellWidth);
            sM.region1Avgb = sum(sum(A(1:sM.minY + sM.rowDifference, :))) / (sM.rowDifference * sM.lengthOfCell);
            sM.region2Avgb = sum(sum(A(sM.minY + sM.rowDifference:sM.minY + 2*sM.rowDifference, :))) / (sM.rowDifference * sM.lengthOfCell);
            sM.region3Avgb = sum(sum(A(sM.minY + 2*sM.rowDifference:end, :))) / (sM.rowDifference * sM.lengthOfCell);
            sM.peripheryRatio = sM.region2Avgb / mean([sM.region1Avgb, sM.region2Avgb]);
            sM.myofilamentArea = sum(nonzero(:));
            sumOfRows = sum(A, 2);
            sM.rowSum = sumOfRows(sumOfRows > 0);
            index = abs((1:length(sM.rowSum)) - round(length(sM.rowSum) / 2));
            index = index / round(length(sM.rowSum) / 2);
            sM.peripheryIndex1 = mean(index .* (sM.rowSum/sum(sM.rowSum))');
            sM.peripheryIndex2 = sum(index .* (sM.rowSum/sum(sM.rowSum))');
            
        end
    end
end

