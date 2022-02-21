    global n     %���������
    global det_L  %����·�̣�б�ߣ�   ����       
    global alpha %��λ���¶Ƚ�        ����      
    global theta %��λ���ٶȷ����    ����
    global beta  %��λ��ӭ���        ���� beta0-theta
    global miu   %��λ�ù���Ħ������  ����
    global rho   %��λ��б������      ����
    global r     %��λ���������      ����
    global vw    %����
    global beta0  %����
    global M     %����
    global g     %�������ٶ�
    global K     %�������������ϵ��
    global W     %��ʼ����
    global CP    %�ٽ繦��
    global Pm    %�����
    global vmax  %��������ṩ�ٶ�����
    global vlimit %��λ������ٶ�����  ����
    global V0     %������ʼ�ٶ�����
    global v0     %��ʼ�ٶ�
    global L      %·���ܳ���б�ߣ�
    global x_L    %������             ����
    global x_3d

    global det_T
    global E0

    
    E0 = 0;
    vw = 0;
    M = 80;
    g = 9.81;
    K = 0.13;
    W = 12430;
    CP = 435;
    Pm = 1234;


    %% ��������
% 0�����
% 1��excel
% 2�����ϳ���
% 3�����϶��£����
% 4��������Ƶ�·route
test_type = 3;

if test_type == 0
    v0 = 0;
    n = 200;
    L = n;
    vmax = 50;
    %����ʵʾ��ÿ��1m����
    x_L = 1:n; %������li 
    det_L = linspace(1,1,n);%rand(1,n);%
    alpha = linspace(-pi/6,pi/6,n);%rand(1,n);%
    beta = linspace(0,0,n);%rand(1,n);%
    miu = 0.0035*ones(1,n);
    %���ʸĴ�ģ��ֱ��·
    rho = linspace(10000,10000,n);%rand(1,n);%
    r = linspace(10000,10000,n);%rand(1,n);%
    V0 = vmax*rand(1,n);
elseif test_type == 1
    %EXCEL���
    v0 = 1;
    beta0 = rand();
    in_name = 'UCl_f';
    earth([in_name, '.xlsx']);
    filename = [in_name, '_out.xlsx'];
    beta = beta0-theta;
    miu = 0.0035*ones(1,n);
    vmax = 15;
    vlimit = ones(1,n) * vmax;
    V0 = rand(1,1) * vlimit;
elseif test_type == 2
    %�����³�����
    n = 40;
    x_L = 1:1000:40000;
    det_L = 1000*ones(1,n);
    h = [1:25:500 500:-25:1];
    x_3d = zeros(n,3);
    x_3d(:,1) = x_L;
    x_3d(:,3) = h;
    v0 = 1;
    L = 40000;
    vmax = 20;
    r = 1000*ones(1,n);
    rho = 1000*ones(1,n);
    miu = 0.0035*ones(1,n);
    alpha = [0.025*ones(20,1), -0.025*ones(20,1)];
    beta = zeros(1,n);
elseif test_type == 3
    %20С��С��
    n = 40;
    x_L = 1:1000:40000;
    det_L = 1000*ones(1,n);
    h = zeros(1,n);
    alpha = zeros(1,n);
    
    for i = 1:2:40 %����
        h(i) = 25;
        alpha(i) = 0.025;
        h(i+1) = -25; %ż��
        alpha(i+1) = -0.025;
    end
    
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
else 
    v0 = 1;
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
end
    
    %% �Ż�
    global times
    times = 0;
    %�Ż��㷨��'active-set' 'interior-point' 'sqp'  'trust-region-reflective'
    %'MaxFunEvals',100000 ����Ż���������100000
    %'GradObj', on',�����ݶȺ���
    %outcomeΪ�����ٶ����У�fvalΪĿ�꺯����Сֵ

    options=optimoptions(@fmincon,'Algorithm','sqp','MaxFunEvals',100000,'MaxIter',10000,'GradObj', 'on');
    [P,fval] = fmincon('func_P',CP*rand(n,1),[],[],[],[],zeros(1,n),Pm*ones(n,1),'nonlcon_P',options);
    fval
    v = P2v(P);
    
    figure
    plot(x_L, v, 'ok-', 'linewidth', 1.1, 'markerfacecolor', [36, 169, 225]/255)%��ͼv-x_L
    xlabel('position(m)');
    ylabel('velocity(m/s)');
    % ������߿��߿�1.1, �������������СΪTimes New Roman��16
    set(gca, 'linewidth', 1.1, 'fontsize', 16, 'fontname', 'times')

    figure
    plot(x_L, P, 'ok-', 'linewidth', 1.1, 'markerfacecolor', [29, 191, 151]/255)%��ͼP-x_L
    xlabel('position(m)');
    ylabel('power(W)');
    title(['Power distribution with Total time ',num2str(sum(det_T)), '(s)']);
    % ������߿��߿�1.1, �������������СΪTimes New Roman��16
    set(gca, 'linewidth', 1.1, 'fontsize', 16, 'fontname', 'times')
    
    
    figure
    size(r)
    size(x_L)
    plot(x_L, 1./r, 'ok-', 'linewidth', 1.1, 'markerfacecolor', [29, 191, 151]/255)%��ͼP-x_L
    xlabel('position(m)');
    ylabel('1/r(m^-1)');
    % ������߿��߿�1.1, �������������СΪTimes New Roman��16
    set(gca, 'linewidth', 1.1, 'fontsize', 16, 'fontname', 'times')

    exertion = 0;
    E = [];
    for i=1:n
        exertion = exertion + (Pm-CP) * (P(i)-CP) / W / (Pm-P(i)) * det_T(i);
        exertion = max(0, exertion);
        E = [E exertion];
    end
    [top, location] = findpeaks(E);
    [top3, l3] = maxk(top, 3);
    points = [];
    for i = l3
        points = [points, location(i)];
    end
    points
    figure
    plot(x_L, E, 'ok-', 'linewidth', 1.1, 'markerfacecolor', [29, 191, 151]/255)%��ͼE-x_L
    hold on
    plot(x_L, E, 'pk-', 'linewidth', 1.1, 'MarkerSize', 15, 'MarkerIndices', points, 'markerfacecolor', [229, 131, 8]/255)
    xlabel('position(m)');
    ylabel('exertion');
    % ������߿��߿�1.1, �������������СΪTimes New Roman��16
    set(gca, 'linewidth', 1.1, 'fontsize', 16, 'fontname', 'times')
    
    x = smooth(x_3d(:,1), 10, 'sgolay', 5);
    y = smooth(x_3d(:,2), 10, 'sgolay', 5);
    z = smooth(x_3d(:,3), 10, 'sgolay', 5);
    figure
    plot3(x, y, z, 'linewidth', 2, 'color', [182, 194, 154]/255)%��ͼheight-xy
    xlabel('x/m');
    ylabel('y/m');
    zlabel('height/m');
    title('Course 3d model');
    % ������߿��߿�1.1, �������������СΪTimes New Roman��16
    set(gca, 'linewidth', 1.1, 'fontsize', 16, 'fontname', 'times')
  

