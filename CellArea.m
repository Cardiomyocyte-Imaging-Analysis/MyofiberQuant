function [Hull,Area,MFArea,BWC]=CellArea(I,threshold,CellRegion)
% calculate cell area based on pre-calculated threshold and cell region
% the threshold is calculated by clustering the fluorescence intensity in
% the image. Here the CellArea function further uses edge smoothing to fine
% tune the detected boundaries of the cell
% Input:
%   I: a grey scale image
%   threshold: threshold of the image calculated by clustering intensity
%   CellRegion: derived from Regionprops, labels the ROI
% Output:
%   Hull: a list of 2D coordinates representing the 2-D convex hull
%   Area: the area of the polygon hull
%   MFArea: the area of the thresholded image
%   BWC: export the mask so it can be printed

% get cropped image area
cropImage=CropImage(I,CellRegion);
% creat mask based on threshold
BWs = cropImage>threshold;
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
[kk,Area]=convhull(x,y);% the cell area is defined by the area in the conves hull
Hull=[y(kk),x(kk)];% get the hull to plot it in the summary
end