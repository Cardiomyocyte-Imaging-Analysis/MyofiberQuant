function [Myofibrils_A, Myofibrils_L, Myofibrils_I, Myofibrils_D, Myofibrils_R]=MyofibrilAssess(Myofibrils,PeakIndex)
% subtract information from the connected myofibrils and PeakIndex
% input:
%   Myofibrils: created by the getMyofibirls function, is an array of
%   cells, each cell contains a 2*x matrix that stores the coordinates of the
%   connected peaks
%   PeakIndex: created by the getPeaks function, is an 2D matrix whose
%   content is subject to change, it should contain peak coordinates in the
%   first two columns, peak height in the 3rd column, peak width in the 4th
%   column, peak prominence in the 5th column
% output: 
%   Myofibrils_A: total area of the myofibiril, calculate the area of the
%   rectangle area between two peaks.
%   Myofibrils_L: length of the myofibirl
%   Myofibrils_I: avarage intensity of the myofibirl, width*prominence
%   divided by length of the myofibirl
%   Myofibirls_D: direction of the myofibril, represented by the angle between the x-axis
%   and the linear regression fit of the myofibril

Len=length(Myofibrils);

Myofibrils_A=zeros(1,Len);
Myofibrils_L=zeros(1,Len);
Myofibrils_I=zeros(1,Len); 
Myofibrils_D=zeros(1,Len);
Myofibrils_R=zeros(1,Len);
for i=1:Len
    tempA=0;
    tempI=0;
    tempM=Myofibrils{i};
    [Mlen,~]=size(tempM);
    
    % linear regression
    X=[ones(Mlen,1),tempM(:,2)];
    y=tempM(:,1);
    tempb=X\y;
    tempcaly=X(:,2)*tempb(2)+tempb(1);
    tempD=tempb(2);% tan(alpha)
    tempD=atan(tempD);%radians direction
    Myofibrils_D(i)=-tempD/pi;% angel direction
    % because coordinates are counted from the top-left corner,
    % the direction needed to be reversed
    Myofibrils_R(i)=real(sqrt(1-sum((y-tempcaly).^2)/sum((y-mean(y)).^2)));
    
    Myofibrils_L(i)=Mlen;
    for j=1:Mlen-1
        x1=tempM(j,1);% vertical coordinate
        y1=tempM(j,2);% horizental coordinate
        tempPeak1=PeakLookup(x1,y1,PeakIndex);
        x2=tempM(j+1,1);% vertical coordinate
        y2=tempM(j+1,2);% horizental coordinate
        tempPeak2=PeakLookup(x2,y2,PeakIndex);
        tempA=tempA+6*(tempPeak2(2)-tempPeak1(2));% the area of the rectangle
           % here we assume the width of the myofibrils are all
           % approximately 6 pixels in width, which is only an estimation
        tempI=tempI+tempPeak1(4)*tempPeak1(5);% adding width*prominence
    end
    Myofibrils_A(i)=tempA;
    Myofibrils_I(i)=tempI/Mlen;
end
end