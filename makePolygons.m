function [pgon, s] = makePolygons(lcs, w, c4)
% creates polygons corresponding to peaks found from an intensity profile
% from the gaussian fit of each peak
% INPUT: lcs -- location of peaks
% w -- width of peaks
% pks -- height of peaks
% c4 -- intensity profile from which lcs, pks, and w were gathered
% OUTPUT: pgon -- array of polygons corresponding to peaks in pks
% s -- array of the standard deviation for each Gaussian fit

pgon = [];
s = [];
b1 = [];
if length(lcs) /2  ~= round(length(lcs) / 2)
    a = 1:floor(length(lcs)/2);
    b = length(lcs):-1:ceil(length(lcs)/2 + 1);
    c = [reshape(a, [length(a), 1]), reshape(b, [length(b), 1])]';
    c = [c(:); ceil(length(lcs)/2)];
else
    a = 1:length(lcs)/2;
    b = length(lcs):-1:length(lcs) / 2 + 1;
    c = [reshape(a, [length(a), 1]), reshape(b, [length(b), 1])]';
    c = c(:);
end
c4 = double(c4);
for jj= 1:length(c)
    peak = c(jj);
    loc = lcs(peak);
    if w(peak) < 4
        range1 = 2;
        range2 = 2;
    elseif w(peak) < 10
        range1 = floor(0.5*w(peak));
        range2 = 3;
    else
        range1 = 4;
        range2 = 3;
    end
    if peak > length(lcs) / 2
        xrange = loc - range2 : loc + range1;
    else
        xrange = loc - range1 : loc + range2;
    end
    opts = fitoptions('Method', 'NonlinearLeastSquares');
    opts.Upper = [Inf Inf 20];
    opts.Lower = [0 0 0];
    f = fit(xrange', c4(xrange), 'gauss1', opts);
    s(peak) = f.c1/sqrt(2);

    y = f(1:length(c4));

    ar(peak) = polyarea(1:length(c4), y');
    xdata = 1:length(c4);
    ydata = y';
    ydata(ydata < 0.1) = 0;
    pgon(peak).shape = polyshape(xdata, ydata);
    y = pgon(peak).shape.Vertices(:, 2);
    y = y(~isnan(y));
    x = pgon(peak).shape.Vertices(:, 1);
    x = x(~isnan(x));
    c4(round(x)) = c4(round(x)) - y;
end

end

