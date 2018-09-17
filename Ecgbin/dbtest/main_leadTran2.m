%% data is saved in .DAT files and is recorded as numbers from 1-14 leads for loop as binary
clc; 
clear all; 
close all;
list = dir('D:\DataBase\EecgLeadSystem\14通道数据20171027\*.dat'); % get information of .DAT documents into structure 'list'
data = [] ;
for sub = 1:length(list)
    fid = fopen(fullfile('D:\DataBase\EecgLeadSystem\14通道数据20171027',list(sub).name),'rb','ieee-be'); % define open method
    d = fread(fid,[14 inf],'bit32'); % read in binary files into a 14*inf matrix every 32bits
    d = d*0.0476837158203125/1000; % transfer to unit mV
    fclose(fid);
    %index1 = find(d(1,1:end-4)~=0 &d(1,2:end-3)==0 & d(1,3:end-2)==0& d(1,4:end-1)==0);
    %index2 = find(d(1,1:end-4)==0 &d(1,2:end-3)==0 & d(1,3:end-2)==0& d(1,4:end-1)~=0);
    %index1 = [index1 size(d,2)];
    %index2 = [1 index2+4]; % find the indices of nonzero segments
    
    %for ii = 1:length(index2)
        tmp = d;%(:,index2(ii):index1(ii)) ; % remove zero segments
        tmp = tmp -ecg_baseline(tmp,0.8/250); % function to correct ECG baseline wandering
        for kk = 1:size(tmp,1);
            tmp(kk,:) = smooth(tmp(kk,:),5);  % reduce signal noise
        end;
         
        data(sub,1).raw = tmp; % 5files*1segments each
        
        %     d = d-ecg_baseline(d,0.25/250);
   % end
end
DATA(1,1).raw = data(1,1).raw(:,8000:18000);
%DATA(1,2).raw = data(1,2).raw(:,2000:4500);
%DATA(1,3).raw = data(1,3).raw(:,3000:6000);
%DATA(1,4).raw = data(1,4).raw(:,6000:8500);
%DATA(1,5).raw = data(1,5).raw(:,3000:6000);
DATA(2,1).raw = data(2,1).raw(:,6000:16000);
%DATA(2,2).raw = data(2,2).raw(:,3000:7000);
%DATA(2,3).raw = data(2,3).raw(:,4000:8000);
%DATA(2,4).raw = data(2,4).raw(:,3000:7000);
%DATA(2,5).raw = data(2,5).raw(:,3000:7000);
DATA(3,1).raw = data(3,1).raw(:,4000:14000); 
%DATA(3,2).raw = data(3,2).raw(:,3000:end);
%DATA(3,3).raw = data(3,3).raw(:,3000:end);
%DATA(3,4).raw = data(3,4).raw(:,2500:6500);
%DATA(3,5).raw = data(3,5).raw(:,3000:end);
DATA(4,1).raw = data(4,1).raw(:,1000:11000);
%DATA(4,2).raw = data(4,2).raw(:,3000:end);
%DATA(4,3).raw = data(4,3).raw(:,3000:end);
%DATA(4,4).raw = data(4,4).raw(:,7000:end);
%DATA(4,5).raw = data(4,5).raw(:,4000:end);
DATA(5,1).raw = data(5,1).raw(:,8000:18000);
%DATA(5,2).raw = data(5,2).raw(:,2000:6000);
%DATA(5,3).raw = data(5,3).raw;
%DATA(5,4).raw = data(5,4).raw(:,3000:end);
%DATA(5,5).raw = data(5,5).raw(:,4000:end);
DATA(6,1).raw = data(6,1).raw(:,2000:12000);
DATA(7,1).raw = data(7,1).raw(:,15000:25000);
DATA(8,1).raw = data(8,1).raw(:,6000:15000);
DATA(9,1).raw = data(9,1).raw(:,5000:15000);
DATA(10,1).raw = data(10,1).raw(:,7000:16000);
% add all of suitable data into DATA, we get processed testdata finally
%% 绘制median波形

 for ntest = 1:size(DATA,1)
     [rpos,qrsheight,qrswidth,sign] = qrs_detect5_1(DATA(ntest,1).raw(1,:)); % 提取R波位置信息
     segdata(ntest,1).seg = beat_segment(DATA(ntest,1).raw,rpos,0.5,0.7,250); % 按时间截取心拍并对齐
     msegdata(ntest,1).seg = wavelet_median(segdata(ntest,1).seg)'; % 计算MEdian波形
 end;
 %% 训练
 total_err1=  [];
