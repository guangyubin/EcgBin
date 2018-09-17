% 采用Ecgpuwave方法识别的波形特征点位置

function wavepos = ptdetector_pu(x,findmark, fs)


POS = bin_PQRSTdetect1(x,findmark,fs,0);

wavepos = [POS.Ponset; POS.P ;POS.Poffset;...
    POS.QRSonset ;POS.R; POS.QRSoffset;...
    POS.Tonset ;POS.T ;POS.Toffset];
