function Peak=PeakLookup(x,y,PeakIndex)
% look up the specfic peak at the x,y location
% input: 
%   x and y as interger that exist in the give PeakIndex
%   PeakIndex are derived from getPeaks.m, which is a 2D matrix
% output:
%   Peak: the information about the peak, should be a 1D array if
%   succcessful. The content of the Peak is related to PeakIndex

index=find((PeakIndex(:,1)==x) .* (PeakIndex(:,2)==y));
if isempty(index)
    Peak=[];
else
    Peak=PeakIndex(index,:);
end
end