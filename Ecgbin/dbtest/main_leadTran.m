%%
list = dir('D:\DataBase\EecgLeadSystem\14通道数据20171027\*.dat');
data = [] ;
for sub = 1 %1:length(list)
    fid = fopen(fullfile('D:\DataBase\EecgLeadSystem\14通道数据20171027',list(sub).name),'rb','ieee-be');
    d = fread(fid,[14 inf],'bit32');
    d = d*0.0476837158203125/1000000; 
    fclose(fid);
    
    matmgc('beat_detector',d(2,:),250);
    [rpos ,~, ~,sign] = qrs_detect5_1(d(2,:)',0.1,0.5,250,0);
    
    index1 = find(d(1,1:end-4)~=0 &d(1,2:end-3)==0 & d(1,3:end-2)==0& d(1,4:end-1)==0);
    index2 = find(d(1,1:end-4)==0 &d(1,2:end-3)==0 & d(1,3:end-2)==0& d(1,4:end-1)~=0);
    index1 = [index1 size(d,2)];
    index2 = [1 index2+4];
    
    for ii = 1:length(index2)
        tmp = d(:,index2(ii):index1(ii)) ;
        tmp = tmp -ecg_baseline(tmp,0.8/250);
        for kk = 1:size(tmp,1);
            tmp(kk,:) = smooth(tmp(kk,:),5);
        end;
        
        data(sub,ii).raw = tmp;
        
        %     d = d-ecg_baseline(d,0.25/250);
    end
end
DATA(1,1).raw = data(1,1).raw(:,1:3000);
DATA(1,2).raw = data(1,2).raw(:,2000:4500);
DATA(1,3).raw = data(1,3).raw(:,3000:6000);
DATA(1,4).raw = data(1,4).raw(:,6000:8500);
DATA(1,5).raw = data(1,5).raw(:,3000:6000);
DATA(2,1).raw = data(2,1).raw;
DATA(2,2).raw = data(2,2).raw(:,3000:7000);
DATA(2,3).raw = data(2,3).raw(:,4000:8000);
DATA(2,4).raw = data(2,4).raw(:,3000:7000);
DATA(2,5).raw = data(2,5).raw(:,3000:7000);
DATA(3,1).raw = data(3,1).raw;
DATA(3,2).raw = data(3,2).raw(:,3000:end);
DATA(3,3).raw = data(3,3).raw(:,3000:end);
DATA(3,4).raw = data(3,4).raw(:,2500:6500);
DATA(3,5).raw = data(3,5).raw(:,3000:end);
DATA(4,1).raw = data(4,1).raw;
DATA(4,2).raw = data(4,2).raw(:,3000:end);
DATA(4,3).raw = data(4,3).raw(:,3000:end);
DATA(4,4).raw = data(4,4).raw(:,7000:end);
DATA(4,5).raw = data(4,5).raw(:,4000:end);
DATA(5,1).raw = data(5,1).raw;
DATA(5,2).raw = data(5,2).raw(:,2000:6000);
DATA(5,3).raw = data(5,3).raw;
DATA(5,4).raw = data(5,4).raw(:,3000:end);
DATA(5,5).raw = data(5,5).raw(:,4000:end);
%% 训练系数

total_err1=  [];
total_err2 = [];
for ntrain = 1:5
    
    
    [Lead_8,Lead_XYZ, Lead_HEICA] = leadSystemTran(cat(2,DATA(ntrain,1).raw,DATA(ntrain,2).raw,DATA(ntrain,3).raw,DATA(ntrain,4).raw,DATA(ntrain,5).raw));
    
    beta2 = [] ;beta1 = [] ;
    for ii = 1:size(Lead_8,1)
        beta1(:,ii) = regress(Lead_8(ii,:)',[Lead_HEICA; ones(1,size(Lead_HEICA,2))]');
    end
    for ii = 1:size(Lead_8,1)
        beta2(:,ii) = regress(Lead_8(ii,:)',[Lead_XYZ; ones(1,size(Lead_XYZ,2))]');
    end
    
    %% 评价性能
 
    for sub = 1:5
        for ii = 1:5
            [Lead_8,Lead_XYZ, Lead_HEICA] = leadSystemTran(DATA(sub,ii).raw);
            Lead_8_fromHEICA = beta1'*[Lead_HEICA; ones(1,size(Lead_HEICA,2))];
            Lead_8_fromxyz = beta2'*[Lead_XYZ; ones(1,size(Lead_XYZ,2))];
            
            [R21,Rs1] = leadSysEval(Lead_8,Lead_8_fromHEICA);
            [R22,Rs2] = leadSysEval(Lead_8,Lead_8_fromxyz);
            
            res1= [R21  Rs1];
            res2 = [R22  Rs2];
            
            total_err1(sub,ii,ntrain,:) =  res1;
            total_err2(sub,ii,ntrain,:) = res2;
            %           figure;
            %     tit = {'I','II','V1','V2','V3','V4','V5','V6'};
            %     for kk = 1:8
            %         subplot(4,2,kk);plot(Lead_8(kk,:),'LineWidth',1);  hold on;  hold on;plot(Lead_8_fromxyz(kk,:),'r');
            %         s = sprintf('%s %.2f %.2f', tit{kk},R21(kk),R22(kk));
            %         hold on;plot(Lead_8_fromHEICA(kk,:),'k');  title(s);
            %         if kk == 8
            %             legend('ref','XYZ to lead8' , 'heica to lead8')
            %         end
            %     end;
            %     disp([Rs1 Rs2]);
        end
    end
end
%%
% total_err1 = mean(squeeze(total_err1),1);
% total_err2 = mean(squeeze(total_err2),1);
a1 = squeeze(mean(total_err1,1));
a1 = squeeze(mean(a1,1));
a1 = squeeze(mean(a1,1));
a2 = squeeze(mean(total_err2,1));
a2 = squeeze(mean(a2,1));
a2 = squeeze(mean(a2,1));
%%

mean(mean(total_err1,4),3);
mean(mean(total_err2,4),3);

