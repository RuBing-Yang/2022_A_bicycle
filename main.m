%file: main.m
global n     %采样点个数
global det_L  %各段路程（斜边）   数组       
global alpha %各位置坡度角        数组      
global theta %各位置速度方向角    数组
global beta  %各位置迎风角        数组 beta0-theta
global miu   %各位置滚动摩擦因数  数组
global rho   %各位置斜坡曲率      数组
global r     %各位置弯道曲率      数组
global vw    %风速
global beta0  %风向
global M     %质量
global g     %重力加速度
global K     %计算空气阻力的系数
global W     %初始能量
global CP    %临界功率
global Pm    %最大功率
global vmax  %人体机能提供速度上限
global vlimit %各位置弯道速度限制  数组
global V0     %迭代初始速度数组
global v0     %初始速度
global L      %路程总长（斜边）
global x_L    %采样点             数组

test_type = 1;

if test_type == 0
    v0 = 0;
    n = 200;
    L = n;
    vmax = 50;
    %以下实示例每隔1m采样
    x_L = 1:n; %采样点li 
    det_L = linspace(1,1,n);%rand(1,n);%
    alpha = linspace(-pi/6,pi/6,n);%rand(1,n);%
    beta = linspace(0,0,n);%rand(1,n);%
    miu = linspace(0.2,0.2,n);%rand(1,n);%
    %曲率改大，模拟直道路
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
%优化算法：'active-set' 'interior-point' 'sqp'  'trust-region-reflective'
%'MaxFunEvals',100000 最大优化迭代次数100000
%'GradObj', 'on',开启梯度函数
[outcome,fval] = fmincon('func',V0,[],[],[],[],zeros(1,n),vlimit,'nonlcon',options);
%outcome为最终速度序列，fval为目标函数最小值
subplot(2, 2, 1);
plot([0,x_L], [v0,outcome])%画图v-x_L
axis([0 max(x_L) 0 max(outcome)]);%调整图纸坐标轴范围
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
plot(x_L, P, 'o')%画图P-x_L
axis([0 max(x_L) 0 max(P)]);%调整图纸坐标轴范围
xlabel('x_L/m');
ylabel('P/W');
title('Power distribution');
grid on;
subplot(2, 2, 3);
global x_3d
plot(x_L,x_3d(:,3))%画图height-x
xlabel('x/m');
ylabel('height/m');
title('Course cross section');
grid on;


subplot(2, 2, 4);
plot3(x_3d(:,1), x_3d(:,2), x_3d(:,3))%画图height-xy
xlabel('x/m');
ylabel('y/m');
zlabel('height/m');
title('Course cross section');
grid on;

disp(fval)%输出最小时间
