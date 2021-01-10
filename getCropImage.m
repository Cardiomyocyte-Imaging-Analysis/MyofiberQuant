function cropImage=getCropImage(I, CellRegion)
% this function uses the original grayscale image and the crop region
% identified by FindROI function, and returns a smaller grayscal image for 
% further analysis
% input:
%   I: should be a 2D matrix possibly uint16 or double
%   CellRegion: a 2x2 matrix, designating the Bounding Box of the croped region
% 
[a,b]=size(I);
cropImage=I(max(floor(CellRegion(2)),1):min(ceil(CellRegion(2)+CellRegion(4)),a),...
    max(floor(CellRegion(1)),1):min(ceil(CellRegion(1)+CellRegion(3)),b));
end