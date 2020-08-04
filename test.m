clc;clear;close all
M = 100;
N = 100;
K = 3;
%% --------------------------------------------------- 生成信号
h = [1;5;3];
x = zeros(M,1);
r = 1;
x(r:r+2,1) = 1.2*h;
r = 40;
x(r:r+2,1) = 1.6*h;
r = 69;
x(r:r+2,1) = 2.8*h;

c0 = [1.2; 1.6; 2.8];
m0 = [1; 40; 69];
y = abs(fft(x,N)).^2;

% %% --------------------------------------------------- 数据处理
% H = fft(h,N);
% H = reshape(H,[N,1]);
% xi = y./(abs(H)).^2;

%% --------------------------------------------------- 验证平方和关系
% ccomb = nchoosek(c,2);
% mcomb = nchoosek(m,2);
% m_m = mcomb(:,2) - mcomb(:,1);
% 
% left = xi - norm(c,2)^2.*ones(size(xi));
% 
% u_1 = exp(1i*(2*pi/N).*m_m);
% uu = [u_1; conj(u_1)];
% cc = [ccomb(:,1).*ccomb(:,2);ccomb(:,1).*ccomb(:,2)];
% 
% right = zeros(N,1);
% for i = 1:N
%     right(i) = sum(cc.*(uu.^(i-1)));
% end
% left - right % 左右相等，说明推导没有错误

%% --------------------------------------------------- 试验零化滤波器法
% tkrec = AnnFilter(left, K*(K-1), 1).';  % 好像不太行

%% --------------------------------------------------- 改进的切比雪夫法
% 数据处理
H = fft(h,N);
H = reshape(H,[N,1]);
xi = y./(abs(H)).^2;
%  初始化
threshold = 10e-4;
T = 300;
beta = -1;

ccomb = nchoosek(c0,2);
c1 = 2*ccomb(:,1).*ccomb(:,2);
m1 = [39;68;29]; m1 = [39;68;30];
% m1 = ones(3,1)*(M/3);
% m1 = floor(rand(floor(K*(K-1)*0.5),1)*M); m1 = sort(m1);
f1_m = @(mx) (-2*pi/N)*diag(0:N-1,0)*sin((2*pi/N)*(0:N-1).'*mx.')*diag(c1,0);
f_m = @(mx) cos((2*pi/N)*(0:N-1).'*mx.')*c1-xi+ones(N,1)*norm(c0,2)^2;
% 迭代
err = zeros(T,1);
for tt = 1:T
    f1m = f1_m(m1);
    gm = (f1m.'*f1m)\f1m.';
    fm = f_m(m1);
    y = m1 - beta*gm*fm;
    m1 = m1 - gm*(fm+beta^2*(f_m(y)-fm+beta*f1m*gm*fm));
%     m1 = floor(m1);
    err(tt+1) = (2*K)\norm(fm,2)^2;
    disp(['第',num2str(tt+1),'次迭代误差：',num2str(err(tt+1))]);
    figure(10)
    plot(1:tt,err(2:tt+1));
end