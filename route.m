function [x,y,z] = route()
    global n
    global alpha
    global beta
    global beta0
    global theta
    global det_L
    global L
    global x_L
    global rho
    global r
    l = 1/50;
    u = 50;
    dh = 25;
    x1 = 10:10:100;
    y1 = (-((10:10:100)-50).^2+2500) * l;
    z1 = linspace(0,-dh/2,10);

    x2 = max(x1) + (10:10:100);
    y2 = (((10:10:100)-50).^2-2500) * l;
    z2 = linspace(-dh/2,0,10);

    x3 = max(x2) + (10:10:100);
    y3 = (-((10:10:100)-50).^2+2500) * l;
    z3 = linspace(0,dh/2,10);

    x4 = max(x3) + (10:10:50);
    y4 = (((10:10:50)-50).^2-2500) * l;
    z4 = linspace(dh/2,dh/2,5);

    x5 = max(x4) + (5:5:200);
    y5 = -2500*l*ones(1,40);
    z5 = dh/2 + sin(2*pi/50*(5:5:200))*dh/2;

    x6 = max(x5) + (10:10:50);
    y6 = sqrt(2500-(10:10:50).^2)-5000*l;
    z6 = linspace(dh/2,dh/2,5);

    x7 = max(x6) + (-10:-10:-50);
    y7 = -sqrt(2500-(50+(-10:-10:-50)).^2)-5000*l;
    z7 = linspace(dh/2,dh/2,5);

    x8 = min(x7) + (-20:-20:-200);
    y8 = zeros(1,10)-7500*l;
    z8 = linspace(dh/2,-dh/2,10);

    x9 = min(x8) + (-3:-3:-150);
    y9 = cos(2*pi/50*(3:3:150))*u-u-7500*l;
    z9 = zeros(1,50)-dh/2;

    x10 = min(x9) + (-20:-20:-200);
    y10 = zeros(1,10)-7500*l;
    z10 = zeros(1,10)-dh/2;

    x = [x1,x2,x3,x4,x5,x6,x7,x8,x9,x10];
    y = [y1,y2,y3,y4,y5,y6,y7,y8,y9,y10];
    z = [z1,z2,z3,z4,z5,z6,z7,z8,z9,z10];
    
    [low, col] = size(x);
    n = col;
    x_L = zeros(n,1);
    alpha = zeros(n,1);
    beta = zeros(n,1);
    theta = zeros(n,1);
    for i = 2:n
        dx = x(i) - x(i-1);
        dy = y(i) - y(i-1);
        dz = z(i) - z(i-1);
        
        det_L(i) = sqrt(dx^2 + dy^2 + dz^2); %d路程
        alpha(i) = asin(dz / det_L(i));
        
        x_L(i) = x_L(i-1) + det_L(i);
        theta(i) = - atan(dx/dy); %速度方向
        
        beta(i) = beta0 - theta(i); %迎风角
    end
    
    L = x_L(n);
    r = zeros(n,1);
    rho = zeros(n,1);
    r(1) = 10000;
    r(2) = 10000;
    rho(1) = 10000;
    rho(2) = 10000;
    for i = 3:n
        d_theta = theta(i) - theta(i-1);
        r(i) = abs(det_L(i) / d_theta); %转弯曲率半径
        d_alpha = alpha(i) - alpha(i-1);
        rho(i) = abs(det_L(i) / d_alpha); %斜面曲率半径
    end
    global x_3d
    x_3d = [x', y', z'];
    %{
    subplot(2,2,1);
    plot([0,x],[0,y], '-o');
    xlabel('x/m');
    ylabel('y/m');
    axis equal;
    grid on;
    subplot(2,2,2);
    plot([0,x1,x2,x3,x4,x5,x6],[0,z1,z2,z3,z4,z5,z6], [x7,x8,x9,x10], [z7,z8,z9,z10]);
    xlabel('x/m');
    ylabel('height/m');
    axis equal;
    grid on;
    subplot(2,2,3);
    plot3([0,x],[0,y],[0,z]);
    xlabel('x/m');
    ylabel('y/m');
    zlabel('height/m');
    axis equal;
    grid on;
    %}
end
