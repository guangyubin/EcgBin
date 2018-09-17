%% ≤‚ ‘median wave database


load('D:\MGCDB\beat_muse_250Hz.mat')
fs = 250;
m = 1;
chan = 2;

idx = 1:length(DATA);
fig = 0;
for ii = 1:length(DATA)
    refpos = DATA(ii).pos;
    rr = floor(60000/DATA(ii).Meas.VentricularRate);
    x = DATA(ii).wave(:,2);
     x = floor((x - mean(x))*200);
    wavepos = ptdetector_bin3(x/200,fs,0.4*fs,rr);  
    tPos2(ii,:) =wavepos([1 3 4 6 9])*1000/fs;  
    [pos , amp] = matmgc('analyze_beat_v1',x,rr);    
    tPos1(ii,:) =refpos*1000/fs;
    tPos3(ii,:) =pos([1 3 4 6 9])*1000/fs;
    
%     a(ii) = (wavepos(2) - pos(2)*1000/fs;
    
%      plot(x);hold on;plot(pos,x(pos),'.r');hold off;

end
clear matmgc
%%
%  clc
disp('mean    mean_err   std     <5ms    <10ms    <20ms    <40ms   <100ms');
disp('____________________________________________________________');
% tPos3(:,5) = tPos3(:,5) +3;
res= meas_qrst(tPos1,tPos3);
disp('____________________________________________________________');

% disp('mean    mean_err   std     <5ms    <10ms    <20ms    <40ms   <100ms');
% disp('____________________________________________________________');
res= meas_qrst(tPos1,tPos2);
% disp('____________________________________________________________');
% [a ,b] =sort(abs(tPos2(:,3) - tPos3(:,3)+1));