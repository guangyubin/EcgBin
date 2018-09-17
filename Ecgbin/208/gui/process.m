function  [FT , avg_ecg]= process(data_dir,RECORDS,label,ii,debug)


     recordName = [data_dir RECORDS{ii}];
    
     [tm,ecg,fs,siginfo] = rdmat(recordName);
% [rpos ,~, ~,sign,norise_qrs] = smg_qrs_detect5_1(ecg',0.1,0.5,fs,0);
[rpos ,~, ~,sign] = qrs_detect5_1(ecg',0.1,0.5,fs,0);
if length(rpos)>3
    ecg = ecg*sign;
    [POS,AMP,VAL_QT,VAL_QTC,VAL_QRS,AMP_Q,AMP_R,AMP_S,QRSType]= bin_PQRSTdetect1(ecg,rpos,fs,0);
    [rpos ,ramp , noise_level,Flag_NoNoise1,Flag_NoNoise2,Flag_NoNoise3] = ecg_noise_level(ecg,POS,AMP,fs);
    Flag_NoNoise  = Flag_NoNoise1 &Flag_NoNoise2 &Flag_NoNoise3;
    [SQIType] = ecg_rmv_noiseqrs_v2(ecg,rpos,fs,Flag_NoNoise);
    
    % 去除噪声beats
    tmp = 1 : length(rpos);
    idx = tmp(SQIType~=0);
    
    rpos1 = rpos(idx);
    SQIType1 = SQIType(idx);
    noise_level1 = noise_level(idx);
    ramp1 = ramp(idx);
    % QRSType == 0  信号质量不好，不予判断。
    % 1、节律特征
    QRSType1 = beat_classify_v2(ecg,rpos1,ramp1,noise_level1,fs);
    QRSType1_plot = QRSType1;
    m = length(QRSType1(QRSType1~=1 & QRSType1~=0 ));
    % 2、房颤特征
    
    %     rr = smg_cal_rr(rpos1,SQIType1,[1 11 21]);
    %     if isempty(rr)
    %         rr = smg_cal_rr(rpos1,SQIType1,[1 11 21]);
    %     end;
    
    [rpos2] = smg_rmv_qrs(rpos1,SQIType1,[1 11 21]);
    [noise_ecg,en_thres] = smg_noise_qrs_detect(ecg',0.1,0.5,fs,0);
    rr = smg_cal_rr(rpos2);
    meanRR = smg_calc_meanRR(rr/fs);
    [ rpos2 ] = smg_rmv_noise_qrs( rpos2, noise_ecg, en_thres*0.8,fs,meanRR,0);
    
    rr = smg_cal_rr(rpos2);    
    
    [AFEv,se,radius,ks_p1, meanRR]  = smg_ecg_af_feature(rr',fs);
    
    %3, 单个计算后，平均后的形态学特征
    [mtQRS1,mtQRS2,mtPR,mPamp ,mQamp, mRamp ,mSamp, mTamp ] = getMorphyFeature(POS,AMP,idx,fs);
    
    % 4、 波形平均后的形态学特征
    tPR = 0;tQRS = 0;tQT = 0; Pamp = 0 ;Qamp = 0;Samp= 0 ;Tamp = 0 ;tQRS2 = 0; qrmrp = 0 ;
    avg_ecg = zeros(1,300);
    if length(SQIType1(SQIType1==1)) > 2
        [avg_ecg] = ecg_avg_epoch(ecg,rpos2(SQIType1==1),0.4*fs,0.6*fs);
        [tPR, tQRS, tQRS2, tQT , Pamp,Qamp,Samp,Tamp,ST,qrmrp] = ecg_avg_feat(avg_ecg,fs,0);
    end
    % 5) 统计QRS的相关系数，用于noise类别的判别
    status = ecg_qrs_stats(ecg,rpos2,fs);
    sqiratio = length((find(SQIType==1)))/ length(SQIType);
%         [npvc,beatinfo] = pvc_detector(ecg,fs,rpos1);
    FT = [AFEv,se,radius,ks_p1, meanRR,m,tPR, tQRS,tQRS2,tQT,Pamp,Qamp,Samp,Tamp,sqiratio,status,mtQRS1,mtQRS2,mtPR,mPamp ,mQamp, mRamp ,mSamp, mTamp];
else
    FT = zeros(1,26);
end
     
       

     
     
  
    if debug== 1      
        
%         subplot(5,2,[1 2]);
% %         plot_ecg_beat_type(ecg,rpos,Flag_NoNoise);        
%         subplot(5,2,[3 4]);
%         plot_ecg_beat_type(ecg,rpos1,SQIType1); title(num2str([ii  label(ii) ]));        
        subplot(3,2,[1 2]);
        
         bin_PQRSTdetect1(ecg,rpos,fs,1);
         
                  
         noise_qrs=rpos1(rpos2==0);
         if ~isempty(noise_qrs)
             hold on;
            plot(noise_qrs,ecg(noise_qrs),'xk');
            hold off;
         end
         
         title(num2str([ii  label(ii) ]));       
%         plot_ecg_beat_type(ecg,rpos1,QRSType1);
        subplot(3,2,[3 4]);        
        plot_ecg_beat_type(ecg,rpos1,QRSType1_plot); 
        if ~isempty(noise_qrs)
             hold on;
            plot(noise_qrs,ecg(noise_qrs),'xk');
            hold off;
        end
         
        subplot(3,2,[5]);         
        
         plot(rr(rr>0)/fs);title(num2str([AFEv,se,radius,ks_p1, meanRR]));
            AnalyzeBeat(avg_ecg,fs,1);
            
%             plot_ecg_beat_type(ecg,rpos1,beatinfo(:,1)); title(npvc);
        subplot(3,2,[6]);
         if length(SQIType1(SQIType1==1)) > 2
       [tPR, tQRS,tQRS2, tQT , Pamp,Qamp,Samp,Tamp,ST,qrmrp]  = ecg_avg_feat(avg_ecg,fs,1);
    
       title(num2str([tPR, tQRS, tQRS2,tQT , Pamp ST,qrmrp ]));
         end
        
    end