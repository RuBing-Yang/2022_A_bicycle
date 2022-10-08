function P = v2P(v)

    global n
    global beta
    global alpha
    global rho
    global M
    global g
    global miu
    global K
    global vw
    global det_L
    global CP
    
    P = zeros(1,n);
    P(1) = CP;
    for i = 2:n
        f = M*(g*cos(alpha(i))+v(i).^2/rho(i))*miu(i); %滚动摩擦力
        f_G = M*g*sin(alpha(i)); %重力分量
        v_vw = v(i) - vw*cos(beta(i)); %纵向逆风相对复苏
        v_vw = max(v_vw, 0);
        fw = K * v_vw.^2; %空气阻力

        F = f + f_G + fw;
        dEk = 0.5*M*(v(i).^2 - v(i-1).^2);
        P(i) = F*v(i) + dEk*v(i)/det_L(i);
    end
end