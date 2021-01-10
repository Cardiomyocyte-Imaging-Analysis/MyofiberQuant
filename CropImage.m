function CroppedImage=CropImage(I,CellRegion)
% crop the area of interest based on the CellRegion, which is derived from
% regionprops. The Region stat must not exeed the image boundary
%
% input:
%   I: 2D matrix
%   CellRegion: ROI information from region props
% output:
%   CroppedImage: cropped image
if size(CellRegion)==0
    CroppedImage=I;
else
    x=floor(CellRegion(1));
    dx=floor(CellRegion(3));
    y=ceil(CellRegion(2));
    dy=ceil(CellRegion(4));
    [a,b]=size(I);
    CroppedImage=I(max(1,y):min(y+dy,a),max(1,x):min(x+dx,b));
end
end