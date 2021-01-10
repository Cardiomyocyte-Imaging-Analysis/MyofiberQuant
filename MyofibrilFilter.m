function AcceptedMyofibril=MyofibrilFilter(Myofibrils,Myofibrils_A, Myofibrils_L, Myofibrils_I, Myofibrils_D)
% briefly rule out short, dim myofibrils that are more likely to be false
% detection or does not carry much importance
% input: 
%   Myofibirls: the connected myofibrils
%   Myofibirls_*: properties of the myofibril to be evaluated
% output: 
%   AcceptedMyofibril: index of accepted myofibril

% initialize indexes
AcceptedMyofibril=[1:length(Myofibrils)];
for i=1:length(Myofibrils)
    if Myofibrils_L(i)<5
        % myofibrils that are too short
       AcceptedMyofibril(i)=0;
    end
    if Myofibrils_I(i)<100
        % myofibrils that are too dim
       AcceptedMyofibril(i)=0;
    end
    if abs(Myofibrils_D(i))>5
        % myofibirls that are largely miss aligned
        AcceptedMyofibril(i)=0;
    end
end
AcceptedMyofibril(AcceptedMyofibril==0)=[];
end
