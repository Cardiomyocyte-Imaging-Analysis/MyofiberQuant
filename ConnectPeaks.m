function [Myofibrils,Flag]=ConnectPeaks(PeakIndex)
Flag=zeros(1,length(PeakIndex(:,1)));
Myofibrils={};
tempFlag=0;
tempCandidate=[];
Current=0;


for i=2:length(Flag)
    tempM=[];
    if Flag(i)==0
        % an unconnected node
        
        Current=i;
        Flag(Current)=-1;
        MyofibrilNumber=length(Myofibrils)+1;
        while tempFlag>-1
            % which means currently extending a myofibril
            X1=[PeakIndex(Current,2),PeakIndex(Current,1)];
            tempM=[tempM;PeakIndex(Current,:)];
            tempCandidate=[];
            f or j=Current+1:length(Flag)
                % look rightward to only extend myofibril to the right
                if Flag(j)==0
                    % see if this node is in range
                    Xt=[PeakIndex(j,2),PeakIndex(j,1)];
                    if PeakIndex(j,2)-PeakIndex(Current,2)<5 && abs(PeakIndex(j,1)...
                            -PeakIndex(Current,1))<3
                        tempCandidate=[tempCandidate;[j,pdist([X1;Xt])]];
                    end
                end
            end
            if isempty(tempCandidate)
                % see if any match was found
                tempFlag=-1;
            else
                ClosestNode=find(tempCandidate(:,2)==min(tempCandidate(:,2)));
                Current=tempCandidate(ClosestNode(1),1);
                Flag(Current)=MyofibrilNumber;
                MyofibrilNumber
                Flag(Current)
                % choose the closest one on the top
            end
        end
        % ending while loop means myofibril has been cut off
        if length(tempM)>0
            Myofibrils=[Myofibrils,{tempM}];
            Flag(i)=MyofibrilNumber;
        end
    end
end
end