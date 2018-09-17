%%
function report = loadmgcxml(record)

if isempty(strfind(record,'.xml'))
    record = [record '.xml'];
end;
fid = fopen(record,'rb');
if fid < 0
    report = [];
    %     fclose(fid);
    %     report.ROIecg = [];
    %     report.AnnWarning.pos = [];
    %     report.AnnWarning.descript = [];
    %     report.hr = [];
    %     report.AFIndex = [];
    %     report.PVCIndex = [];
    return;
end;
fclose(fid);
xmlDoc = xmlread(record);

node = xmlDoc.getElementsByTagName('Version');
child = node.item(0);
version = char(child.item(0).getTextContent());
if strcmp(version,'1.0.1')
    
    report = loadmgcxml_v1(record);
    report.STValue = [];
else
    
    
    node = xmlDoc.getElementsByTagName('PatientInfo');
    child = node.item(0);
    m = 1;
    for ii = 1:2:child.getLength-1
        report.PatientInfo{m} = [char(child.item(ii).getNodeName()) ' = '  char(child.item(ii).getTextContent())];
        m = m +1;
        %     sscanf(char(child.item(ii).getTextContent()),'%d')
    end
    
    
    node = xmlDoc.getElementsByTagName('MeasureInfo');
    child = node.item(0);
    m = 1;
    for ii = 0:1:child.getLength-1
        if ~contains( char(child.item(ii).getNodeName()),'text')
        report.MeasureInfo{m} = [char(child.item(ii).getNodeName()) ' = '  char(child.item(ii).getTextContent())];
        m = m +1;
        end
        %     sscanf(char(child.item(ii).getTextContent()),'%d')
    end
    
    
    % node = xmlDoc.getElementsByTagName('AF_Burden');
    % child = node.item(0);
    % report.RatioOfAF = sscanf(char(child.item(0).getTextContent()),'%d');
    %
    % node = xmlDoc.getElementsByTagName('VE_Isolated_Ratio');
    % child = node.item(0);
    % report.RatioOfPVC = sscanf(char(child.item(0).getTextContent()),'%d');
    %
    % node = xmlDoc.getElementsByTagName('Pause_nEps');
    % child = node.item(0);
    % report.EpisodesOfPause = sscanf(char(child.item(0).getTextContent()),'%d');
    
    node = xmlDoc.getElementsByTagName('HeartRate');
    child = node.item(0);
    for ii = 1:child.getLength
        if(strcmp(char(child.item(ii).getNodeName),'Data'))
            hr = sscanf(char(child.item(ii).getTextContent()),'%d,');
            %         hr = typecast(uint8(tmp),'int16');
            break;
        end
    end;
    report.hr = hr;
    % figure;subplot(313);plot(hr);
    
    node = xmlDoc.getElementsByTagName('QTInterval');
    child = node.item(0);
    for ii = 1:child.getLength
        if(strcmp(char(child.item(ii).getNodeName),'Data'))
            AFEv = sscanf(char(child.item(ii).getTextContent()),'%d,');
            
            %         AFEv = typecast(uint8(tmp),'int16');
            break;
        end
    end;
    report.AFIndex = AFEv;
    % ;subplot(311);plot(AFEv);
    
    
    node = xmlDoc.getElementsByTagName('PVCIndex');
    child = node.item(0);
    PVCIndex= [];
    for ii = 1:child.getLength
        if(strcmp(char(child.item(ii).getNodeName),'Data'))
            PVCIndex = sscanf(char(child.item(ii).getTextContent()),'%d,');
            %         PVCIndex = typecast(uint8(tmp),'int16');
            break;
        end
    end;
    report.PVCIndex = PVCIndex;
    
    node = xmlDoc.getElementsByTagName('RRInterval');
    child = node.item(0);
    RRInterval= [];
