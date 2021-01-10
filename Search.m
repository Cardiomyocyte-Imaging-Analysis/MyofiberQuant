function Next=Search(Peak, I)
Next=[];
for i=1:5
    for j=-2:2
        if I(Peak(1)+j,Peak(2)+i)==1
            Next=[Next;j,i,i*i+j*j];
        end
    end
end
if ~isempty(Next)
    Min=find(Next(:,3)==min(Next(:,3)));
    Next=[Peak(1)+Next(Min,1),Peak(2)+Next(Min,2)];
end
end