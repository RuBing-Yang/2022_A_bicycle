
filename = 'TokyoLady_out.xlsx';

rawdata = xlsread(filename);
x = rawdata(:,1);
y = rawdata(:,2);
z = rawdata(:,3);
x = smooth(x, 10, 'sgolay', 5);
y = smooth(y, 10, 'sgolay', 5);
y = smooth(z, 10, 'sgolay', 5);


figure
plot3(x, y, z, 'linewidth', 2, 'color', [182, 194, 154]/255)%画图height-xy
xlabel('x/m');
ylabel('y/m');
zlabel('height/m');
title('Course 3d model');
% 坐标轴边框线宽1.1, 坐标轴字体与大小为Times New Roman和16
set(gca, 'linewidth', 1.1, 'fontsize', 16, 'fontname', 'times')
