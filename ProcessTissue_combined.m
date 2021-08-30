function [Length, Width, Area, MFArea, Densitya, PIndex, Alignment, HIndex]=ProcessTissue_combined(Path,File,dirOut)
% Read local .tif image and perform initial analysis. A .jpg image of the analysis process on the
% specific image will also be produced
% The programs will also flash the image to full screen before being saved
% Depending on the size and complexity of the image, one image can take up
% to 20s to process.
% there are slight changes to the ProcessImage as this one is intended for
% tissue images. Changes include name of the parameters and calculation of
% MFArea, MF density, Alignment and so on.
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

cd(Path)
I=imread(File);
I=double(I(:,:,1));
% a feature in the source images
[CellRegion,Mask,Direction,Threshold,~,Area,Hull]=FindROI(I);
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
%[Myofibrils_A, Myofibrils_L, Myofibrils_I, Myofibrils_D, Myofibrils_R]=MyofibrilAssess(Myofibrils,PeakIndex1);
% calculate properties of the myofibrils
%AcceptedMyofibril=MyofibrilFilter(Myofibrils,Myofibrils_A, Myofibrils_L, Myofibrils_I, Myofibrils_D);
% filter the myofibrils


% produce the jpg image
f=figure(1);
set(gcf,'WindowState','maximized')
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

subplot(3,2,4)
% cropped image with myofibrils overlay
imshow(cropImage.*cropMask,[])
hold on

subplot(3,2,5)
% cropped image with myofibril overlay
hold on
[a,b]=size(cropImage);
MFAreaMask=zeros(a,b);

%% new stuff
cropImage = cropImage.*cropMask;

V = [1:2:length(cropImage)];
[locs, Area, s, focusedCell2] = verticalLineScanPeaks(V, cropImage);
%figure; subplot(2, 1, 1); imshow(cropImage, []);
[lineTrace, Myofilaments] = traceMyofilaments(V(~cellfun(@isempty,locs)), locs(~cellfun(@isempty,locs)), Area(~cellfun(@isempty,locs)), s(~cellfun(@isempty,locs)), cropImage, cropImage, length(cropImage));

sMyofilaments = sortedMyofilaments(Myofilaments, length(cropImage));
[h, A] = myofilamentDensityHeatmap(cropImage, sMyofilaments.myofilamentsMerged);
A(A~=0) = 1;
figure(f);
subplot(3, 2, 5);
imshow(A, []);

figure(f);
subplot(3, 2, 4); hold on;
for i = 1:length(sMyofilaments.myofilamentsMerged)
    x = sMyofilaments.myofilamentsMerged{i}.xPath;
    y = sMyofilaments.myofilamentsMerged{i}.yPath;
    plot(x, y);
end

% determine the alignment of the myofibrils

Len = length(sMyofilaments.myofilamentsMerged);
Myofibrils_L=zeros(1,Len);
Myofibrils_D=zeros(1,Len);
for i=1:Len
    %tempA=0;
    %tempI=0;
    tempM=sMyofilaments.myofilamentsMerged{i};
    [Mlen,~]=size(tempM.xPath);
    
    % linear regression
    X=[ones(Mlen,1),tempM.xPath];
    y=tempM.yPath;
    tempb=X\y;
    %tempcaly=X(:,2)*tempb(2)+tempb(1);
    tempD=tempb(2);% tan(alpha)
    tempD=atan(tempD);%radians direction
    Myofibrils_D(i)=-tempD/pi;% angel direction
    % because coordinates are counted from the top-left corner,
    % the direction needed to be reversed
    Myofibrils_L(i)=Mlen;
end


%% how to plot myofibrils???

%% continue old stuff

figure(f);
subplot(3,2,6)
% several parameters to check the analysis process
Length=b;
Width=a;
Area=sum(sum(Mask));
MFArea=sum(A(:));
Densitya=MFArea/Area;

Alignment=TissueAlignment(Myofibrils_D,...
    Myofibrils_L);


Str={['Tissue length:     ',num2str(Length)],...
    ['Tissue width:      ',num2str(Width)],...
    ['Tissue area:       ',num2str(Area)],...
    ['Total MF Area:     ',num2str(MFArea)],...
    ['MF density:        ',num2str(Densitya)],...
    ['Peripheral Index:  ',num2str(PIndex)],...
    ['Heterogeneity:     ',num2str(HIndex)],...
    ['Alignment:         ',num2str(Alignment)]};
text(0,0.5,Str)
axis off

disp('Output Values:');
disp(Length);
disp(Width);
disp(Area);
disp(MFArea);
disp(Densitya);
disp(PIndex);
disp(Alignment);
disp(HIndex);

% save the .jpg file, note that end-4 is based on the assumption of .tif
% ending of the file name
filename=[Path,'\',dirOut,'\',File(1:end-4),'.jpg'];
saveas(gcf,filename)
disp(File);
disp('Successfully completed!');
close all

end