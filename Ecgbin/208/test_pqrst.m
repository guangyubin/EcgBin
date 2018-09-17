load FT_208
load avg_ecg;
addpath('osealib');
addpath('smgAFlib');
data_dir = ['..\training2017\'];
[RECORDS, label] = load_data(data_dir);
%%
fs = 300;
n = size(avg_ecg,1);
parfor ii =  1:n
    x = avg_ecg(ii,:);
     fname = [data_dir RECORDS{ii}]; 
      [~,ecg,fs,~] = rdmat(fname);
    if max(x) -min(x) > 0
        [tPR(ii), tQRS(ii), tQRS2(ii), tQT(ii) , Pamp(ii),Qamp(ii),Samp(ii),Tamp(ii),ST(ii),qrmrp(ii),tso(ii),ramp(ii)] = ecg_avg_feat(x,fs,0);
        [tpr2(ii), tqrs2(ii),tqt2(ii) , pamp2(ii),tamp2(ii),st2(ii), ramp2(ii)] = AnalyzeBeat(x,fs,0);
    end
end;
length(find(abs(pamp2 - Pamp)<0.1))/length(pamp2)
%%
index1 = find( abs(pamp2 - Pamp) > 0.1 );

for ii = index1;
    x = avg_ecg(ii,:);
    fname = [data_dir RECORDS{ii}];
    [~,ecg,fs,~] = rdmat(fname);
    subplot(311);[tPR(ii), tQRS(ii), tQRS2(ii), tQT(ii) , Pamp(ii),Qamp(ii),Samp(ii),Tamp(ii),ST(ii),qrmrp(ii),tso(ii)] = ecg_avg_feat(x,fs,1);
    subplot(312); [tpr2(ii), tqrs2(ii),tqt2(ii) , pamp2(ii),tamp2(ii),st2(ii)] = AnalyzeBeat(x,fs,1);
    title(num2str([pamp2(ii) Pamp(ii)  label(ii)]  ));
    subplot(313);plot(ecg);
end