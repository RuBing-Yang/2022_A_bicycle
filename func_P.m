function [T, grad] = func_P(P)
%�Ż�Ŀ�꺯��func
    global n
    global det_L
    global det_T
    det_T = [];
    V = P2v(P);
    grad = (1:n-1)'; %�ݶ�
    for i=1:n
        grad(i)= -det_L(i)/(V(i)^2);
    end
    T = sum(det_T);
end