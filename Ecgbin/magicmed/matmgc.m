% Toolbox for ECG analysis.
% There are a series of function for ECG analysis:
% 	"help",                     matmgc('help')
% 	"version",                  matmgc('version')
% 	"af_AFEV",                  AFEv = matmgc('af_AFEV',rr)
% 	"beat_detector",            matmgc('beat_detector',x,fs,'1.qrs')
%                                qrs = matmgc('beat_detector',x,fs)
% 	"file_analysis",            matmgc('file_analysis',datafile, qrsfile)
% 	"creat_xml" ,               matmgc('creat_xml','mitdb/100')
% 	"creat_qrs",                matmgc(creat_qrs,'mitdb/100')
% 	"creat_qrs_v2",             matmgc('creat_qrs_v2','mitdb/100')
% 	"mit_bxb",                  res = matmgc('mit_bxb','mitdb','100','atr','ate','00:00')
% 	"write_mit_annot",          matmgc('write_mit_annot',ann,'100.ate')
% 	"read_mit_annot" ,          annot = matmgc('read_mit_annot','100.atr')
% 	"analyze_beat_v1",          qrst =  matmgc('analyze_beat_v1',beat)
% Author: guangyubin@bjut.edu.cn
