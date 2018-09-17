
% ���������ڻ��ECG�Ļ���Ʈ��
% x  ECG sigal in mV
% y  ����������

% copyright:  Beijing univesity of techonolgy.
%  Author :    Binguangyu  guangyubin@gmail.com
%  2014.09.30
%

function y = ecg_baseline(x,fc)


k = .7;     % cut-off value
alpha = (1-k*cos(2*pi*fc)-sqrt(2*k*(1-cos(2*pi*fc))-k^2*sin(2*pi*fc)^2))/(1-k);
alpha = real(alpha);
y = zeros(size(x));
for i = 1:size(x,1)
    y(i,:) = filtfilt(1-alpha,[1 -alpha],x(i,:));
end


