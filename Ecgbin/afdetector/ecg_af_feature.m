% Descript: Get some feature about the AF
% Input:
%    QRS: R pos
%    fs : sample rate
% Output:
%    P : Feature.
% History:
%    Version 1.0.0    2017.3.14   guangyubin
% Author:
%     GuangyuBin@bjut.edu.cn.
%     Beijing university of techonolgy
function  [AFEv,se,radius, meanRR] = ecg_af_feature(rr,fs)

AFEv = 0;
se = 0 ;
radius = 0 ;
meanRR = 0 ;

if length(rr)  >= 6
    RR = rr/fs;
    
     AFEv = comput_AFEv(RR);
    
    [ RR1, meanRR ] = smg_RR_filter(RR);
    dRR=smg_calc_dRR(RR,meanRR)';

    [ radius,dRRnew ]  = smg_calc_radius3(dRR,1.5*meanRR,meanRR); %F = 0.9283   Acc = 0.96804
    [se] = shannonEntropy(dRRnew(:,1));     %F = 0.94797   Acc = 0.97702
    
end