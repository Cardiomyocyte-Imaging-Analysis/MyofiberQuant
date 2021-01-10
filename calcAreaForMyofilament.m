function [locs, A, s] = calcAreaForMyofilament(z, V, focusedCell)
%calculates the properties of the myofilaments which exist on the vertical
%line defined by the location in V(z)
% INPUT: z -- index of V to start search with
% V -- array of column indices along which intensity profiles will be taken
% focusedCell -- image from which intensity profiles should be taken
% OUTPUT: locs -- y-coordinates of peaks with an x-coordinate equal to V(z)
% A -- area of myofilaments at V(z) which correspond to the locations in
% locs
% s -- width of myofilaments at V(z) which correspond to  the locations in
% locs

% take the intensity profile  of focusedCell at the column denoted by V(z)
cTotal = focusedCell(:, V(z));



% denoise the data using a wavelet technique
c2 = wdenoise(double(cTotal),1, ...
    'Wavelet', 'sym4', ...
    'DenoisingMethod', 'Bayes', ...
    'ThresholdRule', 'Median', ...
    'NoiseEstimate', 'LevelIndependent');

% set baseline intensity equal to the intensity of the outer perimeter of
% the cell
outerIntensity = mean(cTotal(1:10));
if outerIntensity < mean(cTotal(end - 10:end))
    outerIntensity = mean(cTotal(end - 10:end));
end

% subtract the baseline intensity from both the original intensity profile
% and the denoised intensity profile
c3 = c2 - outerIntensity;
c4 = cTotal - outerIntensity;

% set anything with a negative intensity equal to 0
c4(c3 < 0) = 0;

% identify only the section of the graph which is connected to other areas
% with intensities greater than the baseline
CC = bwconncomp(c4);
numOfPixels = cellfun(@numel,CC.PixelIdxList); %numOfPixels is the number of pixels of each region
if ~isempty(numOfPixels)
    [~,indexOfMax] = max(numOfPixels);
    biggestSection = zeros(size(c4));
    biggestSection(CC.PixelIdxList{indexOfMax}) = 1;
    c4(~biggestSection) = 0;
    c3(~biggestSection) = 0;
    
    % find the height, locations and widths of peaks of the intensity profile, 
    [~, locs, w] = findpeaks(c3, 'MinPeakHeight', 0.35*max(c3), 'MinPeakWidth', 1.5, 'MinPeakDistance', 6, 'MinPeakProminence', 2);
    % fit the Gaussian curve to each peak and return the area and the
    % width
    [pgon, s] = makePolygons(locs, w, c4);
else
    pgon = [];
    s = [];
    locs = [];
end

A = [];

if ~isempty(pgon)
    A = area([pgon(:).shape]);
end

end

