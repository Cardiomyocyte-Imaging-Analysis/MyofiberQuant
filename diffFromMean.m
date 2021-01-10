function percentSame = diffFromMean(data, average)
% Determines the heterogeneity of a single segment of a myofilament.  A value closer to
% one means that the segment is relatively similar to the average density
% of the myofilament
% while a  value closer to 0 indicates that the segment is relatively
% different from othe average density across its length
% INPUT: data -- density profile of a segment of a myofilament
% average -- average density of the entire myofilament
% OUTPUT: percentDiff -- percent similar to average  density 
avgData = mean(data);
percentSame = abs(avgData - average)/average;
percentSame = 1 - percentSame;
end

