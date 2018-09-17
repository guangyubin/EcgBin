%%
%% 1 Creat csv label

path_muse = 'D:\DataBase\MUSE';
path_out = 'D:\MGCDB\muse2';
list = dir(fullfile(path_muse,'*.xml'));

fid = fopen(fullfile(path_out,'index1.csv'),'w+');
title = 'DataID,PatientID,PatientLastName,PatientAge,Gender,HeightCM,WeightKG,VentricularRate,AtrialRate,PRInterval,QRSDuration,QTInterval,QTCorrected,PAxis,RAxis,TAxis,QRSCount,QOnset,QOffset,POnset,POffset,TOffset,ECGSampleBase,ECGSampleExponent,QTcFrederica,Diagnosis,BeatTime£¬BeatType';
fprintf(fid,'%s\n',title);
fclose(fid);


%%
fid_csv = fopen(fullfile(path_out,'index1.csv'),'a+');
DataID = 0;
for kk = 1 : 1000 %length(list)
    fname = fullfile(path_muse,list(kk).name);

    [wave,rpos,QRStype,wave_median,fs,label,Meas,Meas_Orig,diag,diag_orig,Meas_Matrix,adu,PatientInfo]=musexmlread(fname);
    if  Meas.ECGSampleBase==500&& fs == 500 &&...
            ~isempty(Meas.PRInterval)&&~isempty(Meas.QTInterval)...
            &&~isempty(Meas.POffset)&&~isempty(Meas.POnset)
        a1 = Meas.PRInterval-2*( Meas.QOnset - Meas.POnset);
        a2 = Meas.QTInterval - 2*(  Meas.TOffset-Meas.QOnset);
        a3 =  Meas.QRSDuration - 2*(  Meas.QOffset-Meas.QOnset);
        if a1==0 && a2==0 && a3 == 0
                DataID = DataID+1;
            writemuse2csv(fid_csv, PatientInfo,Meas,diag,rpos,QRStype,DataID);
            %1. creat .hea file
            record = sprintf('%010d' , DataID );
            hfname = sprintf('%010d.hea' , DataID );
            fid = fopen(fullfile(path_out,hfname),'w+');
            fprintf(fid,'%010d %d %d %d\n',DataID,size(wave,2),Meas.ECGSampleBase,size(wave,1));
            for chan = 1:size(wave,2)
                fprintf(fid,'%010d %d %.2f %d 0 0 0 0 %s\n',DataID,16,1000/adu,16 , label{chan});
            end
            fclose(fid);
            
            dataname = sprintf('%010d.dat' , DataID );
            fid = fopen(fullfile(path_out,dataname),'w+');
            fwrite(fid,wave','short');
            fclose(fid);
            
            mdwname = sprintf('%010d.mwv' , DataID );
            fid = fopen(fullfile(path_out,mdwname),'w+');
            fwrite(fid,wave_median','short');
            fclose(fid);
            
            beat.time = floor(rpos'/2);
            type = [];
            tt = unique(QRStype);
            ntt = zeros(1,length(tt));
            for nn = 1 : length(tt)
                ntt(nn) = length(find(QRStype == tt(nn)));
            end
            [v ,idx] = max(ntt);
            type = [];
            type(QRStype'==tt(idx)) = 'N';
            type(QRStype'~=tt(idx)) = 'V';
            type = char(type');
            beat.anntyp =type;
            beat.subtyp = beat.anntyp;
            beat.chan = beat.anntyp;
            beat.num = beat.anntyp;
            beat.aux = beat.anntyp;
            atrname =  sprintf('%010d.atr' , DataID );
            writeannot(fullfile(path_out,atrname),beat);
        end
    end
end
    fclose(fid_csv);
    %%
