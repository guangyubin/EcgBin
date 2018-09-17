% 测试Median波形产生的准确性

%
clc
clear
load('D:\MGCDB\MuseDB_500Hz.mat');
fs = 500;

% method :  'correlation' / 'aver'
method = input('please input the method(correlation/aver): ','s');
for ii = 1:length(DATA)
   segdata =  beat_epoch(DATA(ii).wave, DATA(ii).rpos, DATA(ii).QRStype, 0, 0.5, 0.7, DATA(ii).fs);
   wave1 = DATA(ii).wave_median;
   wave2 = wavelet_median(segdata);
   meas(ii) = eval_waves_similarity(wave1, wave2 ,method);
end

if strcmp('correlation',method)
    fprintf('平均相关系数 %8.5f\n',mean(meas))
elseif strcmp('aver',method)
    fprintf('绝对平均误差 %8.5f\n',mean(meas))
end
%%

% plot(x1-mean(x1));
% plot(x2-mean(x2));
% hold on;plot(x3-mean(x3));
% legend('ref','median' , 'wavelete median','mean');

