clc
clear
list = dir('D:\DataBase\MUSE\*.xml');
for ii = 1:10
    ii
%     try
    fname = fullfile('D:\DataBase\MUSE',list(ii).name);
    [err1(:,ii),err2(:,ii),err3(:,ii),err4(:,ii),err5(:,ii)] = muse_getmdwave(fname);
%     catch
%     end
end


err1 = reshape(err1,1,size(err1,1)*size(err1,2));
err2 = reshape(err2,1,size(err1,1)*size(err1,2));
err3 = reshape(err3,1,size(err1,1)*size(err1,2));
err4 = reshape(err4,1,size(err1,1)*size(err1,2));
err5 = reshape(err5,1,size(err1,1)*size(err1,2));
[mean(err1) std(err1)]
[mean(err2) std(err2)]
[mean(err3) std(err3)]
[mean(err4) std(err4)]
[mean(err5) std(err5)]


