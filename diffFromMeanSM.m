function percentSame = diffFromMeanSM(myofilamentDensity, average)
% Determines heterogeneity of myofilaments within a cell.  Values closer to
% 1 indicate a more homogeneous cell, while values closer to 0 indicate a
% more heterogeneous cell
% INPUT: myofilamentDensity -- array containing the average density of each
% myofilament
% average -- average density of all myofilaments
% OUPUT: percentSame -- average of the percent that each myofilament is
% equal to the average segment of myofilament

percentSame = abs(myofilamentDensity - average)/average;
percentSame = mean(percentSame);
percentSame = 1 - percentSame;
end

