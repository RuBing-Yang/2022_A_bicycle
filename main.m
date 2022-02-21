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

global det_T

%% ��������
% 0�����
% 1��excel
% 2�����ϳ���
% 3�����϶��£����
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
    miu = 0.0035*ones(1,n);
    %���ʸĴ�ģ��ֱ��·
    rho = linspace(10000,10000,n);%rand(1,n);%
    r = linspace(10000,10000,n);%rand(1,n);%
    V0 = vmax*rand(1,n);
elseif test_type == 1
    %EXCEL���
    v0 = 1;
    beta0 = rand();
    in_name = 'TokyoMen';
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
    beta0 = rand();
    route();
    beta = beta0-theta;
    miu = 0.0035*ones(1,n);
    vmax = 15;
    vw = 10;
    vlimit = ones(1,n) * vmax;
    V0 = rand(1,1) * vlimit;
end

vw = 0;
M = 80;
g = 9.81;
K = 0.13;
W = 12430;
CP = 435;
Pm = 1234;


global times
times = 0;
options=optimoptions(@fmincon,'Algorithm','sqp','MaxFunEvals',100000,'MaxIter',10000,'GradObj', 'on');
%�Ż��㷨��'active-set' 'interior-point' 'sqp'  'trust-region-reflective'
%'MaxFunEvals',100000 ����Ż���������100000
%'GradObj', 'on',�����ݶȺ���
[P,fval] = fmincon('func_P',CP*rand(n,1),[],[],[],[],zeros(1,n),Pm*ones(n,1),'nonlcon_P',options);
%outcomeΪ�����ٶ����У�fvalΪĿ�꺯����Сֵ

P = smooth(P0, 30, 'sgolay', 5);
v = P2v(P);
data_cell = cell(n,7);
for i = 1:n
    data_cell(i,:) = {x_3d(i,1), x_3d(i,2), x_3d(i,3), x_L(i), P(i), v(i), det_T(i)}; 
end
size(data_cell)
stitle = {'x', 'y', 'h', 'L', 'P', 'v', 'dt'};  % ��ӱ�������
result = [stitle; data_cell]; 

s = xlswrite(filename, result);  

figure
plot(x_L, v, 'ok-', 'linewidth', 1.1, 'markerfacecolor', [36, 169, 225]/255)%��ͼv-x_L
xlabel('position(m)');
ylabel('velocity(m/s)');
title('Velocity distribution');
% ������߿��߿�1.1, �������������СΪTimes New Roman��16
set(gca, 'linewidth', 1.1, 'fontsize', 16, 'fontname', 'times')

figure
plot(x_L, P, 'ok-', 'linewidth', 1.1, 'markerfacecolor', [29, 191, 151]/255)%��ͼP-x_L
xlabel('position(m)');
ylabel('power(W)');
title(['Power distribution with Total time ',num2str(sum(det_T)), '(s)']);
% ������߿��߿�1.1, �������������СΪTimes New Roman��16
set(gca, 'linewidth', 1.1, 'fontsize', 16, 'fontname', 'times')
%{
P0 = P;
x_L0 = x_L

%P = smooth(P0, 5, 'sgolay', 3);
P = P0 + 40*(rand(n,1) - 0.5); %��ֱ
vv0 = v;
v = P2v(P);

figure
plot(x_L, vv0, 'linewidth', 4, 'color', [252, 157, 154]/255)%��ͼP-x_L
hold on
plot(x_L, v, 'ok-', 'linewidth', 1.1, 'markerfacecolor', [36, 169, 225]/255)%��ͼv-x_L
xlabel('position(m)');
ylabel('velocity(m/s)');
title('Velocity distribution after smoothing');
% ������߿��߿�1.1, �������������СΪTimes New Roman��16
set(gca, 'linewidth', 1.1, 'fontsize', 16, 'fontname', 'times')

figure
plot(x_L, P0, 'linewidth', 4, 'color', [252, 157, 154]/255)%��ͼP-x_L
hold on
plot(x_L, P, 'ok-', 'linewidth', 1.1, 'markerfacecolor', [29, 191, 151]/255)%��ͼP-x_L
xlabel('position(m)');
ylabel('power(W)');
title(['Power distribution with Total time ',num2str(sum(det_T)), '(s)']);
% ������߿��߿�1.1, �������������СΪTimes New Roman��16
set(gca, 'linewidth', 1.1, 'fontsize', 16, 'fontname', 'times')
legend('Original power profile', 'Power offset');


x_L = x_L + 100*(rand(n,1) - 0.5); %��ֱ
%P = smooth(P0, 40, 'sgolay', 5);
v = P2v(P0);
figure
plot(x_L, v, 'ok-', 'linewidth', 1.1, 'markerfacecolor', [36, 169, 225]/255)%��ͼv-x_L
xlabel('position(m)');
ylabel('velocity(m/s)');
title('Velocity distribution after smoothing');
% ������߿��߿�1.1, �������������СΪTimes New Roman��16
set(gca, 'linewidth', 1.1, 'fontsize', 16, 'fontname', 'times')

figure
plot(x_L, P0, 'ok-', 'linewidth', 1.1, 'markerfacecolor', [29, 191, 151]/255)%��ͼP-x_L
xlabel('position(m)');
ylabel('power(W)');
title(['Power distribution with Total time ',num2str(sum(det_T)), '(s)']);
% ������߿��߿�1.1, �������������СΪTimes New Roman��16
set(gca, 'linewidth', 1.1, 'fontsize', 16, 'fontname', 'times')

figure
plot(x_L0, P0, 'linewidth', 1.1, 'color', [178, 200, 187]/255)%��ͼP-x_L
hold on
plot(x_L0, P, 'linewidth', 1.1, 'color', [229, 131, 8]/255)%��ͼP-x_L
hold on
plot(x_L, P0, 'linewidth', 2, 'color', [220, 87, 18]/255)%��ͼP-x_L
xlabel('position(m)');
ylabel('power(W)');
title('Power distribution');
% ������߿��߿�1.1, �������������СΪTimes New Roman��16
set(gca, 'linewidth', 1.1, 'fontsize', 16, 'fontname', 'times')
legend('Original power profile', 'Power offset', 'Position offset');
%}




figure
plot3(x_3d(:,1), x_3d(:,2), x_3d(:,3), 'ok-', 'linewidth', 1.1, 'markerfacecolor', [36, 169, 225]/255)%��ͼheight-xy
xlabel('x/m');
ylabel('y/m');
zlabel('height/m');
title('Course cross section');



disp(sum(det_T))%�����Сʱ��
