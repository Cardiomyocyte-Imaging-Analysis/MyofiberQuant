function [CellLength, CellWidth, CellArea, MFArea, Density, PIndex, Alignment, HIndex]=ProcessImage_combined(Path,File,dirOut)
% Read local .tif image and perform initial analysis, important data will
% be stored in a .mat file. A .jpg image of the analysis process on the
% specific image will also be produced
% The programs will also flash the image to full screen before being saved
% Depending on the size and complexity of the image, one image can take up
% to 20s to process.
% input:
%   Path: the local path where the file is stored at, string
%   File: the filename that end with ".tif", string
% output:
%   a .mat file containning several variable will be saved under the same
%   directory with the same name as the file. The information include 1)
%   the ROI being segmented(CellRegion), along with the information about
%   fitted ellipse. The detected peaks after selection will be saved,in case
%   different connecting scheme is needed. Unselected Myofibrils were
%   saved, while the selection strategy is stored in MyofibrilFilter.m
%   a .jpg file containing several images regarding the analysis process is
%   saved under the same directory with the same as the file. Note that the
%   parameters on the bottom-right are convinient calculations and may be
%   different with the final result
%
%
warning('off', 'curvefit:fit:equationBadlyConditioned');
warning('off', 'MATLAB:polyshape:boolOperationFailed')

close all;
cd(Path)
I=imread(File);
I=double(I(:,:,1));
% a feature in the source images
[CellRegion,Mask,Direction,Threshold,MFArea,CellArea,Hull]=FindROI(I);
Direction=-Direction;
% the orientation calculated here are using the bottom left corner as (0,0)
% while after using imshow(), the (0,0) point will be shifted to top right
% corner. For convinience in future calculation, the Direction is reversed
% here
cropImage=CropImage(I, CellRegion);
cropMask=CropImage(Mask, CellRegion);
PIndex=PeriIndex(cropMask,cropImage);
HIndex=Heterogeneity(cropMask,cropImage);
% Mask is a binary mask over the focused cell
PeakIndex=getPeaks(cropImage);
% using vertical line scan to detect peaks in the image
PeakIndex1=PeakFilter(PeakIndex, cropMask);
% remove some peaks that are detrived from noisy data.
Myofibrils=getMyofibrils(PeakIndex1,cropMask);
% connect peaks to get myofibrils
[Myofibrils_A, Myofibrils_L, Myofibrils_I, Myofibrils_D]=MyofibrilAssess(Myofibrils,PeakIndex1);
% calculate properties of the myofibrils
AcceptedMyofibril=MyofibrilFilter(Myofibrils,Myofibrils_A, Myofibrils_L, Myofibrils_I, Myofibrils_D);
% filter the myofibrils


% produce the jpg image
f=figure(1);
set(gcf,'WindowState','fullscreen')
% this flash the image to show the user during the process
% and this is also nessary for Matlab to produce high resolution images

subplot(3,2,1)
imshow(I,[]);
% original image

subplot(3,2,2)
imshow(cropImage,[])
% the cropped image

subplot(3,2,3)
% croped image with convex hull
imshow(cropImage,[]);
hold on
plot(Hull(:,2),Hull(:,1),'LineWidth', 3);

%% New Part
% do myofibril density info on cropImage
V = [1:2:length(cropImage)];
[locs, Area, s, focusedCell2] = verticalLineScanPeaks(V, cropImage);
%figure; subplot(2, 1, 1); imshow(cropImage, []);
[lineTrace, Myofilaments] = traceMyofilaments(V(~cellfun(@isempty,locs)), locs(~cellfun(@isempty,locs)), Area(~cellfun(@isempty,locs)), s(~cellfun(@isempty,locs)), cropImage, cropImage, length(cropImage));

sMyofilaments = sortedMyofilaments(Myofilaments, length(cropImage));
[h, A] = myofilamentDensityHeatmap(cropImage, sMyofilaments.myofilamentsMerged);
A(A~=0) = 1;


%% Old Part
figure(f);
subplot(3,2,4)
% cropped image with myofibrils overlay
imshow(cropImage.*cropMask,[])
hold on
for i=1:length(AcceptedMyofibril)
    tempM=Myofibrils{AcceptedMyofibril(i)};
    plot(tempM(:,2),tempM(:,1))
end

subplot(3,2,5)
% cropped image with myofibril overlay
imshow(A);
[a,b]=size(cropImage);
% imshow(cropImage,[])
% hold on
% for i=1:length(AcceptedMyofibril)
%     tempM=Myofibrils{AcceptedMyofibril(i)};
%     y=tempM(:,2)';
%     x1=tempM(:,1)'+3;
%     x2=tempM(:,1)'-3;
%     plot(y, x1, 'y','LineWidth', 2);
%     plot(y, x1, 'y','LineWidth', 2);
%     y2 = [y,fliplr(y)];
%     inBetween = [x1, fliplr(x2)];
%     fill(y2, inBetween, 'y');
% end


subplot(3,2,6)
% several parameters to check the analysis process
CellLength=b;
CellWidth=a;
CellArea=sum(sum(Mask));
MFArea=sum(sum(A));
Density=MFArea/CellArea;

ta=[2:-4/a:0,0:4/a:2];
ta(find(ta==0))=[];
tb=[2:-4/b:0,0:4/b:2];
tb(find(tb==0))=[];
Alignment=sum(abs(Myofibrils_D(AcceptedMyofibril)-Direction).*...%weighted by length
    Myofibrils_L(AcceptedMyofibril))/sum(Myofibrils_L(AcceptedMyofibril));


Str={['Cell length:     ',num2str(CellLength)],...
    ['Cell width:      ',num2str(CellWidth)],...
    ['Cell area:       ',num2str(CellArea)],...
    ['Total MF Area:   ',num2str(MFArea)],...
    ['MF density:      ',num2str(Density)],...
    ['Peripheral Index:',num2str(PIndex)],...
    ['Heterogeneity:   ',num2str(HIndex)],...
    ['Alignment:       ',num2str(Alignment)]};
text(0,0.5,Str)

axis off

% save the .mat file, note that end-4 is based on the assumption of .tif
% ending of the file name
File = char(File);
filename=strcat(Path,'\',File(1:end-4),'.mat');
save(filename, 'CellRegion','PeakIndex1', 'Myofibrils','Direction','Threshold');
% save the .jpg file
filename=strcat(Path,'\',dirOut,'\',File(1:end-4),'.jpg');
saveas(gcf,filename)
close all;

end