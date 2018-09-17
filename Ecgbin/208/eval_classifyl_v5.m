
%%
% clc;clear
fs = 300;
% clc;clear
% addpath('D:\Database_MIT\af2017\Method2\ecgpuwave')
addpath('osealib');
addpath('smgAFlib');
data_dir = ['..' filesep  'training2017' filesep];
[RECORDS, label] = load_data(data_dir);
label_ref = label;
label([127,165,192,234,274,283,294,580,586,635,668,674,762,765,779,1043,1319,1441,1626,1650]) = 4;
label([692,713,748,1050,1233,963,1547,2572]) = 4;

label([100 195 213 270 444 485 570 612 659 748 820 844 848 962 989 1093]) = 2;
label([1107 1164 1180 1237 1252 1413 1414 1424 1475 1510 1517 1577 1633 1647]) = 2;


label([321 404 493 551 624 666 670 939 1019 1076 1079 1267 1301 7432] ) = 4;
label([1325 1774 2594 2899 3128 3707 5270 5283 6998 7122 8328] ) = 4;
label([326 786 1025 1134 1531 2158 3095 4320 5616 5624 5643 5696 5712 5767 5768] ) = 3;
label([5848 5909 5961 5970 6146 6299 6373 6648] ) = 3;

label([227 229 920 1176 1660 1766 1797 1806 1841 1905 1942]) = 4;
label([2078 2109 2344 2570 2613 2716 2783 2998 3048 3107 3242 3380 3397]) = 4;
label([3604 3697 3718 3823 4275 4330 4465 4559 4578 4583]) = 4;

label([4598 4642 4827 4843 5387 5406 5416 5418 5550 5646 5666]) = 4;
label([5754 5833 5834 5836 5863 5928 5932 6051 6053 6151 6206]) = 4;
label([6265 6275 6364 6543 6555 6646 6750 6752 6784]) = 4;
label([6815 6821 6903 6934 7039 7054 7059 7073 7074 7165 7287 7313]) = 4;
label([7424 7516 7519 7534 7586 7655 7698 7729 7782 7832 7935 7948 7949 8031 8120 8186 8212 8231]) = 4;
label([8232 8233 8237 8348 8384 8411 8459 8469]) = 4;
% noise_normal_list=[34 106 139 307 474 700 705 813 1169 1529 1888 1965 2196 2217 2411 3596 3946 4020 4325 4424 ...
%     4513 4673 4676 4685 4707 4853 4941 4946 5089 5134 5341 5408 5766 6157 6769 6841 7198 7356 7736 8204 8258 8378];
% noise_new_list=[657 6893];
% 
% label(noise_new_list) = 1;
% label(noise_normal_list) = 2;
%%
parms1 = [0.05 ,0.05,0.05,0.1,0.1,0.1,0.15,0.15,0.15];
parms2 = [6 ,8 ,10, 6,8,10,6,8,10 ];

genError = zeros(40,length(parms1));
for kk = 1:length(parms1)
    FT = [];
    parfor ii=1:length(label);%idx2 %1:100 %1:100%1:length(label)
        fname = [data_dir RECORDS{ii}];
        [FT(:,ii)]=  ecg_feature_extract(fname,parms1(kk),parms2(kk));
        
    end;
    tmptree = templateTree('MaxNumSplits',55,'MergeLeaves','on');
    Mdl = fitensemble(FT',label,'AdaBoostM2',40,tmptree,'KFold',100);
    genError(:,kk) = kfoldLoss(Mdl,'Mode','Cumulative');
    save(['FT_208_' num2str(kk)],'FT');
end


%%

% index = find(label==1 | label==2 | label==3|label==4);
% 
% parfor ii = 1:10
%     MdlDeep = fitctree(FT(:,index)',label(index),'MaxNumSplits',55,'MergeLeaves','on','CrossVal','on','KFold',100);
%     errorDeep(ii) = kfoldLoss(MdlDeep);
% end
% 
% disp(mean(errorDeep));
%%
% load('FT_208');
% alltree = fitctree(FT(1:37,index)',label(index),'MaxNumSplits',55,'MergeLeaves','on');
% class = predict(alltree,FT(1:37,:)');
% save('alltree.mat','alltree');
% confusion_matrix(label',class,1);


%%
addpath('gui');
userlist = [1] ;
label_data

