function dv = dpdv(x,vx,P,i)
    
    global n
    global beta
    global alpha
    global rho
    global M
    global g
    global v0
    global miu
    global K
    global vw
    global det_L
    global vmax

    f = miu(i)*M*(g*cos(alpha(i))+vx^2/rho(i)); %����Ħ����
    f_G = M*g*sin(alpha(i)); %��������
    v_vw = vx - vw*cos(beta(i)); %�����������ٶ�
    fw = K * v_vw^2; %��������
    F = f + f_G + fw;
    dv = P(i)/M/vx^2 - F/M/vx;
end
