
%%
% clc;clear
fs = 300;
% clc;clear
addpath('D:\Database_MIT\af2017\Method2\ecgpuwave')
data_dir = ['..' filesep  'training2017' filesep];
[RECORDS, label] = load_data(data_dir);

label([127,165,192,234,274,283,294,580,586,635,668,674,762,765,779,1043,1319,1441,1626,1650]) = 4;
label([692,713,748,1050,1233,963,1547,2572]) = 4;

label([100 195 213 270 444 485 570 612 659 748 820 844 848 962 989 1093]) = 2;
label([1107 1164 1180 1237 1252 1413 1414 1424 1475 1510 1517 1577 1633 1647]) = 2;


label([321 404 493 551 624 666 670 939 1019 1076 1079 1267 1301 7432] ) = 4;
label([1325 1774 2594 2899 3128 3707 5270 5283 6998 7122 8328] ) = 4;
label([326 786 1025 1134 1531 2158 3095 4320 5616 5624 5643 5696 5712 5767 5768] ) = 3;
label([5848 5909 5961 5970 6146 6299 6373 6648] ) = 3;
label([227 229 920 1176 1660 1766 1797 1806 1841 1905 1942]) = 4;
label([2078 2109 2344 2570 2613 2716 2783 2998 3048 3107 3242 3380 3397]) = 4;
label([3604 3697 3718 3823 4275 4330 4465 4559 4578 4583]) = 4;

  label([4598 4642 4827 4843 5387 5406 5416 5418 5550 5646 5666]) = 4;
   label([5754 5833 5834 5836 5863 5928 5932 6051 6053 6151 6206]) = 4;
    label([6265 6275 6364 6543 6555 6646 6750 6752 6784]) = 4;
       label([6815 6821 6903 6934 7039 7054 7059 7073 7074 7165 7287 7313]) = 4;
label([7424 7516 7519 7534 7586 7655 7698 7729 7782 7832 7935 7948 7949 8031 8120 8186 8212 8231]) = 4;
label([8232 8233 8237 8348 8384 8411 8459 8469]) = 4;

% 漏判RR  580 713 1279 1333
% P 波一个个检测


% 房颤错判：557  568 1145 1250 1256 1274 1536 1552 1824 1891

% FT = [];


idx1 = find(FT(5,:)~=0 & label(:)'==2 );
idx2 =find(FT(5,:)==0 & label(:)'==4 & FT(4,:)> 0.6 & FT(4,:)< 1.2);
idx3 = find(label==3& class' == 4);
idx4 = find(label==2& class' == 4);
debug =1 ;
for ii= idx4 %:length(label);%idx2 %1:100 %1:100%1:length(label)
    fname = [data_dir RECORDS{ii}];
    [tm,ecg,fs,siginfo] = rdmat(fname);
    [rpos ,qrsheight, qrswidth,sign] = qrs_detect5_1(ecg',0.1,0.5,fs,0);
    ecg = ecg*sign;
    [POS,AMP,VAL_QT,VAL_QTC,VAL_QRS,AMP_Q,AMP_R,AMP_S,QRSType]= bin_PQRSTdetect1(ecg,rpos,fs,0);
    
    [rpos ,ramp , noise_level,Flag_NoNoise1,Flag_NoNoise2,Flag_NoNoise3] = ecg_noise_level(ecg,POS,AMP,fs);
    Flag_NoNoise  = Flag_NoNoise1 &Flag_NoNoise2 &Flag_NoNoise3;
    
    [SQIType] = ecg_rmv_noiseqrs_v2(ecg,rpos,fs,Flag_NoNoise);
    
    idx = SQIType~=0;
    rpos1 = rpos(idx);
    SQIType1 = SQIType(idx);
    noise_level1 = noise_level(idx);
    ramp1 = ramp(idx);
    QRSType1 = beat_classify_v2(ecg,rpos1,ramp1,noise_level1,fs);
    QRSType1_plot = QRSType1;
    m = length(QRSType1(QRSType1~=1 & QRSType1~=0 ));
    %     QRSType1(QRSType1~=1 & noise_level1 > 0.6)  = 0;
    %     m1 = length(QRSType1(QRSType1~=1 & QRSType1~=0 ));
    [rr] = cal_rr(rpos1,QRSType1,1);
    hr =60*fs/mean(rr);
    
    %     [rr] = cal_rr(rpos1,QRSType1,[1 2 3 4 5 ]);
    %     rr = cal_rr(rpos1,SQIType1,[1 11 21]);
    
    rr = cal_rr(rpos1,SQIType1,1);
    if isempty(rr)
        rr = cal_rr(rpos1,SQIType1,[1 11 21]);
    end;
    [AFEv,se,radius, meanRR]  = ecg_af_feature(rr',fs);
    
    
    %     [m2, hr] = ecg_veb_detect_103(ecg,rpos1,fs);
   tPR = 0;tQRS = 0;tQT = 0; Pamp = 0 ;Qamp = 0;Samp= 0 ;Tamp = 0 ;
    if length(SQIType1(SQIType1==1)) > 2
        [avg_ecg] = ecg_avg_epoch(ecg,rpos1(SQIType1==1),0.5*fs,0.5*fs);
        [tPR, tQRS, tQT , Pamp,Qamp,Samp,Tamp] = ecg_avg_feat(avg_ecg,fs,0); 
    end
    % 7) 统计QRS的相关系数，用于noise类别的判别
    status = ecg_qrs_stats(ecg,rpos,fs);
    sqiratio = length((find(SQIType==1)))/ length(SQIType);
    
    FT(:,ii) = [AFEv,se,radius, meanRR,m,tPR, tQRS, tQT , Pamp,Qamp,Samp,Tamp,sqiratio,status];
    if debug== 1      
        subplot(5,2,[1 2]);
        plot_ecg_beat_type(ecg,rpos,Flag_NoNoise);        
        subplot(5,2,[3 4]);
        plot_ecg_beat_type(ecg,rpos1,SQIType1); title(num2str([ii  label(ii)]));        
        subplot(5,2,[5 6]);
        %         [POS,AMP,VAL_QT,VAL_QTC,VAL_QRS,AMP_Q,AMP_R,AMP_S,QRSType]= bin_PQRSTdetect1(ecg,rpos,fs,1);
        plot_ecg_beat_type(ecg,rpos1,QRSType1);
        subplot(5,2,[7 8]);
        plot_ecg_beat_type(ecg,rpos1,QRSType1_plot);  hold on;plot(rpos1, noise_level1); hold off;
        subplot(5,2,[9]);  QRSType1 = beat_classify_v2(ecg,rpos1,SQIType1,noise_level1,fs);
         plot(60*300./diff(rpos1));
        subplot(5,2,[10]);
        [tpr, tqrs, tqt , pamp] = ecg_avg_feat(avg_ecg,fs,1);title(num2str([tpr, tqrs, tqt , pamp]));
        
    end

end;
%%
disp([length(find(FT(5,:)'~=0 & label(:)==2 )) length(find(FT(5,:)==0 & label(:)'==4 & FT(4,:)> 0.6 & FT(4,:)< 1.2) )]);

%%


