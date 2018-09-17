namelist = {'04015';'04043';'04048'
    '04126';'04746';'04908';'04936';'05091'
    '05121';'05261';'06426';'06453';'06995'
    '07162';'07859';'07879';'07910';'08215'
    '08219';'08378';'08405';'08434';'08455'};

naf = 0 ;
nnorm = 0 ;
nTP = zeros(1,length(namelist));nTN = nTP; nFP = nTN;nFN = nTP;
for ii = 1:length(namelist)
    record = ['D:\MGCDB\mitafdb\' namelist{ii} ];
%     qrs = loadmgcqrs(record);
%    matmgc('creat_qrs',record);
%      delete ([record '.xml'])
    matmgc('creat_xml',record); 
    disp(ii)
  [nTP(ii),nTN(ii),nFP(ii),nFN(ii)] = af_eval_xml_atr(record);
end
Sensitivity = sum(nTP)/((sum(nTP)+sum(nFN)));
Specificity = sum(nTN)/((sum(nTN)+sum(nFP)));
disp('MITAFDB数据库结果:')
fprintf('%d  %d \n %d %d \n' , [sum(nTP) sum(nFN)  sum(nFP) sum(nTN)]);
fprintf('Sensitivity = %.4f; Specificity = %.4f \n' , [Sensitivity Specificity])
%%
