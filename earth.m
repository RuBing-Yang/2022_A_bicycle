function earth()
    %����Google Earth����
    %ά�ȱ���90�ȣ��ϼ�-90�ȣ�����������0-360��
    %�������������ڵر������Ϊ��������ƽ�棬����XYZ����ϵ
    %��γ��תΪx-yֵ��zתΪ�߶�ֵh
    %y������Ϊ����x������Ϊ��
    global n
    global alpha
    global beta
    global beta0
    global theta
    global det_L
    global L
    global rho
    global r
    
    rawdata = xlsread('Tokyo.xlsx');
    size(rawdata)
    x = zeros(n,1);
    y = zeros(n,1);
    h = zeros(n,1);
    theta = zeros(n,1);
    latitude0 = rawdata(1,1) + rawdata(1,2)/60 + rawdata(1,3)/3600; %γ��(degree)
    Re = 6371*1000; %����뾶(m)
    re = Re * cos(latitude0 * pi / 180); 
    
    %�仯��Խ�С����ȥ��ʼ
    rawdata(:,1:7) = rawdata(:,1:7) - rawdata(1,1:7);
    
    n = size(rawdata,1);
    L = 0.0;
    for i = 1:n
        latitude = rawdata(i,1) + rawdata(i,2)/60 + rawdata(i,3)/3600; %γ��(degree)
        longitude = rawdata(i,4) + rawdata(i,5)/60 + rawdata(i,6)/3600;  %����(degree)
        y(i) = Re * sin(latitude * pi / 180); 
        x(i) = re * cos(longitude * pi / 180); 
        h(i) = rawdata(i,7);
        alpha(i) = asin(rawdata(i,7) / 100.0);
    end
    
    rho(1) = 10000;
    for i = 2:n
        dx = x(i) - x(i-1);
        dy = y(i) - y(i-1);
        dh = h(i) - h(i-1);
        det_L(i) = sqrt(dx^2 + dy^2 + dh^2); %d·��
        L = L + det_L(i);
        theta(i) = - atan(dx/dy); %�ٶȷ���
        beta(i) = beta0 - theta(i); %ӭ���
        d_alpha = alpha(i) - alpha(i-1);
        rho(i) = det_L(i) / d_alpha; %б�����ʰ뾶
    end
    
    r(1) = 10000;
    r(2) = 10000;
    for i = 3:n
        d_theta = theta(i) - theta(i-1);
        r(i) = det_L(i) / d_theta; %ת�����ʰ뾶
    end
    
    x
    y
    h
    r
    rho
    alpha
    beta
    theta
    det_L
    