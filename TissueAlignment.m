function Alignment=TissueAlignment(Myofibrils_D,Myofibrils_L)
% Use the length of the myofibrils as weight and got the weighted standard
% deviation of the angle of the linear fit of them
weight=Myofibrils_L/sum(Myofibrils_L);
w_mean=sum(weight.*Myofibrils_D);
Alignment=sqrt(sum((Myofibrils_D-w_mean).^2.*weight)...
    /(length(Myofibrils_L)-1));
Alignment=Alignment/w_mean;
end