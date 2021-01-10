function Index=PeriIndex(Mask, cropImage)
% calculate the peripheral index of the cell, this function takes in
% detected cell area and calculate the sum of the indensities in the
% horizontal direction, as most of the cell in the dataset are aligned with
% the image.
% input:
%   Mask: calculated from the convex hull of the cell area
%   cropImage: calculated from the bounding box of the raw segmentation,
%   representing a refined ROI
% output:
%   Index: peripheral index, the larger it is, the more indensity are on
%   the peripheralof the cell, i.e. less indensity distributed in the
%   center. range of Index is [0,100]
CellArea=Mask.*cropImage;
[a,b]=size(Mask);
distribution=zeros(1,a);
reference=zeros(1,a);
top=1;
bot=a;
for i=1:a
    if top==1 && sum(Mask(i,:))>0 %find top row
        top=i;
    end
    if sum(Mask(i,:))>0 %find bot row
        bot=i;
    end
    reference(i)=sum(cropImage(i,:));%use the original image to include background
end
width=bot-top+1;
if mod(width,2)==1 % if the width is an odd number
    tempd=[0:4/width:2];
    distribution(top:top+floor(width/2)-1)=tempd(end:-1:2);
    distribution(top+floor(width/2)+1:bot)=tempd(2:end);
    distribution(top+floor(width/2))=width-sum(distribution);
    distribution=distribution/width;
else
    tempd=[0:4/(width-2):2]; % if the width is an even number
    distribution(top:top+floor(width/2)-1)=tempd(end:-1:1);
    distribution(top+floor(width/2):bot)=tempd;
    distribution=distribution/width;
end
Index=sum(reference.*distribution)/sum(reference)*100;
end