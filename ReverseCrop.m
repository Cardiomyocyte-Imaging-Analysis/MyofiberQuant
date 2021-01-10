function FullImage=ReverseCrop(I,CellRegion,CroppedMask)
% to return the cropped mask back to the origianl image size, this is
% solely made for matching the cropped mask to peak indexes
[a,b]=size(I);
FullImage=zeros(a,b);
x=floor(CellRegion(1));
dx=floor(CellRegion(3));
y=ceil(CellRegion(2));
dy=ceil(CellRegion(4));
FullImage(max(1,y):min(y+dy,a),max(1,x):min(x+dx,b))=CroppedMask;
end