function dist = dist_E(x,y)
dist = [];
if(length(x)~=length(y))
    disp('length of input vectors must agree')  % disp函数会直接将内容输出在Matlab命令窗口中
else
    z =(x-y).*(x-y);
    dist = sqrt(sum(z));
end
end