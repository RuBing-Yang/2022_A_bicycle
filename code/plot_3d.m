
filename = 'TokyoLady_out.xlsx';

rawdata = xlsread(filename);
x = rawdata(:,1);
y = rawdata(:,2);
z = rawdata(:,3);
x = smooth(x, 10, 'sgolay', 5);
y = smooth(y, 10, 'sgolay', 5);
y = smooth(z, 10, 'sgolay', 5);


figure
plot3(x, y, z, 'linewidth', 2, 'color', [182, 194, 154]/255)%��ͼheight-xy
xlabel('x/m');
ylabel('y/m');
zlabel('height/m');
title('Course 3d model');
% ������߿��߿�1.1, �������������СΪTimes New Roman��16
set(gca, 'linewidth', 1.1, 'fontsize', 16, 'fontname', 'times')
