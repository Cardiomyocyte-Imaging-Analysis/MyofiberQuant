function [h, A] = myofilamentDensityHeatmap(cropImage, mergedMyofilaments)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
A = zeros(size(cropImage));
for jj = 1:length(mergedMyofilaments)
    A = makeTable(A, mergedMyofilaments{jj});
end
figure; h = heatmap(A, 'CellLabelColor','none', 'GridVisible', 'off');
x = length(h.XDisplayLabels);
space = repmat(' ',[x 1]);
c = cellstr(space);
h.XDisplayLabels = c;
y = length(h.YDisplayLabels);
space = repmat(' ',[y 1]);
c = cellstr(space);
h.YDisplayLabels = c;
h.Title = 'Myofilament Density';
end

