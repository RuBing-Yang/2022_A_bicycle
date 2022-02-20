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

test_type = 1;

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
    miu = linspace(0.2,0.2,n);%rand(1,n);%
    %���ʸĴ�ģ��ֱ��·
    rho = linspace(10000,10000,n);%rand(1,n);%
    r = linspace(10000,10000,n);%rand(1,n);%
    V0 = vmax*rand(1,n);
else
    %yrb
    v0 = 0.1;
    beta0 = rand();
    earth();
    beta = beta0-theta;
    miu = linspace(0.2,0.2,n); 
    vmax = 50;
    V0 = vmax*rand(1,n);
end

vw = 0;
M = 80;
g = 9.81;
K = 1;
W = 12430;
CP = 435;
Pm = 1234;
vmax = 50;
vlimit = rand(1,n);

for i = 1:n
    vlimit(i) = vmax;%min(vmax, sqrt(miu(i)*g*r(i)));
end

options=optimoptions(@fmincon,'Algorithm','interior-point','MaxFunEvals',100000,'MaxIter',10000,'GradObj', 'on');
%�Ż��㷨��'active-set' 'interior-point' 'sqp'  'trust-region-reflective'
%'MaxFunEvals',100000 ����Ż���������100000
%'GradObj', 'on',�����ݶȺ���
[outcome,fval] = fmincon('func',V0,[],[],[],[],zeros(1,n),vlimit,'nonlcon',options);
%outcomeΪ�����ٶ����У�fvalΪĿ�꺯����Сֵ
subplot(2, 2, 1);
plot([0,x_L], [v0,outcome])%��ͼv-x_L
axis([0 max(x_L) 0 max(outcome)]);%����ͼֽ�����᷶Χ
xlabel('x_L/m');
ylabel('v/m*s-1');
title('Velocity distribution');
grid on;
P = 1:n;
for i=1:n
    if i==1
        avgv = outcome(i)/2;
        P(i) = M*(outcome(i).^2)/2/det_L(i)+K*((avgv+vw*cos(beta(i))).^2)+M*g*sin(alpha(i))+ (M*g*cos(alpha(i))+avgv.^2*M/rho(i))*miu(i);
    else 
        avgv = (outcome(i)+outcome(i-1))/2;
        P(i) = M*(outcome(i).^2-outcome(i-1).^2)/2/det_L(i)+K*((avgv+vw*cos(beta(i))).^2)+M*g*sin(alpha(i))+ (M*g*cos(alpha(i))+avgv.^2*M/rho(i))*miu(i);
    end
end
subplot(2, 2, 2);
plot(x_L, P, 'o')%��ͼP-x_L
axis([0 max(x_L) 0 max(P)]);%����ͼֽ�����᷶Χ
xlabel('x_L/m');
ylabel('P/W');
title('Power distribution');
grid on;
subplot(2, 2, 3);
global x_3d
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
