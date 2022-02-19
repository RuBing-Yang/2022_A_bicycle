function T = func(v)
%优化目标函数func
    global n
    global detx
    global alpha
    global v0
    V = 1:n;
    V(1) = (v0+v(1))/2;
    for i=2:n
        V(i)=(v(i)+v(i-1))/2;
    end
    T = 0;
    for i=1:n
        T = T + detx(i)/cos(alpha(i))/V(i);
    end
end