%% ¶ÁÈ¡MAGICMEDÊý¾Ý

function [heasig,ecg]  = loadmgcdata(fname)
ecg = [] ;
if strfind(fname,'.dat')
    fname = fname(1:end-4);
end;
try
heasig=readheader([fname '.hea']);
catch
    heasig = [];
end
if isempty(heasig)
    heasig.fmt(1) = 16;
    heasig.gain(1) = 81.239998;
    heasig.freq = 250;
    heasig.nsig = 1;
     heasig.nsamp = 1000;
   
end;


if heasig.fmt(1) == 212

    ecg=rdsign212([fname '.dat'],1,1,heasig.nsamp);
    ecg = ecg/heasig.gain(1);
    ecg= ecg - mean(ecg);
end;
if heasig.fmt(1) == 16
    fid = fopen([fname '.dat']);
if fid < 0
    disp('no .dat files')
    return;
end;
ecg = fread(fid,[heasig.nsig heasig.nsamp],'short');
fclose(fid);
ecg = ecg/heasig.gain(1);

end
