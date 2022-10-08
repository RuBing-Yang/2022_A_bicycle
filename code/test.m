    x_3d = zeros(n,3);
    x_3d(:,1) = x_L;
    x_3d(:,3) = h;
    v0 = 1;
    L = 40000;
    vmax = 20;
    r = 1000*ones(1,n);
    rho = 1000*ones(1,n);
    miu = 0.0035*ones(1,n);
    beta = zeros(1,n);
    
    
    V0 = 1;
    route();
    vw = 10;
    beta0 = pi/6;
    filename = ['wind_', num2str(vw), '_' , num2str(beta0), '.xlsx'];
    beta = beta0-theta;
    miu = 0.0035*ones(1,n);
    miu_s = 0.02*ones(1,n);
    vmax = 15;
    vlimit = ones(1,n) * vmax;


    options=optimoptions(@fmincon,'Algorithm','sqp','MaxFunEvals',100000,'MaxIter',10000,'GradObj', 'on');
    [P,fval] = fmincon('func_P',CP*rand(n,1),[],[],[],[],zeros(1,n),Pm*ones(n,1),'nonlcon_P',options);
    fval
    v = P2v(P);
    
    figure
    plot(x_L, v, 'ok-', 'linewidth', 1.1, 'markerfacecolor', [36, 169, 225]/255)%»­Í¼v-x_L
    xlabel('position(m)');
    ylabel('velocity(m/s)');
    set(gca, 'linewidth', 1.1, 'fontsize', 16, 'fontname', 'times')

    figure
    plot(x_L, P, 'ok-', 'linewidth', 1.1, 'markerfacecolor', [29, 191, 151]/255)
    xlabel('position(m)');
    ylabel('power(W)');
    title(['Power distribution with Total time ',num2str(sum(det_T)), '(s)']);
    set(gca, 'linewidth', 1.1, 'fontsize', 16, 'fontname', 'times')
    
    ontname', 'times')

    exertion = 0;
    E = [];
    for i=1:n
        exertion = exertion + (Pm-CP) * (P(i)-CP) / W / (Pm-P(i)) * det_T(i);
        exertion = max(0, exertion);
        E = [E exertion];
    end