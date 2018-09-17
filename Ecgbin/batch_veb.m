clc
A= [];
path ='D:\MGCDB\CAREB0\ErrorVEB\';
list = dir([path '*.dat']);
s = 0;
ss = 0 ;
sraw = 0 ; 
for ii = 1: length(list)
 
    %     disp(list(ii).name);
  disp([path,list(ii).name(1:end-4)])
    matmgc('creat_qrs_v2' ,[path,list(ii).name(1:end-4)]);

        ann = loadmgcqrs([path,list(ii).name(1:end-4), '.qrs']);
        index = find(ann.anntyp=='V');
        sraw = sraw + length(index);
        delete ([path,list(ii).name(1:end-4) '.xml'])
    matmgc('creat_xml' ,[path,list(ii).name(1:end-4)]);
    qrs = loadmgcqrs([path,list(ii).name(1:end-4)]);
    ss = ss + length(qrs.anntyp);
    s = s+length(find(qrs.anntyp=='V'));


    
end

clear matmgc
str = sprintf('ErrorVEB数据库: 原始PVC数量= %d； 改进后的PVC数量＝　%d; 心拍总数= %d； 所占比重= %.10f' , sraw , s,ss,1-s/ss);
disp(str)
  
eval_mitdb_qrsdetector;
mitafdb_test
%%
batch_dir('D:\MGCDB\CAREB0\DataFlag\');
batch_dir('D:\MGCDB\CAREB0\ErrorTWave\');