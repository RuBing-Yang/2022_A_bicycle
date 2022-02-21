%file: nonlcon.m
function [ce, ceq] = nonlcon_P(P)
    %非线性约束条件nonlcon
    global W
    global n
    global CP
    global Pm
    global det_L
    global times
    global det_T
    global E0
    
    ce = [];
    ceq = [];
    exertion = E0;
    if length(det_T) == 0
        v = P2v(P);
    end
      
    for i=1:n
        exertion = exertion + (Pm-CP) * (P(i)-CP) / W / (Pm-P(i)) * det_T(i);
        exertion = max(0, exertion);
        ce = [ce, exertion-1];
    end
	times = times + 1;
	if mod(times,1000) == 0
        times
    end
end