function [BoundingBox,Mask,Direction,Threshold,MFArea,CellArea,Hull]=FindROI(I)
% Find the location of the cell with in the image, helps to reduce
% detected peaks, thus reduce calculation load. Also helps to visualize the
% myofibril detection.
% The function use edge detection to find the cell.
% input:
%   I: 2D double matrix, storing the fluorescence intensity in each pixel
% output:
%   Mask: a 2D logical matrix masking over the focused cell
%   BoundingBox, Centroid, MajorAxisLength,MinorAxisLength,Direction: these
%   are properties derived from the regionprops() function. it uses a
%   ellipse to fit the connected area and return the information about the
%   ellipse
%   threhold: the threshold being used in the primary thresholding, where
%   the problem is most likely to occur

% set a matrix of zeros for returning the mask
Mask=zeros(size(I));
% sample proper threshold from the distribution of intensity in the image
Intensity=sort(reshape(I,[],1));
% cluster the pixel values into 2 category using kmeans
idx=kmeans(Intensity,2);
if idx(1)==1 %chances are that some clustering would reverse 1 and 2
    Threshold=Intensity(sum(idx==1));
else
    Threshold=Intensity(sum(idx==2));
end

% remove as much background as possible
I1=I;
I(I<max(Threshold))=0;
% smooth the image, preventing cut-off introduced peaks
I=medfilt2(I);
% try to connect points in the cell area, and close the area 
% size of the disk could be tuned larger to help connect the cell area
[~, thresh] = edge(I, 'sobel');
fudgeFactor = 0.5;
BW = edge(I,'sobel', thresh * fudgeFactor);
SE = strel('disk', 10);
BW=imdilate(BW,SE);
BW=imfill(BW,'holes');
CC=bwconncomp(BW);
numPixels = cellfun(@numel,CC.PixelIdxList);
% obviously, the largest area should be the cell
% but beware that low sample threshold could make large noise area as well
% look for this in other sample images
[~,idx] = max(numPixels);
BoundingBox=[];
if ~isempty(idx)
    % for interepted frames in video/z scan 
    Mask(CC.PixelIdxList{idx}) = 1;
    Props=regionprops(CC,'BoundingBox','Orientation','Centroid',...
        'MajorAxisLength','MinorAxisLength');
    BoundingBox=Props(idx).BoundingBox;
    Direction=Props(idx).Orientation;
    Centroid=Props(idx).Centroid;
    MajorAxisLength=Props(idx).MajorAxisLength;
    MinorAxisLength=Props(idx).MinorAxisLength;
end
% get cropped image area
cropImage=CropImage(I,BoundingBox);
% creat mask based on threshold
BWs = cropImage>Threshold;
% clean the mask, delete those with less than 10 pixels
BWC=bwareaopen(BWs,10);
MFArea=sum(sum(BWC));
% set k to iterate over boundries longer than
k=1;
% generate the boundaries
B=bwboundaries(BWC);
for i=1:length(B)
    bb=B{i};
    if length(bb(:,1))>20 % ignore the boundaries shorter than 20
        bbx=bb(:,2);
        bby=bb(:,1);
        % use Savitzky-Golay filtering to smooth the boundaries
        sbbx=sgolayfilt(bbx, 2, 15);
        sbby=sgolayfilt(bby, 2, 15);
        SB{k}=[sbby,sbbx];
        k=k+1;
    end
end
BP=[];% reorganize the boundaries to calculate the convex hull
for i=1:length(SB)
    bb=SB{i};
    BP=[BP;bb];
end
x=BP(:,2);
y=BP(:,1);
[kk,CellArea]=convhull(x,y);% the cell area is defined by the area in the conves hull
Hull=[y(kk),x(kk)];% get the hull to plot it in the summary
[a,b]=size(cropImage);
tMask = poly2mask(Hull(:,2),Hull(:,1),a,b);
Mask=ReverseCrop(I,BoundingBox,tMask);
end
