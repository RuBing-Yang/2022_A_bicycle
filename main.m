%file: main.m
global n     %采样点个数
global det_L  %各段路程（斜边）   数组       
global alpha %各位置坡度角        数组
global beta  %各位置迎风角        数组
global miu   %各位置滚动摩擦因数  数组
global rho   %各位置斜坡曲率      数组
global r     %各位置弯道曲率      数组
global vw    %风速
global M     %质量
global g     %重力加速度
global K     %计算空气阻力的系数
global W     %初始能量
global CP    %临界功率
global vmax  %人体机能提供速度上限
global vlimit %各位置弯道速度限制  数组
global V0     %迭代初始速度数组
global v0     %初始速度
global L      %路程总长（斜边）

v0 = 0;
n = 100;
%以下实示例每隔1m采样
l = 1:n; %采样点li 
det_L = linspace(1,1,n);%rand(1,n);%
alpha = linspace(0,0,n);%rand(1,n);%
beta = linspace(0,0,n);%rand(1,n);%
miu = linspace(0.2,0.2,n);%rand(1,n);%
%曲率改大，模拟直道路
rho = linspace(10000,10000,n);%rand(1,n);%
r = linspace(10000,10000,n);%rand(1,n);%

vw = 0;
M = 80;
g = 9.81;
K = 1;
W = 1500;
CP = 300;
vmax = 50;
vlimit = rand(1,n);
V0 = vmax*rand(1,n);

for i = 1:n
    vlimit(i) = vmax;%min(vmax, sqrt(miu(i)*g*r(i)));
end
options=optimoptions(@fmincon,'MaxFunEvals',100000,'Algorithm','sqp');
%优化算法：interior-point sqp sqp-legacy active-set
%'MaxFunEvals',100000 最大优化迭代次数100000
[outcome,fval] = fmincon('func',V0,[],[],[],[],zeros(1,n),vlimit,'nonlcon',options);
%outcome为最终速度序列，fval为目标函数最小值
plot([0,l], [v0,outcome])%画图v-l
disp(fval)%输出最小时间
