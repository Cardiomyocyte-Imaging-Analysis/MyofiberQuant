function Index=Heterogeneity(Mask, cropImage)
% calculate the heterogeneity of the cell, this function takes in
% detected cell area and calculate the std of avarage the indensities in the
% vertical direction, background excluded, as most of the cell in the 
% dataset are aligned with the image.
% input:
%   Mask: calculated from the convex hull of the cell area
%   cropImage: calculated from the bounding box of the raw segmentation,
%   representing a refined ROI
% output:
%   Index: Heterogeneity, the smaller it is, the more evenly the indensity
%   are distributed along the cell.
CellArea=Mask.*cropImage;
[a,b]=size(Mask);
reference=zeros(1,b);
left=1;
right=b;
for i=1:b
    if left==1 && sum(Mask(:,i))>0 %find top row
        left=i;
    end
    if sum(Mask(:,i))>0 %find bot row
        right=i;
    end
    reference(i)=sum(CellArea(:,i));
    %use the cropped image to exclude background
end
InCell=reference(reference>0);
Index=std(InCell)/mean(InCell);
% normalize the std based on average intensity of this image
Index=exp(-Index);
% rescale the index from 0-infinite to 1-0
end