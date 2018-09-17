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
function  [AFEv,se,radius, ks_p1, meanRR] = smg_ecg_af_feature(rr,fs)

AFEv = 0;
se = 0 ;
radius = 0 ;
meanRR = 0 ;
ks_p1=0;
ks_p2=0;
try
    if length(rr)  >= 6
        RR = rr/fs;
        meanRR = smg_calc_meanRR(RR);
         XYedges=-0.6:0.04:0.6;
        AFEv = smg_AFEv_comput_AFEv(RR,meanRR,XYedges,0);
%         AFEv = smg_AFEv_comput_AFEv(RR,meanRR,0);
%         AFEv = comput_AFEv(RR);
        
        dRR=smg_calc_dRR_v2(RR)';
        
        [ radius ]  = smg_calc_radius(dRR,1.5*meanRR,meanRR,0.6);
        [se] = smg_alg_shannonEntropyV2(dRR);
        
        
        %% ks-test
        [ ks_p1, ks_p2 ] = smg_helper_kstest2( RR, 0 );
        
    end
catch ME
    rethrow(ME);
    for enb=1:length(ME.stack); disp(ME.stack(enb)); end;
    AFEv = 0;
    se = 0 ;
    radius = 0 ;
    meanRR = 0 ;
    ks_p1=0;
    ks_p2=0;
end