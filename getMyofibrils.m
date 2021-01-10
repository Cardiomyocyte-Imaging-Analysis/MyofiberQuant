function Myofibrils=getMyofibrils(PeakIndex,CropImage)
% connect peaks based on the peaks being detected
% input:
%   PeakIndex: created by the getPeaks function, is an 2D matrix whose
%   content is subject to change, it should contain peak coordinates in the
%   first two columns, peak height in the 3rd column, peak width in the 4th
%   column, peak prominence in the 5th column
%   CropImage: only serve as in indicator of the size of the image, it
%   doesn't matter whether the cropped image or the mask was passed over
% Output:
%   Myofibirls: an array of cells, each cell contains a 2*x matrix that 
%   stores the coordinates of the connected peaks  


[a,b]=size(CropImage);
Map=zeros(a,b);
Myofibrils={};
tempM=[];

for i=1:length(PeakIndex)
    Map(PeakIndex(i,1),PeakIndex(i,2))=1;
    % initialize the map of peaks
end
for i=1:length(PeakIndex)
    tempM=[];
    if Map(PeakIndex(i,1),PeakIndex(i,2))==1
        Current=[PeakIndex(i,1),PeakIndex(i,2)];
        while Map(Current(1),Current(2))==1
            tempM=[tempM;Current];
            Next=Search(Current, Map);
            if isempty(Next)
                Map(Current(1),Current(2))=0;
                % myofibril fail to connect, end while loop
            else
                Map(Current(1),Current(2))=0;
                % whenver the peak is being connected, remove this peak
                Current=Next;
                % go to next node
            end
        end
    end
    if ~isempty(tempM)
        Myofibrils=[Myofibrils,{tempM}];% attach new myofibril
    end
end
end