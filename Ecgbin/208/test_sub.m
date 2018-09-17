% clc
% clear
data_dir = ['..' filesep  'training2017' filesep];
[RECORDS, label] = load_data(data_dir);
m = 1;
fs = 300;


% parpool('local',4)
index = find(label==2 | label==4);
RECORDS = RECORDS(index);
label = label(index);
a1 = zeros(1,length(RECORDS));
a2 = a1;class = a1;
debug = 1;

for ii= 1:length(RECORDS)
    fname = [data_dir RECORDS{ii}];
    [tm,ecg,fs,siginfo] = rdmat(fname);
    [QRS,sign,en_thres] = qrs_detect5(ecg',0.25,0.5,fs,0);
    [a1(ii),a2(ii),yy] = ecg_rr_match(QRS,fs);
    if a1(ii) ==1 
        class(ii) = 4; 
    end;
    if a1(ii) == 0  
        class(ii) = 2 ;
    end;
    if debug ==1
        if class(ii)~=2 && label(ii) ==2  % Normal classified Other
            close all;
            [QRS,sign,en_thres] = qrs_detect5(ecg',0.25,0.5,fs,debug);
           qrs = ecg_rmv_shortqrs(QRS);
            figure;       
            subplot(311); plot(ecg); hold on;plot(QRS,ecg(QRS),'.'); hold off;         
               subplot(312); plot(ecg); hold on;plot(qrs,ecg(qrs),'.'); hold off;     
             subplot(313); [a1(ii),a2(ii),yy] = ecg_rr_match(QRS,fs,debug);
            title(a2(ii));
        end
    end
    
end;
%%
[m2,F,Acc] = confusion_matrix(label',class',1);
%%

% X= cat(1,a1,a2)';
% Y = label';
% [class4,meanF,meanAcc] =  ecg_classify_ctress(X,Y);
% length(find(label==2))
% length(find(label==2 & a1==1))
% length(find(label==4 & a1==0))
% %%
% plot(a2((label==2 | label==3 )),'.');title('Normal');
