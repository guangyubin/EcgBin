%   Matmgc example
% 	{"help",                     help         },
% 	{"version",                  version      },
% 	{"af_AFEV",                  af_AFEV      },
% 	{"beat_detector",            beat_detector},
% 	{"file_analysis",            file_analysis},
% 	{"mit_bxb",                  bxb},

%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% beat_detector :
%    input : ecg data in mV
%             sample rate must be 250Hz
%    Output:  qrs  [pos  anntype subtype .....]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
sig=rdsign212('D:\Database_MIT\mitdb\105.dat',2,1,2500);
x = sig(:,1)/200;
qrs = matmgc('beat_detector',x,250);
figure;plot_ecg_beat_type(x-mean(x),qrs(1,:),qrs(3,:));
%%
hea=readheader('D:\Database_MIT\mitdb\116.hea');
sig=rdsign212('D:\Database_MIT\mitdb\116.dat',2,1,hea.nsamp);
x = sig(:,1)/200;
matmgc('beat_detector',x',250,'D:\Database_MIT\116.ate','mit');
matmgc('mit_bxb','D:\Database_MIT\mitdb\','100','atr','ate1')
matmgc('mit_bxb','D:\Database_MIT\mitdb\','105','atr','ate2')
% beat_mit = readannot('D:\MGCDB\mitdb\105.ate');
% figure;plot_ecg_beat_type(x-mean(x),beat_mit.time,(beat_mit.anntyp));
 

 clear matmgc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% file_analysis :
%    input : fname: 数据文件 , 只兼容16bit数据格式
%            qrsfile： QRS注释文件
%            dataformat:   'mgc'  'mit'
%              
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
fid = fopen('D:\MGCDB\mitdb\105.dat','rb');
x = fread(fid,'short')/200;
fclose(fid);

 matmgc('file_analysis','D:\MGCDB\mitdb\105','D:\MGCDB\mitdb\105.qrs','mgc');

 beat_mgc = loadAnn_mgc('D:\MGCDB\mitdb\105.qrs');
 figure;plot_ecg_beat_type(x-mean(x),beat_mgc.pos,beat_mgc.subtype,1,5000);

 matmgc('file_analysis','D:\MGCDB\mitdb\105','D:\MGCDB\mitdb\105.ate','mit');
 beat_mit = readannot('D:\MGCDB\mitdb\105.ate');
  figure;plot_ecg_beat_type(x-mean(x),beat_mit.time,(beat_mit.anntyp),1,5000);
  
  
  %%
clc
path = 'D:\MGCDB\CAREB0\';
list = dir([path '*.dat']);
for ii = 1: length(list)
    matmgc('file_analysis',fullfile(path,list(ii).name(1:end-4)),...
       fullfile(path,[list(ii).name(1:end-4) '.qrs']),'mgc');
   
%    A(:,ii) = matmgc('mit_bxb',path,list(ii).name(1:end-4),'atr','ate');
end
 clear matmgc
 
 %%
 
   %%

path = 'D:\Database_mit\mitdb\';
list = dir([path '*.dat']);
for ii = 1: length(list)
    matmgc('file_analysis',fullfile(path,list(ii).name(1:end-4)),...
       fullfile(path,[list(ii).name(1:end-4) '.ate']),'mit');
   
   A(:,ii) = matmgc('mit_bxb',path,list(ii).name(1:end-4),'atr','ate','5:0');
end
A1 = sum(A,2);
str = sprintf('%.4f %.4f %.4f %.4f',1-A1(3)/(A1(1)+A1(3)),...
1-A1(2)/(A1(1)+A1(3)),...
1-A1(5)/(A1(4)+A1(6)),...
1-A1(6)/(A1(4)+A1(6)));
disp(str);
%%
clc
path = 'D:\Database_mit\mitdb\';
list = dir([path '*.dat']);
for ii = 1: length(list)
   A(:,ii) = matmgc('mit_bxb',path,list(ii).name(1:end-4),'atr','ate1','5:0');
end
A1 = sum(A,2);
str = sprintf('%.4f %.4f %.4f %.4f',1-A1(3)/(A1(1)+A1(3)),...
1-A1(2)/(A1(1)+A1(3)),...
1-A1(5)/(A1(4)+A1(6)),...
1-A1(6)/(A1(4)+A1(6)));
disp(str);
% matmgc('mit_bxb','D:\Database_MIT\mitdb\','105','atr','ate2')

 clear matmgc