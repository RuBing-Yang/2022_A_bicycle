%file: nonlcon.m
function [ce, ceq] = nonlcon(v_try)
%������Լ������nonlcon
%���������ʼ���v_try
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
    global det_L
    global CP
    global Pm
    global v0
    %V = 1:n;
    %V(1) = (v_try(1)+v0)/2;
    %for i=2:n
        %V(i)=(v_try(i)+v_try(i-1))/2;
    %end
    
    ce = zeros(1,2*n-2);
    ceq = [v_try(1)-v0];
    exertion = 0;
    for i=2:n
        f = M*(g*cos(alpha(i))+v_try(i).^2/rho(i))*miu(i); %����Ħ����
        f_G = M*g*sin(alpha(i)); %��������
        v_vw = v_try(i) - vw*cos(beta(i)); %���������Ը���
        fw = max(K * v_vw.^2 * det_L(i), 0); %��������
        
        F = f + f_G + fw;
        dEk = 0.5*M*(v_try(i).^2 - v_try(i-1).^2);
        P = F*v_try(i) + dEk*v_try(i)/det_L(i);
        
        exertion = exertion + (Pm-CP) * (P-CP) / W / (Pm-P);
        exertion = max(0, exertion);
        
        ce(2*i-3) = exertion-1;
        ce(2*i-2) = P-Pm;
    end
end