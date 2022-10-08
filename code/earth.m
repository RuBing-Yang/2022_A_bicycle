function earth(filename)
    %利用Google Earth数据
    %维度北极90度，南极-90度，经度向东增长0-360度
    %将整个赛道所在地表面近似为地球切面平面，建立XYZ坐标系
    %经纬度转为x-y值，z转为高度值h
    %y正方向为北，x正方向为东
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
    
    rawdata = xlsread(filename);
    x = zeros(n,1);
    y = zeros(n,1);
    h = zeros(n,1);
    theta = zeros(n,1);
    latitude0 = rawdata(1,1) + rawdata(1,2)/60 + rawdata(1,3)/3600; %纬度(degree)
    Re = 6371*1000; %地球半径(m)
    re = Re * cos(latitude0 * pi / 180); 
    
    %变化相对较小，减去初始
    rawdata(:,1:7) = rawdata(:,1:7) - rawdata(1,1:7);
    
    x_L = [];
    n = size(rawdata,1);
    x_L(1) = 0.0;
    for i = 1:n
        latitude = rawdata(i,1) + rawdata(i,2)/60 + rawdata(i,3)/3600; %纬度(degree)
        longitude = rawdata(i,4) + rawdata(i,5)/60 + rawdata(i,6)/3600;  %经度(degree)
        y(i) = Re * latitude * pi / 180; 
        x(i) = re * longitude * pi / 180; 
        h(i) = rawdata(i,7);
        %alpha(i) = asin(rawdata(i,8) / 100.0);
    end
    
    alpha = zeros(1,n);
    for i = 2:n
        dx = x(i) - x(i-1);
        dy = y(i) - y(i-1);
        dh = h(i) - h(i-1);
        
        det_L(i) = sqrt(dx^2 + dy^2 + dh^2); %d路程
        alpha(i) = asin(dh / det_L(i));
        
        x_L(i) = x_L(i-1) + det_L(i);
        theta(i) = - atan(dx/dy); %速度方向
        
        beta(i) = beta0 - theta(i); %迎风角
    end
    
    L = x_L(n);
    r = 10000*ones(n,1);
    rho = 10000*ones(n,1);
    for i = 3:n
        d_theta = theta(i) - theta(i-1);
        r(i) = abs(det_L(i) / d_theta); %转弯曲率半径
        d_alpha = alpha(i) - alpha(i-1);
        rho(i) = abs(det_L(i) / d_alpha); %斜面曲率半径
    end
    global x_3d
    x_3d = [x, y, h];
    