%     for ii = 1:child.getLength
%         if(strcmp(char(child.item(ii).getNodeName),'Data'))
%             RRInterval= sscanf(char(child.item(ii).getTextContent()),'%d,');
%             %         RRInterval = typecast(uint8(tmp),'int16');
%             break;
%         end
%     end;
    report.RRInterval = RRInterval;
    
    
    node = xmlDoc.getElementsByTagName('STValue');
    STValue = [];
    try
        child = node.item(0);
        for ii = 1:child.getLength
            if(strcmp(char(child.item(ii).getNodeName),'Data'))
                STValue = sscanf(char(child.item(ii).getTextContent()),'%d,');
                %             PauseIndex = typecast(uint8(tmp),'int16');
                break;
            end
        end;
    catch
    end
    report.STValue = STValue;
    % ;subplot(312);plot(PVCIndex);
    pos = [];
    node = xmlDoc.getElementsByTagName('RegionOfInteresting');
    child = node.item(0);
    count = 1;
    roi_ecg = [];
    for ii = 0:child.getLength-1
        if(contains(char(child.item(ii).getNodeName),'SegmentEcg'))
            c2 = child.item(ii).getChildNodes;
            for kk = 1: c2.getLength-1
                if(strcmp(char(c2.item(kk).getNodeName),'Time'))
                    pos(count) = sscanf(char(c2.item(kk).getTextContent()),'%d');
                end
                if(strcmp(char(c2.item(kk).getNodeName),'Type'))
                    type{count} = char(c2.item(kk).getTextContent());
                end
                if(strcmp(char(c2.item(kk).getNodeName),'Data'))
                    roi_ecg(:,count) = sscanf(char(c2.item(kk).getTextContent()),'%d,');
                    
                    %                 ecg(:,count) = typecast(uint8(tmp),'int16');
                    count = count+1;
                end
            end
        end
    end;

    
    report.HRV = [];
    node = xmlDoc.getElementsByTagName('HRV');
    child = node.item(0);
    count = 1;
    ecg = [];
    for ii = 1:child.getLength-1
        if(strcmp(char(child.item(ii).getNodeName),'TimeDomain'))
            c2 = child.item(ii).getChildNodes;
            for kk = 1: c2.getLength-1
                if(strcmp(char(c2.item(kk).getNodeName),'MeanRR'))
                    report.HRV.TimeDomain.MeanRR = sscanf(char(c2.item(kk).getTextContent()),'%d');
                end
                if(strcmp(char(c2.item(kk).getNodeName),'Observation'))
                    type{count} = char(c2.item(kk).getTextContent());
                end
                if(strcmp(char(c2.item(kk).getNodeName),'Data'))
                    report.HRV.TimeDomain.IBI = sscanf(char(c2.item(kk).getTextContent()),'%d,');
                    
                    %                 report.HRV.TimeDomain.IBI  = typecast(uint8(tmp),'int16');
                    count = count+1;
                end
            end
        end
        
        if(strcmp(char(child.item(ii).getNodeName),'FreqDomain'))
            c2 = child.item(ii).getChildNodes;
            for kk = 1: c2.getLength-1
                if(strcmp(char(c2.item(kk).getNodeName),'LFHF'))
                    report.HRV.FreqDomain.LFHF = sscanf(char(c2.item(kk).getTextContent()),'%f');
                end
                if(strcmp(char(c2.item(kk).getNodeName),'Observation'))
                    type{count} = char(c2.item(kk).getTextContent());
                end
                if(strcmp(char(c2.item(kk).getNodeName),'Data'))
                    report.HRV.FreqDomain.PSD = sscanf(char(c2.item(kk).getTextContent()),'%d,');
                    
                    %                 report.HRV.FreqDomain.PSD  = typecast(uint8(tmp),'int16');
                    count = count+1;
                end
            end
        end
        
    end;
    
    report.Event_AF  = [];
    node = xmlDoc.getElementsByTagName('RhythmEvent');
    
    child0 = node.item(0);
    for jj = 1:child0.getLength-1
        if(strcmp(char(child0.item(jj).getNodeName),'AF'))
            child = child0.item(jj);
            et = [];
            m = 1;
            for ii = 1:child.getLength-1
                if(strcmp(char(child.item(ii).getNodeName),'Type'))
                    tp = char(child.item(ii).getTextContent());
                end
                if(strcmp(char(child.item(ii).getNodeName),'Abbreviate'))
                    Abbr = char(child.item(ii).getTextContent());
                end
                if(contains(char(child.item(ii).getNodeName),'EVENT'))
                    c2 = child.item(ii).getChildNodes;
                    for kk = 1: c2.getLength-1
                        if(strcmp(char(c2.item(kk).getNodeName),'Time'))
                            pos(count) = sscanf(char(c2.item(kk).getTextContent()),'%d');
                        end
                        if(strcmp(char(c2.item(kk).getNodeName),'Duration'))
                            Duration= char(c2.item(kk).getTextContent());
                            dr = sscanf(char(c2.item(kk).getTextContent()),'%f');
                        end
                    end
                    type{count} = [ tp Duration];
                    et(m,1) = pos(count);
                    et(m,2) = dr;
                    m = m +1;
                    count = count+1;
                    
                    
                end
            end
            report.Event_AF = et;
            
            
        end
    end
    % catch
    % end
    report.AnnWarning = [];
    if ~isempty(pos)
        report.ROIecg = roi_ecg;
        report.AnnWarning.pos = (pos)*250;
        report.AnnWarning.descript = type;
    end
    
end
%%
% figure;
% for ii = 1:count-1
% subplot(count,1,ii);plot(ecg(:,ii)); title(pos(ii));
% end;
% subplot(count,1,count) ; plot(data((pos(1))*250:(pos(1)+30)*250));
%
% disp([char(phone.item(1).getNodeName()) ':' char(phone.item(1).getTextContent())]);
% disp([char(phone.item(3).getNodeName()) ':' char(phone.item(3).getTextContent())]);
% disp([char(phone.item(5).getNodeName()) ':' char(phone.item(5).getTextContent())]);
% %%
% hr = sscanf(char(phone.item(5).getTextContent()),'%2x');
% figure;plot(hr);