%% 测试median wave database


load('D:\MGCDB\beat_muse_250Hz.mat')
fs = 250;
m = 1;
chan = 2;
wavepos8 = zeros(8,9);
QRSampl  = zeros(1,8);
idx = 1:length(DATA);
fig = 0;
POS = zeros(length(DATA),5,9);
POS_REF = zeros(length(DATA),5);
parfor ii = 1:length(DATA)
    refpos = DATA(ii).pos;
    rr = floor(60000/DATA(ii).Meas.VentricularRate);
    y = mean(abs(DATA(ii).wave),2);
    waveposabs = ptdetector_bin2(y,fs,0.4*fs,rr);

    [wavepos8,QRSampl,Tampl] =  parr_ptdetector(DATA(ii).wave,fs,rr);
    [v, idx1] = max(abs(Tampl));
    tmp  = floor(median(wavepos8,1));
    wavepos= waveposabs;
    wavepos(1:3) = wavepos8(2,1:3);  % P 波采用II导联
    wavepos(4:5) = waveposabs(4:5);  % Qonset采用abs
    wavepos(6) = tmp(6);   %  Qend采用median
    wavepos(7:9) = tmp(7:9);   % Tend 采用meidan
    tPos1(ii,:) =refpos*1000/fs;
    tPos2(ii,:) =wavepos([1 3 4 6 9])*1000/fs;
    x = cat(1,wavepos8(:,[1 3 4 6 9]),waveposabs([1 3 4 6 9]));
    POS(ii,:,:) = x';
    POS_REF(ii,:) = refpos;
    %     if fig==1
    % %         wavepos = ptdetector_bin2(avg_ecg,fs,0.4*fs,rr,1);
    %         subplot(211);
    %         plot_beat_pos(DATA(ii).wave(:,2),refpos,fs);   hold on;
    %         plot_beat_pos(DATA(ii).wave(:,2),wavepos([1 2 3 4 5 6 9]),fs,[],'+');
    %         s = sprintf('P onset间期误差= %d ',tPos2(ii,1) - tPos1(ii,2));
    %         title(s);hold off;
    %         hold on;
    %         title(s);hold off;
    %         subplot(212);
    %         plot(1:4:1200,DATA(ii).wave);
    %     end
    
    
end

%%
% clc
disp('mean    mean_err   std     <5ms    <10ms    <20ms    <40ms   <100ms');
disp('____________________________________________________________');
res= meas_qrst(tPos1,tPos2);
disp('____________________________________________________________');
