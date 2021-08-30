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
     
    % find the height, locations and widths of peaks of the intensity profile, 
    [~, locs, w] = findpeaks(c2, 'MinPeakHeight', 0.35*max(c2), 'MinPeakWidth', 1.5, 'MinPeakDistance', 6, 'MinPeakProminence', 6);
    % fit the Gaussian curve to each peak and return the area and the
    % width
    [pgon, s] = makePolygons(locs, w, cTotal);

A = [];

if ~isempty(pgon)
    A = area([pgon(:).shape]);
end

end

