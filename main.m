%file: main.m
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

%% ��������
% 0�����
% 1��excel
% 2�����ϳ���
% 3�����϶��£����
test_type = 2;

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
    earth('Tokyo_f.xlsx');
    beta = beta0-theta;
    miu = 0.0035*ones(1,n);
    vmax = 50;
    vlimit = rand(1,n) * vmax;
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
else
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
end

vw = 0;
M = 80;
g = 9.81;
K = 0.13;
W = 12430;
CP = 435;
Pm = 1234;

options=optimoptions(@fmincon,'Algorithm','sqp','MaxFunEvals',100000,'MaxIter',10000,'GradObj', 'on');
%�Ż��㷨��'active-set' 'interior-point' 'sqp'  'trust-region-reflective'
%'MaxFunEvals',100000 ����Ż���������100000
%'GradObj', 'on',�����ݶȺ���
[P,fval] = fmincon('func_P',CP*rand(n,1),[],[],[],[],zeros(1,n),Pm*ones(n,1),'nonlcon_P',options);
%outcomeΪ�����ٶ����У�fvalΪĿ�꺯����Сֵ
subplot(2, 2, 1);
v = P2v(P);
plot(x_L, v)%��ͼv-x_L
xlabel('x_L/m');
ylabel('v/m*s-1');
title('Velocity distribution');
grid on;

nonlcon(v)
subplot(2, 2, 2);
plot(x_L, P, 'o')%��ͼP-x_L
xlabel('x_L/m');
ylabel('P/W');
title('Power distribution');
grid on;
subplot(2, 2, 3);

plot(x_L,x_3d(:,3))%��ͼheight-x
xlabel('x/m');
ylabel('height/m');
title('Course cross section');
grid on;


subplot(2, 2, 4);
plot3(x_3d(:,1), x_3d(:,2), x_3d(:,3))%��ͼheight-xy
xlabel('x/m');
ylabel('y/m');
zlabel('height/m');
title('Course cross section');
grid on;

disp(fval)%�����Сʱ��
