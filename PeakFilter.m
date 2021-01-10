function PeakIndex=PeakFilter(PeakIndex, Mask)
% remove peaks derived from noisy image, which are usually of low
% prominence, small width. Here we also remove the peaks outside the
% cropped area
% input: 
%   PeakIndex:  information about the detected peak
%   Mask: 2D binary matrix storing the shape of the ROI
% Peak
i=1;
[a,b]=size(Mask);
while i<=length(PeakIndex)
    if Mask(PeakIndex(i,1),PeakIndex(i,2))==0||PeakIndex(i,1)>a-3||PeakIndex(i,1)<3||PeakIndex(i,2)>b-5
        % remove peaks that are within [0,5]*[-2,+2] range of the edge, so
        % that the indexes won't exceed boundary
        PeakIndex(i,:)=[];
    else 
        i=i+1;
    end
end
end