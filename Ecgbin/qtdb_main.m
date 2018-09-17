%%
clc
clear
load ptbdb1000Hz_beat;
donset2 =zeros(1,size(DATA,2));
qt0=donset2;qt1 =donset2 ;qt2 =donset2;donset1 = donset2;donset3 = donset1;
dtend1 = donset2;dtend2 = donset2;
for ii = 1:1:size(DATA,2)
    %     subplot(311);plot_ecg_beat_type(DATA(:,ii),POS(:,ii),'(p)(N)(T)');
    disp(ii)
    wavepos1 = ptdetector_pu(DATA(1:4:end,ii),0.4*250, 250);
    wavepos2 = ptdetector_bin((DATA(1:4:end,ii)),250,0.4*250,RR(ii),0);
    wavepos3 =  ptdetector_Christov(DATA(1:4:end,ii),250,0.4*250,RR(ii) ,0);
    wavepos4 =  ptdetector_Christov(DATA(:,ii),1000,0.4*1000,RR(ii) ,0);
    
    wavepos0 = POS(:,ii);
    qt0(ii)  =  (wavepos0(9) - wavepos0(4));
    qt1(ii)  =  (wavepos1(9) - wavepos1(4))*4;
    qt2(ii)  =  (wavepos2(9) - wavepos2(4))*4;
    qt3(ii)  = ( wavepos3(9) - wavepos3(4))*4;
    qt4(ii)  = ( wavepos4(9) - wavepos4(4));
    donset3(ii) = wavepos3(4)*4 -  wavepos0(4);
    donset4(ii) = wavepos4(4) -  wavepos0(4);
        donset2(ii) = wavepos2(4)*4 -  wavepos0(4);
    dtend1(ii) = wavepos3(9)*4 -  wavepos0(9);
    dtend2(ii) = wavepos4(9) -  wavepos0(9);
%         if  abs(wavepos3(4)*4 -  wavepos0(4)) >50 % abs(qt3(ii) - qt0(ii)) > 100 %donset2(ii) < -20
%             subplot(411); plot_ecg_beat_type(DATA(:,ii),wavepos0,'(P)(N)(T)');
%             subplot(412); plot_ecg_beat_type(DATA(1:4:end,ii),wavepos2,'(P)(N)(T)');
%             subplot(413); plot_ecg_beat_type(DATA(1:4:end,ii),wavepos3,'123456789');
%             subplot(414); plot_ecg_beat_type(DATA(:,ii),wavepos4,'123456789');
%     
%                 title(num2str([qt0(ii) qt3(ii) qt4(ii)]))
%         end;
    
    
end;
%%
clc
(fprintf('QRS onset error =  %.2f \n' , mean(abs(donset2))));
(fprintf('QRS onset error =  %.2f \n' , mean(abs(donset3))));
(fprintf('QRS onset error =  %.2f \n' , mean(abs(donset4))));
(fprintf('Tend  error =  %.2f \n' , mean(abs(dtend1))));
(fprintf('Tend  error =  %.2f \n' , mean(abs(dtend2))));
meas_qt(qt0,qt1);
meas_qt(qt0,qt2);
meas_qt(qt0,qt3);
meas_qt(qt0,qt4);
%%


