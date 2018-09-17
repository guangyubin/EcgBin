
% Descript: load database AF2017
% Input:
%    data_dir: directory of database
% Output:
%    Reocrds:  file name
%    label : 1 for ~ ;  2 for 'N' 3 for 'AF'  4 for 'Other'
% History:
%    Version 1.0.0    2017.3.14   guangyubin
% Author:
%     GuangyuBin@bjut.edu.cn. 
%     Beijing university of techonolgy


%                
function [RECORDS, label] = load_data(data_dir)
 %data_dir = 'training2017\';
fid = fopen([data_dir filesep 'RECORDS'],'r');
if(fid ~= -1)
    RECLIST = textscan(fid,'%s');
else
    error(['Could not open ' data_dir 'RECORDS for scoring. Exiting...'])
end
fclose(fid);

%% Load the reference classification results
reffile = [data_dir filesep 'REFERENCE-v2.csv'];
fid = fopen(reffile, 'r');
if(fid ~= -1)
    Ref = textscan(fid,'%s %s','Delimiter',',');       
else
    error(['Could not open ' reffile ' for scoring. Exiting...'])
end
fclose(fid);

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