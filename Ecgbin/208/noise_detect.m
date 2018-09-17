%%
data_dir = 'training2017\';
fid = fopen([data_dir 'RECORDS'],'r');
if(fid ~= -1)
    RECLIST = textscan(fid,'%s');
else
    error(['Could not open ' data_dir 'RECORDS for scoring. Exiting...'])
end
fclose(fid);

%% Load the reference classification results
reffile = ['training2017' filesep 'REFERENCE.csv'];
fid = fopen(reffile, 'r');
if(fid ~= -1)
    Ref = textscan(fid,'%s %s','Delimiter',',');
else
    error(['Could not open ' reffile ' for scoring. Exiting...'])
end
fclose(fid);
%%
RECORDS = RECLIST{1};
%%
label = zeros(1,length(RECORDS));
for ii = 1:length(RECORDS)
    if strcmp(Ref{1,2}(ii),'~')
        label(ii) = 1;
    end
    if strcmp(Ref{1,2}(ii),'N')
        label(ii) = 2;
    end
    if strcmp(Ref{1,2}(ii),'A')
        label(ii) = 3;
    end
    if strcmp(Ref{1,2}(ii),'O')
        label(ii) = 4;
    end
end


%%
figure;
p2 = [];
for ii=1:length(RECORDS)
     fname = [data_dir RECORDS{ii}];  
 
     [tm,ecg,fs,siginfo]=rdmat(fname);
    
    [QRS,sign,en_thres,p2(ii,:)] = qrs_detect3(ecg',0.25,0.6,fs,[],0,0);   


end
%%

species = label ;
species(label==2 |label==3|label==4) =  0;
mean(p2(species==1,:))
mean(p2(species==0,:))

% [C ,err] = classify(p2,p2,species,'linear',[1 0.0001 ]) ;
% C = C';
% C = zeros(1,length(label));
C(p2(:,1)<0.6 &p2(:,2) > 0.3) = 1;
gscatter(p2(:,1),p2(:,2),species);


x00=length(find(species==0 & C==0)) ;
x01= length(find(species==0 & C==1));
x10 = length(find(species==1& C==0));
x11 = length(find(species==1 & C==1));
disp([x00 x01 ;x10 x11]);
disp(2*x11/(x01+x10+x11+x11));