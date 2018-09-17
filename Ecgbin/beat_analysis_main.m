%%
clc
% clear
load qtdb_beat;
fs = 250;
% qt0=zeros(1,size(DATA,2));qt1 =qt0 ;
% dtoff = qt0; donset1 = qt0;
list = find(abs(qt1-qt0)>100);
for ii = list %1:1:size(DATA,2)
    %     subplot(311);plot_ecg_beat_type(DATA(:,ii),POS(:,ii),'(p)(N)(T)');
    disp(ii)
    wavepos1 = ptdetector_Christov(DATA(:,ii),fs,0.4*fs,RR(ii),0 );
    wavepos0 = POS(:,ii);
    qt0(ii)  =  1000*(wavepos0(9) - wavepos0(4))/fs;
    qt1(ii)  =  1000*(wavepos1(9) - wavepos1(4))/fs;
    donset1(ii) = 1000*(wavepos1(4) - wavepos0(4))/fs;
    dtoff(ii) = 1000*(wavepos1(9) - wavepos0(9))/fs;
    if abs(qt1(ii) - qt0(ii)) > 100
        subplot(211); plot_ecg_beat_type(DATA(:,ii),wavepos0,'123456789');hold off;
        subplot(212); plot_ecg_beat_type(DATA(:,ii),wavepos1,'123456789'); hold off;
        title(abs(qt1(ii) - qt0(ii)) );
    end;

end;
%%
clc
(fprintf('QRS onset error =  %.2f \n' , mean(abs(donset1))));
(fprintf('T offset error =  %.2f \n' , mean(abs(dtoff))));
meas_qt(qt0,qt1);

%%


