function batch_dir(path)
% clc
% A= [];
% path ='D:\MGCDB\CAREB0\ErrorVEB\';
list = dir(fullfile(path ,'*.dat'));
% s = 0;
% ss = 0 ;
% sraw = 0 ; 
for ii = 1: length(list)
 
    %     disp(list(ii).name);
  disp([path,list(ii).name(1:end-4)])
    matmgc('creat_qrs' ,[path,list(ii).name(1:end-4)]);
    delete ([path,list(ii).name(1:end-4) '.xml'])
    matmgc('creat_xml' ,[path,list(ii).name(1:end-4)]);


    
end