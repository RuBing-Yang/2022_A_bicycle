%file: nonlcon.m
function [ce, ceq] = nonlcon_P(P)
    %非线性约束条件nonlcon
    global W
    global n
    global CP
    global Pm
    
    ce = [];
    ceq = [];
    exertion = 0;
      
    for i=1:n
        exertion = exertion + (Pm-CP) * (P(i)-CP) / W / (Pm-P(i));
        exertion = max(0, exertion);
        ce = [ce, exertion-1];
    end
end