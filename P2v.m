function v = P2v(P)

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
    
    v = zeros(1,n);
    v(1) = v0;
    for i = 2:n
        [a,b] = ode45(@dpdv, [0 det_L(i)], v(i-1), [], P, i);
        v(i) = b(length(b));
    end
end