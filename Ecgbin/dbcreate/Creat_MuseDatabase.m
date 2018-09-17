%%  250Hz 从MUSE数据中，提取出Meidan Wave数据，生成MDWVDB
clc
clear
list = dir('D:\DataBase\MUSE\*.xml');
%133
DATA = [];
m = 1;
% for ii = 1:length(list)
%     fname = fullfile('D:\DataBase\MUSE',list(ii).name);
%     [wave,rpos,QRStype,wave_median,fs,label,Meas,Meas_Orig,diag,diag_orig,Meas_Matrix,adu,PatientID]=musexmlread(fname);
%     
%     if  Meas.ECGSampleBase==500&&...
%             isfield(Meas,'PRInterval')&&isfield(Meas,'QTInterval')...
%             &&isfield(Meas,'POffset')&&isfield(Meas,'POnset')
%         a1 = Meas.PRInterval-2*( Meas.QOnset - Meas.POnset);
%         a2 = Meas.QTInterval - 2*(  Meas.TOffset-Meas.QOnset);
%         a3 =  Meas.QRSDuration - 2*(  Meas.QOffset-Meas.QOnset);
%         if a1==0 && a2==0 && a3 == 0
%             if fs==500
%                 DATA(m).wave = wave_median(1:2:end,:)*adu/1000;
%                 DATA(m).pos = floor([Meas.POnset, Meas.POffset,Meas.QOnset,Meas.QOffset,Meas.TOffset]/2);
%                 
%                 a = 1;
%             else
%                 DATA(m).wave = wave_median(1:1:end,:)*adu/1000;
%                 DATA(m).pos = floor( [Meas.POnset, Meas.POffset,Meas.QOnset,Meas.QOffset,Meas.TOffset]/2);
%                 
%                 a = 1;
%             end
%             
%             DATA(m).heartrate = Meas.VentricularRate;
%             DATA(m).Meas = Meas;
%             
%             m = m +1;
%         end
%     end
% end
% 
% save('D:\MGCDB\mdwvdb_250Hz.mat','DATA');
% load('D:\MGCDB\mdwvdb_250Hz.mat');

%% 
clc
clear
list = dir('D:\DataBase\MUSE\*.xml');
%133
DATA = [];
m = 1;

% fprintf(fid , 'ID','PatientLastName','PatientAge','DateofBirth','HeightCM','WeightKG',
% 'VentricularRate','')
for ii = 1: 2 %length(list)
    fname = fullfile('D:\DataBase\MUSE',list(ii).name);
    [wave,rpos,QRStype,wave_median,fs,label,Meas,Meas_Orig,diag,diag_orig,Meas_Matrix,adu,PatientInfo]=musexmlread(fname);
    
    if  Meas.ECGSampleBase==500&&...
            isfield(Meas,'PRInterval')&&isfield(Meas,'QTInterval')...
            &&isfield(Meas,'POffset')&&isfield(Meas,'POnset')
        a1 = Meas.PRInterval-2*( Meas.QOnset - Meas.POnset);
        a2 = Meas.QTInterval - 2*(  Meas.TOffset-Meas.QOnset);
        a3 =  Meas.QRSDuration - 2*(  Meas.QOffset-Meas.QOnset);
        if a1==0 && a2==0 && a3 == 0
            if fs==500
                DATA(m).wave = wave*adu/1000;
                DATA(m).rpos = floor(rpos*Meas.ECGSampleBase/(2*fs));
                DATA(m).QRStype = QRStype;
                DATA(m).wave_median = wave_median;                
                DATA(m).fs = fs;                    
                DATA(m).label = label;
                DATA(m).Meas = Meas;                   
                DATA(m).Meas_Orig = Meas_Orig;                    
                DATA(m).diag = diag;
                DATA(m).diag_orig = diag_orig;          
                DATA(m).Meas_Matrix = Meas_Matrix;
                DATA(m).adu = adu;  
                m = m +1;
            end
        end
    end
end
%     save('D:\MGCDB\MuseDB_500Hz.mat','DATA');    
%     load('D:\MGCDB\muse\MuseDB_500Hz.mat');
    

    
    
