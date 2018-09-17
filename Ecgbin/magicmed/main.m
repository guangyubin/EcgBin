   %%

path = 'D:\MGCDB\CAREB0\data2';
list = dir([path '*.dat']);
for ii = 1: length(list)
   matmgc('creat_qrs_v2' ,[path,list(ii).name(1:end-4)]);
    matmgc('creat_xml' ,[path,list(ii).name(1:end-4)]);
end