total_err2 = []; 
for ntrain = 1:10 % ntrain = the number of tester
    
    
    [Lead_8,Lead_EASI, Lead_HEICA] = leadSystemTran2(DATA(ntrain,1).raw); % 计算median波形下三种导连数据
    
    beta2 = [] ;beta1 = [] ;
    for ii = 1:size(Lead_8,1)
        beta1(:,ii) = regress(Lead_8(ii,:)',[Lead_HEICA; ones(1,size(Lead_HEICA,2))]'); % 计算HEICA回归参数
    end
    for ii = 1:size(Lead_8,1)
        beta2(:,ii) = regress(Lead_8(ii,:)',[Lead_EASI; ones(1,size(Lead_EASI,2))]'); % 计算EASI回归参数
    end

% calculator the relationship of lead_8 with lead_HEICA,lead_EASI    
%% 评价性能
    
    %for sub = 1:5
    sub = ntrain;
        %for ii = 1:5
            [Lead_8,Lead_EASI, Lead_HEICA] = leadSystemTran2(DATA(ntrain,1).raw);% 计算全部数据的lead_8结果
            Lead_8_fromHEICA = beta1'*[Lead_HEICA; ones(1,size(Lead_HEICA,2))];% 用回归参数计算HEICA结果
            Lead_8_fromEASI = beta2'*[Lead_EASI; ones(1,size(Lead_EASI,2))]; % 用回归参数计算EASI结果
            
%             for num = 1:8
%                subplot(2,4,num);
%                 plot(Lead_8(num,1:750),'LineWidth',4,'Color',[0.6 0.6 0.6]');
%                hold on;
%                plot(Lead_8_fromHEICA(num,1:750),'b');
%                hold on;               
%                plot(Lead_8_fromEASI(num,1:750),'r');
%             end;
%             legend('Lead_8','HEICA','EASI');
%             截取三种结果的部分波形，绘制结果对比图

            filename1 = strcat('Lead_8',num2str(ntrain),'.jpg');
            ecgplot_8chan(Lead_8(:,1:2500)/100,250,filename1,fullfile('C:\Users\gazellesun\Desktop\LeadTran\data2', filename1));
            filename2 = strcat('Lead_8_fromHEICA',num2str(ntrain),'.jpg');
            ecgplot_8chan(Lead_8_fromHEICA(:,1:2500)/100,250,filename2,fullfile('C:\Users\gazellesun\Desktop\LeadTran\data2', filename2));
            filename3 = strcat('Lead_8_fromEASI',num2str(ntrain),'.jpg');
            ecgplot_8chan(Lead_8_fromEASI(:,1:2500)/100,250,filename3,fullfile('C:\Users\gazellesun\Desktop\LeadTran\data2', filename3));
%             将结果分别输出到指定路径下  
            [R21,Rs1] = leadSysEval(Lead_8,Lead_8_fromHEICA);
            [R22,Rs2] = leadSysEval(Lead_8,Lead_8_fromEASI);
            
%             res1= [R21  Rs1];
%             res2 = [R22  Rs2];
            
            total_err1(ntrain,:) = Rs1; % HEICA与原始数据的方差归一化结果
            total_err2(ntrain,:) = Rs2; % EASI与原始数据的方差归一化结果
           %            figure;
           %      tit = {'I','II','V1','V2','V3','V4','V5','V6'};
           %      for kk = 1:8
           %          subplot(4,2,kk);plot(Lead_8(kk,:),'LineWidth',1);  hold on;  hold on;plot(Lead_8_fromxyz(kk,:),'r');
           %         s = sprintf('%s %.2f %.2f', tit{kk},R21(kk),R22(kk));
           %          hold on;plot(Lead_8_fromHEICA(kk,:),'k');  title(s);
           %          if kk == 8
           %              legend('ref','XYZ to lead8' , 'heica to lead8')
           %          end
           %      end;
           %      disp([Rs1 Rs2]);
        %end
    %end
end
%%
% total_err1 = mean(squeeze(total_err1),1);
% total_err2 = mean(squeeze(total_err2),1);
% a1 = squeeze(mean(total_err1,1));
% a1 = squeeze(mean(a1,1));
% a1 = squeeze(mean(a1,1));
% a2 = squeeze(mean(total_err2,1));
% a2 = squeeze(mean(a2,1));
% a2 = squeeze(mean(a2,1));
%%
% 
% result1=mean(mean(total_err1,3),2); % result of Lead_8_fromHEICA
% result2=mean(mean(total_err2,3),2); % result of Lead_8_fromEASI

