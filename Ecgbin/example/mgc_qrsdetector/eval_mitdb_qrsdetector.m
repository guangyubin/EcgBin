   %%
A= [];
path = 'D:\MGCDB\mitdb250\';
list = dir([path '*.dat']);
for ii = 1: length(list)
 
    %     disp(list(ii).name);
        disp([path,list(ii).name(1:end-4)])
    matmgc('creat_qrs' ,[path,list(ii).name(1:end-4)]);
       delete ([path,list(ii).name(1:end-4) '.xml'])
    matmgc('creat_xml' ,[path,list(ii).name(1:end-4)]);
    qrs = loadmgcqrs([path,list(ii).name(1:end-4), '.qrs']);

%    [hea, ecg] = loadmgcdata([path,list(ii).name(1:end-4)]);
%      qrs = matmgc('beat_detector',ecg,fs);

   
    qrs2atr([path,list(ii).name(1:end-4), '.ate1'],qrs)
    ann = readannot([path,list(ii).name(1:end-4), '.ate1']);
    A(:,ii) = matmgc('mit_bxb',path,list(ii).name(1:end-4),'atr','ate1','5:0');
    
end
   clear matmgc
%%

A1 = sum(A(:,[1:47]),2);
disp('MITDB数据库结果:')
disp("Sen    | PPV    | Sen    | PPV    | Sen    | PPV    |");
str = sprintf('%.4f | %.4f | %.4f | %.4f | %.4f | %.4f | %.4f | %.4f | %.4f',...
    A1(1)/(A1(1)+A1(3)),...
    A1(1)/(A1(1)+A1(2)),...
    A1(4)/(A1(4)+A1(6)),...
    A1(4)/(A1(4)+A1(5)),...
    A1(7)/(A1(7)+A1(9)),...
    A1(7)/(A1(7)+A1(8)));
disp(str);
clear matmgc;

%%
path = 'D:\MGCDB\mitdb250\';
list = dir([path '*.dat']);
for ii = 1: length(list)
    record = [path,list(ii).name(1:end-4)];
     [nTP(ii),nTN(ii),nFP(ii),nFN(ii)] = af_eval_xml_atr(record);
end
Sensitivity = sum(nTP)/((sum(nTP)+sum(nFN)));
Specificity = sum(nTN)/((sum(nTN)+sum(nFP)));
disp('MITDB房颤结果:')
fprintf('%d  %d \n %d %d \n' , [sum(nTP) sum(nFN)  sum(nFP) sum(nTN)]);
fprintf('Sensitivity = %.4f; Specificity = %.4f \n' , [Sensitivity Specificity])
clear matmgc
