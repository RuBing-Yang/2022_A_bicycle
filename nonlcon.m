%file: nonlcon.m
function [ce, ceq] = nonlcon(v)
%非线性约束条件nonlcon
    global W
    global beta
    global alpha
    global rho
    global n
    global M
    global g
    global miu
    global K
    global vw
    global detx
    global CP
    global v0
    V = 1:n;
    V(1) = (v(1)+v0)/2;
    for i=2:n
        V(i)=(v(i)+v(i-1))/2;
    end
    ce = 0;
    ceq = [];
    for i=1:n
        WF = M*(g*cos(alpha(i))+V(i).^2/rho(i))*miu(i);
        WG = M*g*sin(alpha(i));
        WW = K*(V(i)+vw*sin(beta(i))).^2;
        
        t =  detx(i)/cos(alpha(i))/V(i);
        if i==1
            ce = ce + max(0,(WF+WG+WW)*detx(i)/cos(alpha(i)) + 0.5*M*(v(i).^2) - CP * t);
        else
            ce = ce + max((WF+WG+WW)*detx(i)/cos(alpha(i)) + 0.5*M*(v(i).^2-v(i-1).^2) - CP * t,0);
        end
    end
    ce = ce - W;
    
end