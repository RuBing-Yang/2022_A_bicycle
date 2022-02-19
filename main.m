%% ��������
x1 = [0 0 10; 20000 0 510; 40000 0 10];

x2 = [0 0 0];
for i = 1:20
    if i%2 == 0 %������ɽ��
        x2 = [x2; 1000*i 0 25];
    else
        x2 = [x2; 1000*i 0 0];
    end
end

%file: main.m
global n     %���������
global detx  %����ˮƽ�����      ����       
global alpha %��λ���¶Ƚ�        ����
global beta  %��λ��ӭ���        ����
global miu   %��λ�ù���Ħ������  ����
global rho   %��λ��б������      ����
global r     %��λ���������      ����
global vw    %����
global M     %����
global g     %�������ٶ�
global K     %�������������ϵ��
global W     %��ʼ����
global CP    %�ٽ繦��
global vmax  %��������ṩ�ٶ�����
global vlimit %��λ������ٶ�����  ����
global V0     %������ʼ�ٶ�����
global v0     %��ʼ�ٶ�
global L      %ˮƽ·���ܳ�
v0 = 0;
n = 100;
%����ʵʾ��ÿ��1m����
x = 1:n; %������xi 
detx = linspace(1,1,n);%rand(1,n);%
alpha = linspace(0,0,n);%rand(1,n);%
beta = linspace(0,0,n);%rand(1,n);%
miu = linspace(0.2,0.2,n);%rand(1,n);%
%���ʸĴ�ģ��ֱ��·
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
%�Ż��㷨��interior-point sqp sqp-legacy active-set
%'MaxFunEvals',100000 ����Ż���������100000
[outcome,fval] = fmincon('func',V0,[],[],[],[],zeros(1,n),vlimit,'nonlcon',options);
%outcomeΪ�����ٶ����У�fvalΪĿ�꺯����Сֵ
plot([0,x], [v0,outcome])%��ͼv-x
disp(fval)%�����Сʱ��