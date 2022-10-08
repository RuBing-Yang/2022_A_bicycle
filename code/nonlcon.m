%file: nonlcon.m
function [ce, ceq] = nonlcon(v)
%非线性约束条件nonlcon
%迭代：速率集合v_try
    global W
    global n
    global CP
    global Pm
    global v0
    %V = 1:n;
    %V(1) = (v_try(1)+v0)/2;
    %for i=2:n
        %V(i)=(v_try(i)+v_try(i-1))/2;
    %end
    
    ce = -1;
    ceq = [];
    V = [v0, v];
    exertion = 0;
    P = v2P(V);
    if max(P) >= Pm || min(P) < 0
        max(P)
        min(P) 
        ce = 1;
    else
        for i=2:n
            exertion = exertion + (Pm-CP) * (P(i)-CP) / W / (Pm-P(i));
            exertion = max(0, exertion);
            if exertion > 1
                exertion
                ce = 1;
                break
            end
        end
    end
end