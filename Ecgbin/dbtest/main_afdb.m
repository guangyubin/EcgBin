% 处理MIT AF database的主程序

%%
namelist = {'00735';'03665';'04015';'04043';'04048'
    '04126';'04746';'04908';'04936';'05091'
    '05121';'05261';'06426';'06453';'06995'
    '07162';'07859';'07879';'07910';'08215'
    '08219';'08378';'08405';'08434';'08455'};

naf = 0 ;
nnorm = 0 ;
nTP = zeros(1,length(namelist));nTN = nTP; nFP = nTN;nFN = nTP;
for ii = 1:25
    qrs = readannot(['D:\Database_MIT\afdb\' namelist{ii} '.qrs']);
    rpos = qrs.time;
    [label_ref] = afdbRead('D:\Database_MIT\afdb\',namelist{ii},rpos);    
    se = zeros(1,length(rpos));AFEv2 = se;AFEv = se;radius = se;meanRR = se;
    for kk = 64:length(rpos)
        rr = diff(rpos(kk-63:kk));
        % 调用C语言的库
        AFEv2(kk) = matmgc('af_AFEV',rr'*1000/250);
    end    
    label = zeros(1,length(qrs));
    label(AFEv2 > 20) = 1;
    label(AFEv2 < 20) = 0 ;
    [nTP(ii),nTN(ii),nFP(ii),nFN(ii)] = afdb_eval_entry(label_ref,label);
    naf = naf+length(find(label_ref==1));
    nnorm = nnorm +length(find(label_ref==0));    
end
%%
Sensitivity = sum(nTP)/((sum(nTP)+sum(nFN)));
Specificity = sum(nTN)/((sum(nTN)+sum(nFP)));
fprintf('%d  %d \n %d %d \n' , [sum(nTP) sum(nFN)  sum(nFP) sum(nTN)]);
fprintf('Sensitivity = %.4f; Specificity = %.4f \n' , [Sensitivity Specificity])
%%



