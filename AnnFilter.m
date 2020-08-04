function tk = AnnFilter(x, K, T)
%% OMP�ع��㷨_����ʵ��_�ִ��������ۡ�������Ӧ��
%% ���������
    %x              ��������Ҷϵ��
    %K              �����������
    %T              ����������
%% ���������
    %tk             ��������ʱ��
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N = length(x);        % ��ȡ����Ҷϵ������
M = floor(N/2);       % ����Ҷϵ��������һ�� 
L = K;                % �˲�������

r = x( (-M+L: -1: -M) + floor(N/2)+1 );   % ������Ҷϵ����ȡ�������������
c = x( (-M+L: M) + floor(N/2) + 1 );     % ������Ҷϵ����ȡ�������������
my_A = toeplitz(c, r);   % �����������к�ĸ���Ҷϵ��������Topelitz����

[~, ~, V] = svd(my_A, 0);    % �Թ����Topelitz�����������ֵ�ֽ�

ann_filter_coeff = V(:, K+1);% ѡ����С������ֵ����Ӧ��������������Ϊ�˲���ϵ������

tk = sort(mod(-angle(roots(ann_filter_coeff))/(2*pi)*T, T)); % ͨ����С���˷��ָ�����ʱ��