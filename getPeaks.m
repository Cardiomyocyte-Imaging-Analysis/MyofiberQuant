function PeakIndex=getPeaks(I)
% do vertical line scans through the image, return peak information
% input:
%   I: 2D double matrix containing the cropped image 
% output:
%   PeakIndex: store all the properties we need about the peak, including
%   peak coordinate, peak intesity, peak width, peak prominence
[a,b]=size(I);
% vertical line scan
VerLines=[1:2:b];
PeakIndex=[];
I=medfilt2(I);
for i=1:length(VerLines)
    Line=I(:,VerLines(i));
    % findpeak on vertical line scan, with wavelet denoising
    C = wdenoise(double(Line),1, ...
        'Wavelet', 'sym4', ...
        'DenoisingMethod', 'Bayes', ...
        'ThresholdRule', 'Median', ...
        'NoiseEstimate', 'LevelIndependent');
    [peaks, locs, width, prominence] = findpeaks(C, 'MinPeakHeight', 0.35*max(C), ...
        'MinPeakWidth', 1.5, 'MinPeakDistance', 6, 'MinPeakProminence', 6);
    for j=1:length(locs)
        PeakIndex=[PeakIndex;[locs(j),VerLines(i),peaks(j),width(j),prominence(j)]];
    end
end
end