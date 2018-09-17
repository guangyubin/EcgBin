function [ft] = ecg_feature_extract(fname,THR_RATIO_AMP, THR_DIFF_NUMS)

if nargin <2
   THR_RATIO_AMP = 0.1;
    THR_DIFF_NUMS = 8;
end
%%
   [~,ecg,fs,~] = rdmat(fname);
    [rpos ,~, ~,sign] = qrs_detect5_1(ecg',0.1,0.5,fs,0);
    ecg = ecg*sign;
    [POS,AMP,~,~,~,~,~,~,~]= bin_PQRSTdetect1(ecg,rpos,fs,0);
    
    [rpos ,ramp , noise_level,Flag_NoNoise1,Flag_NoNoise2,Flag_NoNoise3] = ecg_noise_level(ecg,POS,AMP,fs,THR_RATIO_AMP,THR_DIFF_NUMS);
    Flag_NoNoise  = Flag_NoNoise1 &Flag_NoNoise2 &Flag_NoNoise3;    
    [SQIType] = ecg_rmv_noiseqrs_v2(ecg,rpos,fs,Flag_NoNoise);
    
    idx = SQIType~=0;
    rpos1 = rpos(idx);
    SQIType1 = SQIType(idx);
    noise_level1 = noise_level(idx);
    ramp1 = ramp(idx);
    QRSType1 = beat_classify_v2(ecg,rpos1,ramp1,noise_level1,fs);  
    m = length(QRSType1(QRSType1~=1 & QRSType1~=0 ));
%     [rr] = cal_rr(rpos1,QRSType1,1);
%     hr =60*fs/mean(rr);
%     
%     rr = cal_rr(rpos1,SQIType1,[1 11 21]);
%     if isempty(rr)
%         rr = cal_rr(rpos1,SQIType1,[1 11 21]);
%     end;
%     [AFEv,se,radius, meanRR]  = ecg_af_feature(rr',fs);   
    bVF = vfdetect(rpos,ramp);
    %% smg
    [rpos1] = smg_rmv_qrs(rpos1,SQIType1,[1 11 21]);
    [noise_ecg,en_thres] = smg_noise_qrs_detect(ecg',0.1,0.5,fs,0);
    rr = smg_cal_rr(rpos1);
    meanRR = smg_calc_meanRR(rr/fs);
    [ rpos1 ] = smg_rmv_noise_qrs( rpos1, noise_ecg, en_thres*0.8,fs,meanRR,0);    
    rr = smg_cal_rr(rpos1);        
    [AFEv2,se,radius2,ks_p12, meanRR2]  = smg_ecg_af_feature(rr',fs);
    %%
        %3, 单个计算后，平均后的形态学特征
    [mtQRS1,mtQRS2,mtPR,mPamp ,mQamp, mRamp ,mSamp, mTamp ] = getMorphyFeature(POS,AMP,idx,fs);
    
 
    %ecg_avg_feat
   tPR = 0;tQRS = 0;tQT = 0; Pamp = 0 ;Qamp = 0;Samp= 0 ;Tamp = 0 ;tQRS2 = 0 ;ST = 0 ;
   qrmrp = 0 ;tso = 0 ;  
   % AnalyzeBeat
   tpr2 = 0 ;tqrs2 = 0;tqt2 = 0 ;pamp2 = 0 ;tamp2 = 0 ;st2 = 0 ;
   % pvc_detector
   npvc = 0 ;
    if length(SQIType1(SQIType1==1)) > 2
        
        [avg_ecg] = ecg_avg_epoch(ecg,rpos1(SQIType1==1),0.4*fs-1,0.6*fs);
%          [tPR, tQRS, tQT , Pamp,Qamp,Samp,Tamp] = ecg_avg_feat_v1(avg_ecg,fs,0); 
        [tPR, tQRS, tQRS2, tQT , Pamp,Qamp,Samp,Tamp,ST,qrmrp,tso] = ecg_avg_feat(avg_ecg,fs,0);        
        [tpr2, tqrs2,tqt2 , pamp2,tamp2,st2] = AnalyzeBeat(avg_ecg,fs,0);
%         [npvc,beatinfo] = pvc_detector(ecg,fs,rpos1);
%         [avg_ecg] = ecg_avg_epoch(ecg,rpos1(SQIType1==1),0.5*fs,0.5*fs);
%         [tPR, tQRS, tQT , Pamp,Qamp,Samp,Tamp] = ecg_avg_feat(avg_ecg,fs,0); 
%         [tpr2, tqrs2,tqt2 , pamp2,tamp2,st2] = AnalyzeBeat(avg_ecg,fs,0);
    end
    % 7) 统计QRS的相关系数，用于noise类别的判别
    status = ecg_qrs_stats(ecg,rpos,fs);
    sqiratio = length((find(SQIType==1)))/ length(SQIType);

%     [AFEv2,se,radius2, meanRR2,m,tPR, tQRS,tQT,Pamp,Qamp,Samp,Tamp,sqiratio,status];
        ft = [AFEv2,se,radius2,meanRR2,...
              m,tPR, tQRS,tQT,Pamp,Qamp,Samp,Tamp,...
              sqiratio,status,...
              tQRS2,mtQRS1,mtQRS2, mtPR,mPamp ,mQamp, mRamp ,mSamp, mTamp,ST,qrmrp,tso,bVF,...
              tpr2, tqrs2,tqt2 , pamp2,tamp2,st2,npvc...
              ks_p12];
    
   % ft = [AFEv,se,radius, meanRR,m,tPR, tQRS,tQT,Pamp,Qamp,Samp,Tamp,sqiratio,status];%
    
   