%%
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
%      matmgc('creat_qrs' ,record);
%     matmgc('creat_xml' ,record);
    qrs = loadmgcqrs(record);
    rpos = qrs.time;
    afindex = qrs.qrs(:,2);
    label2 = [];
    label2(afindex > 18) = 1;
    label2(afindex <= 18) = 0 ;
    [label_ref] = afdbRead('D:\MGCDB\mitafdb\',namelist{ii},rpos);    
    [nTP(ii),nTN(ii),nFP(ii),nFN(ii)] = afdb_eval_entry(label_ref,label2);
    naf = naf+length(find(label_ref==1));
    nnorm = nnorm +length(find(label_ref==0));    
end

Sensitivity = sum(nTP)/((sum(nTP)+sum(nFN)));
Specificity = sum(nTN)/((sum(nTN)+sum(nFP)));
fprintf('%d  %d \n %d %d \n' , [sum(nTP) sum(nFN)  sum(nFP) sum(nTN)]);
fprintf('Sensitivity = %.4f; Specificity = %.4f \n' , [Sensitivity Specificity])
clear matmgc;
