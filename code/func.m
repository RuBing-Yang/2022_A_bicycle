function [T, grad] = func(v)
%�Ż�Ŀ�꺯��func
    global n
    global det_L
    global L
    global v0
    V = [v0, v];
    grad = (1:n-1)'; %�ݶ�
    for i=2:n
        grad(i-1)= -det_L(i)/(V(i)^2);
    end
    
    T = 0;
    for i=1:n
        T = T + det_L(i)/V(i);
    end
end