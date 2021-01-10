function [Length,Width]=CellLength(Hull)
Length=max(Hull(:,2))-min(Hull(:,2));
Width=max(Hull(:,1))-min(Hull(:,1));
end