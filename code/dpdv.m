function dv = dpdv(x,vx,P,i)
    
    global beta
    global alpha
    global rho
    global M
    global g
    global miu
    global K
    global vw
    
    f = miu(i)*M*(g*cos(alpha(i))+vx^2/rho(i)); %滚动摩擦力
    f_G = M*g*sin(alpha(i)); %重力分量
    v_vw = vx - vw*cos(beta(i)); %纵向逆风相对速度
    fw = K * v_vw^2; %空气阻力
    F = f + f_G + fw;
    dv = P(i)/M/vx^2 - F/M/vx;
    
end

